# Check the class of the object
class(grid_sf)

# Check the geometry type
st_geometry_type(grid_sf)

# Display the first few entries to understand the structure
head(grid_sf)

# Confirm if it's a simple feature with polygon geometries
is(grid_sf, "sf")  # Should return TRUE

# Check the CRS of the grid and data points
st_crs(grid_sf)
st_crs(behavior_sf)

# Verify they are the same; if not, transform one to match the other
if (st_crs(grid_sf) != st_crs(behavior_sf)) {
  behavior_sf <- st_transform(behavior_sf, st_crs(grid_sf))
}

# Get the bounding box of the grid
st_bbox(grid_sf)

# Get the bounding box of the data points
st_bbox(behavior_sf)

# Ensure they overlap or fall within the expected spatial area

# After the join, check if the grid structure holds
head(behavior_grid)

# Check if data points are associated with grid cells
table(st_geometry(behavior_grid))  # Should return counts for each polygon

# Summarize and inspect the output
summary(grid_summary)

# Check the unique values for the variable used for fill
unique(grid_summary$mean_variable)

# Check the summarized data structure
head(grid_summary)

# Plot the grid with the data points
plot(grid_sf, col = "#f2f2f2", border = "grey", main = "Grid Structure")
plot(st_geometry(behavior_sf), add = TRUE, col = "red", pch = 16)  # Data points in red

