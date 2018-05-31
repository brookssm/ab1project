library(rgdal)
library(sp)
library(leaflet)
library(dplyr)
library(ggplot2)

# http://zevross.com/blog/2015/10/14/manipulating-and-mapping-us-census-data-in-r-using-the-acs-tigris-and-leaflet-packages-3/
tract <- readOGR(dsn = "./data/census/geog")
tract@data$GEOID <- as.character(tract@data$GEOID)

acs_data <- read.csv("./data/census/ACS_16_5YR_B02001_with_ann.csv",
                     stringsAsFactors = F) %>% 
  mutate(GEO.id2 = as.character(GEO.id2))
full <- tract
full@data <- left_join(tract@data, acs_data, 
                       by = c("GEOID" = "GEO.id2"))

# https://gis.stackexchange.com/questions/89512/r-dealing-with-missing-data-in-spatialpolygondataframes-for-moran-test
# FUNCTION TO REMOVE NA's IN sp DataFrame OBJECT
#   x           sp spatial DataFrame object
#   margin      Remove rows (1) or columns (2) 
sp.na.omit <- function(x, margin=1) {
  if (!inherits(x, "SpatialPointsDataFrame") & !inherits(x, "SpatialPolygonsDataFrame")) 
    stop("MUST BE sp SpatialPointsDataFrame OR SpatialPolygonsDataFrame CLASS OBJECT") 
  na.index <- unique(as.data.frame(which(is.na(x@data),arr.ind=TRUE))[,margin])
  if(margin == 1) {  
    cat("DELETING ROWS: ", na.index, "\n") 
    return( x[-na.index,]  ) 
  }
  if(margin == 2) {  
    cat("DELETING COLUMNS: ", na.index, "\n") 
    return( x[,-na.index]  ) 
  }
}

# King County Polygon Geometry and Census Demographics
# in SpatialPolygonDataFrame
full <- sp.na.omit(full)

map <- leaflet() %>% 
  addPolygons(data = full)

map
