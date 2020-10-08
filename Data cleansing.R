library(data.table)
library(ggplot2)
library(dplyr)
library(leaflet)
library(janitor)
library(ggmap)
library(tidyr)
library(bit64)
options(scipen = 999)

##Read in preserving special characters, then clean names

Tax_data <- fread("C:/Users/Admin/Documents/EUI/Tax paid.csv", sep = ",", 
                     header = T, encoding = "UTF-8", na.strings = "n.a.")


str(Tax_data)


Tax_data <- Tax_data %>%
  clean_names()

Tax_data$year_end_date <- as.Date(Tax_data$year_end_date, format = "%d/%m/%Y")
