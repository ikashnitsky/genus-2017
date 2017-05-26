################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Prepare. Download geodata
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# download cached geodata [2.21 MB]
url <- 'https://ndownloader.figshare.com/files/4817635'
path <- 'geo_data/shp.n2eu28.RData.zip'

ifelse(file.exists(path), yes = 'file alredy exists', no = download.file(url, path,mode="wb"))
# If there are problems downloading the data automatically, please download them manually from
# https://dx.doi.org/10.6084/m9.figshare.3100657.v2

unzip(zipfile = path,exdir = 'geo_data')

###
# Report finish of the script execution
print('Done: script 2.01')
