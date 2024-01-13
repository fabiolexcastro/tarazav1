

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, fs, sf, tidyverse, rgeos, gtools, stringr, glue)

g <- gc(reset = T)
rm(list =ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
dirs <- dir_ls('./tif/nasa/cmip6/historical', type = 'directory')
dirs

dir <- dirs[1]

# Function ----------------------------------------------------------------
count.files <- function(dir){
  
  cat('Processing ', dir, '\n')
  fles <- dir_ls(dir)
  fles <- grep('tas', fles, value = T)
  fles <- map(fles, dir_ls, type = 'directory')
  

  
  
  
}

