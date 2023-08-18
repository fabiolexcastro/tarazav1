
## Download SRTM
## Clary Juliana 
## August 12 th 2023

### Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, rgeos, gtools, stringr, glue, elevatr)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

### Load data ---------------------------------------------------------------
zone <- terra::vect('./gpkg/zone-mpios.gpkg')

?get_elev_raster

### To download -------------------------------------------------------------
srtm <- get_elev_raster(st_as_sf(zone), z = 12)
dir <- './tif/srtm'
dir_create(dir)
terra::writeRaster(x = srtm, filename = glue('{dir}/srtm_z9_raw.tif'), overwrite = T)
