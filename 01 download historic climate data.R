
## Historic climate data 
## Clary Juliana 
## August 12 th 2023

### Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, rgeos, gtools, stringr, glue)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

### Load data ---------------------------------------------------------------
mpio <- vect('D:/data/spatial/igac/Municipios202305.gpkg')
bsin <- vect('E:/asesorias/2023/clary/shp/cuencaTaraza.shp')
bsin <- terra::project(bsin, 'EPSG:4326')
root <- 'https://nex-gddp-cmip6.s3-us-west-2.amazonaws.com/NEX-GDDP-CMIP6'

writeVector(bsin, './gpkg/zone.gpkg')
zone <- terra::vect('./gpkg/zone.gpkg')
zone <- mpio[mpio$MpNombre %in% c('Tarazá', 'Ituango'),]
zone <- terra::project(zone, 'EPSG:4326')

terra::writeVector(zone, './gpkg/zone-mpios.gpkg')

# Parameters
ssps <- c('ssp245', 'ssp585')
vars <- c('pr', 'tasmax', 'tasmin')
gcms <- c('ACCESS-CM2', 'ACCESS-ESM1-5', 'BCC-CSM2-MR', 'CanESM5', 'CESM2-WACCM', 'CESM2', 'CMCC-CM2-SR5', 'CMCC-ESM2', 'CNRM-ESM2', 'CNRM-ESM2', 'CNRM-CM6-1', 'CNRM-ESM2-1', 'EC-Earth3-Veg-LR')

### Functions to use --------------------------------------------------------
down.hist <- function(var, gcm, ab1, ab2){
  
  # Proof 
  # var <- 'pr'
  # gcm <- gcms[1]
  # ab1 <- 'r1i1p1f1'
  # ab2 <- 'gn'
  
  # Start 
  cat('To process: ', var, ' ', gcm, '\n')
  urlw <- as.character(glue('{root}/{gcm}/historical/{ab1}/{var}/{var}_day_{gcm}_historical_{ab1}_{ab2}_{c(1989, 2009, 2010)}.nc'))
  dirs <- as.character(glue('tif/nasa/cmip6/historical/{gcm}/{var}/{basename(urlw)}'))
  dout <- unique(dirname(dirs))
  ifelse(!file.exists(dout), dir_create(dout), print('Directorio existe'))
  
  # To download 
  map(.x = 1:length(urlw), .f = function(i){
    
    cat('>>> To start the process:', i, '\t')
    url <- urlw[i]
    out <- dirs[i]
    download.file(url = url, destfile = out, mode = 'wb')
    
    rst <- rast(out)
    rst <- rotate(rst)
    rst <- crop(rst, zone)
    terra::writeRaster(x = rst, filename = glue('{dout}/zone_{basename(out)}'), overwrite = T)
    
    file.remove(out); rm(rst); gc(reset = T)
    cat('Done!\n')
    
  })
  
  
  
  
}

### To apply the function ---------------------------------------------------

### ACCESS-CM2
map(.x = 3:length(vars), .f = function(v){
  down.hist(var = vars[v], gcm = 'ACCESS-CM2', ab1 = 'r1i1p1f1', ab2 = 'gn')
})


### CanESM5
map(.x = 1:length(vars), .f = function(v){
  down.hist(var = vars[v], gcm = 'CanESM5', ab1 = 'r1i1p1f1', ab2 = 'gn')
})


### INM-CM4-8
map(.x = 1:length(vars), .f = function(v){
  down.hist(var = vars[v], gcm = 'INM-CM4-8', ab1 = 'r1i1p1f1', ab2 = 'gr1')
})

### BCC-CSM2-MR
map(.x = 1:length(vars), .f = function(v){
  down.hist(var = vars[v], gcm = 'BCC-CSM2-MR', ab1 = 'r1i1p1f1', ab2 = 'gn')
})



