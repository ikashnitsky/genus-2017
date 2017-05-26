################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Download and unzip the missing data.  DE, DK, SI. NUTS2
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))



# download the cached data, downloaded from national Statistical Offices [795.4 KB]
url <- 'https://ndownloader.figshare.com/files/4819075'
path <- 'data1_raw/Missing_data/missing_data_raw.zip'


ifelse(file.exists(path), yes = 'file alredy exists', no = download.file(url, path,mode="wb"))
# If there are problems downloading the data automatically, please download them manually from
# https://dx.doi.org/10.6084/m9.figshare.3100111.v2

unzip(zipfile = path,exdir = 'data1_raw/Missing_data')



###
# Report finish of the script execution
print('Done: script 2.04')
