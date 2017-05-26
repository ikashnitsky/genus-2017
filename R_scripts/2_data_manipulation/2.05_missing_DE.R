################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Prepare missing data. Germany. NUTS-2
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################


# What is missing?
# Germany. DED4 and DED5 (Chemnitz and Leipzig) + NUTS-3
# Deaths and pop str. for 2003-2013


# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')




p1 <- read.csv('data1_raw/Missing_data/raw_DE/173-33-4-B.csv.gz',colClasses = 'character')

p1$age <-  rep(c(paste0('a0',0:9),paste0('a',10:74),rep('open',3),'total'))

# summarise open age group
p1 <- p1 %>% gather('sex','value',4:6) %>%
        mutate(value=as.numeric(value)) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>%
        ungroup() %>%
        filter(age!='total')

# !!! add 2003 equal to 2004 a year earlier
p1.03 <- p1 %>% filter(year=='2004', !age%in%c('a00'))
p1.03$year <- '2003'
p1.03$age <- c(paste0('a0',0:9),paste0('a',10:73),'open')
p1.03.a74 <- p1.03 %>% filter(age=='a73')
p1.03.a74$age <- 'a74'
p1.03 <- bind_rows(p1.03,p1.03.a74)

# add 2003 to the main data set
p1 <- bind_rows(p1.03,p1) %>% arrange(sex,year,id,age)


# smooth the old ages
open <- p1 %>% filter(age=='open') %>% droplevels() %>% select(-age)

# load HMD data
hmd <- read.table('data1_raw/Missing_data/raw_DE/HMD_DE_exposure_1x1.txt.gz',header=T,skip=2,as.is = T) 
names(hmd) <- c('year','age','f','m','b')
hmd.weights <- hmd %>%
        filter(age%in%75:99,year%in%2003:2010) %>% droplevels() %>%
        ik_ut_colclass_numeralize(3:5) %>% 
        gather('sex','value',3:5) %>%
        group_by(year,sex) %>%
        mutate(value=value/sum(value)) %>%
        ungroup()
hmd.weights$age <- paste0('a',hmd.weights$age)
hmd.weights$year <- paste(hmd.weights$year)

old <- left_join(hmd.weights,open,c('year','sex')) %>%
        mutate(value=value.x*value.y) %>%
        select(year,id,sex,age,value)

# add old back to the main data set
p1 <- bind_rows(p1,old)

# zeros to open age group
p1[p1$age=='open',5] <- 0


p1 <- arrange(p1, sex,year,id,age)
p1$year <- paste0('y',p1$year)





###
# deaths recreate for 1-year age groups using HMD mortality ratios for Germany

mx <- read.table('data1_raw/Missing_data/raw_DE/HMD_DE_Mx_1x1.txt.gz',header=T,skip=2,colClasses = 'character') 
names(mx) <- c('year','age','f','m','b')
mx <- mx %>% filter(year%in%2003:2010,age%in%0:99) %>%
        gather('sex','value',3:5)
mx$age <- c(paste0('a0',0:9),paste0('a',10:99))
mx$year <- paste0('y',mx$year)
mx$value <- as.numeric(mx$value)

d1 <- left_join(filter(p1,!age%in%c('open','total')),mx,c('year','sex','age')) %>%
        mutate(value=value.x*value.y) %>%
        select(year,id,sex,age,value) %>%
        arrange(sex,year,id,age)
        
# add a zero open age category
dopen <- d1 %>% filter(age=='a00') %>%
        mutate(age='open',value=0)

# add to the main data set
d1 <- bind_rows(d1,dopen) %>% arrange(sex,year,id,age)




# correct population structure in 2003 for those died in 2003
p1[p1$year=='y2003',5] <- p1[p1$year=='y2003',5]-d1[d1$year=='y2003',5]



###
#convert to factors
p1 <- p1 %>% mutate(year=factor(year),id=factor(id),sex=factor(sex),age=factor(age))
d1 <- d1 %>% mutate(year=factor(year),id=factor(id),sex=factor(sex),age=factor(age))

###
# add 'total' age proup

ptot <- p1 %>% mutate(age=factor('total')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup()

n2p1 <- suppressWarnings(bind_rows(p1,ptot)) %>%
        mutate(age=factor(age))


dtot <- d1 %>% mutate(age=factor('total')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup()

n2d1 <- suppressWarnings(bind_rows(d1,dtot)) %>%
        mutate(age=factor(age))



################################################################################
# save properly
n2d1mDE <- n2d1
n2p1mDE <- n2p1
save(n2d1mDE,n2p1mDE,file = 'data1_raw/Missing_data/ready.missing.DE.RData')



###
# Report finish of the script execution
print('Done: script 2.05')
