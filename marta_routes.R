library(gtfsr)
library(dplyr)
options(dplyr.width = Inf)
library(magrittr)
library(leaflet)
library(tidycensus)
library(mapview)
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
setwd("/Users/timtan/documents/gt/vip/eagleone/pointsofinterests")
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

censusMap <- mapview(fulton, zcol = "estimate", legend = TRUE)
censusMap
#-------------------------------------------------------------------------------------------------
# Create icons -- doesn't work yet
groceryIcon <- makeIcon(
  iconUrl = "https://static.thenounproject.com/png/236784-200.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
schoolIcon <- makeIcon(
  iconUrl = "https://cdn4.iconfinder.com/data/icons/school-icon-set-1/512/1-512.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
hospitalIcon <- makeIcon(
  iconUrl = "https://image.flaticon.com/icons/png/512/33/33777.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
# Set icons to respective points of interest -- doesn't work yet
icons <- vector()
for (i in 1:length(CoordinateX)) {
  if (Type == "Grocery Store") {
    append(icons, groceryIcon)
  }
  else if (Type == "School") {
    append(icons, schoolIcon)
  }
  else {
    append(icons, hospitalIcon)
  }
}
#-------------------------------------------------------------------------------------------------

# Add points of interest markers to map
#addMarkers(MartaMap, ~CoordinateX, ~CoordinateY, label = ~Name, icon = ~icons)
addMarkers(MartaMap, ~CoordinateX, ~CoordinateY, label = ~Name) #run again if didn't show up
addMarkers(MartaMap, data = fulton)
mapview(MartaMap)




