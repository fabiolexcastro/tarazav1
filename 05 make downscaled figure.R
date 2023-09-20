
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, hrbrthemes, ggspatial, sf, tidyverse, gtools, stringr, glue)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
srtm <- rast('./tif/srtm/srtm_z9_fill.tif')
bsin <- vect('./gpkg/zone.gpkg')
rraw <- rast('./tif/nasa/cmip6/historical/ACCESS-CM2/tasmax/zone_tasmax_day_ACCESS-CM2_historical_r1i1p1f1_gn_1979.nc')

# Extract by mask  --------------------------------------------------------
srtm <- srtm %>% terra::crop(., c(-76, -75.2, 7.22, 7.7)) 

# Conversion to Celcius ---------------------------------------------------
rraw <- rraw[[1]]
rraw <- rraw - 273.15

plot(rraw[[1]])

# SRTM map  ---------------------------------------------------------------
srtm.tble <- srtm %>% 
  terra::as.data.frame(., xy = T) %>% 
  as_tibble() %>% 
  setNames(c('x', 'y', 'value'))

g.srtm <- ggplot() + 
  geom_tile(data = srtm.tble, aes(x = x, y = y, fill = value)) + 
  scale_fill_gradientn(colors = terrain.colors(10)) +
  geom_sf(data = st_as_sf(bsin), fill = NA, col = 'grey60') + 
  coord_sf() + 
  theme_ipsum_es() + 
  theme(legend.position = 'bottom', 
        axis.text.y = element_text(hjust = 0.5, angle = 90),
        axis.text.x = element_text(hjust = 0.5), 
        axis.title = element_text(face = 'bold'),
        legend.key.width = unit(3, 'line'),
        text = element_text(family = 'Barlow'), 
        plot.title = element_text(face = 'bold', hjust = 0.5), 
        legend.title = element_text(face = 'bold')) +
  guides(fill = guide_legend( 
          direction = 'horizontal',
          keyheight = unit(1.15, units = "mm"),
          keywidth = unit(15, units = "mm"),
          title.position = 'top',
          title.hjust = 0.5,
          label.hjust = .5,
          nrow = 1,
          byrow = T,
          reverse = F,
          label.position = "bottom"
        )) +
  annotation_scale(location =  "bl", width_hint = 0.5, text_family = 'Barlow', text_col = 'grey60', bar_cols = c('grey60', 'grey99'), line_width = 0.2) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.1, "in"), pad_y = unit(0.2, "in"), 
                         style = north_arrow_fancy_orienteering(text_family = 'Barlow', text_col = 'grey40', line_col = 'grey60', fill = c('grey60', 'grey99'))) 

ggsave(plot = g.srtm, filename = './png/srtm_map.png', units = 'in', width = 9, height = 5, dpi = 300)

