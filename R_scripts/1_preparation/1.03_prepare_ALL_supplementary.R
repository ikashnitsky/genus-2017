################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Prepare supplementary data (mainly, classifications)
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')



################################################################################
# Lists of NUTS regions

idn0 <- read.csv('data0_supplementary/EU_nuts/idn0.csv.gz',colClasses='character')
idn0 <- unique(idn0$idn0)

idn1 <- read.csv('data0_supplementary/EU_nuts/idn1.csv.gz',colClasses='character')
idn1 <- unique(idn1$idn1)

idn2 <- read.csv('data0_supplementary/EU_nuts/idn2.csv.gz',colClasses='character')
idn2 <- unique(idn2$idn2)

idn3 <- read.csv('data0_supplementary/EU_nuts/idn3.csv.gz',colClasses='character')
idn3 <- unique(idn3$idn3)

idn0eu28 <- read.csv('data0_supplementary/EU_nuts/EU28.CSV.GZ',header=F,colClasses='character')
idn0eu28 <- idn0eu28$V1

idn1eu28 <- idn1[substr(idn1,1,2)%in%idn0eu28]
idn2eu28 <- idn2[substr(idn2,1,2)%in%idn0eu28]
idn3eu28 <- idn3[substr(idn3,1,2)%in%idn0eu28]

save(list = c('idn0','idn1','idn2','idn3','idn0eu28','idn1eu28','idn2eu28','idn3eu28'),
     file = 'data0_supplementary/idn0123.RData')



################################################################################
# EuroVoc definition of European regions
# http://eurovoc.europa.eu/drupal/?q=request&mturi=http://eurovoc.europa.eu/100277&language=en&view=mt&ifacelang=en

EU28 <- idn0eu28
EUN <- c('IE','DK','SE','FI','EE','LT','LV')
EUW <- c('UK','FR','DE','BE','NL','LU','AT')
EUS <- c('PT','ES','IT','EL','SI','HR','CY','MT')
EUE <- c('CZ','PL','SK','HU','BG','RO')

EU28.df <- data.frame(country=EU28,subregion=NA)

EU28.df$subregion[EU28.df$country%in%EUE] <- 'E'
EU28.df$subregion[EU28.df$country%in%EUN] <- 'N'
EU28.df$subregion[EU28.df$country%in%EUS] <- 'S'
EU28.df$subregion[EU28.df$country%in%EUW] <- 'W'

EU28.df$subregion <- factor(EU28.df$subregion)

save(EU28,EUN,EUW,EUS,EUE,EU28.df, file = 'data0_supplementary/subregions.EuroVoc.countries.RData')


# classification of nuts2 regions
df <- data.frame(id=idn2eu28) %>%
        mutate(country=substr(id,1,2),
               subregion='NA')

df[which(substr(df$id,1,2)%in%EUN),'subregion'] <- 'N'
df[which(substr(df$id,1,2)%in%EUW),'subregion'] <- 'W'
df[which(substr(df$id,1,2)%in%EUS),'subregion'] <- 'S'
df[which(substr(df$id,1,2)%in%EUE),'subregion'] <- 'E'

idn2sub <- ik_ut_colclass_factorize(df)

save(file = 'data0_supplementary/idn2sub.Rdata',idn2sub)



################################################################################
# Remote NUTS-2 regions to be removed

# first step. Remove remote areas
# Remove non-European territories of France, Spain and Portugal
remove.n1 <- c('ES7','FR9','PT2','PT3')
remove.n2 <- c(paste0('ES',c(63,64,70)),paste('FR',91:94,sep=''),'PT20','PT30')
remove.remote <- c(remove.n1,remove.n2)

save(file = 'data0_supplementary/remove.remote.Rdata',remove.remote)


# load prefered font for graphics - "Roboto Condensed"
extrafont::ttf_import('data0_supplementary/Roboto_Condensed')



###
# Report finish of the script execution
print('Done: script 1.03')