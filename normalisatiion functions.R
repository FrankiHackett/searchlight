### Normalisation functions!

### I am going to need to create some ratios here. eg:
# global revenue per person (company)
# profit margin (per company)
# effective rate (per country-company)




################################ Effective tax rates #################################################

Efctve_rev <- Tax_aligned %>% 
  group_by(country, year) %>%
  summarize(country_rev = sum(revenue_eur, na.rm = T))

Efctve_tax <- Tax_aligned %>% 
  group_by(country, year) %>%
  summarize(country_tax = sum(corporation_taxes_eur, na.rm = T))


Efctve_rate <- merge(Efctve_rev, Efctve_tax, all = T)
Efctve_rate <- mutate(Efctve_rate, effective_rate = country_tax/country_rev)

Efctve_rate <- Efctve_rate[effective_rate > 0]


################################ Revenue Normalisation ############################################### 


#### Creating global revenue per person ratio.

Company_revs <- Tax_aligned %>%
  group_by(company, year) %>%
  summarize(global_rev = sum(revenue_eur, na.rm = T)) #for reasons I don't understand, this works...

Company_peeps <- Tax_aligned %>%
  group_by(company, year) %>%
  summarize(global_peeps = sum(number_of_employees, na.rm = T))


Global_rev_pp <- merge(Company_revs, Company_peeps, all = T)
Global_rev_pp <- mutate(Global_rev_pp, rev_pp = global_rev/global_peeps)


#### Normalising Revenue

#This creates a variable which shows what revenue companies would have earned in each 
#country with global revenue averaged per staff member 

Normal_rev <- Tax_aligned[, c("company", "country", "year", 
                              "tax_for_the_year_eur", "revenue_eur", "number_of_employees")]


Normal_rev <- merge(Normal_rev, Global_rev_pp, all.x = T, by = c("company", "year"))

Normal_rev <- Normal_rev %>%
  mutate(norm_rev = rev_pp * number_of_employees)

Normal_rev <- Normal_rev[norm_rev > 0] # this removes rows where there is no data


#### Tax on normalised revenue - effective rate
# This uses the effective tax rate to tax normalised revenue

Normal_rev <- merge(Normal_rev, Efctve_rate, all.x = T, by = c("country", "year"))

Normal_rev <- Normal_rev %>%
  mutate(normal_tax = norm_rev * effective_rate)


#### Tax on normalised revenue - real rate
# This uses the real tax rate to tax normalised revenue

real_rates <- fread("C:/Users/Admin/Documents/EUI/Corporate-Tax-Rates-Data-1980-2019.csv", sep = ",", 
                    encoding = "UTF-8", integer64= "numeric")

real_rates[is.na(real_rates)] <- 0

real_rates$rate <- as.numeric(real_rates$rate)

Normal_rev <- merge(Normal_rev, real_rates, all.x = T, by = c("country", "year"))

Normal_rev <- Normal_rev %>%
  mutate(normal_real_tax = norm_rev * rate / 100)
