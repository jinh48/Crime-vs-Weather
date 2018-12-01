library("RSocrata")
source("keys.R")

df <- read.socrata(
  "https://data.seattle.gov/resource/b3ws-t8sc.json?location_city=seattle",
  app_token = "LohlCfXXXfYI7xjWHo8PBNHhr",
  stringsAsFactors = FALSE
)
