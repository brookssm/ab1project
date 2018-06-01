library(jsonlite)
library(knitr)
library(dplyr)
library(httr)
library(leaflet)
library(maps)

#Creates csv files for bus stop data and crime data
bus_stops <- read.csv("./data/bus_stops_data.csv", stringsAsFactors=FALSE, fileEncoding="latin1")
crime_data <- read.csv("./data/police_report_data.csv"
                       , stringsAsFactors=FALSE, fileEncoding="latin1")

#Creates a data frame selecting crime data that will be used for a map
crime_map_data <- select(crime_data, Offense.Type, Offense.Description,
                     Date.Reported, Month, Year, Longitude,
                     Latitude)
#Filters the selected crime data
crime_map_data <- filter(crime_data, Year == "2018") %>%
  filter( Month > "2")

#Creates a data frame selecting crime data that will be used for a table
crime_table_data <- select(crime_data, Offense.Description,
                         Month, Year, Longitude,
                         Latitude)
#Filters the selected crime data
crime_table_data <- filter(crime_table_data, Year == "2018") %>%
  filter( Month > "2")