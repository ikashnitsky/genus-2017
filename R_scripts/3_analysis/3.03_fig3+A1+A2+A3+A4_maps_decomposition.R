################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Figure 3. Map decomposition for the whole period 2003-2043
# Also: figures A1, A2, A3, A4 (for each of the 4 decades)
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

myfont <- "Roboto Condensed"

# load own functions
load('data0_supplementary/own_functions.RData')

# load data
load('geo_data/shp.n2eu28.all.RData')
load('data3_calculated/n2dec0342.RData')

basemap <- ik_map_eu.base(family = myfont)

bord <- fortify(Sborders)

variables <- c('g','nw','w','ct','mg','mt')

labels.decomposed <- paste(paste0(LETTERS[1:6],'.'),
                           c('Change in TSR',
                             'Non-working age',
                             'Working age',
                             'Cohort turnover',
                             'Migration (15-64)',
                             'Mortality (15-64)'))


dfm0312 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%1:10) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.0312 <- fortify(Sn2, region = 'id') 
fort.0312 <- left_join(x=fort.0312, y=dfm0312, by = 'id')

maps0312 <- list()

for (i in 1:length(variables)){
        vari <- variables[i]
        mapi <- basemap +
                geom_polygon(data = gghole(fort.0312)[[1]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                geom_polygon(data = gghole(fort.0312)[[2]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                scale_fill_viridis(vari)+
                geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
                guides(fill = guide_colorbar(barwidth = 1, barheight = 9))
        
        maps0312[[i]] <- mapi
}

maps0312[[1]]

map.0312 <- ik_phd_gg_align.6.plots(maps0312, labels = labels.decomposed, family = myfont) +
        annotate('text',x=20.5,y=29.1,label='2003 - 2012',size=12,fontface=2,hjust=1, vjust=0, family = myfont)

ggsave('_output/figA1_map_decomposed_0312.png',map.0312,width=12,height=18,dpi=192)



################################################################################
# the same 6 maps for 2013 - 2022

dfm1322 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%11:20) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.1322 <- fortify(Sn2, region = 'id') 
fort.1322 <- left_join(x=fort.1322, y=dfm1322, by = 'id')

maps1322 <- list()

for (i in 1:length(variables)){
        vari <- variables[i]
        mapi <- basemap +
                geom_polygon(data = gghole(fort.1322)[[1]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                geom_polygon(data = gghole(fort.1322)[[2]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                scale_fill_viridis(vari)+
                geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
                guides(fill = guide_colorbar(barwidth = 1, barheight = 9))
        
        maps1322[[i]] <- mapi
}


map.1322 <- ik_phd_gg_align.6.plots(maps1322, labels = labels.decomposed, family = myfont)+
        annotate('text',x=20.5,y=29.1,label='2013 - 2022',size=12,fontface=2,hjust=1, vjust=0, family = myfont)

ggsave('_output/figA2_map_decomposed_1322.png',map.1322,width=12,height=18,dpi=192)



################################################################################
# the same 6 maps for 2023 - 2032

dfm2332 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%21:30) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.2332 <- fortify(Sn2, region = 'id') 
fort.2332 <- left_join(x=fort.2332, y=dfm2332, by = 'id')

maps2332 <- list()

for (i in 1:length(variables)){
        vari <- variables[i]
        mapi <- basemap +
                geom_polygon(data = gghole(fort.2332)[[1]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                geom_polygon(data = gghole(fort.2332)[[2]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                scale_fill_viridis(vari)+
                geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
                guides(fill = guide_colorbar(barwidth = 1, barheight = 9))
        
        maps2332[[i]] <- mapi
}


map.2332 <- ik_phd_gg_align.6.plots(maps2332, labels = labels.decomposed, family = myfont)+
        annotate('text',x=20.5,y=29.1,label='2023 - 2032',size=12,fontface=2,hjust=1, vjust=0, family = myfont)

ggsave('_output/figA3_map_decomposed_2332.png',map.2332,width=12,height=18,dpi=192)





################################################################################
# the same 6 maps for 2033 - 2042

dfm3342 <- n2dec0342 %>%
        filter(as.numeric(factor(year))%in%31:40) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.3342 <- fortify(Sn2, region = 'id') 
fort.3342 <- left_join(x=fort.3342, y=dfm3342, by = 'id')

maps3342 <- list()

for (i in 1:length(variables)){
        vari <- variables[i]
        mapi <- basemap +
                geom_polygon(data = gghole(fort.3342)[[1]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                geom_polygon(data = gghole(fort.3342)[[2]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                scale_fill_viridis(vari)+
                geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
                guides(fill = guide_colorbar(barwidth = 1, barheight = 9))
        
        maps3342[[i]] <- mapi
}


map.3342 <- ik_phd_gg_align.6.plots(maps3342, labels = labels.decomposed, family = myfont)+
        annotate('text',x=20.5,y=29.1,label='2033 - 2042',size=12,fontface=2,hjust=1, vjust=0, family = myfont)

ggsave('_output/figA4_map_decomposed_3342.png',map.3342,width=12,height=18,dpi=192)







################################################################################
# THE WHOLE PERIOD. for 2003 - 2042

dfm0342 <- n2dec0342 %>%
        #filter(as.numeric(factor(year))%in%1:40) %>%
        group_by(id) %>%
        select(-1,-9,-10,-11,-12) %>%
        summarise_each(funs(sum))

fort.0342 <- fortify(Sn2, region = 'id') 
fort.0342 <- left_join(x=fort.0342, y=dfm0342, by = 'id')

maps0342 <- list()

for (i in 1:length(variables)){
        vari <- variables[i]
        mapi <- basemap +
                geom_polygon(data = gghole(fort.0342)[[1]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                geom_polygon(data = gghole(fort.0342)[[2]], aes_string(x='long', y='lat', group='group', fill=vari),
                             color='grey30',size=.2)+
                scale_fill_viridis(vari)+
                geom_path(data=bord,aes(x=long, y=lat, group=group),color='grey20',size=.5)+
                guides(fill = guide_colorbar(barwidth = 1, barheight = 9))
        
        maps0342[[i]] <- mapi
}

maps0342[[1]]


map.0342 <- ik_phd_gg_align.6.plots(maps0342, labels = labels.decomposed, family = myfont) +
        annotate('text',x=20.5,y=29.1,label='2003 - 2042',size=12,fontface=2,hjust=1, vjust=0, family = myfont)

ggsave('_output/fig3_map_decomposed_0342.png',map.0342,width=12,height=18,dpi=192)



###
# Report finish of the script execution
print('Done: script 3.03')
