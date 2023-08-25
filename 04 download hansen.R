
## Download HANSEN dataset
## Clary Juliana 
## August 23 th 2023

### Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, gfcanalysis, rgdal, sf, fs, tidyverse, rgeos, gtools, stringr, glue, elevatr)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

### Load data -----------------------------------------------------------
zone <- terra::vect('gpkg/zone-mpios.gpkg')
plot(zone)

# Calc tiles --------------------------------------------------------------
tles <- calc_gfc_tiles(aoi = st_as_sf(zone))
plot(tles)
dout <- './tif/hansen/raw'
dir_create(dout)

# To download -------------------------------------------------------------
hnsn <- gfcanalysis::download_tiles(tiles = tles, output_folder = dout)
hnsn <- terra::rast('./tif/hansen/raw/Hansen_GFC-2019-v1.7_treecover2000_10N_080W.tif')
hnsn <- terra::crop(hnsn, zone)

dir_create('./tif/hansen/extent')
terra::writeRaster(x = hnsn, filename = './tif/hansen/extent/treecover.tif', overwrite = TRUE)

plot(hnsn)
plot(zone, add = T)




