library(dplyr)
library(geojsonio)
library(leaflet)

sound_stops <- all_stops %>% 
  filter(agency == "Sound Transit")
community_stops <- all_stops %>% 
  filter(agency == "Community Transit")
metro_stops <- all_stops %>% 
  filter(agency == "Metro Transit")
all_stops <- read.csv("./data/bus_stops_data.csv")
choices <- c(all_stops, community_stops, metro_stops, sound_stops)
topoData <- geojsonio::geojson_read("./data/geojson/neighborhoods.geojson",
                                    what = "sp")
agencycolor <- colorFactor(c("#00ffb3", "#ff4c00", "#1300ff"), all_stops$agency)
leaflet(topoData) %>%
  setView(-122.3035, 47.6553, zoom = 13) %>%
  addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
           attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
                    <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
                    <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
  addPolygons(stroke = TRUE, smoothFactor = 0.1, fillOpacity = 0,
              popup = paste0(topoData$name, ", ", topoData$city), color = "white", 
              weight = 1, opacity = 0.5) %>% 
  addCircles(data = all_stops, ~lon, ~lat, popup = paste0(all_stops$agency, ", ", 
                                                          all_stops$route_id), 
             weight = 10, radius = 100, color = ~agencycolor(agency), 
             stroke = FALSE, fillOpacity = 1.0) %>%
  addLegend("bottomright", pal = agencycolor, values = ~all_stops$agency,
            title = "Transit Agency",
            opacity = 0.8, data = all_stops)
 
