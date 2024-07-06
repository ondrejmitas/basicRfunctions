###### make a positive emotion change effectiveness map #####
##
## WHERE
##
## self response data set: fr_start_end
## skin conductance and location: behavior_filtered_fr
## emotion self report variable: connection_5
## skin conductance: phasic_z
##
#######

# join positive emotion change data (Fort de Roovere) in to behavior_filtered_f, which contains location and skin conductance data

fr_start_end$pptnumber <- fr_start_end$Participant
fr_con4 <- fr_start_end[c("pptnumber","connection_4")]

behavior_filtered_fr_con4 <- merge(behavior_filtered_fr, fr_con4, by = "pptnumber")

# Convert latitude and longitude to spatial points
behavior_sf <- st_as_sf(behavior_filtered_fr_con4, coords = c("long", "lat"), crs = 4326)

# Project to a projected coordinate system (e.g., UTM)
behavior_sf <- st_transform(behavior_sf, crs = "+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs")

# Define grid size 
grid_size <- 6

# Create a grid based on the bounding box of the data
grid <- st_make_grid(behavior_sf, cellsize = grid_size, what = "polygons", square = FALSE)

# Convert the sfc object to an sf object
grid_sf <- st_sf(geometry = grid)

# Plot the grid with color adjustments
# plot(grid_sf, col = "#f2f2f2", border = "darkgrey", main = "Grid Visualization")

# Assign each data point to the corresponding grid square
behavior_grid <- st_join(grid_sf, behavior_sf, left=TRUE)


# First, summarize phasic_z by participant within each hexbin
behavior_grid_avg <- behavior_grid %>%
  group_by(geometry, pptnumber) %>%
  summarise(
    avg_phasic_z = mean(phasic_z, na.rm = TRUE),  # Average phasic_z for each participant in each hexbin
    connection_4 = first(connection_4)  # Assuming connection_5 is the same for each participant
  ) %>%
  ungroup()

## filter out as NA cells with fewer participants, and calculate correlation

grid_summary <- behavior_grid_avg %>%
  group_by(geometry) %>%
  summarise(
    unique_participants = n_distinct(pptnumber),
    correlation = if(unique_participants >= 5) {
      cor(avg_phasic_z, connection_4, use = "complete.obs")
    } else {
      NA_real_  # Return NA if there are not enough participants
    }
  )

# Define the fixed breaks for the correlation ranges
breaks <- c(-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1)

# Cut the correlation data into fixed value ranges
grid_summary <- grid_summary %>%
  mutate(correlation_range = cut(correlation, breaks = breaks, include.lowest = TRUE))

grid_summary_eff <- grid_summary[complete.cases(grid_summary$correlation_range), ]

# Define a color palette
color_palette <- c("#2166ac", "#4393c3", "#92c5de", "#d1e5f0", "#fddbc7","#f4a582", "#d6604d","#b2182b", "#67001f")

# Create map as background and add hexbin layer with correlation data
ggplot(grid_summary_eff) +
  annotation_map_tile(zoom = 17, type = "osm") +  # Adds an OpenStreetMap tile
  geom_sf(aes(fill = correlation_range), size = 0.00001) +
  scale_fill_manual(values = color_palette) +
  theme_minimal() +
  labs(fill = "Correlation Ranges", title = "Spatial Grid Analysis of Correlation Between Phasic_z and Nps")