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
         HD01_VD02 = 100 * HD01_VD02 / HD01_VD01,
         HD01_VD03 = 100 * HD01_VD03 / HD01_VD01,
         HD01_VD04 = 100 * HD01_VD04 / HD01_VD01,
         HD01_VD05 = 100 * HD01_VD05 / HD01_VD01,
         HD01_VD06 = 100 * HD01_VD06 / HD01_VD01,
         HD01_VD07 = 100 * HD01_VD07 / HD01_VD01,
         HD01_VD08 = 100 * HD01_VD08 / HD01_VD01) %>% 
  setNames(c("Population", "% White", "% Black",
             "% American Indian & Alaskan Native",
             "% Asian", 
             "% Native Hawaiian & Pacific Islander",
             "% Other", "% Two or more races",
             "GEOID", "Census Tract")) %>% 
  mutate(`Census Tract` = gsub("[^0-9.]", "", `Census Tract`)) %>% 
  mutate(`% Nonwhite` = 100 - `% White`)

# Create full spatial object with acs data and census borders
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

# gets rid of polygon data for areas not in acs
census_map <- sp.na.omit(census_map)

# My map's color palette
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = c(0, 100)
)
