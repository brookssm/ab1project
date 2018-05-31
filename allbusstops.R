library(jsonlite)
library(httr)
library(dplyr)
library(magrittr)
source("./key.R")

agencies <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.json?key=", key)) %>% 
  content("text") %>% 
  fromJSON() %>% 
  use_series(data) %>% 
  use_series(references) %>% 
  use_series(agencies) %>% 
  select(id, name)

get_route_ids_for_agency <- function(agency_id) {
  Sys.sleep(0.101)
  GET(paste0("http://api.pugetsound.onebusaway.org/api/where/route-ids-for-agency/", 
             agency_id, ".json?key=", key)) %>% 
    content("text") %>% 
    fromJSON() %>% 
    use_series(data) %>% 
    use_series(list)
}

get_stop_ids_for_agency <- function(agency_id) {
  Sys.sleep(0.101)
  GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/", 
             agency_id, ".json?key=", key)) %>% 
    content("text") %>% 
    fromJSON() %>% 
    use_series(data) %>% 
    use_series(list)
}

route_ids <- sapply(agencies$id, get_route_ids_for_agency) %>% 
  unlist(use.names = F)

stop_ids <- sapply(agencies$id, get_stop_ids_for_agency) %>% 
  unlist(use.names = F)

get_stops_for_route <- function(route_id) {
  Sys.sleep(0.101)
  GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/", 
             route_id, ".json?key=", "TEST", "&includePolylines=FALSE")) %>% 
    content("text") %>% 
    fromJSON() %>% 
    use_series(data) %>% 
    use_series(references) %>% 
    use_series(stops) %>% 
    select(-routeIds)
}

get_stop_from_id <- function(stop_id) {
  Sys.sleep(0.150)
  GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stop/", 
             stop_id, ".json?key=", "TEST")) %>% 
    content("text") %>% 
    fromJSON() %>% 
    use_series(data) %>%
    use_series(entry) %>% 
    as.data.frame(stringsAsFactors = F) %>% 
    select(-routeIds)
}

# Neither of these work, too much requesting
# stops <- get_stops_for_route(route_ids[1])
# for(id in route_ids[2:length(route_ids)]) {
#   stops <- rbind(stops, get_stops_for_route(id))
# }
# 
# stops <- get_stop_from_id(stop_ids[1])
# for(id in stop_ids[2:length(stop_ids)]) {
#   stops <- rbind(stops, get_stop_from_id(id))
# }