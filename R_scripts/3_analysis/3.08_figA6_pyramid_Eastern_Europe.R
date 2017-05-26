################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure A6. Appendix. Population pyramids. Eastern Europe
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

myfont <- "Roboto Condensed"

# load own functions
load('data0_supplementary/own_functions.RData')

# load data
load('data2_prepared/n2p1.RData')
load('data2_prepared/n2p1proj.RData')

load('data0_supplementary/subregions.EuroVoc.countries.RData')

df.ee.obs <- filter(n2p1,substr(paste(id),1,2)%in%EUE,
                    age%in%c(paste0('a0',0:9),paste0('a',10:84)),sex!='b',year!='y2013') %>% 
        droplevels() %>%
        group_by(year,sex,age) %>%
        summarise(value=sum(value)) %>%
        ungroup()

df.ee.proj <- filter(n2p1proj,substr(paste(id),1,2)%in%EUE,
                     age%in%c(paste0('a0',0:9),paste0('a',10:84)),sex!='total') %>%
        droplevels() %>%
        group_by(year,sex,age) %>%
        summarise(value=sum(value)) %>%
        ungroup()


df.ee <- bind_rows(df.ee.obs,df.ee.proj)
df.ee$year <- factor(df.ee$year)

gg1 <- ik_gg_population.pyramid.compare(df = df.ee,t1 = 2003,t2 = 2013, base_family = myfont)
gg2 <- ik_gg_population.pyramid.compare(df = df.ee,t1 = 2013,t2 = 2023, base_family = myfont)
gg3 <- ik_gg_population.pyramid.compare(df = df.ee,t1 = 2023,t2 = 2033, base_family = myfont)
gg4 <- ik_gg_population.pyramid.compare(df = df.ee,t1 = 2033,t2 = 2043, base_family = myfont)


gg <- cowplot::plot_grid(gg1,gg2,gg3,gg4,ncol = 2,label_size = 20,
                         labels=c('A. 2003 and 2013',
                                  'B. 2013 and 2023',
                                  'C. 2023 and 2033',
                                  'D. 2033 and 2043'))


ggsave('_output/figA6_pyramid_EastEU.png',gg,width = 12, height = 14,dpi=192)



###
# Report finish of the script execution
print('Done: script 3.08')
