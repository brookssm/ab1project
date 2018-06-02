library(dplyr)
all_bus_stops <- read.csv("./data/puget sound gtfs/stops.txt", stringsAsFactors = F, fileEncoding = "latin1") %>% 
  setNames(gsub("stop_", "", colnames(.))) %>% 
  select(id, name, lat, lon)

all_bus_agencies <- read.csv("./data/puget sound gtfs/agency.txt", stringsAsFactors = F, fileEncoding = "latin1")