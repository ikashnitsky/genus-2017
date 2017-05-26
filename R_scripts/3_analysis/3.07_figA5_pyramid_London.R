################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure A5. Appendix. Population pyramids. London
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


df.london <- filter(n2p1,id=='UKI1',age%in%c(paste0('a0',0:9),paste0('a',10:90)),sex!='b') %>% 
        droplevels()

# simulate age 90
a90 <- filter(df.london,age=='a89') %>%
        mutate(age='a90',
               value=.9*value)

df.london[is.null(df.london)] <- NA

df.london <- ik_dm_fill.missings(df.london,a90,by=c('year','id','sex','age'))



gg <- ik_gg_population.pyramid.compare(df = df.london,t1 = 2003,t2 = 2013, base_family = myfont)

ggsave('_output/figA5_pyramid_London.png',gg,width = 7, height = 7,dpi=192)


###
# Report finish of the script execution
print('Done: script 3.07')
