################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Calculate TSR decomposition for the PROJ period
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')



# ################################################################################
# LOGIC of the computations
# We only need 1-year population structure and the projected numbers of migrants.
# Cohort turnover is calculated from the population structure; numbers of deaths 
# are calculated form the demographic balance formula.



load('data2_prepared/n2.PROJ.RData')


###
# calculate cohort turnover for working ages (15-64)
# The idea is to account for migration and mortality at the ages 14 and 64
p.14.64 <- filter(n2p1proj, age%in%c('a14','a64'),sex=='b',year!='y2043') %>%
        droplevels() %>%  select(-sex) %>%
        spread(age,value) %>%
        rename(p14=a14,p64=a64)

# correct for those MIGRATED at ages 14 and 64
mg.14.64 <- n2m1proj %>% 
        filter(age%in%c('a14','a64'),sex=='b') %>%
        spread(age,value) %>% select(-sex) %>%
        rename(mg14=a14,mg64=a64)

# correct for those DIED at ages 14 and 64
p.14.64.begin <- filter(n2p1proj, year!='y2043',age%in%c('a14','a64'),sex=='b') %>% 
        droplevels() %>% select(-sex) %>%
        spread(age,value)
p.14.64.end <- filter(n2p1proj, year!='y2013',age%in%c('a15','a65'),sex=='b') %>% 
        droplevels() %>% select(-sex)%>%
        spread(age,value)
p.14.64.end$year <- p.14.64.begin$year

pg.14.64 <- left_join(p.14.64.begin,p.14.64.end,by=c('year','id')) %>% # pg means 'population growth'
        mutate(pg14=a15-a14,
               pg64=a65-a64) %>%
        select(year,id,pg14,pg64)

mt.14.64 <- left_join(pg.14.64,mg.14.64,by=c('year','id')) %>%
        mutate(mt14=pg14-mg14,
               mt64=pg64-mg64) %>%
        select(year,id,mt14,mt64)


CT <- left_join(p.14.64,mt.14.64,by=c('year','id'))
CT <- left_join(CT,mg.14.64,by=c('year','id'))
CT <- CT %>%
        mutate(CT = (p14-p64) -.5*(mt14-mt64) -.5*(mg14-mg64)) %>%
        select(year,id,CT) 


###
# calculate migration at working ages (15-64)
MG <- n2m1proj
levels(MG$age) <- c(rep('PY',15),rep('PW',50),rep('PO',36),'PT')
MG <- MG %>% filter(sex=='b') %>% select(-sex) %>%
        group_by(id,year,age) %>%
        summarise(MG=sum(value)) %>%
        ungroup()%>%
        filter(age=='PW') %>%
        droplevels() %>%
        select(-age)



###
# now aggreagte for broad age groups        

p3 <- n2p1proj 
levels(p3$age) <- c(rep('PY',15),rep('PW',50),rep('PO',36),'PT')
p3 <- p3 %>% filter(sex=='b') %>% select(-sex) %>%
        group_by(id,year,age) %>%
        summarise(value=sum(value)) %>%
        ungroup()%>%
        spread(age,value) %>%
        mutate(PN = PY+PO) %>%
        select(-PO,-PY)

p3begin <- filter(p3, year!='y2043') %>% droplevels()
p3end <- filter(p3, year!='y2013')
p3end$year <- p3begin$year

df <- left_join(p3begin,p3end,by=c('id','year'))

df <- left_join(df,CT, by=c('id','year'))
df <- left_join(df,MG, by=c('id','year'))

df <- df %>% mutate(MT = PW.y-PW.x-CT-MG)


################################################################################
# Calculate decomposition

dec <- transmute(df, year=year, id=id,
                 g = PW.y/PN.y - PW.x/PN.x,
                 nw = .5*(PW.y+PW.x)*(1/PN.y-1/PN.x),
                 w = .5*(1/PN.y+1/PN.x)*(PW.y-PW.x),
                 mt = .5*(1/PN.y+1/PN.x)*MT,
                 mg = .5*(1/PN.y+1/PN.x)*MG,
                 ct = .5*(1/PN.y+1/PN.x)*CT,
                 tsr.year.begin = PW.x/PN.x)     

#calculate TSR for the periods beginings
tsr0 <- df %>%
        filter(year%in%c('y2013','y2023','y2033')) %>%
        transmute(year=year, id=id,
                  tsr=PW.x/PN.x) %>%
        spread(year,tsr)
names(tsr0)[2:4] <- gsub('y20','tsr',names(tsr0)[2:4])


n2proj.dec <- left_join(dec,tsr0,'id')   

save(n2proj.dec,file = 'data3_calculated/n2proj.dec.Rdata')


###
# Report finish of the script execution
print('Done: script 2.11')
