install.packages("cartogram")
install.packages("maptools")
install.packages("rgeos")

library(cartogram)
library(rgeos)
library(maptools)

############ Getting the right mapping names for the data

data(wrld_simpl)

country_names <- as.data.frame(wrld_simpl$NAME, stringsAsFactors = FALSE)

names(country_names)[names(country_names) == "wrld_simpl$NAME"] <- "country"

country_names$map_country <- country_names

country_names$country <- as.character(country_names$country)

country_names <- rbind(country_names, c("Channel Islands", "Guernsey"))

country_names <- rbind(country_names, c("Others", "Bouvet Island"))


#data_countries <- as.data.frame(unique(Tax_aligned$country)) # this code gets the country names and helps tidy them

#names(data_countries)[names(data_countries) == "unique(Tax_aligned$country)"] <- "country"

#country_list <- merge(country_names, data_countries, all = TRUE)

#wrong_names <- anti_join(country_list, country_names)

Tax_to_map <- merge(Tax_aligned, country_names, by = "country", all.x = TRUE, all.y = FALSE)

Tax_to_map %>%
  


################ Putting 'Others' somewhere sensible


plot(wrld_simpl)


??rgeos
