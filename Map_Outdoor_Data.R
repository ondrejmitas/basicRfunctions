##### map outdoor data #####

## geo libraries
library(sf)
library(sp)
library(dplyr)
library(ggspatial)
library(rnaturalearth)
library(rnaturalearthdata)
library(SpatialKDE)


# Convert latitude and longitude to spatial points
nuenen_outdoor_sf <- st_as_sf(nuenen_outdoor_scr, coords = c("long", "lat"), crs = 4326)

# Project to a projected coordinate system (e.g., UTM)
nuenen_outdoor_sf <- st_transform(nuenen_outdoor_sf, crs = "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs")

# Define grid size 
grid_size <- 3

# Create a grid based on the bounding box of the data
grid <- st_make_grid(nuenen_outdoor_sf, cellsize = grid_size, what = "polygons", square = FALSE)

# Convert the sfc object to an sf object
grid_sf <- st_sf(geometry = grid)

# Plot the grid with color adjustments
# plot(grid_sf, col = "#f2f2f2", border = "darkgrey", main = "Grid Visualization")

# Assign each data point to the corresponding grid square
nuenen_grid <- st_join(grid_sf, nuenen_outdoor_sf, left=TRUE)

## filter out as NA cells with fewer participants

grid_summary2 <- nuenen_grid %>%
  group_by(geometry) %>%
  summarise(
    unique_participants = n_distinct(participant),  # Count unique participants
    scr = ifelse(unique_participants < 3, NA, mean(phasic_z, na.rm = TRUE))  # Set to NA if less than 3 unique
  )

grid_summary2 <- grid_summary2 %>%
  mutate(mean_variable_quantile = cut_number(scr, n = 8))

grid_summary2 <- grid_summary2[complete.cases(grid_summary2$scr), ]

color_palette2 <- c("lightblue","mediumaquamarine", "olivedrab3", "khaki2", "gold1", "orange2","orangered3","darkred")

#create map as background


ggplot(grid_summary2) +
  annotation_map_tile(zoom = 18, type = "osm") +  # Adds an OpenStreetMap tile
  geom_sf(aes(fill = mean_variable_quantile), size = 0.00001) +
  scale_fill_manual(values = color_palette2) +  # Explicit color mapping
  theme_minimal() +
  labs(fill = "Quantiles", title = "Spatial Grid Analysis with Quantile-Based Color Scale")
