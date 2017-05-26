################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure 5. Plot decomposed bettas, 2003-2042, dependent variable- TSR 2003
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

est0342 <- ik_phd_estimate.conv.models.dec(n2dec0342, years=2003:2043)

est0342 <- est0342 %>% mutate(size=ifelse(pValue<.05,1,.1))


g0a <- ggplot(est0342,aes(x=year,y=coef))+
        
        annotate('rect',xmin=-Inf,xmax=11,ymin=-Inf,ymax=Inf,fill='grey95')+
        geom_hline(yintercept=0)+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(2)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1.5)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(2)),
                   aes(group=model_y.x,color=model_y.x),size=3,shape=21,fill='white')+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(3)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1.5)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(3)),
                   aes(group=model_y.x,color=model_y.x),size=3,shape=16)+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(1)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=2)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(1)),
                   aes(group=model_y.x,color=model_y.x),size=4)+
        
        scale_color_manual(values = viridis(6)[1:3]) +
        scale_x_discrete(labels= year.labels)+
        scale_y_continuous(limits=c(-.05,.03))+
        xlab(NULL)+
        ylab('Beta-coefficient')+
        theme_few(base_size = 20, base_family = myfont)+
        theme(legend.position='none',
              axis.text.x = element_text(angle = 0, vjust = 0.5),
              axis.ticks = element_line(size = year.ticks))+
        annotate('text',family = myfont,
                 x=c(25,6),
                 y=c(.017,.007),
                 label=c('Non-working age','Working age'),
                 color=viridis(6)[c(2:3)],
                 size=7, hjust=0, vjust=1)+
        annotate('text', family = myfont,
                 x=c(17),
                 y=c(-.041),
                 label=c('Overall model'),
                 color=viridis(6)[c(1)],
                 size=8, hjust=0, vjust=1)



g0b <- ggplot(est0342,aes(x=year,y=coef))+
        
        annotate('rect',xmin=-Inf,xmax=11,ymin=-Inf,ymax=Inf,fill='grey95')+
        geom_hline(yintercept=0)+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(6)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(6)),
                   aes(group=model_y.x,color=model_y.x),size=2,shape=16)+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(4)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(4)),
                   aes(group=model_y.x,color=model_y.x),size=2,shape=21,fill='white')+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(5)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(5)),
                   aes(group=model_y.x,color=model_y.x),size=2,shape=16)+
        
        geom_line(data=filter(est0342,as.numeric(model_y.x)%in%c(3)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1.5)+
        geom_point(data=filter(est0342,as.numeric(model_y.x)%in%c(3)),
                   aes(group=model_y.x,color=model_y.x),size=3,shape=16)+
        
        scale_color_manual(values = viridis(6)[3:6]) +
        scale_x_discrete(labels= year.labels)+
        scale_y_continuous(limits=c(-.05,.03))+
        xlab(NULL)+
        ylab('Beta-coefficient')+
        theme_few(base_size = 20, base_family = myfont)+
        theme(legend.position='none',
              axis.text.x = element_text(angle = 0, vjust = 0.5),
              axis.ticks = element_line(size = year.ticks))+
        annotate('text', family = myfont,
                 x=c(1,14,25),
                 y=c(.017,.008,-.006),
                 label=c('Cohort turnover','Migration','Mortality'),
                 color=viridis(6)[c(4:6)],
                 size=6, hjust=0, vjust=1)+
        annotate('text', family = myfont,
                 x=c(15),
                 y=c(-.02),
                 label=c('Working age'),
                 color=viridis(6)[c(3)],
                 size=7, hjust=0, vjust=1)



####################################################################################################
# plot accumulated betas


est0342cum <- est0342 %>%
        group_by(model_y.x) %>%
        mutate(coef.cum = cumsum(coef)) %>%
        ungroup() %>%
        arrange(model_y.x,year)

gcum.a <- ggplot(est0342cum,aes(x=year,y=coef.cum))+
        
        annotate('rect',xmin=-Inf,xmax=11,ymin=-Inf,ymax=Inf,fill='grey95')+
        geom_hline(yintercept=0)+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(2)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1.5)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(2)),
                   aes(group=model_y.x,color=model_y.x),size=3,shape=21,fill='white')+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(3)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1.5)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(3)),
                   aes(group=model_y.x,color=model_y.x),size=3,shape=16)+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(1)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=2)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(1)),
                   aes(group=model_y.x,color=model_y.x),size=4)+
        
        scale_color_manual(values = viridis(6)[1:3]) +
        scale_x_discrete(labels= year.labels)+
        coord_cartesian(ylim = c(-.75,.05))+
        xlab(NULL)+
        ylab('Cumulative beta-coefficient')+
        theme_few(base_size = 20, base_family = myfont)+
        theme(legend.position='none',
              axis.text.x = element_text(angle = 0, vjust = 0.5),
              axis.ticks = element_line(size = year.ticks))+
        annotate('text',family = myfont,
                 x=c(20,16),
                 y=c(-.34,-.1),
                 label=c('Non-working age','Working age'),
                 color=viridis(6)[c(2:3)],
                 size=7, hjust=0, vjust=1)+
        annotate('text',family = myfont,
                 x=c(23),
                 y=c(-.55),
                 label=c('Overall model'),
                 color=viridis(6)[c(1)],
                 size=8, hjust=0, vjust=1)




gcum.b <- ggplot(est0342cum,aes(x=year,y=coef.cum))+
        
        annotate('rect',xmin=-Inf,xmax=11,ymin=-Inf,ymax=Inf,fill='grey95')+
        geom_hline(yintercept=0)+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(4)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(4)),
                   aes(group=model_y.x,color=model_y.x),size=2,shape=21,fill='white')+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(5)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(5)),
                   aes(group=model_y.x,color=model_y.x),size=2,shape=16)+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(6)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(6)),
                   aes(group=model_y.x,color=model_y.x),size=2,shape=16)+
        
        geom_line(data=filter(est0342cum,as.numeric(model_y.x)%in%c(3)),
                  aes(group=model_y.x,color=model_y.x),stat='identity',size=1.5)+
        geom_point(data=filter(est0342cum,as.numeric(model_y.x)%in%c(3)),
                   aes(group=model_y.x,color=model_y.x),size=3,shape=16)+
        
        scale_color_manual(values = viridis(6)[3:6]) +
        scale_x_discrete(labels= year.labels)+
        coord_cartesian(ylim = c(-.75,.05))+
        xlab(NULL)+
        ylab('Cumulative beta-coefficient')+
        theme_few(base_size = 20, base_family = myfont)+
        theme(legend.position='none',
              axis.text.x = element_text(angle = 0, vjust = 0.5),
              axis.ticks = element_line(size = year.ticks))+
        annotate('text',family = myfont,
                 x=c(1,33,26),
                 y=c(.07,.07,-.14),
                 label=c('Cohort turnover','Migration','Mortality'),
                 color=viridis(6)[c(4:6)],
                 size=6, hjust=0, vjust=1)+
        annotate('text',family = myfont,
                 x=c(19),
                 y=c(-.27),
                 label=c('Working age'),
                 color=viridis(6)[c(3)],
                 size=7, hjust=0, vjust=1)


####################################################################################################
# save both plots

gg <- cowplot::plot_grid(g0a,g0b,gcum.a,gcum.b,labels = LETTERS[1:4],ncol = 2,align = 'hv',label_size = 20, hjust = -1)

ggsave('_output/fig5_model_estimates_0342_norm+cum.png',gg,width = 15,height = 11,dpi=192)



###
# Report finish of the script execution
print('Done: script 3.05')
