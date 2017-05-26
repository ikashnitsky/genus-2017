################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure 1. TSR in 2003 and 2043 + change over 4 decades - map results
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')

# load data
load('geo_data/shp.n2eu28.all.RData')
load('data3_calculated/n2dec0342.RData')

myfont <- "Roboto Condensed"

basemap <- ik_map_eu.base()

bord <- fortify(Sborders)
fort <- fortify(Sn2, region = 'id') 

################################################################################
# maps TSR 2003 and 2042 - fixed color scales
df.tsr03 <- n2dec0342 %>% filter(year == 'y2003')

fort.tsr03 <- left_join(x=fort, y=df.tsr03, by = 'id')

tsr03 <- basemap +
        geom_polygon(data = gghole(fort.tsr03)[[1]], aes_string(x='long', y='lat', group='group', fill='tsr03'),
                     color='grey30',size=.1)+
        geom_polygon(data = gghole(fort.tsr03)[[2]], aes_string(x='long', y='lat', group='group', fill='tsr03'),
                     color='grey30',size=.1)+
        scale_fill_viridis('TSR\n2003',limits=c(.868,2.765), option = 'B')+
        geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
        guides(fill = guide_colorbar(barwidth = 1, barheight = 9))


load('DATA/aaa.RESULTS/.calculated/n2tsr43.Rdata')

fort.tsr43 <- left_join(x=fort, y=n2tsr43, by = 'id')

tsr43 <- basemap +
        geom_polygon(data = gghole(fort.tsr43)[[1]], aes_string(x='long', y='lat', group='group', fill='tsr43'),
                     color='grey30',size=.1)+
        geom_polygon(data = gghole(fort.tsr43)[[2]], aes_string(x='long', y='lat', group='group', fill='tsr43'),
                     color='grey30',size=.1)+
        scale_fill_viridis('TSR\n2043',limits=c(.868,2.765), option = 'B')+
        geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
        guides(fill = guide_colorbar(barwidth = 1, barheight = 9))






################################################################################
# change maps 4 periods - fixed color scales

df.g1 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%1:10) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.g1 <- left_join(x=fort, y=df.g1, by = 'id')

g1 <- basemap +
        geom_polygon(data = gghole(fort.g1)[[1]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        geom_polygon(data = gghole(fort.g1)[[2]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        scale_fill_viridis('TSR change\n2003-2012',limits=c(-.7238,.3275))+
        geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
        guides(fill = guide_colorbar(barwidth = 1, barheight = 9))


df.g2 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%11:20) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.g2 <- left_join(x=fort, y=df.g2, by = 'id')

g2 <- basemap +
        geom_polygon(data = gghole(fort.g2)[[1]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        geom_polygon(data = gghole(fort.g2)[[2]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        scale_fill_viridis('TSR change\n2013-2022',limits=c(-.7238,.3275))+
        geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
        guides(fill = guide_colorbar(barwidth = 1, barheight = 9))


df.g3 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%21:30) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.g3 <- left_join(x=fort, y=df.g3, by = 'id')

g3 <- basemap +
        geom_polygon(data = gghole(fort.g3)[[1]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        geom_polygon(data = gghole(fort.g3)[[2]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        scale_fill_viridis('TSR change\n2023-2032',limits=c(-.7238,.3275))+
        geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
        guides(fill = guide_colorbar(barwidth = 1, barheight = 9))


df.g4 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%31:40) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.g4 <- left_join(x=fort, y=df.g4, by = 'id')

g4 <- basemap +
        geom_polygon(data = gghole(fort.g4)[[1]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        geom_polygon(data = gghole(fort.g4)[[2]], aes_string(x='long', y='lat', group='group', fill='g'),
                     color='grey30',size=.1)+
        scale_fill_viridis('TSR change\n2033-2042',limits=c(-.7238,.3275))+
        geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
        guides(fill = guide_colorbar(barwidth = 1, barheight = 9))






################################################################################
# align all 6 maps with arrows

require(gridExtra)

list.plots <- list(tsr03,g1,g2,g3,g4,tsr43)


gg <- ggplot()+
        coord_equal(xlim = c(0, 21), ylim = c(0, 30), expand = c(0,0))+
        
        annotation_custom(ggplotGrob(list.plots[[1]]),
                          xmin = 0,xmax = 10,ymin = 20,ymax = 30)+
        
        annotation_custom(ggplotGrob(list.plots[[2]]),
                          xmin = 12,xmax = 21,ymin = 20,ymax = 29)+
        annotation_custom(ggplotGrob(list.plots[[3]]),
                          xmin = 12,xmax = 21,ymin = 10.5,ymax = 19.5)+
        
        annotation_custom(ggplotGrob(list.plots[[4]]),
                          xmin = 0,xmax = 9,ymin = 10.5,ymax = 19.5)+
        annotation_custom(ggplotGrob(list.plots[[5]]),
                          xmin = 0,xmax = 9,ymin = 1,ymax = 10)+
        annotation_custom(ggplotGrob(list.plots[[6]]),
                          xmin = 11,xmax = 21,ymin = 0,ymax = 10)+
        
        labs(x = NULL, y = NULL)+
        theme_void()


# DF with the coordinates of the 5 arrows
df.arrows <- data.frame(id=1:5,
                        x=c(10,12,12,9,9),
                        y=c(25,23,15,13,5),
                        xend=c(12,12,9,9,11),
                        yend=c(25,17,15,7,5))

# add arrows
gg <- gg + geom_curve(data = df.arrows %>% filter(id==1),
                      aes(x=x,y=y,xend=xend,yend=yend),
                      curvature = 0, 
                      arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
        geom_curve(data = df.arrows %>% filter(id==2),
                   aes(x=x,y=y,xend=xend,yend=yend),
                   curvature = 0.3, 
                   arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
        geom_curve(data = df.arrows %>% filter(id==3),
                   aes(x=x,y=y,xend=xend,yend=yend),
                   curvature = 0, 
                   arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
        geom_curve(data = df.arrows %>% filter(id==4),
                   aes(x=x,y=y,xend=xend,yend=yend),
                   curvature = -0.3, 
                   arrow = arrow(type="closed",length = unit(0.25,"cm"))) +
        geom_curve(data = df.arrows %>% filter(id==5),
                   aes(x=x,y=y,xend=xend,yend=yend),
                   curvature = 0, 
                   arrow = arrow(type="closed",length = unit(0.25,"cm"))) 

# add labes
gg <- gg + annotate('text',label = LETTERS[1:6],
                    x=c(0,12,12,0,0,11)+.5,
                    y=c(30.5,29.5,20,20,10.5,10.5)-1,
                    size=10,hjust=0, vjust=1, family = myfont)


ggsave('_output/fig1_maps_TSR_change_4decades.png',gg,width = 12,height = 18,dpi = 192)



###
# Report finish of the script execution
print('Done: script 3.01')
