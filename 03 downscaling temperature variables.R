
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
zone <- terra::vect('./gpkg/zone-mpios.gpkg')
srtm <- terra::rast('./tif/srtm/srtm_z9_fill.tif')

# List the files 
path <- './tif/nasa/cmip6/historical'
mdls <- dir_ls(path) %>% basename()

### Function to use ---------------------------------------------------------
make.down <- function(mdel, varb){
  
  mdel <- mdls[1]
  varb <- 'tasmin'
  
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
    
    dwn <- map(.x = 1:nlyr(rst), .f = function(j){
      
      cat('Day :', j, '\n')
      rs <- rst[[j]]
      dw <- raster.downscale(srtm, rs, se = FALSE, p = 0.90)
      dw <- dw$downscale
      return(dw)
      
    })
    
    dwn <- reduce(dwn)
    out <- unique(dirname(fles))
    nme <- glue('down_{basename(fle)}')
    terra::writeRaster(x = dwn, filanem = glue('{out}/{nme}'), overwrite = TRUE)
    cat('Done!\n')
                
  })
  
  
  
  
  
}
















