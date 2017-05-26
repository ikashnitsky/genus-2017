################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Replace slots in x by corresponding values from y
# NOTE: input requites two data frames (x and y) with at least 1 common id field
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################

ik_dm_fill.missings <- function(x,y,by){
        x <- merge(x,y,by=by,all.x=T,all.y=F)
        x$value.y[ is.na(x$value.y) ] <- x$value.x[ is.na(x$value.y) ]
        x$value <- x$value.y
        x <- subset(x, select=-c(value.x,value.y))
        return(x)
}
