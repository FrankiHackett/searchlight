install.packages("naniar")
install.packages("heatmaply")
install.packages("reshape")

library(naniar)
library(ggplot2)
library(heatmaply)
library(dplyr)
library(reshape)
library(tidyr)



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
Missing_data$company <-NULL
Missing_data$country <-NULL
Missing_data$year <-NULL

Pivot_missing <- gather(Missing_data, key = value_type, value = "value", 
                        corporation_taxes_original_currency, 
                        revenue,
                        pbt,
                        number_of_employees, na.rm = FALSE)



#using ggplot2 to build heatmap

ggplot(Pivot_missing, aes(x= value_type, y = company_country,
                         fill = value)) +
  geom_tile()


x <- LETTERS[1:20]
y <- paste0("var", seq(1,20))
data <- expand.grid(X=x, Y=y)
data$Z <- runif(400, 0, 5)
  