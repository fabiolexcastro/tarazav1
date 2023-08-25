
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



#










