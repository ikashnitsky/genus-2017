################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Read and prepare regional population projections data
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')

load('data0_supplementary/idn0123.RData')
load('data0_supplementary/remove.remote.Rdata')



################################################################################
# Population structure

# download cached Eurostat data [16.28 MB]
url1 <- 'http://ndownloader.figshare.com/files/4795531'
path1 <- 'data1_raw/Eurostat/projected/proj_13rpms.tsv.gz'

ifelse(file.exists(path1), yes = 'file alredy exists', no = download.file(url1, path1,mode="wb"))
# If there are problems downloading the data automatically, please download them manually from
# https://dx.doi.org/10.6084/m9.figshare.3084556

# read the raw data in
pop.raw <- read.table(path1, sep = c('\t'), header = T) 

#correct the first column
pop <- separate(pop.raw, age.sex.geo.time, c('age','sex','id'), sep = ',') 

pop <- ik_ut_colclass_factorize(pop, 1:3)


# convert to long data format
p1 <- gather(pop, year, value, X2080:X2013)

p1$year <- gsub('X','y',p1$year)
p1$year <- factor(p1$year)
levels(p1$sex) <- c('f','m','b')
p1$sex <- factor(paste(p1$sex))


p1 <- filter(p1, id%in%idn2eu28, year%in%paste0('y',2013:2043)) %>%
        droplevels()

#correct ages
ages <- levels(p1$age)
ages[nchar(ages)==2] <- gsub('Y','a0',ages[nchar(ages)==2])
ages[nchar(ages)==3] <- gsub('Y','a',ages[nchar(ages)==3])
ages[1:3] <- c('total','open','a00')

levels(p1$age) <- ages
p1$age <- factor(paste(p1$age))

p1 <- p1 %>% select(year,id,sex,age,value) %>%
        arrange(sex,year,id,age)



################################################################################
# Migration data
        
# download cached Eurostat data [4.54 MB]
url2 <- 'https://ndownloader.figshare.com/files/4795534'
path2 <- 'data1_raw/Eurostat/projected/proj_13ranmig.tsv.gz'

ifelse(file.exists(path2), yes = 'file alredy exists', no = download.file(url2, path2,mode="wb"))
# If there are problems downloading the data automatically, please download them manually from
# https://dx.doi.org/10.6084/m9.figshare.3084559

# read the raw data in
mig.raw <- read.table(path2, sep = c('\t'), header = T) 

#correct the first column
mig.raw <- separate(mig.raw, age.sex.geo.time, c('age','sex','id'), sep = ',')

mig.raw <- ik_ut_colclass_factorize(mig.raw, 1:3)


# convert to long data format
m1 <- gather(mig.raw, year, value, X2080:X2013)

m1$year <- gsub('X','y',m1$year)
m1$year <- factor(m1$year)
levels(m1$sex) <- c('f','m','b')
m1$sex <- factor(paste(m1$sex))

# filter only relevant data
m1 <- filter(m1, id%in%idn2eu28, year%in%paste0('y',2013:2042)) %>%
        droplevels()

#correct ages
ages <- levels(m1$age)
ages[nchar(ages)==2] <- gsub('Y','a0',ages[nchar(ages)==2])
ages[nchar(ages)==3] <- gsub('Y','a',ages[nchar(ages)==3])
ages[1:3] <- c('total','open','a00')
ages[ages=='Y100'] <- 'open'

levels(m1$age) <- ages
m1$age <- factor(paste(m1$age))

# summarize the two 'open' age groups
m1 <- m1 %>% group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>%
        ungroup() %>%
        arrange(sex,year,id,age)




################################################################################
# Remove remote regions

p1 <- p1 %>% filter(!id%in%remove.remote) %>% droplevels()
m1 <- m1 %>% filter(!id%in%remove.remote) %>% droplevels()


################################################################################
# Save the ready data

n2p1proj <- p1
n2m1proj <- m1

save(n2p1proj,n2m1proj,file = 'data2_prepared/n2.PROJ.RData')
save(n2p1proj,file = 'data2_prepared/n2p1proj.RData')
save(n2m1proj,file = 'data2_prepared/n2m1proj.RData')




###
# Report finish of the script execution
print('Done: script 2.03')