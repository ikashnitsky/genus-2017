################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Prepare missing data. Denmark. NUTS-2
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
# See also: https://ikashnitsky.github.io/2017/denmark-nuts-reconstruction/
#                                                                                                    
################################################################################

# What is missing?
# Population structures (before 2007) and deaths (before 2006) for all NUTS-2 
# regions of Denmark. There was an administrative reform in 2007 that changed
# the whole municipal and regional division in the country.
# 
# Strategy: I will aggregate data from munucupality level at NUTS-2 level
# The matching between mun and NUTS-2 is done manually using GIS, i.e. I 
# checked what municipalities of the division before 2007 were located in the
# present day NUTS-2 and NUTS-3 regions.


# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')

match <- read.csv('data1_raw/Missing_data/raw_DK/MATCHED.csv')

################################################################################
# population 
p1 <- read.csv('data1_raw/Missing_data/raw_DK/BEF1A.csv.gz')

p1 <- p1 %>% gather('year','value',4:7)
levels(p1$age) <- c(paste('a0',0:9,sep=''),paste('a',10:99,sep=''),rep('open',26))
# summarize by age
p1 <- p1 %>% group_by(code,sex,age,year) %>%
        summarise(value=sum(value)) %>% ungroup()

#summarize ny NUTS-2
n2p1 <- inner_join(p1,match,'code') %>% 
        group_by(year,idn2,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup() %>%
        rename(id=idn2) %>%
        select(year,id,sex,age,value) %>%
        arrange(sex,year,id,age) %>%
        mutate(year=factor(year)) 

# add both sex
n2p1b <- n2p1 %>% mutate(sex=factor('b')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup() 

n2p1 <- suppressWarnings(bind_rows(n2p1b,n2p1)) %>%
        mutate(sex=factor(sex),
               value=as.numeric(value))

# add age 'total'
ptot <- n2p1 %>% mutate(age=factor('total')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup()

n2p1 <- suppressWarnings(bind_rows(n2p1,ptot)) %>%
        mutate(age=factor(age))





################################################################################
# deaths 
d1 <- read.csv('data1_raw/Missing_data/raw_DK/FOD2.csv.gz')

d1 <- d1 %>% gather('year','value',4:6)
levels(d1$age) <- c(paste('a0',0:9,sep=''),paste('a',10:99,sep=''),rep('open',26))
# summarize by age
d1 <- d1 %>% group_by(code,sex,age,year) %>%
        summarise(value=sum(value)) %>% ungroup()

#summarize ny NUTS-2
n2d1 <- inner_join(d1,match,'code') %>% 
        group_by(year,idn2,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup() %>%
        rename(id=idn2) %>%
        select(year,id,sex,age,value) %>%
        arrange(sex,year,id,age) %>%
        mutate(year=factor(year)) 

# add both sex
n2d1b <- n2d1 %>% mutate(sex=factor('b')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup() 

n2d1 <- suppressWarnings(bind_rows(n2d1b,n2d1)) %>%
        mutate(sex=factor(sex),
               value=as.numeric(value))

# add age 'total'
ptot <- n2d1 %>% mutate(age=factor('total')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup()

n2d1 <- suppressWarnings(bind_rows(n2d1,ptot)) %>%
        mutate(age=factor(age))




# save
n2d1mDK <- n2d1
n2p1mDK <- n2p1

save(n2d1mDK,n2p1mDK, file = 'data1_raw/Missing_data/ready.missing.DK.RData')



###
# Report finish of the script execution
print('Done: script 2.06')
