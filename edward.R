library("httr")
library("jsonlite")
library("dplyr")
library("censusapi")
source("key.R")
source("key2.R")


#Key is OBA, key2 is US Census

try <- GET(paste0("https://api.census.gov/data/2014/pep/natstprc?get=Alabama,4849377&DATE=7&for=01:*&key=",key2))
try1 <- content(try, as = "text")

body <- fromJSON(try)

write.csv(file = "try.csv", try)
write_json(try, tmp)

stringi::stri_enc_detect(content(try, "raw"))

http_status(try)

Sys.setenv(CENSUS_KEY=key2)
readRenviron("~/.Renviron")
Sys.getenv("CENSUS_KEY")

apis <- listCensusApis()
View(apis)

