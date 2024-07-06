##############################
##
## Kernel Density
##
##############################



cell_size = 3
band_width = 100

nuenen_outdoor_sf_kde <- nuenen_outdoor_sf

nuenen_outdoor_sf_kde <- nuenen_outdoor_sf_kde %>%
  st_as_sf(coords = c("long", "lat"), dim = "XY") %>%
  select()

grid_nuenen <- nuenen_outdoor_sf_kde %>%
  create_grid_hexagonal(cell_size = cell_size, side_offset = band_width)

kde <- nuenen_outdoor_sf_kde %>%
  kde(band_width = band_width, kernel = "quartic", grid = grid_nuenen)

# make percentiles

kde <- kde %>%
  mutate(kde_value = cut_number(kde_value, n = 4))

#grid_summary2 <- grid_summary2[complete.cases(grid_summary2$scr), ]

color_palette2 <- c("skyblue1","skyblue2", "skyblue3", "skyblue4")

## visualization attempt using tmap package

# tm_shape(kde) +
#  tm_polygons(col = "kde_value", palette = "viridis", title = "KDE Estimate") 
#+
#tm_shape(nuenen_outdoor_sf_kde) 
#+
# tm_bubbles(size = 0.1, col = "red")

## visualization attempt using ggplot package

kde <- kde[complete.cases(kde$kde_value), ]

ggplot(kde) +
  annotation_map_tile(zoom = 18, type = "osm") +  # Adds an OpenStreetMap tile
  geom_sf(aes(fill = kde_value), size = 0.00001) +
  scale_fill_manual(values = color_palette2) +  # Explicit color mapping
  theme_minimal() +
  labs(fill = "Density of location points", title = "Spatial Grid Analysis with Quantile-Based Color Scale")
