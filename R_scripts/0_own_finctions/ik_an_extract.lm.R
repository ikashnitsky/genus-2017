################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Extract estimates of simple lm models
# NOTE: the function is designed for just a simple linear regression with just 
# 1 regressor
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################


ik_an_extract.lm <- function(list, round=T){
        
        extract <- data.frame(matrix(0,length(list),7))
        names(extract) <- c('model_y.x','coef','conf2.5','conf97.5','pValue','Rsq','cor')
        
        for (i in 1:length(list)){
             
                modeli <- list[[i]]
                
                namei <- names(list)[i]
                coef <- coef(modeli)[[2]]
                ci1 <- confint(modeli)[2,1]
                ci2 <- confint(modeli)[2,2]
                p.value <- summary(modeli)$coefficients[2,4]
                Rsq <- summary(modeli)$r.squared
                cor <- cor(modeli$model)[2,1]
                
                extract[i,1] <- namei
                extract[i,2:7] <- c(coef,ci1,ci2,p.value,Rsq,cor)
                   
        }
        
        if (round==T) {extract[,2:7] <- apply(extract[,2:7],2,round,3)} else {}
        
        return(extract)
}