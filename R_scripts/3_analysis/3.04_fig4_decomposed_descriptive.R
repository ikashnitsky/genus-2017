################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure 4. Descriptive analysis of the decomposed TSR
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

myfont <- "Roboto Condensed"
brbg3 <- brewer.pal(11, "BrBG")[c(8,2,11)]

# load own functions
load('data0_supplementary/own_functions.RData')

# load data
load('data3_calculated/n2dec0342.RData')



plots <- list()

vars <- c('g','nw','w','ct','mg','mt')

year.labels <- paste(2003:2042) 
year.labels[-c(1,11,21,31,40)] <- ''

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

# old colors
# viridis(100)[c(10,60,95)]

for (i in 1:length(vars)){
        ylimi <- quantile(unlist(n2dec0342[,vars[i]]), probs=c(.001,.999))
        if(ylimi[2]<0){ylimi[2] <- 0}
        labi <- seq(round(ylimi[1],2),ylimi[2],.01)
        
        ggi <- ggplot()+
                geom_vline(xintercept = 1:40,colour = 'grey80',size=.5)+
                
                geom_jitter(data = n2dec0342,aes_string(x='year',y=vars[i],color='subregion'),
                            alpha=1,size=.1,width = .5)+
                
                geom_line(data = df.sub, aes_string(x='year',y=vars[i],color='subregion',group='subregion'),
                          size=3,color='white')+
                geom_line(data = df.sub, aes_string(x='year',y=vars[i],color='subregion',group='subregion'),
                          size=1.8,color='black')+
                geom_line(data = df.sub, aes_string(x='year',y=vars[i],color='subregion',group='subregion'),
                          size=1.5,lineend='round')+
                
                geom_line(data = df.mean, aes_string(x='year',y=vars[i],group=1),
                          size=3,color='white')+
                geom_line(data = df.mean, aes_string(x='year',y=vars[i],group=1.2),
                          size=1.5,color='black')+
                #geom_point(data = df.mean, aes_string(x='year',y=vars[i]),size=2.5,color='white')+
                geom_point(data = df.mean, aes_string(x='year',y=vars[i]),size=2.2,color='black')+
                
                geom_hline(yintercept=0,color='black')+
                
                
                coord_cartesian(ylim = ylimi)+
                scale_color_manual(values = rev(brbg3))+
                scale_y_continuous('',breaks = labi,labels = labi)+
                scale_x_discrete('',labels= year.labels)+
                theme_few(base_size = 15, base_family = myfont)+
                theme(axis.text.x = element_text(angle = 0, vjust = 0.5),
                      legend.position='none')
        
        
        
        plots[[i]] <- ggi
}


# align 6 plots in a fancy way
labels.decomposed <- paste(paste0(LETTERS[1:6],'.'),
                           c('Change in TSR',
                             'Non-working age',
                             'Working age',
                             'Cohort turnover',
                             'Migration (15-64)',
                             'Mortality (15-64)'))


gg.six <- ik_phd_gg_align.6.plots(plots, labels = labels.decomposed, family = myfont) +
        annotate('rect',xmin = 9,xmax = 12.3,ymin = 24.5,ymax = 29.5,color='black',size=.5,fill=NA)+
        annotate('point',x=9.5,y=seq(28.5,25.5,length.out = 3),size=10,color=rev(brbg3))+
        annotate('text',x=10,y=seq(28.5,25.5,length.out = 3),hjust=0,vjust=0.5,size=7,color='black',
                 label=c('Eastern\nEurope','Southern\nEurope','Western\nEurope'), family = myfont)

ggsave('_output/fig4_decomposed_descriptive.png',gg.six,width = 12,height = 12*1.5,dpi=192)



###
# Report finish of the script execution
print('Done: script 3.04')
        