install.packages("naniar")
install.packages("heatmaply")
install.packages("reshape")
install.packages("plotly")

library(naniar)
library(ggplot2)
library(heatmaply)
library(dplyr)
library(reshape)
library(tidyr)
library(data.table)



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

#Preparing data to go into heatmap - pos v negative

Missing_data$corporation_taxes_original_currency[!is.na(Missing_data$corporation_taxes_original_currency)] <- 1
Missing_data$revenue[!is.na(Missing_data$revenue)] <- 1
Missing_data$pbt[!is.na(Missing_data$pbt)] <- 1
Missing_data$number_of_employees[!is.na(Missing_data$number_of_employees)] <- 1

Missing_data$corporation_taxes_original_currency[is.na(Missing_data$corporation_taxes_original_currency)] <- 0
Missing_data$revenue[is.na(Missing_data$revenue)] <- 0
Missing_data$pbt[is.na(Missing_data$pbt)] <- 0
Missing_data$number_of_employees[is.na(Missing_data$number_of_employees)] <- 0


#Grouping data

Missing_data$company_country <- paste(Missing_data$year, Missing_data$company, Missing_data$country, sep = " - ")

Missing_data$all_data <- paste(Missing_data$corporation_taxes_original_currency, Missing_data$revenue, 
                             Missing_data$pbt, Missing_data$number_of_employees)

Missing_data$company <-NULL
Missing_data$country <-NULL
Missing_data$year <-NULL

Pivot_missing <- gather(Missing_data, key = value_type, value = "value", 
                        corporation_taxes_original_currency, 
                        revenue,
                        pbt,
                        number_of_employees, 
                     #   all_data,
                        na.rm = FALSE)

##Creating filter functions

Missing_2017 <- Pivot_missing[grep("2017", Pivot_missing$company_country),]
Missing_2018 <- Pivot_missing[grep("2018", Pivot_missing$company_country),]
Missing_2019 <- Pivot_missing[grep("2019", Pivot_missing$company_country),]
Missing_2020 <- Pivot_missing[grep("2020", Pivot_missing$company_country),]




#using ggplot2 to build heatmap

ggplot(Pivot_missing, aes(x= value_type, y = company_country,
                         fill = value)) +
  geom_raster() +
  theme(axis.text.x = element_text(
    angle = 90,
    face = 1
  ), legend.position = "none", 
  axis.text.y = element_text(
    size = 2
  )
  ) 
?ggplot2

  