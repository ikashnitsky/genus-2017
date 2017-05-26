################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Fix the problem of mapping ppolygons with holes using ggplot2
# NOTE: inpot is a fortified spatialPolygons object
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################

# NOTE: The solution comes from an SO question
# http://stackoverflow.com/questions/21748852/choropleth-map-in-ggplot-with-polygons-that-have-holes/32186989

# How to use the function?
# The output is a list with 2 elements.
# The layer plygons and holes should be plotted twice using the data from boths 
# objects of the gghole output. For example:

# gg_map <- ggplot() +
#         geom_polygon(data = gghole(FORT)[[1]], 
#                      aes_string(x='long', y='lat', group='group',fill='VAR'),
#                      color='grey30',size=.1)+
#         geom_polygon(data = gghole(FORT)[[2]], 
#                      aes_string(x='long', y='lat', group='group',fill='VAR'),
#                      color='grey30',size=.1)

# Where: FORT is a fortified spatialPolygons, VAR is some variable to define fill
# colors

gghole <- function(fort){
        poly <- fort[fort$id %in% fort[fort$hole,]$id,]
        hole <- fort[!fort$id %in% fort[fort$hole,]$id,]
        out <- list(poly,hole)
        names(out) <- c('poly','hole')
        return(out)
}