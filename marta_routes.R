library(gtfsr)
library(dplyr)
options(dplyr.width = Inf)
library(magrittr)
library(leaflet)
library(tidycensus)
library(mapview)
library(sf)
options(tigris_use_cache = TRUE)
#spDistance
#geosphere

# Extract MARTA GTFS data from MARTA site and create GTFS object
# Fix no agency_id in routes_df error by adding agency_id column
marta_url = "https://www.itsmarta.com/google_transit_feed/google_transit.zip"
marta_objs <- marta_url %>% import_gtfs()
for (i in 8:2) {
  currentCol <- marta_objs$routes_df[,i]
  marta_objs$routes_df[,i+1] <- currentCol
}
colnames(marta_objs$routes_df) <- c("route_id","agency_id","route_short_name","route_long_name",
                          "route_desc","route_type","route_url","route_color","route_text_color")
for (i in 1:length(marta_objs$routes_df$agency_id)) {
  marta_objs$routes_df$agency_id[i] = "MARTA"
}

# Create map of MARTA network
marta_agency_name <- marta_objs[['agency_df']]$agency_name[1]
MartaMap <- map_gtfs(gtfs_obj = marta_objs, agency_name = marta_agency_name)
MartaMap

# Read CSV file with points of interests
setwd("/Users/timtan/documents/gatech/vip/eagleone/pointsofinterests")
Interests <- read.csv(file = "locationsdata.csv", header = TRUE, ",")
Type <- Interests[,1]
Name <- Interests[,2]
CoordinateX <- Interests[,3]
CoordinateY <- Interests[,4]
# Convert coordinate strings to double
options(digits=9)
for (i in 1:length(CoordinateX)) {
  CoordinateX <- as.double(CoordinateX)
  CoordinateY <- as.double(CoordinateY)
}

# Map of Fulton county
census_api_key("4aa4b75a96ccc3d770313fbfbe89b406f4161f0b")
fulton <- get_acs(geography = "tract", 
                  variables = "B01003_001", 
                  state = "GA", 
                  county = "Fulton", 
                  geometry = TRUE)

# Add points of interest markers to map
#addMarkers(MartaMap, ~CoordinateX, ~CoordinateY, label = ~Name, icon = ~icons)
#addMarkers(MartaMap, ~CoordinateX, ~CoordinateY, label = ~Name) #run again if didn't show up
#addMarkers(MartaMap, data = fulton)
#mapview(MartaMap)


# Create map with Fulton country and Marta stops

popMap = fulton%>%leaflet()%>%addTiles()%>%addPolygons()


popMap = addCircleMarkers(
  popMap,
  ~marta_objs$stops_df$stop_lon,
  ~marta_objs$stops_df$stop_lat,
  label = c(~marta_objs$stops_df$stop_name, ~marta_objs$stops_df$stop_name),
  radius = 6,
  color = "yellow",
  stroke = FALSE,
  fillOpacity = 0.5)

popMap = addCircleMarkers(
  popMap,
  ~CoordinateX,
  ~CoordinateY,
  label = ~Name,
  radius = 10,
  color = "red",
  stroke = FALSE,
  fillOpacity = 0.5)

popMap







