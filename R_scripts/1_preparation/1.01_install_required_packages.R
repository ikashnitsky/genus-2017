################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Install required packages
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################


# This script will make sure that there will be no error in the replication of 
# the analysis due to R packages absence or version missmatch.
# For this reason we use the special package for reproducible research called 
# "checkpoint".
# This package installes all the packages used in a project precisely as they 
# were at a specific date, the date of abalysis. 
# More info: https://github.com/RevolutionAnalytics/checkpoint/wiki


# install "checkpoint" package with all its dependencies 
# install only if it was not previously installed
# solution by Sacha Epskamp from: http://stackoverflow.com/a/9341833/4638884
if (!require('checkpoint',character.only = TRUE))
{
        install.packages('checkpoint',dep=TRUE)
        if(!require('checkpoint',character.only = TRUE)) stop("Package not found")
}

# load "checkpoint" package
library(checkpoint)

# create the system directory for `checkpont` to avoid being asked about that
ifelse(dir.exists('~/.checkpoint'),yes = print('directory already exists'),no = dir.create('~/.checkpoint'))

# Set the checkpoint date for reproducibility: 2017-02-09
# Now quite a long process starts: "checkpoint" scans through all the scripts in 
# the project and finds all the packages that should be installed to run the scripts.
# The packages will be installed precisely as the were on 2016-03-14.
checkpoint('2017-02-09')



# Let's thank the authors of these packages we use!

# 'dplyr',             Hadley Wickham and Romain Francois (2015). dplyr: A Grammar of Data Manipulation. R package version 0.4.3.
# 'tidyr',             Hadley Wickham (2016). tidyr: Easily Tidy Data with `spread()` and `gather()` Functions. R package version 0.4.1.
# 'readr',             Hadley Wickham and Romain Francois (2015). readr: Read Tabular Data. R package version 0.2.2.
# 'data.table',        M Dowle, A Srinivasan, T Short, S Lianoglou with contributions from R Saporta and E Antonyan (2015). data.table: Extension of Data.frame. R package version 1.9.6. 
# 'ggplot2',           H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2009.
# 'ggthemes',          Jeffrey B. Arnold (2016). ggthemes: Extra Themes, Scales and Geoms for 'ggplot2'. R package version 3.0.2.
# 'viridis',           Simon Garnier (2016). viridis: Default Color Maps from 'matplotlib'. R package version 0.3.4.
# 'cowplot',           Claus O. Wilke (2015). cowplot: Streamlined Plot Theme and Plot Annotations for 'ggplot2'. R package version 0.6.1.
# 'gridExtra',         Baptiste Auguie (2015). gridExtra: Miscellaneous Functions for "Grid" Graphics. R package version 2.1.0.
# 'sp',                Pebesma, E.J., R.S. Bivand, 2005. Classes and methods for spatial data in R. R News 5 (2)
# 'maptools',          Roger Bivand and Nicholas Lewin-Koh (2016). maptools: Tools for Reading and Handling Spatial Objects. R package version 0.8-39.
# 'rgdal',             Roger Bivand, Tim Keitt and Barry Rowlingson (2015). rgdal: Bindings for the Geospatial Data Abstraction Library. R package version 1.1-3
# 'rgeos'              Roger Bivand and Colin Rundel (2015). rgeos: Interface to Geometry Engine - Open Source (GEOS). R package version 0.3-15.

# load required packages
library(dplyr)
library(tidyr)
library(readr)
library(data.table)
library(ggplot2)
library(ggthemes)
library(viridis)
library(cowplot)
library(gridExtra)
library(sp)
library(maptools)
library(rgdal)
library(rgeos)
library(extrafont)
library(RColorBrewer)



# make sure everythins goes ok
print(sessionInfo())

###
# Report finish of the script execution
print('Done: script 1.01')
