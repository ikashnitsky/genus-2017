################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure 2. Plot TSR dynamics. OBS + PROJ for subregions
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

myfont <- "Roboto Condensed"

# load own functions
load('data0_supplementary/own_functions.RData')

# load data
load('data3_calculated/n2dec0342.RData')

years <- paste0('y',2003:2043)
fullyears <- paste0('y',2003:2042)

year.labels <- 2003:2042
year.labels[-c(seq(1,36,5),40)] <- ''
year.ticks <- (as.numeric(nchar(year.labels))+4)/8


brbg3 <- brewer.pal(11, "BrBG")[c(8,2,11)]


################################################################################

df.sub <- n2dec0342 %>%
        select(1,3:9,12) %>%
        group_by(year,subregion) %>%
        summarise_each(funs(mean)) %>%
        ungroup()

df.mean <- n2dec0342 %>%
        select(1,3:9) %>%
        group_by(year) %>%
        summarise_each(funs(mean)) %>%
        ungroup()

gg.tsr.dist <- ggplot()+
        
        annotate('rect',xmin=-Inf,xmax=11,ymin=-Inf,ymax=Inf,fill='grey95')+
        
        geom_jitter(data=n2dec0342, 
                    aes(x=year,y=tsr,color=subregion),
                    size=2,alpha=.75,width = .5) +
        
        geom_line(data=df.sub,
                  aes(x=year,y=tsr,group=subregion), 
                  size=3, color='white',lineend='round') +
        geom_line(data=df.sub,
                  aes(x=year,y=tsr,group=subregion), 
                  size=2, color='black',lineend='round') +
        geom_line(data=df.sub,
                  aes(x=year,y=tsr,group=subregion,color=subregion), 
                  size=1.8,lineend='round') +
        
        geom_line(data=df.mean,
                  aes(x=year,y=tsr,group=1), 
                  size=3, color='white',lineend='round') +
        geom_line(data=df.mean,
                  aes(x=year,y=tsr,group=1), 
                  size=2, color='black',lineend='round') +
        geom_point(data=df.mean,
                   aes(x=year,y=tsr),
                   color='black',size=1.8) +
        
        scale_color_manual(values = rev(brbg3))+
        
        xlab(NULL)+
        scale_x_discrete(labels=year.labels)+
        scale_y_continuous(breaks = seq(1,2.75,.25))+
        ylab('Total support ratio')+
        theme_few(base_size = 20, base_family = myfont)+
        theme(legend.position='none',
              axis.text.x = element_text(angle = 0, vjust = 0.5),
              axis.ticks = element_line(size = year.ticks))+
        
        geom_text(data = data_frame(x= c(19.5,26.5,21.5), 
                                    y=c(2.4,2.25,1.05), 
                                    label = c('Eastern Europe','Southern Europe','Western Europe')), 
                  aes(x=x,y=y,label=label),
                  color = rev(brbg3),family = myfont,
                  size=8, hjust=0.5, vjust=0) +
        
        annotate('text',x=10,y=2.9,label='London',family = myfont,
                 color=brbg3[1],size=6,hjust=0, vjust=1,fontface=3)+
        annotate('text',x=32,y=.87,label='Eastern Germany',family = myfont,
                 color=brbg3[1],size=6,hjust=0, vjust=1,fontface=3)+
        
        annotate('text',x=1,y=1.5,label='Mean EU',color='black',size=8,hjust=0, vjust=1,family = myfont)+
        geom_curve(data = data.frame(x = 3.5, y = 1.5, xend = 3.5, yend = 2.03),
                   aes(x=x,y=y,xend=xend,yend=yend),
                   color='black', size=.5, curvature = 0,
                   arrow = arrow(type="closed",length = unit(0.25,"cm")))+
        geom_curve(data = data.frame(x=c(19.5,26.5,21.5),
                                     xend=c(19.5,26.5,21.5),
                                     y=c(2.38,2.23,1.1), 
                                     yend=c(1.85,1.65,1.63)),
                   aes(x=x,y=y,xend=xend,yend=yend),
                   color='black', size=.5, curvature = 0,
                   arrow = arrow(type="closed",length = unit(0.25,"cm")))
        

ggsave('_output/fig2_TSR_0342_jitter+lines.png',gg.tsr.dist,width = 12,height = 12,dpi=192)



###
# Report finish of the script execution
print('Done: script 3.02')