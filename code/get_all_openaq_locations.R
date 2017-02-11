library("ropenaq")
library("dplyr")
pagee <- 1
dataGeo <- NULL
nrows <- 10000
while(nrows == 10000){
  temp <- aq_locations(page = pagee,
                       limit = 10000)
  nrows <- nrow(temp)
  pagee <- pagee + 1
  dataGeo <- dplyr::bind_rows(dataGeo, temp)
}
dataGeo <- filter(dataGeo, location != "Test Prueba", location != "PA")
save(dataGeo, file = "data/openaq_locations.RData")