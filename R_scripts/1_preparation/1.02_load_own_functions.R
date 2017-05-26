################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Load and save own functions
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# Logic behind functions names.
# 'ik' - my initials
# Second part defines the function's specification
# 'an' - analysis
# 'dm' - data manipulations
# 'gg' - graphics (named after ggplot2 package)
# 'map' - mapping
# 'phd' - PhD project specific functions
# 'ut' - utilites

# Load all self-written functions

source('R_scripts/0_own_finctions/ik_an_extract.lm.R')
source('R_scripts/0_own_finctions/ik_an_multiple.y.lm.list.R')
source('R_scripts/0_own_finctions/ik_dm_fill.missings.R')
source('R_scripts/0_own_finctions/ik_gg_gghole.R')
source('R_scripts/0_own_finctions/ik_gg_population.pyramid.compare.R')
source('R_scripts/0_own_finctions/ik_map_eu.base.R')
source('R_scripts/0_own_finctions/ik_phd_an_theil.decomposition.R')
source('R_scripts/0_own_finctions/ik_phd_estimate.conv.models.dec.R')
source('R_scripts/0_own_finctions/ik_phd_gg_align.6.plots.R')
source('R_scripts/0_own_finctions/ik_ut_columns.classes.R')

save.image('data0_supplementary/own_functions.RData')



###
# Report finish of the script execution
print('Done: script 1.02')