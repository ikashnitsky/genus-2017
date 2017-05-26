################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Decompose THEIL inequality index for between and within groups components
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Data organization!
# Input should be any data.frame with at least 3 columns representing
# (1) unique records (default is 'id')
# (2) groups (default is 'group')
# (3) values to be analyzed for inequality (default is 'value')
# Data frame may be prepared according to default organization OR
# the correct colums could be defined

# Output is a list of 2 data farmes 
# 1. theil - global, between, within 
# 2. theil.each.group.impact

ik_phd_an_theil.decomposition <- function(df, id='id', group='group', value='value'){
        
        require(dplyr)
        require(tidyr)
        
        df <- df[,match(c(id,group,value),colnames(df))]
        colnames(df) <- c('id','group','value')
        
        df <- df %>%
                mutate(sum_value = sum(value,na.rm=T),
                       ni = length(value),
                       si = value/sum_value,
                       theil.glob =  sum(si*log(ni*si),na.rm = T))

        
        theil.glob <- df %>%
                summarise_each(funs(mean)) %>%
                select(theil.glob)
        
        theil.each.group <- df %>%
                group_by(group) %>%
                mutate(sij = value/sum(value,na.rm = T),
                       s_gj = sum(value/sum_value,na.rm = T),
                       nij=length(value),
                       theil.between = s_gj*log(ni/nij*s_gj),
                       theil.within = s_gj*sum(sij*log(nij*sij),na.rm =T)) %>%
                summarise_each(funs(mean)) %>%
                select(group,theil.between,theil.within) 
        
        theil.between.within <- theil.each.group %>%
                select(-group) %>% 
                summarise_each(funs(sum)) 
        
        theil <- cbind(theil.glob, theil.between.within) %>%
                gather('theil','value',1:3)
        
        theil.each.group.impact <- theil.each.group %>%
                gather('variable','value',2:3)
        
        
        out <- list()
        out[[1]] <- theil
        names(out)[1] <- 'theil'
        out[[2]] <- theil.each.group.impact
        names(out)[2] <- 'theil.each.group.impact'
        
        return(out)
}

