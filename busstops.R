library(jsonlite)
library(httr)
library(knitr)
library(dplyr)
library(ggplot2)
library(ggmap)
library(mapdata)
source("./key.R")

agencies <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.json?", key))
agencies <- content(agencies, "text")
agencies <- fromJSON(agencies)
agencies <- data.frame(agencies$data$references$agencies)

metro_routes <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/routes-for-agency/1.json?", key))
metro_routes <- content(metro_routes, "text")
metro_routes <- fromJSON(metro_routes)
metro_routes <- data.frame(metro_routes$data$list, stringsAsFactors = FALSE)

response_70 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100264.json?", key, "&version=2"))
body_70 <- content(response_70, "text")
parsed_body_70 <- fromJSON(body_70)
routes_70 <- data.frame(parsed_body_70$data$references$stops, stringsAsFactors = FALSE)
rm(body_70, parsed_body_70, response_70)
routes_70$route_id <- 70
routes_70 <- routes_70 %>% 
  select(lat, lon, route_id)

response_31 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100184.json?", key, "&version=2"))
body_31 <- content(response_31, "text")
parsed_body_31 <- fromJSON(body_31)
routes_31 <- data.frame(parsed_body_31$data$references$stops, stringsAsFactors = FALSE)
rm(body_31, parsed_body_31, response_31)
routes_31$route_id <- 31
routes_31 <- routes_31 %>% 
  select(lat, lon, route_id)

response_32 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100193.json?", key, "&version=2"))
body_32 <- content(response_32, "text")
parsed_body_32 <- fromJSON(body_32)
routes_32 <- data.frame(parsed_body_32$data$references$stops, stringsAsFactors = FALSE)
rm(body_32, parsed_body_32, response_32)
routes_32$route_id <- 32
routes_32 <- routes_32 %>% 
  select(lat, lon, route_id)

response_43 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100223.json?", key, "&version=2"))
body_43 <- content(response_43, "text")
parsed_body_43 <- fromJSON(body_43)
routes_43 <- data.frame(parsed_body_43$data$references$stops, stringsAsFactors = FALSE)
rm(body_43, parsed_body_43, response_43)
routes_43$route_id <- 43
routes_43 <- routes_43 %>% 
  select(lat, lon, route_id)

response_44 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100224.json?", key, "&version=2"))
body_44 <- content(response_44, "text")
parsed_body_44 <- fromJSON(body_44)
routes_44 <- data.frame(parsed_body_44$data$references$stops, stringsAsFactors = FALSE)
rm(body_44, parsed_body_44, response_44)
routes_44$route_id <- 44
routes_44 <- routes_44 %>% 
  select(lat, lon, route_id)

response_45 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100225.json?", key, "&version=2"))
body_45 <- content(response_45, "text")
parsed_body_45 <- fromJSON(body_45)
routes_45 <- data.frame(parsed_body_45$data$references$stops, stringsAsFactors = FALSE)
rm(body_45, parsed_body_45, response_45)
routes_45$route_id <- 45
routes_45 <- routes_45 %>% 
  select(lat, lon, route_id)

response_48 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100228.json?", key, "&version=2"))
body_48 <- content(response_48, "text")
parsed_body_48 <- fromJSON(body_48)
routes_48 <- data.frame(parsed_body_48$data$references$stops, stringsAsFactors = FALSE)
rm(body_48, parsed_body_48, response_48)
routes_48$route_id <- 48
routes_48 <- routes_48 %>% 
  select(lat, lon, route_id)

response_49 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100447.json?", key, "&version=2"))
body_49 <- content(response_49, "text")
parsed_body_49 <- fromJSON(body_49)
routes_49 <- data.frame(parsed_body_49$data$references$stops, stringsAsFactors = FALSE)
rm(body_49, parsed_body_49, response_49)
routes_49$route_id <- 49
routes_49 <- routes_49 %>% 
  select(lat, lon, route_id)

response_63 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_102639.json?", key, "&version=2"))
body_63 <- content(response_63, "text")
parsed_body_63 <- fromJSON(body_63)
routes_63 <- data.frame(parsed_body_63$data$references$stops, stringsAsFactors = FALSE)
rm(body_63, parsed_body_63, response_63)
routes_63$route_id <- 63
routes_63 <- routes_63 %>% 
  select(lat, lon, route_id)

response_64 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100253.json?", key, "&version=2"))
body_64 <- content(response_64, "text")
parsed_body_64 <- fromJSON(body_64)
routes_64 <- data.frame(parsed_body_64$data$references$stops, stringsAsFactors = FALSE)
rm(body_64, parsed_body_64, response_64)
routes_64$route_id <- 64
routes_64 <- routes_64 %>% 
  select(lat, lon, route_id)

response_65 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100254.json?", key, "&version=2"))
body_65 <- content(response_65, "text")
parsed_body_65 <- fromJSON(body_65)
routes_65 <- data.frame(parsed_body_65$data$references$stops, stringsAsFactors = FALSE)
rm(body_65, parsed_body_65, response_65)
routes_65$route_id <- 65
routes_65 <- routes_65 %>% 
  select(lat, lon, route_id)

response_67 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100259.json?", key, "&version=2"))
body_67 <- content(response_67, "text")
parsed_body_67 <- fromJSON(body_67)
routes_67 <- data.frame(parsed_body_67$data$references$stops, stringsAsFactors = FALSE)
rm(body_67, parsed_body_67, response_67)
routes_67$route_id <- 67
routes_67 <- routes_67 %>% 
  select(lat, lon, route_id)

response_71 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100265.json?", key, "&version=2"))
body_71 <- content(response_71, "text")
parsed_body_71 <- fromJSON(body_71)
routes_71 <- data.frame(parsed_body_71$data$references$stops, stringsAsFactors = FALSE)
rm(body_71, parsed_body_71, response_71)
routes_71$route_id <- 71
routes_71 <- routes_71 %>% 
  select(lat, lon, route_id)

response_73 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100267.json?", key, "&version=2"))
body_73 <- content(response_73, "text")
parsed_body_73 <- fromJSON(body_73)
routes_73 <- data.frame(parsed_body_73$data$references$stops, stringsAsFactors = FALSE)
rm(body_73, parsed_body_73, response_73)
routes_73$route_id <- 73
routes_73 <- routes_73 %>% 
  select(lat, lon, route_id)

response_74 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100268.json?", key, "&version=2"))
body_74 <- content(response_74, "text")
parsed_body_74 <- fromJSON(body_74)
routes_74 <- data.frame(parsed_body_74$data$references$stops, stringsAsFactors = FALSE)
rm(body_74, parsed_body_74, response_74)
routes_74$route_id <- 74
routes_74 <- routes_74 %>% 
  select(lat, lon, route_id)

response_75 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100269.json?", key, "&version=2"))
body_75 <- content(response_75, "text")
parsed_body_75 <- fromJSON(body_75)
routes_75 <- data.frame(parsed_body_75$data$references$stops, stringsAsFactors = FALSE)
rm(body_75, parsed_body_75, response_75)
routes_75$route_id <- 75
routes_75 <- routes_75 %>% 
  select(lat, lon, route_id)

response_78 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100273.json?", key, "&version=2"))
body_78 <- content(response_78, "text")
parsed_body_78 <- fromJSON(body_78)
routes_78 <- data.frame(parsed_body_78$data$references$stops, stringsAsFactors = FALSE)
rm(body_78, parsed_body_78, response_78)
routes_78$route_id <- 78
routes_78 <- routes_78 %>% 
  select(lat, lon, route_id)

response_167 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100059.json?", key, "&version=2"))
body_167 <- content(response_167, "text")
parsed_body_167 <- fromJSON(body_167)
routes_167 <- data.frame(parsed_body_167$data$references$stops, stringsAsFactors = FALSE)
rm(body_167, parsed_body_167, response_167)
routes_167$route_id <- 167
routes_167 <- routes_167 %>% 
  select(lat, lon, route_id)

response_197 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100088.json?", key, "&version=2"))
body_197 <- content(response_197, "text")
parsed_body_197 <- fromJSON(body_197)
routes_197 <- data.frame(parsed_body_197$data$references$stops, stringsAsFactors = FALSE)
rm(body_197, parsed_body_197, response_197)
routes_197$route_id <- 197
routes_197 <- routes_197 %>% 
  select(lat, lon, route_id)

response_271 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100162.json?", key, "&version=2"))
body_271 <- content(response_271, "text")
parsed_body_271 <- fromJSON(body_271)
routes_271 <- data.frame(parsed_body_271$data$references$stops, stringsAsFactors = FALSE)
rm(body_271, parsed_body_271, response_271)
routes_271$route_id <- 271
routes_271 <- routes_271 %>% 
  select(lat, lon, route_id)

response_277 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100168.json?", key, "&version=2"))
body_277 <- content(response_277, "text")
parsed_body_277 <- fromJSON(body_277)
routes_277 <- data.frame(parsed_body_277$data$references$stops, stringsAsFactors = FALSE)
rm(body_277, parsed_body_277, response_277)
routes_277$route_id <- 277
routes_277 <- routes_277 %>% 
  select(lat, lon, route_id)

response_372 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100214.json?", key, "&version=2"))
body_372 <- content(response_372, "text")
parsed_body_372 <- fromJSON(body_372)
routes_372 <- data.frame(parsed_body_372$data$references$stops, stringsAsFactors = FALSE)
rm(body_372, parsed_body_372, response_372)
routes_372$route_id <- 372
routes_372 <- routes_372 %>% 
  select(lat, lon, route_id)

response_373 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100215.json?", key, "&version=2"))
body_373 <- content(response_373, "text")
parsed_body_373 <- fromJSON(body_373)
routes_373 <- data.frame(parsed_body_373$data$references$stops, stringsAsFactors = FALSE)
rm(body_373, parsed_body_373, response_373)
routes_373$route_id <- 373
routes_373 <- routes_373 %>% 
  select(lat, lon, route_id)

response_312 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100187.json?", key, "&version=2"))
body_312 <- content(response_312, "text")
parsed_body_312 <- fromJSON(body_312)
routes_312 <- data.frame(parsed_body_312$data$references$stops, stringsAsFactors = FALSE)
rm(body_312, parsed_body_312, response_312)
routes_312$route_id <- 312
routes_312 <- routes_312 %>% 
  select(lat, lon, route_id)

response_931 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_102558.json?", key, "&version=2"))
body_931 <- content(response_931, "text")
parsed_body_931 <- fromJSON(body_931)
routes_931 <- data.frame(parsed_body_931$data$references$stops, stringsAsFactors = FALSE)
rm(body_931, parsed_body_931, response_931)
routes_931$route_id <- 931
routes_931 <- routes_931 %>% 
  select(lat, lon, route_id)

response_238 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/1_100130.json?", key, "&version=2"))
body_238 <- content(response_238, "text")
parsed_body_238 <- fromJSON(body_238)
routes_238 <- data.frame(parsed_body_238$data$references$stops, stringsAsFactors = FALSE)
rm(body_238, parsed_body_238, response_238)
routes_238$route_id <- 238
routes_238 <- routes_238 %>% 
  select(lat, lon, route_id)

metro_stops <- rbind(routes_31, routes_32, routes_43, routes_44, routes_45, routes_48,
                      routes_49, routes_63, routes_64, routes_65, routes_67, routes_70,
                      routes_71, routes_73, routes_74, routes_75, routes_78, routes_167, routes_197,
                      routes_271, routes_277, routes_372, routes_373, routes_931, routes_238, routes_312)
                      
metro_stops$agency <- "Metro Transit"

sound_routes <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/routes-for-agency/40.json?", key))
sound_routes <- content(sound_routes, "text")
sound_routes <- fromJSON(sound_routes)
sound_routes <- data.frame(sound_routes$data$list, stringsAsFactors = FALSE)

response_542 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/40_100511.json?", key, "&version=2"))
body_542 <- content(response_542, "text")
parsed_body_542 <- fromJSON(body_542)
routes_542 <- data.frame(parsed_body_542$data$references$stops, stringsAsFactors = FALSE)
rm(body_542, parsed_body_542, response_542)
routes_542$route_id <- 542
routes_542 <- routes_542 %>% 
  select(lat, lon, route_id)

response_540 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/40_100235.json?", key, "&version=2"))
body_540 <- content(response_540, "text")
parsed_body_540 <- fromJSON(body_540)
routes_540 <- data.frame(parsed_body_540$data$references$stops, stringsAsFactors = FALSE)
rm(body_540, parsed_body_540, response_540)
routes_540$route_id <- 540
routes_540 <- routes_540 %>% 
  select(lat, lon, route_id)

response_556 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/40_100451.json?", key, "&version=2"))
body_556 <- content(response_556, "text")
parsed_body_556 <- fromJSON(body_556)
routes_556 <- data.frame(parsed_body_556$data$references$stops, stringsAsFactors = FALSE)
rm(body_556, parsed_body_556, response_556)
routes_556$route_id <- 556
routes_556 <- routes_556 %>% 
  select(lat, lon, route_id)

response_541 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/40_102640.json?", key, "&version=2"))
body_541 <- content(response_541, "text")
parsed_body_541 <- fromJSON(body_541)
routes_541 <- data.frame(parsed_body_541$data$references$stops, stringsAsFactors = FALSE)
rm(body_541, parsed_body_541, response_541)
routes_541$route_id <- 541
routes_541 <- routes_541 %>% 
  select(lat, lon, route_id)

response_586 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/40_586.json?", key, "&version=2"))
body_586 <- content(response_586, "text")
parsed_body_586 <- fromJSON(body_586)
routes_586 <- data.frame(parsed_body_586$data$references$stops, stringsAsFactors = FALSE)
rm(body_586, parsed_body_586, response_586)
routes_586$route_id <- 586
routes_586 <- routes_586 %>% 
  select(lat, lon, route_id)

response_link <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/40_100479.json?", key, "&version=2"))
body_link <- content(response_link, "text")
parsed_body_link <- fromJSON(body_link)
routes_link <- data.frame(parsed_body_link$data$references$stops, stringsAsFactors = FALSE)
rm(body_link, parsed_body_link, response_link)
routes_link$route_id <- "Link light rail"
routes_link <- routes_link %>% 
  select(lat, lon, route_id)

sound_stops <- rbind(routes_540, routes_541, routes_542, routes_556, routes_586, routes_link)
sound_stops$agency <- "Sound Transit"

community_routes <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/routes-for-agency/29.json?", key))
community_routes <- content(community_routes, "text")
community_routes <- fromJSON(community_routes)
community_routes <- data.frame(community_routes$data$list, stringsAsFactors = FALSE)

response_810 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/29_810.json?", key, "&version=2"))
body_810 <- content(response_810, "text")
parsed_body_810 <- fromJSON(body_810)
routes_810 <- data.frame(parsed_body_810$data$references$stops, stringsAsFactors = FALSE)
rm(body_810, parsed_body_810, response_810)
routes_810$route_id <- "810"
routes_810 <- routes_810 %>% 
  select(lat, lon, route_id)

response_821 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/29_821.json?", key, "&version=2"))
body_821 <- content(response_821, "text")
parsed_body_821 <- fromJSON(body_821)
routes_821 <- data.frame(parsed_body_821$data$references$stops, stringsAsFactors = FALSE)
rm(body_821, parsed_body_821, response_821)
routes_821$route_id <- "821"
routes_821 <- routes_821 %>% 
  select(lat, lon, route_id)

response_855 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/29_855.json?", key, "&version=2"))
body_855 <- content(response_855, "text")
parsed_body_855 <- fromJSON(body_855)
routes_855 <- data.frame(parsed_body_855$data$references$stops, stringsAsFactors = FALSE)
rm(body_855, parsed_body_855, response_855)
routes_855$route_id <- "855"
routes_855 <- routes_855 %>% 
  select(lat, lon, route_id)

response_860 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/29_860.json?", key, "&version=2"))
body_860 <- content(response_860, "text")
parsed_body_860 <- fromJSON(body_860)
routes_860 <- data.frame(parsed_body_860$data$references$stops, stringsAsFactors = FALSE)
rm(body_860, parsed_body_860, response_860)
routes_860$route_id <- "860"
routes_860 <- routes_860 %>% 
  select(lat, lon, route_id)

response_871 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/29_871.json?", key, "&version=2"))
body_871 <- content(response_871, "text")
parsed_body_871 <- fromJSON(body_871)
routes_871 <- data.frame(parsed_body_871$data$references$stops, stringsAsFactors = FALSE)
rm(body_871, parsed_body_871, response_871)
routes_871$route_id <- "871"
routes_871 <- routes_871 %>% 
  select(lat, lon, route_id)

response_880 <- GET(paste0("http://api.pugetsound.onebusaway.org/api/where/stops-for-route/29_880.json?", key, "&version=2"))
body_880 <- content(response_880, "text")
parsed_body_880 <- fromJSON(body_880)
routes_880 <- data.frame(parsed_body_880$data$references$stops, stringsAsFactors = FALSE)
rm(body_880, parsed_body_880, response_880)
routes_880$route_id <- "880"
routes_880 <- routes_880 %>% 
  select(lat, lon, route_id)

community_stops <- rbind(routes_810, routes_821, routes_855, routes_860, routes_871,
                         routes_880)
community_stops$agency <- "Community Transit"

rm(routes_31, routes_32, routes_43, routes_44, routes_45, routes_48,
   routes_49, routes_63, routes_64, routes_65, routes_67, routes_70,
   routes_71, routes_73, routes_74, routes_75, routes_78, routes_167, routes_197, 
   routes_271, routes_277, routes_372, routes_373, routes_540, routes_541, 
   routes_542, routes_556, routes_586, routes_link, routes_810, routes_821, routes_855, 
   routes_860, routes_871, routes_880, routes_931, routes_312, routes_238)

all_stops <- rbind(metro_stops,sound_stops,community_stops)
all_stops$route_id <- paste("Route", all_stops$route_id)
all_stops$route_id[all_stops$route_id == "Route Link light rail"] <- "Link light rail"
#write.csv(all_stops, file = "./data/bus_stops_data.csv")

