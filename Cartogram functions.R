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
library(rgdal)
library(spatialEco)
library(rnaturalearth)



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


 carto_funct <- function(variable, year_val){
   variable = enquo(arg = variable)
   
   Tax_summarised <- Tax_to_map %>%
     group_by(NAME, year) %>%
     summarise(sum_variable = sum(!!variable, na.rm = T))
   sum_variable <- merge(Tax_to_map, Tax_summarised, by = c("NAME", "year"), all = T, allow.cartesian = T) 
   names(sum_variable)[names(sum_variable) == "v1"] <- "variable_sum"
   sum_variable <- dplyr::distinct(sum_variable, NAME, year, sum_variable)
   sum_variable[is.na(sum_variable)] <- 0
   sum_variable <- dplyr::filter(sum_variable, year == year_val)

   world_map <- ne_countries(returnclass = "sf") # Binding to geoshapes and transforming into sf shape ##
 
   world_map = world_map %>% 
    select(sovereignt) %>% 
    filter(sovereignt != "Antarctica") %>% 
    st_transform(world_map, crs = "+proj=cea")

   names(world_map)[names(world_map) == "sovereignt"] <- "NAME"
 
   wrld_simpl_tax <- left_join(world_map, sum_variable, by = "NAME") %>%
   na.omit()
   
 
   tax_cart <- cartogram_cont(wrld_simpl_tax, "sum_variable", 5) # Mapping #
   plot(tax_cart["sum_variable"]) 
   }



# carto_funct(revenue_eur, 2018)

