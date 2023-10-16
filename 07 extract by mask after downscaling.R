
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, hrbrthemes, ggspatial, sf, fs, tidyverse, gtools, stringr, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
bsin <- vect('./gpkg/zone.gpkg')

path <- './tif/nasa/cmip6/historical/ACCESS-CM2'
vars <- c('pr', 'tasmin', 'tasmax')
year <- 1979:2014

# Function to use ---------------------------------------------------------
make.extract <- function(vr, yr){
  
  # vr <- 'tasmin'
  # yr <- 1979
  
  cat('... Processing: ', yr, '\n')
  fles <- dir_ls(path, regexp = vr) %>% dir_ls(., type = 'directory') %>% as.character()
  fles <- grep(yr, fles, value = T) %>% dir_ls() %>% as.character()
  fles <- fles %>% mixedsort()
  fles <- grep('.tif$', fles, value = T)
  fles <- grep(paste0('/', vr), fles, value = T)
  
  map(.x = fles, .f = function(f){
    cat('Basename: ', basename(f), '\n')
    r <- rast(f)
    z <- terra::crop(r, bsin)
    z <- terra::mask(z, bsin)
    o <- paste0(dirname(f), '/', 'bsin_', basename(f))
    terra::writeRaster(x = z, filename = o, overwrite = TRUE)
    rm(r, z)
    gc(reset = T)
    file.remove(f)
  })
  
  cat('-----Done-----\n')
  
}

# Extract by mask  --------------------------------------------------------#

# Tasmax
year <- 1979:2014
map(.x = 1:length(year), .f = function(i){
  make.extract(vr = 'tasmax', yr = year[i])
})

# Tasmin 
year <- 1980:2014
map(.x = 1:length(year), .f = function(i){
  make.extract(vr = 'tasmin', yr = year[i])
})


# Check 1979  -------------------------------------------------------------

fles <- dir_ls('./tif/nasa/cmip6/historical/ACCESS-CM2/tasmax/1979', regexp = '.tif$')
fles <- as.character(fles)
fles <- grep('bsin', fles, value = TRUE)

grep('tasmax_1.tif', fles, value = T)


# To change the names
fles.bsin <- grep('bsin_bsin', fles, value = TRUE)
for(i in 1:length(fles.bsin)){
  cat('To change the name: ', i, '\n')
  file.remove(fles.bsin[i], gsub('bsin_bsin_', 'bsin_', fles.bsin[i]))
}

# To extract by mask
fles <- dir_ls('./tif/nasa/cmip6/historical/ACCESS-CM2/tasmax/1979', regexp = '.tif$')
fles <- as.character(fles)
fles <- grep('/tasmax_', fles, value = TRUE)

fles <- grep('tasmax_', fles, value = T)
fles <- fles[-grep('bsin', fles, value = F)]










