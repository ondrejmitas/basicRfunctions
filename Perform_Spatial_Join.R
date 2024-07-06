#### perform spatial join with GeoJSON ####

## import GeoJSON. It has to be called "map"!

locations <- st_read("Library/CloudStorage/OneDrive-BUas/work/my_research/experience/ExperiencingNature/0.RawData/map.geojson")

# Convert GeoJSON to spatial object
locations_sf <- st_as_sf(locations)

#lat and long are not complete at 1618031 cases
behavior_filtered <- nat_scr[complete.cases(nat_scr[c("lat", "long")]), ]
psych::describe(behavior_filtered)
#oddly it still comes to 1618031 cases

# Convert dataframe to sf
behavior_sf <- st_as_sf(behavior_filtered, coords = c("long", "lat"))

# check coordinate systems

st_crs(behavior_sf) 
#NA

st_crs(locations_sf)
#WGS 84

#assign WGS 84 to behavior_sf
st_crs(behavior_sf) <- st_crs(locations_sf)

# check if all polygons are valid. If so gives TRUE across the board
st_is_valid(locations_sf)

# Perform spatial join
# behavior_join <- st_within(behavior_sf, locations_sf)

# Create binary variables for each location
for (i in seq_along(locations_sf$name)) {
  location_var <- paste0("location", i)
  behavior_filtered[[location_var]] <- as.numeric(st_within(behavior_sf, locations_sf[i, ]))
}

# test for bridge 

data_location_bridge <- behavior_filtered[complete.cases(behavior_filtered$location2), ]

data_location_bridge.points = st_as_sf(data_location_bridge, coords = c("long", "lat"), crs = 4326, agr = "constant")
plot(data_location_bridge.points)
write_csv(data_location_bridge, "Library/CloudStorage/OneDrive-BUas/work/my_research/experience/ExperiencingNature/2.ProcessedData/data_location_bridge.csv")
# end of test

# fill named variables with 0's

behavior_filtered$tower <- 0
behavior_filtered$bridge <- 0
behavior_filtered$lunchroom <- 0
behavior_filtered$fort_woods <- 0
behavior_filtered$SH_visitorcenter <- 0
behavior_filtered$SH_lunchroom <- 0
behavior_filtered$SH_ntberg_lookout <- 0
behavior_filtered$SH_ntberg_bench <- 0
behavior_filtered$SH_parking_built_entry <- 0
behavior_filtered$parking_lot <- 0
behavior_filtered$SH_touristroad <- 0

# change to 1's when the point is present within the polygon

behavior_filtered$tower[behavior_filtered$location1 == 1] <- 1
behavior_filtered$bridge[behavior_filtered$location2 == 1] <- 1
behavior_filtered$lunchroom[behavior_filtered$location3 == 1] <- 1
behavior_filtered$fort_woods[behavior_filtered$location4 == 1] <- 1
behavior_filtered$SH_visitorcenter[behavior_filtered$location5 == 1] <- 1
behavior_filtered$SH_lunchroom[behavior_filtered$location6 == 1] <- 1
behavior_filtered$SH_ntberg_lookout[behavior_filtered$location7 == 1] <- 1
behavior_filtered$SH_ntberg_bench[behavior_filtered$location8 == 1] <- 1
behavior_filtered$SH_parking_built_entry[behavior_filtered$location9 == 1] <- 1
behavior_filtered$parking_lot[behavior_filtered$location10 == 1] <- 1
behavior_filtered$SH_touristroad[behavior_filtered$location11 == 1] <- 1


#### perform spatial join with grid ####