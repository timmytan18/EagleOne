library(acs)
library(tigris)
library(leaflet)
library(mapview)
library(stringr)

api.key.install(key="4aa4b75a96ccc3d770313fbfbe89b406f4161f0b")
geo.lookup(state="GA", place="Atlanta")
geo.lookup(state="GA", county="Fulton County")
geo.lookup(state="GA", county="Dekalb County")
lookup_code(state="GA",county="Fulton County")
lookup_code(state="GA",county="Dekalb County")

shapefile <- tracts(state='13', county='121')
plot(shapefile)

countylist <- c('089', '121')
shapefile <- tracts(state='13', county=countylist)
plot(shapefile)

mytable <- acs.lookup(endyear=2015, table.number="B19013")
str(mytable)

results(mytable)$variable.name
myvars <- mytable[1] 
myspan <- 2
myendyear <- 2015

countylist2 <- as.numeric(countylist)
countylist2
mygeo <- geo.make(state=13, county=countylist2, tract="*")

mydata <- acs.fetch(endyear=myendyear, span=myspan, geography=mygeo, variable=myvars)
