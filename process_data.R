library("RSocrata")
source("keys.R")

df <- read.socrata(
  "https://data.seattle.gov/resource/b3ws-t8sc.json",
  app_token = "LohlCfXXXfYI7xjWHo8PBNHhr",
  stringsAsFactors = FALSE
)
