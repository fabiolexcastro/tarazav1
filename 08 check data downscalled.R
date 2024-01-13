

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
  fles <- unlist(fles)
  fles <- as.character(fles)

  lng.tmx <- length(grep('tasmax', fles, value = T))
  lng.tmn <- length(grep('tasmin', fles, value = T))
  
  # Check 
  print(lng.tmx == lng.tmn)
  
  # Now list inside each year (folder)
  x <- 1 
  
  map(.x = 1:length(fles), .f = function(x){
    
    fls <- dir_ls(fles[x], regexp = '.tif$')
    fls <- as.character(fls)
    fls <- mixedsort(fls)
    frq <- tibble(folder = fles[x], nlng = length(fls))
    fls.bsn <- grep('bsin', fls, value = T)
    fls.bsn
    lng.bsn <- length(fls.bsn)
    
    if(lng.bsn != 365){
      
      rot <- basename(fls.bsn) %>% str_sub(., 1, 11)
      rot <- unique(rot)
      mss <- setdiff(paste0(rot, '_', 1:365, '.tif'), basename(fls.bsn))
      dir.mss <- fls.bsn %>% dirname() %>% unique()
      
      
    } else {
      print('Ok')
    }
    
    
    
  })
  
  
  
}

make.down <- function(dir, nms){
  
  dir <- dir.mss
  nms <- mss
  
  cat('To process\n')
  lst.fls <- dir_ls(dir)
  lst.fls <- grep('.tif$', lst.fls, value = T)
  
  
}

