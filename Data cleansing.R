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
                     header = T, encoding = "UTF-8", integer64= "numeric")


str(Tax_data)


Tax_data <- Tax_data %>%
  clean_names()

Tax_data$revenue <- as.numeric(Tax_data$revenue)

Tax_data$year_end_date <- as.Date(Tax_data$year_end_date, format = "%d/%m/%Y")

Tax_next_year <- Tax_data[, .(company, country, year, corporation_taxes_eur)]

Tax_next_year$tax_year <- Tax_next_year$year - 1

Tax_next_year$year <- NULL

names(Tax_next_year)[names(Tax_next_year) == "tax_year"] <- "year"

names(Tax_next_year)[names(Tax_next_year) == "corporation_taxes_eur"] <- "tax_for_the_year_eur"


Tax_aligned <- merge(Tax_data, Tax_next_year, on = c("company", "country", "year"), all = TRUE)
