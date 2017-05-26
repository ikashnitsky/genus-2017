################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Table A1. Summary table Appendix. Statistics by country
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')

# load data
load('data3_calculated/n2dec0342.RData')
load('data0_supplementary/subregions.EuroVoc.countries.RData')
load('data0_supplementary/idn2sub.Rdata')

tsr <- n2dec0342 %>% filter(year %in% paste0('y',c(2003,2013,2023,2033,2043))) %>%
        group_by(year,country) %>%
        summarise(tsr=mean(tsr)) %>%
        ungroup() %>%
        spread(year,tsr)


dec <- n2dec0342 %>% select(-(9:12)) %>%
        mutate(decade=factor(ceiling(as.numeric(year)/10))) %>%
        select(-1) %>%
        group_by(decade,id) %>%
        summarise_each(funs(sum)) %>%
        ungroup() %>%
        mutate(id=factor(substr(paste(id),1,2))) %>%
        group_by(decade,id) %>%
        summarise_each(funs(mean))%>%
        ungroup()

dec0312 <- dec %>% filter(decade==1) %>% select(-1) %>% rename(country=id)

nreg <- idn2sub[,1:2] %>% group_by(country) %>% summarise(nreg=n())


load('data2_prepared/n2p1.RData')

pop <- n2p1 %>% filter(sex=='b',year%in%c('y2003','y2013'),age=='total') %>% droplevels() %>%
        mutate(country=factor(substr(paste(id),1,2))) %>%
        group_by(year,country) %>% summarise(pop.cnt=sum(value),mean.pop=mean(value)) %>%
        ungroup() 

pop.cnt <- pop %>% select(-mean.pop) %>% spread(year,pop.cnt)
names(pop.cnt)[2:3] <- paste0(names(pop.cnt)[2:3],'pop.cnt')

pop.mean.pop <- pop %>% select(-pop.cnt) %>% spread(year,mean.pop)
names(pop.mean.pop)[2:3] <- paste0(names(pop.mean.pop)[2:3],'mean.pop')



join <- suppressWarnings(left_join(tsr,dec0312,by='country'))
join <- suppressWarnings(left_join(join,EU28.df,by='country'))
join <- suppressWarnings(left_join(join,nreg,by='country'))
join <- suppressWarnings(left_join(join,pop.cnt,by='country'))
join <- suppressWarnings(left_join(join,pop.mean.pop,by='country'))

join <- join %>% arrange(subregion,country) %>%
        select(-y2023,-y2033) %>%
        select(subregion,country,nreg,y2003pop.cnt,y2003mean.pop,y2013pop.cnt,y2013mean.pop,
               y2003,g,nw,w,ct,mg,mt,y2013)

write.csv(join,file = '_output/tabA1_summary_stat_by_country.csv',row.names = F)


###
# Report finish of the script execution
print('Done: script 3.06')
