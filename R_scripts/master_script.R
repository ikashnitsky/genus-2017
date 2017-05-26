################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# MASTER SCRIPT
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))


# This is a master script. 
# Running just this one script, one may replicate all the results of the paper.
# This script runs all other scripts in a sequential order performing all steps
# of the data manipulation and analysis.

# After the execution of each script, the message of the form
# > [1] "Done: script x.xx"
# will arrive, indicating the overall progress

# The reference execution time of all scripts 
# on a win7 intel core i5 machine with 4GB RAM is 10 minutes. 
# Half of the time is consumed by instalation of the packages. 
# That is only required during the first execution of the scripts.
# The speed may vary considerably depending on your internet connection.
# In total, the scripts download 34.8 MB of data + all the packages


# STEP 1. Preparations
source('R_scripts/1_preparation/1.01_install_required_packages.R') # very long!
# now we need to re-open R session and run the 1.01 script again
.rs.restartR()
source('R_scripts/1_preparation/1.01_install_required_packages.R') # quick this time
source('R_scripts/1_preparation/1.02_load_own_functions.R')
source('R_scripts/1_preparation/1.03_prepare_ALL_supplementary.R')

# STEP 2. Data manipulations
source('R_scripts/2_data_manipulation/2.01_download_geodata.R')
source('R_scripts/2_data_manipulation/2.02_download&prepare_OBS_data.R')
source('R_scripts/2_data_manipulation/2.03_download&prepare_PROJ_data.R')
source('R_scripts/2_data_manipulation/2.04_missing_download&unzip.R')
source('R_scripts/2_data_manipulation/2.05_missing_DE.R')
source('R_scripts/2_data_manipulation/2.06_missing_DK.R')
source('R_scripts/2_data_manipulation/2.07_missing_SI.R')
source('R_scripts/2_data_manipulation/2.08_missing_RO_smooth.R')
source('R_scripts/2_data_manipulation/2.09_missing_INSERT.R')
source('R_scripts/2_data_manipulation/2.10_TSR_decomposition_OBS.R')
source('R_scripts/2_data_manipulation/2.11_TSR_decomposition_PROJ.R')
source('R_scripts/2_data_manipulation/2.12_TSR_decomposition_n2dec0342.R')
source('R_scripts/2_data_manipulation/2.13_TSR_2043.R')

# STEP 3. Analysis
source('R_scripts/3_analysis/3.01_fig1_maps_TSR_growth_4decades.R')
source('R_scripts/3_analysis/3.02_fig2_TSR_subregions_0342.R')
source('R_scripts/3_analysis/3.03_fig3+A1+A2+A3+A4_maps_decomposition.R')
source('R_scripts/3_analysis/3.04_fig4_decomposed_descriptive.R')
source('R_scripts/3_analysis/3.05_fig5_model_estimates_0342.R')
source('R_scripts/3_analysis/3.06_tabA1_summary_stat_by_country.R')
source('R_scripts/3_analysis/3.07_figA5_pyramid_London.R')
source('R_scripts/3_analysis/3.08_figA6_pyramid_Eastern_Europe.R')

# find all the results in '_output/'