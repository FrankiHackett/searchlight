install.packages("naniar")
install.packages("heatmaply")

library(naniar)
library(ggplot2)
library(heatmaply)
library(dplyr)



#First NA plot
#vis_miss(Tax_aligned)

#Filtering data to get only required columns

Missing_data <- Tax_data

Missing_data$currency <- NULL
Missing_data$year_end_date <- NULL
Missing_data$rate_at_year_end <- NULL
Missing_data$v14 <- NULL
Missing_data$v15 <- NULL
Missing_data$link <- NULL
Missing_data$corporation_taxes_eur <- NULL
Missing_data$pbt_eur <- NULL
Missing_data$revenue_eur <- NULL

#Preparing data to go into heatmap

Missing_data$corporation_taxes_original_currency[!is.na(Missing_data$corporation_taxes_original_currency)] <- 1
Missing_data$revenue[!is.na(Missing_data$revenue)] <- 1
Missing_data$pbt[!is.na(Missing_data$pbt)] <- 1
Missing_data$number_of_employees[!is.na(Missing_data$number_of_employees)] <- 1

Missing_data$corporation_taxes_original_currency[is.na(Missing_data$corporation_taxes_original_currency)] <- 0
Missing_data$revenue[is.na(Missing_data$revenue)] <- 0
Missing_data$pbt[is.na(Missing_data$pbt)] <- 0
Missing_data$number_of_employees[is.na(Missing_data$number_of_employees)] <- 0

#using ggplot2 to build heatmap

ggplot(Missing_data, aes(x= c() y = y))+
  geom_tile()
