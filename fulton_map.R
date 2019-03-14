library(tidycensus)
library(mapview)
options(tigris_use_cache = TRUE)

census_api_key("4aa4b75a96ccc3d770313fbfbe89b406f4161f0b")

fulton <- get_acs(geography = "tract", 
              variables = "B01003_001", 
              state = "GA", 
              county = "Fulton", 
              geometry = TRUE)

mapview(fulton, zcol = "estimate", legend = TRUE)



v15 <- load_variables(2016, "acs5", cache = TRUE)

View(v15)
