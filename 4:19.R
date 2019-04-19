library(leaflet)
library(leaflet.extras)
library(tidycensus)
library(mapview)
library(rgdal)
options(tigris_use_cache = TRUE)

fulton <- get_acs(geography = "tract", 
                  variables = "B01003_001", 
                  state = "GA", 
                  county = "Fulton", 
                  geometry = TRUE)

dekalb <- get_acs(geography = "tract", 
                  variables = "B01003_001", 
                  state = "GA", 
                  county = "Dekalb", 
                  geometry = TRUE)

cobb <- get_acs(geography = "tract", 
                variables = "B01003_001", 
                state = "GA", 
                county = "Cobb", 
                geometry = TRUE)

clayton <- get_acs(geography = "tract", 
                   variables = "B01003_001", 
                   state = "GA", 
                   county = "Clayton", 
                   geometry = TRUE)

g1 <- mapview(fulton, zcol = "estimate", legend = TRUE)
g2 <- mapview(dekalb, zcol = "estimate", legend = TRUE)
g3 <- mapview(cobb, zcol = "estimate", legend = TRUE)
g4 <- mapview(clayton, zcol = "estimate", legend = TRUE)
g <- g1 + g2 + g3 + g4

setwd("/Users/timothywu/vip/eagleone/Atlanta_City_Limits")
neighborhoods = "c:/Users/timothywu/vip/eagleone/Neighborhoods/Neighborhoods.shp"
atl = readOGR(dsn = getwd(),
                  layer = "Atlanta_City_Limits")
head(atl)
summary(atl)
leaflet(data=atl) %>%
  addPolygons(fillColor="Blue")

leaflet(atl) %>%
  addPolygons(m, color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))

#starts right here
filename = "/Users/timothywu/vip/eagleone/stops.csv"
data_filter = read.csv(filename, header = TRUE)
m = leaflet()
m = addTiles(m)
m = addCircleMarkers(m, 
                     lng = data_filter$stop_lon, # we feed the longitude coordinates 
                     lat = data_filter$stop_lat,
                     popup = data_filter$stop_name, 
                     radius = 7, 
                     stroke = FALSE, 
                     fillOpacity = 0.5, 
                     color = "orange",
                     group = "Bus Stops"
)
m


interest_data = "/Users/timothywu/vip/eagleone/pointsofinterests/locationsdata(2).csv"
poi = read.csv(interest_data, header = TRUE)

getColor <- function(poi) {
  sapply(poi$Type_of_Location, function(Type_of_Location) {
    if(Type_of_Location == "Grocery Store") {
      "green"
    } else if(Type_of_Location == "Hospital") {
      "red"
    } else {
      "blue"
    } })
}

m = addCircleMarkers(m, 
                     lng = poi$Lng, # we feed the longitude coordinates 
                     lat = poi$Lat,
                     popup = poi$Location_Name, 
                     radius = 7, 
                     stroke = FALSE, 
                     fillOpacity = 0.75, 
                     color = getColor(poi),
                     group = "Points of Interest"
)
m

#m = addMarkers(m, lng=poi$Lng, lat = poi$Lat, popup = poi$Location_Name)
m = addLegend(m, "bottomright", 
              colors=c("orange","green","red", "blue"), 
              labels=c("Marta Stops", "Grocery Store", "Hospital", "School"),
              title="Atlanta",
              opacity=.75)
m
mydrawPolylineOptions <- function (allowIntersection = TRUE, 
                                   drawError = list(color = "#b00b00", timeout = 2500), 
                                   guidelineDistance = 20, metric = TRUE, feet = FALSE, zIndexOffset = 2000, 
                                   shapeOptions = drawShapeOptions(fill = FALSE), repeatMode = FALSE) {
  leaflet::filterNULL(list(allowIntersection = allowIntersection, 
                           drawError = drawError, guidelineDistance = guidelineDistance, 
                           metric = metric, feet = feet, zIndexOffset = zIndexOffset,
                           shapeOptions = shapeOptions,  repeatMode = repeatMode)) }
m = addDrawToolbar(m,
  polylineOptions = mydrawPolylineOptions(metric=TRUE, feet=FALSE),
  editOptions=editToolbarOptions(selectedPathOptions=selectedPathOptions())
) 
m
