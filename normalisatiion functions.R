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
  summarize(global_rev = sum(revenue_eur, na.rm = T)) 

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


################################################ Profit normalisation ##########################################

### Creating global profit margin per company

Company_profs <- Tax_aligned %>%
  group_by(company, year) %>% 
  summarize(comp_rev = sum(revenue_eur, na.rm = T), comp_profit = sum(pbt_eur, na.rm = T))

Company_profs <- mutate(Company_profs, prof_marg = comp_rev / comp_profit)

Company_profs <- Company_profs[prof_marg > 0]



### Creating normalised profits
# This shows how much profit  companies would have earned if profits were earned at the same margin across the world

Normal_prof <- Tax_aligned[, c("company", "country", "year", 
                              "tax_for_the_year_eur", "revenue_eur", "pbt_eur")]

Normal_prof <- merge(Normal_prof, Company_profs, all.x = T, by = c("company", "year"))

Normal_prof <- Normal_prof %>%
  mutate(norm_prof = revenue_eur * prof_marg)

Normal_prof <- Normal_prof[norm_prof > 0] # this removes rows where there is no data


#Tax on normalised profit - effective rate
Normal_prof <- merge(Normal_prof, Efctve_rate, all.x = T, by = c("country", "year"))

Normal_prof <- Normal_prof %>%
  mutate(normal_tax = norm_prof * effective_rate)


#### Tax on normalised profit - real rate
# This uses the real tax rate to tax normalised profit

real_rates <- fread("C:/Users/Admin/Documents/EUI/Corporate-Tax-Rates-Data-1980-2019.csv", sep = ",", 
                    encoding = "UTF-8", integer64= "numeric")

real_rates[is.na(real_rates)] <- 0

real_rates$rate <- as.numeric(real_rates$rate)

Normal_prof <- merge(Normal_prof, real_rates, all.x = T, by = c("country", "year"))

Normal_prof <- Normal_prof %>%
  mutate(normal_real_tax = norm_prof * rate / 100)


######################################### Tax normalisation ######################################################

Normal_tax <-Tax_aligned[, c("company", "country", "year", 
                             "tax_for_the_year_eur", "revenue_eur", "pbt_eur")]

Normal_tax <- merge(Normal_tax, real_rates, all.x = T, by = c("country", "year"))

Normal_tax <- Normal_tax %>%
  mutate(real_tax_eur = pbt_eur * rate / 100)

