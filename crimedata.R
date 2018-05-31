library(jsonlite)
library(knitr)
library(dplyr)
library(httr)
library(leaflet)
library(maps)

bus_stops <- read.csv("./data/bus_stops_data.csv", stringsAsFactors = FALSE)
crime_data <- read.csv("./data/police_report_data.csv",
                       stringsAsFactors = FALSE)
crime_data <- select(crime_data, Offense.Type,
                     Date.Reported, Month, Year, Longitude,
                     Latitude)
names(crime_data) <- c("Offense Type","Date Reported",
                      "Month", "Year", "Longitude", "Latitude")
crime_data <- filter(crime_data, Year == "2018") %>%
  filter( Month > "2")
color <- colorFactor("Reds", crime_data$Month)
crime_map <- leaflet(crime_data) %>% setView(lng = -122.3312, lat = 47.62199, zoom = 10) %>%
  addTiles() %>%
  addCircles(
    ~Longitude,
    ~Latitude,
    popup = paste0("Date Reported: ",
                   crime_data$`Date Reported`),
    color = ~color(crime_data$Month)
  ) %>%
  addCircles(
    data = bus_stops, ~lon, ~lat,
    popup = paste0(bus_stops$route_id),
    color = "Blue"
  )
crime_map