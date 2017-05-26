################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Calculate decomposition for 263 NUTS-2 regions for 2003-2042 OBS+PROJ
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')



load('data3_calculated/n2proj.dec.Rdata')
load('data3_calculated/n2obs.dec.Rdata')
load('data0_supplementary/idn2sub.Rdata')
load('data0_supplementary/idn0123.RData')


n2dec0342 <- rbind(n2obs.dec[,1:9],n2proj.dec[,1:9])

tsr03 <- n2dec0342 %>% filter(year%in%c('y2003')) %>%
        select(2,9) %>% rename(tsr03=tsr.year.begin)

n2dec0342 <- left_join(n2dec0342,tsr03,'id') 

n2dec0342 <- n2dec0342 %>% rename(tsr=tsr.year.begin)

# add country and subregion factors
n2dec0342 <- suppressWarnings(left_join(n2dec0342,idn2sub,'id'))
n2dec0342$id <- factor(n2dec0342$id)


save(file = 'data3_calculated/n2dec0342.RData', n2dec0342)




###
# Report finish of the script execution
print('Done: script 2.12')
