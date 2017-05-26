################################################################################
#                                                                                                        
# Genus 2017. 2017-05-26
# Prepare data for inserting missings 
# NUTS-2, 1-year age structure, 100 years, OBSERVED period
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                                                                    
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load own functions
load('data0_supplementary/own_functions.RData')

load('data0_supplementary/idn0123.RData')


################################################################################
# Population structure

# download cached Eurostat data [7.35 MB]
url1 <- 'https://ndownloader.figshare.com/files/4795327'
path1 <- 'data1_raw/Eurostat/observed/demo_r_d2jan.tsv.gz'

ifelse(file.exists(path1), yes = 'file alredy exists', no = download.file(url1, path1,mode="wb"))
# If there are problems downloading the data automatically, please download them manually from
# https://dx.doi.org/10.6084/m9.figshare.3084394.v1

# read the raw data in
n2p1.raw <- read.table(path1, sep = c('\t'), header = T,as.is = T) 


#####
# CORRECTIONS

#correct the first column
n2p1 <- separate(n2p1.raw, sex.age.geo.time, c('sex','age','id'), sep = ',') 

n2p1 <- ik_ut_colclass_factorize(n2p1,1:3)


# reshape to long data format
n2p1 <- n2p1 %>% gather('year','value',4:28)


#!!! remove EU flags from the value column 

# b 	break in time series 	c 	confidential 	d 	definition differs, see metadata
# e 	estimated 	f 	forecast 	i 	see metadata (phased out)
# n 	not significant 	p 	provisional 	r 	revised
# s 	Eurostat estimate (phased out) 	u 	low reliability 	z 	not applicable 

# in our data set only these flags are present: b, c, e, p

n2p1$value <- gsub('b','',n2p1$value)
n2p1$value <- gsub('c','',n2p1$value)
n2p1$value <- gsub('e','',n2p1$value)
n2p1$value <- gsub('p','',n2p1$value)

# change ':' symbol for NA
n2p1$value[n2p1$value==':'] <- NA
n2p1$value[n2p1$value==': '] <- NA

# transform the value column to numeric format
n2p1$value <- as.numeric(n2p1$value)

# correct years
n2p1$year <- gsub('X','y',n2p1$year)
n2p1$year <- factor(n2p1$year)

### FILTER ONLY needed (but keep sex for now)
# filter NUTS-2, 
n2p1 <- filter(n2p1, id%in%idn2eu28, year%in%paste0('y',2003:2013)) %>% 
        droplevels()

# Correct the levels of factor variables: age and sex
# correct ages, levels
for (i in 1:nlevels(n2p1$age)){
        agei <- gsub('Y','',levels(n2p1$age)[i])
        subi <- if(nchar(agei)==1){
                paste0('a00',agei)
        }else if(nchar(agei)==2){
                paste0('a0',agei)
        }else if(nchar(agei)==3){
                paste0('a',agei) # we will summarize everything greater than 100 years
        }else{agei}
        levels(n2p1$age)[i] <- subi
        #print(paste(i,'out of',nlevels(n2p1$age)))
}

n2p1$age <- paste(n2p1$age)
n2p1$sex <- paste(n2p1$sex)

n2p1$age[n2p1$age=='TOTAL'] <- 'total'
n2p1$age[n2p1$age=='_LT1'] <- 'a000'
n2p1$age[n2p1$age%in%c('_OPEN','_GE100','aUNK',paste0('a',100:109))] <- 'open'

n2p1$sex[n2p1$sex=='T'] <- 'b'
n2p1$sex[n2p1$sex=='F'] <- 'f'
n2p1$sex[n2p1$sex=='M'] <- 'm'

n2p1$age <- factor(paste(n2p1$age))
n2p1$sex <- factor(paste(n2p1$sex))

# change NAs for zeros
n2p1[is.na(n2p1)] <- 0


# summarize open age group
n2p1 <- n2p1 %>% group_by(year,id,sex,age) %>%
        summarise(value=sum(value)) %>%
        ungroup() %>% droplevels()

# remove now unneccessary extra digit in age levels
levels(n2p1$age) <- gsub('a0','a',levels(n2p1$age))






###
# Remove remote regions
load('data0_supplementary/remove.remote.Rdata')

n2p1 <- n2p1 %>% filter(!id%in%remove.remote) %>%
        droplevels()

# 

#####
# save the data before inserting the missing data
save(n2p1, file = 'data1_raw/n2p1.missings.RData')
################################################################################







################################################################################
# Deaths

# download cached Eurostat data [3.59 MB]
url2 <- 'https://ndownloader.figshare.com/files/4795345'
path2 <- 'data1_raw/Eurostat/observed/demo_r_magec.tsv.gz'

ifelse(file.exists(path2), yes = 'file alredy exists', no = download.file(url2, path2,mode="wb"))
# If there are problems downloading the data automatically, please download them manually from
# https://dx.doi.org/10.6084/m9.figshare.3084418


# read the raw data in
n2d1.raw <- read.table(path2, sep = c('\t'), header = T,as.is = T)

#####
# CORRECTIONS

#correct the first column
n2d1 <- separate(n2d1.raw, sex.age.geo.time, c('sex','age','id'), sep = ',') 

####
n2d1 <- ik_ut_colclass_factorize(n2d1,1:3)

# reshape to long data format
n2d1 <- n2d1 %>% gather('year','value',4:27)


#!!! remove EU flags from the value column 

# b 	break in time series 	c 	confidential 	d 	definition differs, see metadata
# e 	estimated 	f 	forecast 	i 	see metadata (phased out)
# n 	not significant 	p 	provisional 	r 	revised
# s 	Eurostat estimate (phased out) 	u 	low reliability 	z 	not applicable 

# in our data set only these flags are present: b, c, e, p

n2d1$value <- gsub('b','',n2d1$value)
n2d1$value <- gsub('c','',n2d1$value)
n2d1$value <- gsub('e','',n2d1$value)
n2d1$value <- gsub('p','',n2d1$value)

# change ':' symbol for NA
n2d1$value[n2d1$value==':'] <- NA
n2d1$value[n2d1$value==': '] <- NA

# transform the value column to numeric format
n2d1$value <- as.numeric(n2d1$value)

# correct years
n2d1$year <- gsub('X','y',n2d1$year)
n2d1$year <- factor(n2d1$year)

### FILTER ONLY needed (but keep sex for now)
# filter NUTS-2, 
n2d1 <- filter(n2d1, id%in%idn2eu28, year%in%paste0('y',2003:2012)) %>% 
        droplevels()

# Correct the levels of factor variables: age and sex
# correct ages, levels
for (i in 1:nlevels(n2d1$age)){
        agei <- gsub('Y','',levels(n2d1$age)[i])
        subi <- if(nchar(agei)==1){
                paste0('a00',agei)
        }else if(nchar(agei)==2){
                paste0('a0',agei)
        }else if(nchar(agei)==3){
                paste0('a',agei) # we will summarize everything greater than 100 years
        }else{agei}
        levels(n2d1$age)[i] <- subi
        #print(paste(i,'out of',nlevels(n2d1$age)))
}

n2d1$age <- paste(n2d1$age)
n2d1$sex <- paste(n2d1$sex)

n2d1$age[n2d1$age=='TOTAL'] <- 'total'
n2d1$age[n2d1$age=='_LT1'] <- 'a000'
n2d1$age[n2d1$age%in%c('_OPEN','_GE100','aUNK',paste0('a',100:109))] <- 'open'

n2d1$sex[n2d1$sex=='T'] <- 'b'
n2d1$sex[n2d1$sex=='F'] <- 'f'
n2d1$sex[n2d1$sex=='M'] <- 'm'

n2d1$age <- factor(paste(n2d1$age))
n2d1$sex <- factor(paste(n2d1$sex))

# summarize open age group
n2d1 <- n2d1 %>% group_by(year,id,sex,age) %>%
        summarise(value=sum(value, na.rm=T)) %>%
        ungroup() %>% droplevels()

# remove now unneccessary extra digit in age levels
levels(n2d1$age) <- gsub('a0','a',levels(n2d1$age))


###
# Remove remote regions
load('data0_supplementary/remove.remote.Rdata')

n2d1 <- n2d1 %>% filter(!id%in%remove.remote) %>%
        droplevels()


#####
# save the data before inserting the missing data
save(n2d1, file = 'data1_raw/n2d1.missings.RData')
################################################################################


###
# Report finish of the script execution
print('Done: script 2.02')
