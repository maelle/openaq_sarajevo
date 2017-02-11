
count <- aq_measurements(city = "Coyhaique",
                         parameter = "pm25")
count <- attr(count, "meta")$found

coyhaique <- 1:(ceiling(count/10000)) %>%
  map(function(page){
    aq_measurements(city = "Coyhaique",
                    parameter = "pm25",
                    limit = 10000,
                    page = page)
  }) %>%
  bind_rows()



count <- aq_measurements(location = "US+Diplomatic+Post%3A+Ulaanbaatar",
                         parameter = "pm25")
count <- attr(count, "meta")$found

ulaanbaatar <- 1:(ceiling(count/10000)) %>%
  map(function(page){
    aq_measurements(location = "US+Diplomatic+Post%3A+Ulaanbaatar",
                    parameter = "pm25",
                    limit = 10000,
                    page = page)
  }) %>%
  bind_rows()

cities <- bind_rows(coyhaique, ulaanbaatar)
cities <- group_by(cities, location, day = as.Date(dateLocal))
cities <- summarize(cities, pm25 = mean(value))
save(cities, file = "data/cities.RData")
