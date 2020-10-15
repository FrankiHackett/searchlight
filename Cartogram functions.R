install.packages("cartogram")
install.packages("maptools")
install.packages("rgeos")
install.packages("tibble")
install.packages("sf")
install.packages("tidyverse")
install.packages("mapproj")
install.packages("tmap")
install.packages("mosaic")
install.packages("latticeExtra")

library(cartogram)
library(rgeos)
library(maptools)
library(tibble)
library(sf)
library(tidyverse)
library(broom)
library(mapproj)
library(tmap)
library(mosaic)
library(latticeExtra)



####################### Cartogram functions #########################################################
#We need to get a list of countries from the wrld_simpl shapefile database, and combine it with our
#database. This has involved some manual cleanup, as wrld_simpl doesn't necessarily reflect the current
#set of countries in the world, or in the database.

#We then create functions that allow for flexibly creating our relevant values

####################### Getting the right mapping names for the data ##################################

data(wrld_simpl)

country_names <- as.character(wrld_simpl$NAME, stringsAsFactors = FALSE)

country_names <- fread("C:/Users/Admin/Documents/EUI/countries.csv", sep = ",", 
                       encoding = "UTF-8", integer64= "numeric")

Tax_to_map <- merge(Tax_aligned, country_names, by = "country", all.x = TRUE, all.y = FALSE)

names(Tax_to_map)[names(Tax_to_map) == "map_country"] <- "NAME"
  


#####Below deprecated as I have tried to make the map names better... 
 
#country_names <- rbind(country_names, c("Channel Islands", "Guernsey"))

#country_names <- rbind(country_names, c("Others", "Bouvet Island"))




#data_countries <- as.data.frame(unique(Tax_aligned$country)) # this code gets the country names and helps tidy them

#names(data_countries)[names(data_countries) == "unique(Tax_aligned$country)"] <- "country"

#country_list <- merge(country_names, data_countries, all = TRUE)

#wrong_names <- anti_join(country_list, country_names)


########################## Sum by country function ###############################################


 sum_country <- function(dataset, variable){
   variable = enquo(arg = variable)
   
   Tax_summarised <- dataset %>%
     group_by(NAME) %>%
     summarise(sum_variable = sum(!!variable, na.rm = T))
   sum_variable <- merge(dataset, Tax_summarised, by = "NAME", all = T) 
  # names(sum_variable)[names(sum_variable) == "v1"] <- "variable_sum"
   sum_variable <- dplyr::distinct(sum_variable, NAME, sum_variable)
   sum_variable[is.na(sum_variable)] <- 0
   return(sum_variable)
 }

 rev_sum <- sum_country(Tax_to_map, revenue_eur) #example for revenue






######################### Binding to geoshapes and transforming into sf shape ################################
# This needs to be functionalised 


wrld_simpl_tax <- wrld_simpl



wrld_simpl_tax@data <- sp::merge(wrld_simpl_tax@data, rev_sum, by = "NAME", all = TRUE)

ws_tax_no <- st_as_sf(wrld_simpl_tax)
st_crs(ws_tax_no)

tax_coords <- st_transform(ws_tax_no, crs = 4088)
st_crs(tax_coords)

tax_coords[is.na(tax_coords)] <- 10


######################### Mapping ##########################################

##This does not work yet

tax_cart <- cartogram(tax_coords, "sum_variable")

spplot(tax_coords, "sum_variable")
