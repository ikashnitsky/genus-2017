################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Align decomposed plots neatly on A4 canvas
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# 
# See also: https://ikashnitsky.github.io/2017/align-six-maps/
#
################################################################################


ik_phd_gg_align.6.plots <- function(list.plots, family = "",
                                    labels=LETTERS[1:6], labels.size=8){
        
        require(tidyverse)
        require(gridExtra)
        
        gg <- ggplot()+
                coord_equal(xlim = c(0, 21), ylim = c(0, 30), expand = c(0,0))+
                
                annotation_custom(ggplotGrob(list.plots[[1]]),
                                  xmin = 0.5, xmax = 8.5, ymin = 21, ymax = 29)+
                
                annotation_custom(ggplotGrob(list.plots[[2]]),
                                  xmin = 12.5, xmax = 20.5, ymin = 19.5, ymax = 27.5)+
                annotation_custom(ggplotGrob(list.plots[[3]]),
                                  xmin = 12.5,xmax = 20.5,ymin = 10.5,ymax = 18.5)+
                
                annotation_custom(ggplotGrob(list.plots[[4]]),
                                  xmin = 0.5, xmax = 8.5, ymin = 9,ymax = 17)+
                annotation_custom(ggplotGrob(list.plots[[5]]),
                                  xmin = 0.5, xmax = 8.5, ymin = 0, ymax = 8)+
                annotation_custom(ggplotGrob(list.plots[[6]]),
                                  xmin = 12.5,xmax = 20.5, ymin = 0, ymax = 8)+
                
                labs(x = NULL, y = NULL)+
                theme_void()
        
        
        # DF with the coordinates of the 5 arrows
        df.arrows <- data.frame(id=1:5,
                                x=c(8.5,8.5,12.5,12.5,12.5),
                                y=c(21,21,10.5,10.5,10.5),
                                xend=c(12.5,12.5,8.5,8.5,12.5),
                                yend=c(20.5,17.5,10,7,7))
        
        # add arrows
        gg <- gg +
                geom_curve(data = df.arrows %>% filter(id==1),
                           aes(x=x,y=y,xend=xend,yend=yend),
                           curvature = 0.1,
                           arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
                geom_curve(data = df.arrows %>% filter(id==2),
                           aes(x=x,y=y,xend=xend,yend=yend),
                           curvature = -0.1,
                           arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
                geom_curve(data = df.arrows %>% filter(id==3),
                           aes(x=x,y=y,xend=xend,yend=yend),
                           curvature = -0.15,
                           arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
                geom_curve(data = df.arrows %>% filter(id==4),
                           aes(x=x,y=y,xend=xend,yend=yend),
                           curvature = 0,
                           arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
                geom_curve(data = df.arrows %>% filter(id==5),
                           aes(x=x,y=y,xend=xend,yend=yend),
                           curvature = 0.3,
                           arrow = arrow(type="closed",length = unit(0.25,"cm")))
        
        # add labes
        gg <- gg + annotate('text',label = labels,
                            x=c(.5,12.5,12.5,.5,.5,12.5)+.5,
                            y=c(29,27.5,18.5,17,8,8)+.1,
                            size=labels.size,hjust=0, vjust=0, family = family)
        
        return(gg)
}


