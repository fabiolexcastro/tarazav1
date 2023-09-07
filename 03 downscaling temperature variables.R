
## Downscaling process to temperature rasters
## Clary Juliana 
## August 12 th 2023

### Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, rgdal, spatialEco, sf, fs, tidyverse, rgeos, gtools, stringr, glue, elevatr)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

### Load data ---------------------------------------------------------------
zone <- terra::vect('./gpkg/zone.gpkg')
srtm <- terra::rast('./tif/srtm/srtm_z9_fill.tif')

# List the files 
path <- './tif/nasa/cmip6/historical'
mdls <- dir_ls(path) %>% basename()

### Function to use ---------------------------------------------------------
make.down <- function(mdel, varb){
  
  # mdel <- mdls[1]
  # varb <- 'tasmin'
  
  cat('To process: ', mdel, ' ', varb, '\n')
  fles <- glue('{path}/{mdel}') %>% 
    dir_ls(., type = 'directory') %>% 
    grep(varb, ., value = T) %>% 
    as.character() %>% 
    dir_ls(., regexp = '.nc$') %>% 
    as.character()
  
  head(fles, 2)
  
  rstr <- map(.x = 1:length(fles), .f = function(i){
    
    fle <- fles[i]
    rst <- rast(fle)
    rst <- terra::crop(rst, c(-76, -75.2, 7.22, 7.7))
    plot(rst[[1]])
    
    dwn <- map(.x = 1:nlyr(rst), .f = function(j){
      
      cat('Day :', j, '\n')
      rs <- rst[[j]]
      dw <- raster.downscale(srtm, rs, se = FALSE, p = 0.90)
      dw <- dw$downscale
      yr <- basename(fle) %>% str_split(., '_') %>% map_chr(8) %>% gsub('.nc$', '', .)
      ou <- glue('{unique(dirname(fles))}/{yr}')
      dir_create(ou)
      terra::writeRaster(x = dw, filename = glue('{ou}/{varb}_{j}.tif'), overwrite = TRUE)
      rm(rs, dw, yr, ou)
      gc(reset = TRUE)
      
    })
   
  })
  
}

# To apply the function ---------------------------------------------------

vrss <- c('tasmin', 'tasmax')

# Model 1
map(.x = 1:2, .f = function(v){
  make.down(mdel = mdls[1], varb = vrss[v])
})

# Model 2
map(.x = 1:2, .f = function(v){
  make.down(mdel = mdls[2], varb = vrss[v])
})

# Model 3
map(.x = 1:2, .f = function(v){
  make.down(mdel = mdls[3], varb = vrss[v])
})


# Repetir con los modelos 3, 4 y 5 una vez que ya hayan sido descargados


# To check the results  ---------------------------------------------------















