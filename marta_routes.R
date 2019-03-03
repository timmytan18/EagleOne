library(gtfsr)
library(dplyr)
options(dplyr.width = Inf)
library(magrittr)
library(leaflet)
#spDistance
#geosphere

set_api_key()

# Filter map feedlist for Marta
feedlist_df <- get_feedlist()
marta_df <- feedlist_df %>%
  filter(grepl('atlanta', loc_t, ignore.case = TRUE))
marta_objs <- read_gtfs("google_transit", local(TRUE))

# Map Marta network
marta_agency_name <- marta_objs[['agency_df']]$agency_name[1]
MartaMap <- map_gtfs(gtfs_obj = marta_objs, agency_name = marta_agency_name)

MartaMap

# Read CSV file with points of interests
Interests <- read.csv(file = "locationsdata.csv", header = TRUE, ",")
Type <- Interests[,1]
Name <- Interests[,2]
CoordinateX <- Interests[,3]
CoordinateY <- Interests[,4]

options(digits=9)
for (i in 1:length(CoordinateX)) {
  CoordinateX <- as.double(CoordinateX)
  CoordinateY <- as.double(CoordinateY)
}
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
#addMarkers(MartaMap, ~CoordinateX, ~CoordinateY, label = ~Name, icon = ~icons)
addMarkers(MartaMap, ~CoordinateX, ~CoordinateY, label = ~Name)
addMarkers(MartaMap, -84.47001, 33.7545)
MartaMap




