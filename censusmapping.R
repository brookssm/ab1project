library(rgdal)
library(sp)
library(leaflet)
library(dplyr)
library(ggplot2)

# http://zevross.com/blog/2015/10/14/manipulating-and-mapping-us-census-data-in-r-using-the-acs-tigris-and-leaflet-packages-3/
tract <- readOGR(dsn = "./data/census/geog")
tract@data$GEOID <- as.character(tract@data$GEOID)

# American Community Survey demographic data for King County
# margin of error can be *very* high, averaged over 5 years
# for a *general idea* of how neighborhoods have looked
acs_data <- read.csv("./data/census/ACS_16_5YR_B02001_with_ann.csv", stringsAsFactors=FALSE, fileEncoding="latin1") %>% 
  mutate(GEO.id2 = as.character(GEO.id2)) %>% 
  select(starts_with("HD01"), -HD01_VD09, -HD01_VD10,
         GEO.id2, `GEO.display.label`) %>% 
  mutate_if(is.integer, as.double) %>% 
  mutate(# Population counts to population percents
         # mutate_if not working
         HD01_VD02 = HD01_VD02 / HD01_VD01,
         HD01_VD03 = HD01_VD03 / HD01_VD01,
         HD01_VD04 = HD01_VD04 / HD01_VD01,
         HD01_VD05 = HD01_VD05 / HD01_VD01,
         HD01_VD06 = HD01_VD06 / HD01_VD01,
         HD01_VD07 = HD01_VD07 / HD01_VD01,
         HD01_VD08 = HD01_VD08 / HD01_VD01) %>% 
  setNames(c("Population", "% White", "% Black",
             "% American Indian & Alaskan Native",
             "% Asian", 
             "% Native Hawaiian & Pacific Islander",
             "% Other", "% Two or more races",
             "GEOID", "Census Tract")) %>% 
  mutate(`Census Tract` = gsub("[^0-9.]", "", `Census Tract`)) %>% 
  mutate(`% Nonwhite` = 1 - `% White`)

census_map <- tract
census_map@data <- left_join(tract@data, acs_data)

# https://gis.stackexchange.com/questions/89512/r-dealing-with-missing-data-in-spatialpolygondataframes-for-moran-test
# FUNCTION TO REMOVE NA's IN sp DataFrame OBJECT
#   x           sp spatial DataFrame object
#   margin      Remove rows (1) or columns (2) 
sp.na.omit <- function(x, margin=1) {
  if (!inherits(x, "SpatialPointsDataFrame") & !inherits(x, "SpatialPolygonsDataFrame")) 
    stop("MUST BE sp SpatialPointsDataFrame OR SpatialPolygonsDataFrame CLASS OBJECT") 
  na.index <- unique(as.data.frame(which(is.na(x@data),arr.ind=TRUE))[,margin])
  if(margin == 1) {  
    # cat("DELETING ROWS: ", na.index, "\n") 
    return( x[-na.index,]  ) 
  }
  if(margin == 2) {  
    # cat("DELETING COLUMNS: ", na.index, "\n") 
    return( x[,-na.index]  ) 
  }
}

# King County Polygon Geometry and Census Demographics
# in SpatialPolygonDataFrame
census_map <- sp.na.omit(census_map)

pal <- colorNumeric(
  palette = "YlGnBu",
  domain = c(0, 100)
)

labels <- lapply(seq(nrow(acs_data)), function(i) {
  paste0( "<p>",
          "<p><strong>Census Tract ", acs_data[i, "Census Tract"], "</strong></p>", 
          "<p>","</p>", 
          "</p>" ) 
})

nonwhite_map <- leaflet() %>% 
  addPolygons(data = census_map,
              fillColor = ~pal(`% Nonwhite` * 100),
              color = "#b2aeae",
              weight = 1,
              fillOpacity = 1,
              label = lapply(labels, HTML)) %>% 
  addLegend(pal = pal,
            values = census_map$`% Nonwhite` * 100,
            position = "bottomright",
            title = "% Nonwhite in population")

