################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Function. Compare population pyramids at two points in time
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################


ik_gg_population.pyramid.compare <- function(df, t1, t2,
                                             year='year', age='age', sex='sex', value='value',
                                             level.male='m',level.female='f',
                                             base_family = "",base_size=15) {
        
        require(ggplot2)
        require(ggthemes)
        require(dplyr)
        
        df <- df[,match(c(year,age,sex,value),colnames(df))]
        colnames(df) <- c('year','age','sex','value')
        
        t1s <- paste0('y',t1)
        t2s <- paste0('y',t2)
        
        df <- filter(df, year%in%c(t1s,t2s),sex%in%c(level.female,level.male))
        
        # characteristics that will differntiate between 1-year and 5-year pyramids
        n.age.groups <- length(unique(paste(df$age)))
        age.group.size <- if(n.age.groups>30){1}else{5}
        
        
        max.f.t1 <- filter(df,sex==level.female,year==t1s) %>% mutate(value=value/sum(value)*100) %>% with(max(value))
        max.m.t1 <- filter(df,sex==level.male,year==t1s) %>% mutate(value=value/sum(value)*100) %>% with(max(value))
        max.f.t2 <- filter(df,sex==level.female,year==t2s) %>% mutate(value=value/sum(value)*100) %>% with(max(value))
        max.m.t2 <- filter(df,sex==level.male,year==t2s) %>% mutate(value=value/sum(value)*100) %>% with(max(value))
        max.y <- max(max.f.t1,max.m.t1,max.f.t2,max.m.t2)
        max <- ceiling(max.y*10)/10
        step <- if(n.age.groups>30){.5}else{2}
        
        labels.y <- seq(0,max,step)
        labels.y <- c(-rev(labels.y),labels.y)
        labels.y <- labels.y[!is.null(labels.y)]
        
        breaks <- unique(paste(df$age))
        #breaks <- c(breaks,s)
        breaks[-(seq(0,(length(breaks)-1),5)+1)] <- NA
        
        labels <- paste(0:(length(breaks)-1))
        labels[-(seq(0,(length(breaks)-1),5)+1)] <- NA
        
        
        
        gg <- ggplot(data=df,aes(x=age)) +
                geom_path(data=filter(df,sex==level.female,year==t1s),aes(y=value/sum(value)*100,group='identity',
                                                                          color='black'),alpha=.5) +
                geom_path(data=filter(df,sex==level.male,year==t1s),aes(y=value*(-1)/sum(value)*100,group='identity',
                                                                        color='yellow'),alpha=.5) +
                geom_path(data=filter(df,sex==level.female,year==t2s),aes(y=value/sum(value)*100,group='identity',
                                                                          color='black'),linetype=2) +
                geom_path(data=filter(df,sex==level.male,year==t2s),aes(y=value*(-1)/sum(value)*100,group='identity',
                                                                        color='yellow'),linetype=2) +
                geom_vline(xintercept=c(16,66),alpha=.3)+
                geom_hline(yintercept=0)+
                #add the boundaries lines
                geom_hline(yintercept = c(-max,max),color='white')+
                coord_flip(xlim = c(1,n.age.groups+1/step*10))+
                scale_color_manual('Sex',labels=c('Female','Male','Female','Male'),
                                   values=c('magenta','deepskyblue','magenta','deepskyblue'))+
                #scale_fill_manual('Sex',labels=c('Female','Male'),values=c('magenta','deepskyblue'))+
                scale_x_discrete(breaks=breaks,labels=labels)+
                scale_y_continuous(breaks=labels.y,
                                   labels=labels.y)+
                ylab('Percent of total population')+
                xlab('Age')+
                theme_few(base_size=base_size, base_family = base_family)+
                theme(aspect.ratio=1,
                      legend.position="none")
        
        
        
        #annotate to create legend
        
        gg <- gg + annotate('text', x=n.age.groups+15*(1/age.group.size), y=-max,
                            label=c('Males'),hjust=0,size=5, family = base_family)+
                annotate('text', x=n.age.groups+15*(1/age.group.size), y=max-step*1.5,
                         label=c('Females'),hjust=0,size=5, family = base_family)+
                
                annotate('segment', x=n.age.groups+10*(1/age.group.size),
                         xend=n.age.groups+10*(1/age.group.size),
                         y=-max,
                         yend=-max+step,
                         color='deepskyblue')+
                annotate('segment', x=n.age.groups+5*(1/age.group.size),
                         xend=n.age.groups+5*(1/age.group.size),
                         y=-max,
                         yend=-max+step,
                         color='deepskyblue',linetype=2)+
                
                annotate('segment', x=n.age.groups+10*(1/age.group.size),
                         xend=n.age.groups+10*(1/age.group.size),
                         y=max-step*1.5,
                         yend=max-step*.5,
                         color='magenta')+
                annotate('segment', x=n.age.groups+5*(1/age.group.size),
                         xend=n.age.groups+5*(1/age.group.size),
                         y=max-step*1.5,
                         yend=max-step*.5,
                         color='magenta',linetype=2)+
                
                annotate('text', x=n.age.groups+10*(1/age.group.size), y=-max+step,
                         label=paste(t1),hjust=-.2,size=4, family = base_family)+
                annotate('text', x=n.age.groups+5*(1/age.group.size), y=-max+step,
                         label=paste(t2),hjust=-.2,size=4, family = base_family)+
                
                annotate('text', x=n.age.groups+10*(1/age.group.size), y=max-step*.5,
                         label=paste(t1),hjust=-.2,size=4, family = base_family)+
                annotate('text', x=n.age.groups+5*(1/age.group.size), y=max-step*.5,
                         label=paste(t2),hjust=-.2,size=4, family = base_family)
        
        
        return(gg)
}
