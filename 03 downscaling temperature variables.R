
## Downscaling process to temperature rasters
## Clary Juliana 
## August 12 th 2023

### Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, rgdal, sf, fs, tidyverse, rgeos, gtools, stringr, glue, elevatr)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

### Load data ---------------------------------------------------------------
zone <- terra::vect('./gpkg/zone-mpios.gpkg')
srtm <- terra::rast('./tif/srtm/srtm_z9_fill.tif')

# List the files 
path <- './tif/nasa/cmip6/historical'
mdls <- dir_ls(path) %>% basename()



















