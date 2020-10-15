install.packages("cartogram")
install.packages("maptools")
install.packages("rgeos")
install.packages("tibble")

library(cartogram)
library(rgeos)
library(maptools)
library(tibble)

############ Getting the right mapping names for the data

data(wrld_simpl)

country_names <- as.data.frame(wrld_simpl$NAME, stringsAsFactors = FALSE)

names(country_names)[names(country_names) == "wrld_simpl$NAME"] <- "country"

country_names$map_country <- country_names

country_names$country <- as.character(country_names$country)

country_names <- rbind(country_names, c("Channel Islands", "Guernsey"))

country_names <- rbind(country_names, c("Others", "Bouvet Island"))

Tax_to_map <- merge(Tax_aligned, country_names, by = "country", all.x = TRUE, all.y = FALSE)

names(Tax_to_map)[names(Tax_to_map) == "map_country"] <- "NAME"


#data_countries <- as.data.frame(unique(Tax_aligned$country)) # this code gets the country names and helps tidy them

#names(data_countries)[names(data_countries) == "unique(Tax_aligned$country)"] <- "country"

#country_list <- merge(country_names, data_countries, all = TRUE)

#wrong_names <- anti_join(country_list, country_names)


######We need to create summary functions before we can map as each country can have only one data value... :P 


 sum_country <- function(variable){
   Tax_summarised <- Tax_to_map[, sum(Tax_to_map[, ..variable], na.rm = T), by = NAME]
   sum_variable <- merge(Tax_to_map, Tax_summarised, by = "NAME", all = T) 
   names(sum_variable)[names(sum_variable) == "v1"] <- "variable_sum"
   return(sum_variable)
 }


str(Tax_tbl)

 #####CANNOT GET THE FUNCTION TO WORK. Gives me total sum after first run

rev_sum <- sum_country(revenue)
Tax_summarised <- Tax_to_map[, sum(Tax_to_map$revenue, na.rm = T), by = NAME]
ungroup(Tax_to_map)

########## Binding to geoshapes

names(Tax_to_map)[names(Tax_to_map) == "map_country"] <- "NAME"

wrld_simpl_tax <- wrld_simpl

wrld_simpl_tax@data <- merge(wrld_simpl_tax@data, Tax_to_map, by = "NAME", all = TRUE)



###### Mapping

str(wrld_simpl)

cartogram(wrld_simpl_tax, 'revenue')


??rgeos
