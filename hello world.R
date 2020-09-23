library(data.table)
library(ggplot2)
library(dplyr)
library(leaflet)
library(janitor)
library(ggmap)
library(tidyr)

install.packages("janitor")
install.packages("leaflet")
install.packages("ggmap")


##Read in preserving special characters, then clean names

SCR_siberco <- fread("C:/Users/Admin/Documents/EUI/Base mining data/SCR_SIBELCO.csv", sep = ",", 
                     header = T, encoding = "UTF-8", na.strings = "n.a.")
SCR_siberco$V1 <- NULL

str(SCR_siberco)


SCR_siberco <- SCR_siberco %>%
  clean_names()

SCR_siberco <- SCR_siberco %>%
  filter(!is.na(p_l_before_tax_eur_last_avail_yr))

Grouped_SCR <- aggregate((SCR_siberco$p_l_before_tax_eur_last_avail_yr), 
                         by = list(SCR_siberco$country_iso_code), FUN = sum)






##Mapping

leaflet(options = leafletOptions(dragging = TRUE)) %>%
  addProviderTiles("Esri") %>%
  setView(lng = 20.316667, lat = 52.9, zoom = 3.5) %>%
  addMarkers()
