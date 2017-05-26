################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Prepare missing data. Slovenia. NUTS-2
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# What is missing?
# Population structure for 2003 and 2004




# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')



p5 <- read.csv('data1_raw/Missing_data/raw_SI/05C1004E.csv.gz')

colnames(p5) <- c('sex','year','age','name','value')
levels(p5$sex) <- c('m','b','f') # ! scpecific naming in the original dataset

# # check regional differences (optional)
# dataplot <- subset(p5, sex=='b'&year%in%paste(2003:2007,'H1',sep=''))
# dp.split <- split(dataplot, dataplot$age)
# dp.shares <- list()
# for (i in 5:25){
#         di <- dp.split[[i]]
#         stri <- di[,5]/dp.split[[1]][,5]
#         oi <- data.frame(di[,1:4],stri)
#         dp.shares[[i-4]] <- oi
# }
# dp.shares <- rbindlist(dp.shares)
# 
# plot <- ggplot()+
#         geom_line(data=dp.shares, aes(x=age,y=stri,group = name,color=name))+
#         facet_grid(year~.)
# plot
# 
# plot2 <- ggplot()+
#         geom_line(data=dp.shares, aes(x=age,y=stri,group = year,color=year))+
#         facet_grid(name~.)
# plot2

# result of a check. Significant differences could be seen through time, by not across regions.
# Hence, I can take the pop structure for Slovenia and produce pop structures for regions


# load pop str for Slovenia from HMD
hmd <- read.table('data1_raw/Missing_data/raw_SI/HMD.SI.x1pop.txt.gz', header=T) 
names(hmd) <- c('year','age','f','m','b')
hmd <- hmd %>%
        filter(year%in%c('2003','2004')) %>%
        gather('sex','value',3:5)

# summarize by ages
hmd$age <- c(paste('a0',0:9,sep=''),paste('a',10:99,sep=''),rep('open',11))
hmd <- hmd %>% group_by(year,age,sex) %>%
        summarise(value=sum(value)) %>%
        ungroup() 
hmd.ps <- hmd %>% group_by(year,sex) %>%
        mutate(value=value/sum(value)) %>%
        ungroup()
hmd.ps$year <- paste0('y',hmd.ps$year)
        

ptot <- filter(p5, year%in%c('2003H1','2004H1'),age=='Age - TOTAL') %>% droplevels() %>%
        rename(id=name) %>% select(-age)
levels(ptot$year) <- c('y2003','y2004')
levels(ptot$id) <-  c('SI','SI01','SI02')



# calculate pop structures
p1 <- suppressWarnings(full_join(hmd.ps,ptot,by=c('year','sex'))) %>%
        mutate(value=value.x*value.y) %>%
        select(year,id,sex,age,value) %>%
        arrange(sex,year,id,age) %>%
        mutate(year=factor(year),
               sex=factor(sex),
               age=factor(age))


###
# add 'total' age proup

ptot <- p1 %>% mutate(age=factor('total')) %>%
        group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>% 
        ungroup()

n2p1 <- suppressWarnings(bind_rows(p1,ptot)) %>%
        mutate(age=factor(age)) %>%
        filter(id!='SI') %>%
        droplevels()


# save
n2p1mSI <- n2p1

save(n2p1mSI, file = 'data1_raw/Missing_data/ready.missing.SI.RData')




###
# Report finish of the script execution
print('Done: script 2.07')
