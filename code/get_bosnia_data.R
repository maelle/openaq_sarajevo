library("ropenaq")
library("dplyr")
library("purrr")
library("ggplot2")
library("ggmap")
library("viridis")
library("ggthemes")
library("ggrepel")
count <- aq_measurements(city = "Sarajevo", 
                         country = "BA")
count <- attr(count, "meta")$found

sarajevo <- 1:(ceiling(count/10000)) %>%
  map(function(page){
    aq_measurements(city = "Sarajevo", 
                    country = "BA",
                    limit = 10000,
                    page = page)
  }) %>%
  bind_rows()

readr::write_csv(sarajevo, path = "data/sarajevo.csv")

ggplot(sarajevo) +
  geom_point(aes(dateLocal, value)) +
  facet_grid(parameter ~ location)

daily <- filter(sarajevo, parameter == "pm10") %>%
  group_by(location, longitude, latitude, day = as.Date(dateLocal)) %>%
  summarize(pm10 = mean(value)) %>%
  group_by(day) %>%
  filter(all(!is.na(pm10))) %>%
  ungroup() %>%
  filter(location != "Ivan Sedlo")
  

oneday <- filter(daily, day == lubridate::ymd("2017 02 10"))

sarajevo_map <- get_map(location = "Sarajevo Bosnia",
                        zoom = 12)

map_data <- unique(select(daily, longitude,
                          latitude, location))
ggmap(sarajevo_map) +
  theme_map() +
  geom_point(data = map_data,
             aes(longitude,
                 latitude),
             size = 4) +
  geom_label_repel(data = map_data,
                   aes(longitude,
                       latitude,
                       label = location))


ggplot(daily) +
  geom_line(aes(day, pm10)) +
  facet_grid(location  ~ .) +
  geom_hline(yintercept = 50, col = "red") +
  ylab(expression(paste("PM10 concentration (", mu, "g/",m^3,")"))) + 
  theme(strip.text.y = element_text(angle = 0))