library(naniar)
library(reshape)
library(data.table)
library(plotly)



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

Missing_data <- Missing_data %>%
  mutate(all_data = (corporation_taxes_original_currency * revenue) 
                             * (pbt * number_of_employees))

Missing_data$company <-NULL
Missing_data$country <-NULL
Missing_data$year <-NULL

Pivot_missing <- gather(Missing_data, key = value_type, value = "value", 
                        corporation_taxes_original_currency, 
                        revenue,
                        pbt,
                        number_of_employees, 
                        all_data,
                        na.rm = FALSE)




##Creating filter and plot function 


missingPlot <- function(value){
  Filtered_missing <- Pivot_missing[grep(value, Pivot_missing$company_country),]
  missing_plot <- ggplot(Filtered_missing, aes(x= value_type, y = company_country)) +
     geom_tile(aes(height = 1, 
                   fill = value)) 
     theme(axis.text.x = element_text(
        face = 1
     ), legend.position = "none", 
     axis.text.y = element_text(
       size = 10 
         
     )
    )
  return(missing_plot)
  }

missingPlot("China")


names(Tax_to_map)
  