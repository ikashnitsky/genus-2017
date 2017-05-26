################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Reconstruct the population data for Romania, NUTS-2
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Why?
# There was a Census in Romania in 2011 that registered large, and previously 
# underestimated, decrease in population size. Evidently, the outmigration from 
# Romania was underreported. Yet, no rollback corrections were made, and Eurostat 
# provides non-harmonized data for Romanian regions. Thus, we harmonized the 
# population figures for Romanian regions. 


# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')



load('data1_raw/n2p1.missings.RData')
load('data1_raw/n2d1.missings.RData')

n2p1RO <- n2p1 %>% filter(substr(paste(id),1,2)=='RO') %>% droplevels()
n2d1RO <- n2d1 %>% filter(substr(paste(id),1,2)=='RO') %>% droplevels()


################################################################################
# Exploratory data analysis
################################################################################

#plot to see the discrepancy
gg.pop <- ggplot(n2p1RO %>% group_by(year,id,sex) %>% summarise(value=sum(value)))+
        geom_point(aes(x=year,y=value/10^6))+
        facet_wrap(id~sex,scales = "free",ncol = 3)+
        scale_x_discrete('',labels=2003:2013)+
        theme_few(base_size = 15)

ggsave('_output/Romania_check_discrepancy.png',gg.pop,width = 12,height = 18,dpi=192)

# check the age effect
df.ch.age <- n2p1RO %>% 
        filter(sex=='b') %>%
        mutate(a10 = factor(paste0(substr(paste(age),2,2),'0s'))) %>%
        group_by(year,id,a10) %>% 
        summarise(value=sum(value))


gg.pop.b.10 <- ggplot(filter(df.ch.age,a10!='o0s'))+
        geom_point(aes(x=year,y=value/10^6))+
        geom_path(aes(x=year,y=value/10^6,group=1))+
        facet_grid(id~a10,scales = "free")+
        scale_x_discrete('',labels=3:13)+
        theme_few(base_size = 10)

ggsave('_output/Romania_check_discrepancy_by_age.png',gg.pop.b.10,width = 18,height = 12,dpi=192)






gg.death <- ggplot(n2d1RO %>% group_by(year,id,sex) %>% summarise(value=sum(value)))+
        geom_point(aes(x=year,y=value/10^3))+
        geom_path(aes(x=year,y=value/10^3,group=1))+
        facet_wrap(id~sex,scales = "free",ncol=3)+
        scale_x_discrete('',labels=2003:2013)+
        theme_few(base_size = 10)


df.ch.age.death <- n2d1RO %>% 
        filter(sex=='b') %>%
        mutate(a10 = factor(paste0(substr(paste(age),2,2),'0s'))) %>%
        group_by(year,id,a10) %>% 
        summarise(value=sum(value))

gg.pop.b.10 <- ggplot(filter(df.ch.age.death,a10!='o0s'))+
        geom_point(aes(x=year,y=value/10^3))+
        geom_path(aes(x=year,y=value/10^3,group=1))+
        facet_grid(id~a10,scales = "free")+
        scale_x_discrete('',labels=3:13)+
        theme_few(base_size = 10)

# nothing particularly strange here


################################################################################
# Let's correct it. Cohort-wise
# STRATEGY:
# 1. Calculate pseudo-observed migration numbers using mortality figures and 
#    unharmonized population
# 2. Forward-roll population structure 2003 using the mortality and observed migration data
# 3. Calculate the descrepancy between estimated population forward-roll population 
#    and the observed population in 2012
# 4. Distribute the discrepancy by years taking into account the pseudo-observed migration
# In short, the idea is to redistribute the excess(shortage) of population 
# assuming that migration record captured the real trends.
# *assumption: everybody is born on 01-01-yyyy
# *assumption: migration in 2011 equals 2010 
################################################################################

# drop OPEN and TOTAL age groups and year 2013
df.p <- n2p1RO %>% filter(!age%in%c('open','total'),year!='y2013') %>% droplevels()
df.d <- n2d1RO %>% filter(!age%in%c('open','total'),!year%in%c('y2012','y2013')) %>% droplevels()


# create cohort variable and spread using cohorts 
# we also drop all the cohorts with not full data + 2003:2001 - kids
# dfc means data frame cohort
dfc.p <- df.p %>% 
        mutate(cohort = factor(paste0('c',2003+as.numeric(year)-as.numeric(age))),
               age=NULL) %>%
        spread(year,value) %>%
        arrange(sex,id,desc(cohort)) %>%
        filter(cohort%in%paste0('c',2003:1928)) %>%
        droplevels()

dfc.d <- df.d %>% 
        mutate(cohort = factor(paste0('c',2003+as.numeric(year)-as.numeric(age))),
               age=NULL) %>%
        spread(year,value) %>%
        arrange(sex,id,desc(cohort)) %>%
        filter(cohort%in%paste0('c',2003:1928))%>%
        droplevels()



# calculate cohort change
dfc.cc <- data.frame(dfc.p[,1:3],
                    dfc.p[,5:13]-dfc.p[,4:12])
names(dfc.cc)[4:12] <- names(dfc.p)[4:12]

# calculate observed migration
dfc.mg <- data.frame(dfc.cc[,1:3],
                    dfc.cc[,4:11]+dfc.d[,4:11]) # + because of mortality


# calculate cumulated annual excessive migration for each year
dfc.ex.2 <- dfc.p %>% 
        transmute(id=id,sex=sex,cohort=cohort,
                  ex03=((y2012-y2003) - 
                              apply(dfc.mg[,4:11],1,sum) +
                              apply(dfc.d[,4:11],1,sum)) / 9,  # divide by 9 years
                  ex04=ex03*2,ex05=ex03*3,ex06=ex03*4,ex07=ex03*5,
                  ex08=ex03*6,ex09=ex03*7,ex10=ex03*8) 

dfc.p.cor <- data.frame(dfc.p[,1:4], dfc.p[,5:12]+dfc.ex.2[,4:11],y2012=dfc.p[,13])



# now we need to transform back from cohorts to ages
cor <- dfc.p.cor %>%
        gather('year','value',y2003:y2012) %>%
        mutate(tmp.coh=as.numeric(substr(paste(cohort),2,5)),
               tmp.year=as.numeric(substr(paste(year),2,5)),
               age = factor(paste0('a',tmp.year-tmp.coh)),
               tmp.coh=NULL,
               tmp.year=NULL)
#correct the levels of age
levels(cor$age)[nchar(levels(cor$age))==2] <- gsub('a','a0',levels(cor$age)[nchar(levels(cor$age))==2])
cor$year <- factor(cor$year)

cor <- arrange(cor, year,id,sex,age) %>% select(4,1,2,6,3,5)

# finally, insert the new values to the initial data set
n2p1mRO <- ik_dm_fill.missings(n2p1RO,cor,by=1:4)

save(n2p1mRO,file = 'data1_raw/Missing_data/ready.missing.RO.RData')



################################################################################
# check the harmonization

# plot the garmonized data 
df.ch.age.cor <- n2p1mRO %>% 
        filter(sex=='b') %>%
        mutate(a10 = factor(paste0(substr(paste(age),2,2),'0s'))) %>%
        group_by(year,id,a10) %>% 
        summarise(value=sum(value))


gg.pop.b.10.cor <- ggplot(filter(df.ch.age.cor,a10!='o0s'))+
        geom_point(aes(x=year,y=value/10^6))+
        geom_path(aes(x=year,y=value/10^6,group=1))+
        facet_grid(id~a10,scales = "free")+
        scale_x_discrete('',labels=3:13)+
        theme_few(base_size = 10)


ggsave('_output/Romania_check_harmonized_data_by_age.png',width = 18,height = 12,dpi=192)



###
# Report finish of the script execution
print('Done: script 2.08')