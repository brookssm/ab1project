library(jsonlite)
library(httr)
library(knitr)
library(dplyr)
library(ggplot2)
library(ggmap)
library(mapdata)

#reads in bus stop data
all_stops <- read.csv("./data/bus_stops_data.csv", stringsAsFactors = FALSE)

library(leaflet)
# loads map data
map <- leaflet(all_stops) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                              attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
                              <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
                              <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') 
# sets color palette by agency
agencycolor <- colorFactor(c("#5dff00", "#ED1B2E", "#006aff"), 
                           all_stops$agency)
# creates map
map %>% 
  # location of map and zoom
  setView(-122.3035, 47.6553, zoom = 11) %>% 
  # adds bus stop, assigns size and color
  addCircles(~lon, ~lat, popup = paste0(all_stops$agency, ", ", 
                                        all_stops$route_id), 
             weight = 10, radius = 50, color = ~agencycolor(agency), 
             stroke = FALSE, fillOpacity = 0.8) %>% 
  # adds legend for point color
  addLegend("bottomright", pal = agencycolor, values = ~all_stops$agency,
            title = "Transit Agency",
            opacity = 0.8
  )
