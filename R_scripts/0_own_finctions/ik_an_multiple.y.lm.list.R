################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Run several simple lm models with various regressands (yi) and the 
# same regressor (x)
# NOTE: the function is designed for just a simple linear regression with just 
# 1 regressor; input is a data.farme; x and y are defined as numbers
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################

ik_an_multiple.y.lm.list <- function(data, y, x, scaled=F, log.x=F){
        
        require(dplyr)

        models <- list()
        for (i in 1:length(y)){
                
                var.x <- unlist(select(data,x))
                var.y <- unlist(select(data,y[i]))

                if (scaled==F & log.x==F){modeli <- lm(var.y~var.x)} 
                else if (scaled==F & log.x==T){modeli <- lm(var.y~log(var.x))}
                else if (scaled==T & log.x==F) {modeli <- lm(scale(var.y)~scale(var.x))}
                else {modeli <- lm(scale(var.y)~scale(log(var.x)))}

                models[[i]] <- modeli
                names(models)[i] <- paste(names(data)[y[i]],names(data)[x],sep='.')
        }
        return(models)
}
