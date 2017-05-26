################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Estimate convergence models from decomposed data
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
# NOTE: this funcrion depends on other self-defined functions:
# ik_an_multiple.y.lm.list() AND ik_an_extract.lm()
#                                                                                                    
################################################################################


ik_phd_estimate.conv.models.dec <- function(df,years){
        
        require(dplyr)
        require(tidyr)
        require(data.table)
        
        jan1.years <- paste0('y',years)
        fullyears <- jan1.years[-length(jan1.years)]
        
        est.l <- list()
        
        for (i in 1:length(fullyears)) {
                di <- filter(df, year==fullyears[i])
                modelsi <- ik_an_multiple.y.lm.list(di,y=3:8,x=10)
                tablei <- ik_an_extract.lm(modelsi,round = F) %>%
                        mutate(year = fullyears[i]) %>%
                        gather('variable','value',2:7)
                tablei$model_y.x <- factor(c("(A). Level 1. Overall model","(B). Level 2. Non-working age","(C). Level 2. Working age",
                                      "(F). Level 3. Mortality","(E). Level 3. Migration","(D). Level 3. Cohort turnover"))

                est.l[[i]] <- tablei
                names(est.l)[i] <- fullyears[i]
        }
        
        est <- rbind_all(est.l) %>%
                spread(variable,value) %>%
                mutate(year=factor(year)) %>%
                group_by(model_y.x) %>%
                mutate(group.mean = mean(coef)) %>%
                ungroup()
        
        return(est)
        
}
