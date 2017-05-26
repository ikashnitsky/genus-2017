################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Insert misssing population data. n2p1 and n2d1
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')



load('data1_raw/n2p1.missings.RData')
load('data1_raw/n2d1.missings.RData')



# insert Germany
load('data1_raw/Missing_data/ready.missing.DE.RData')
n2p1 <- ik_dm_fill.missings(n2p1, n2p1mDE, by=1:4)
n2d1 <- ik_dm_fill.missings(n2d1, n2d1mDE, by=1:4)

# insert Denmark
load('data1_raw/Missing_data/ready.missing.DK.RData')
n2p1 <- ik_dm_fill.missings(n2p1, n2p1mDK, by=1:4)
n2d1 <- ik_dm_fill.missings(n2d1, n2d1mDK, by=1:4)

# insert Slovenia
load('data1_raw/Missing_data/ready.missing.SI.RData')
n2p1 <- ik_dm_fill.missings(n2p1, n2p1mSI, by=1:4)


# insert Romania - harmonized data
load('data1_raw/Missing_data/ready.missing.RO.RData') 
n2p1mRO <- n2p1mRO %>% select(-cohort)
n2p1 <- ik_dm_fill.missings(n2p1, n2p1mRO, by=1:4)



###
# FINAL SAVE!!!
save(n2p1, file = 'data2_prepared/n2p1.RData')
save(n2d1, file = 'data2_prepared/n2d1.RData')
save(n2d1,n2p1,file = 'data2_prepared/n2.OBS.RData')




###
# Report finish of the script execution
print('Done: script 2.09')