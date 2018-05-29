library(jsonlite)
library(httr)
library(knitr)
library(dplyr)
library(ggplot2)
library(ggmap)
library(mapdata)
library(leaflet)

incident_response <- read.csv("./data/police_report_data.csv", 
                              stringsAsFactors = FALSE)

incident_response <- incident_response %>% 
  select(Offense.Type, Summarized.Offense.Description, Date.Reported, Month,
         Year, Longitude, Latitude)

colnames(incident_response) <- c("Offense Type", "Offense Description", 
                                 "Date Reported", "Month", "Year", "Longitude", 
                                 "Latitude")

incident_response$`Date Reported` <- strtrim(incident_response$`Date Reported`, 
                                             10)
incident_response$`Date Reported` <- sub("2018", "18", 
                                         incident_response$`Date Reported`)
incident_response$`Date Reported` <- as.Date(incident_response$`Date Reported`, 
                                             "%m/%d/%y")

incident_response$`Offense Description` <- tolower(incident_response$`Offense Description`)

capFirst <- function(s) {
  paste(toupper(substring(s, 1, 1)), substring(s, 2), sep = "")
}

incident_response$`Offense Description` <- capFirst(incident_response$`Offense Description`)

write.csv(incident_response, "./data/police_report_data.csv")

crimemap <- leaflet(incident_response) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                                       attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, 
                                       <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
                                       <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') 
# sets color palette by agency
crimecolor <- colorFactor("Reds", n = 4,
                           incident_response$`Month`)
# creates map
crimemap %>% 
  # location of map and zoom
  setView(-122.3035, 47.6553, zoom = 12) %>% 
  # adds bus stop, assigns size and color
  addCircles(~`Longitude`, 
             ~`Latitude`, 
             popup = paste0(incident_response$`Offense Description`, 
                            ", reported: ",         
                            incident_response$`Date Reported`), 
             weight = 10, radius = 50, color = ~crimecolor(`Month`), 
             stroke = FALSE, fillOpacity = 1.0) %>% 
  # adds legend for point color
  addLegend("bottomright", pal = crimecolor, values = ~incident_response$Month,
            title = "Month of Report",
            opacity = 0.8
  ) #%>% 
  # adds bus routes
  #addCircles(data = all_stops, ~lon, ~lat, popup = paste0(all_stops$agency, ", ", 
  #                                      all_stops$route_id), 
  #           weight = 10, radius = 50, color = "#5dff00", 
  #           stroke = FALSE, fillOpacity = 0.8)

