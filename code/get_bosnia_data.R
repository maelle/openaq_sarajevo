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