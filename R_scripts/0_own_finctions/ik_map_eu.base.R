################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Create a canvas map of Europe
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# NOTE: the function requires certain spatial objects to be loaded in Global 
# Environment. They can be downloaded here:
# https://dx.doi.org/10.6084/m9.figshare.3100657

ik_map_eu.base <- function(background_color='grey90', family = ""){
        
        require(ggplot2)
        require(ggthemes)
        require(sp)
        require(rgdal)
        require(maptools)
        
        
        if (exists('Sneighbors')==F){
                load('/Jottacloud/PhD/R/DATA/zzz.geodata/shp.neighbors.RData')
        } else {}
        
        map <- ggplot()+
                geom_polygon(data=fortify(Sneighbors),aes(x=long, y=lat, group=group),fill=background_color,color=background_color)+
                coord_equal(ylim=c(1350000,5450000), xlim=c(2500000, 6600000))+
                guides(fill = guide_colorbar(barwidth = 1.5, barheight = 20))+
                
                theme_map(base_family = family)+
                theme(panel.border=element_rect(color = 'black',size=.5,fill = NA),
                      legend.position = c(1, 1),
                      legend.justification = c(1, 1),
                      legend.background = element_rect(colour = NA, fill = NA),
                      legend.title = element_text(size=15),
                      legend.text = element_text(size=15))+
                scale_x_continuous(expand=c(0,0)) +
                scale_y_continuous(expand=c(0,0)) +
                labs(x = NULL, y = NULL)
        
        return(map)
}
