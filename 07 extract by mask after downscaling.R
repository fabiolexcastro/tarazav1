
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
  
  vr <- 'tasmin'
  yr <- 1979
  
  cat('... Processing: ', yr, '\n')
  fles <- dir_ls(path, regexp = vr) %>% dir_ls(., type = 'directory') %>% as.character()
  fles <- grep(yr, fles, value = T) %>% dir_ls() %>% as.character()
  fles <- fles %>% mixedsort()
  
  map(.x = fles, .f = function(f){
    f <- fles[1] # Correr y borrar 
    cat('Basename: ', basename(f), '\n')
    r <- rast(f)
    r
    
  })
  
  
}

# Extract by mask  --------------------------------------------------------











