library('dplyr')
library('ggmap')
library('ggplot2')
library('shiny')
library('leaflet')
library('RMySQL')

# get data from DB
# conn <- dbConnect(
#   drv = RMySQL::MySQL(),
#   dbname = "paycial",
#   host = "paycial.cwirrisfr2wu.us-east-1.rds.amazonaws.com",
#   user = "yws08",
#   password = "PAYwon08!"
# )
#location = dbGetQuery(conn, "SELECT * FROM paycial.LOCATION_LOG WHERE LATITUDE != 0 AND LONGITUDE != 0;")

#dbDisconnect(conn)

location <- read.csv("location.csv")

seoulLonLat = unlist(geocode('seoul', source = 'google'))
#seoulmap = qmap(seoulLonLat, zoom = 11, source = 'stamen', maptype = 'toner-lite')
#plotLocation = ggplot(data = location, aes(x = LATITUDE, y = LONGITUDE))

# 전체 데이터
dataNoZLoc = filter(location, LONGITUDE != 0, LATITUDE != 0) %>%
  select(LONGITUDE, LATITUDE, API_TYPE, REG_ID, REG_DT) %>%
  mutate(DATE = as.Date(REG_DT))

#%>% mutate(REGION = reverseGeoCode(c(dataNoZLoc$LATITUDE, dataNoZLoc$LONGITUDE)))
#lons = as.double(dataNoZLoc$LONGITUDE)
#lats = as.double(dataNoZLoc$LATITUDE)
#temp <- mapply(FUN = function(lon, lat) revgeocode(c(lon, lat)), lons, lats)

# 결제 데이터
dataPayLoc = filter(dataNoZLoc, API_TYPE == 'paygroup/payment') %>%
  select(LONGITUDE, LATITUDE, REG_ID, REG_DT) %>%
  mutate(DATE = as.Date(REG_DT))
# 체크인 데이터
dataCheckLoc = filter(dataNoZLoc, API_TYPE == 'checkIn') %>%
  select(LONGITUDE, LATITUDE, REG_ID, REG_DT) %>%
  mutate(DATE = as.Date(REG_DT))

#seoulmap + geom_point(data = dataCheckLoc, aes(LONGITUDE, LATITUDE), size = 3, colour='#018b4d')
