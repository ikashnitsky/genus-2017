################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Calculate TSR in 2043
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')

load('data2_prepared/n2p1proj.RData')


p3 <- n2p1proj 
levels(p3$age) <- c(rep('PY',15),rep('PW',50),rep('PO',36),'PT')
p3 <- p3 %>% filter(sex=='b') %>% select(-sex) %>%
        group_by(id,year,age) %>%
        summarise(value=sum(value)) %>%
        ungroup()%>%
        spread(age,value) %>%
        mutate(PN = PY+PO) %>%
        select(-PO,-PY)

n2tsr43 <- p3 %>% filter(year=='y2043') %>%
        transmute(id=id,tsr43=PW/PN)

save(n2tsr43, file = 'data3_calculated/n2tsr43.RData')



###
# Report finish of the script execution
print('Done: script 2.13')