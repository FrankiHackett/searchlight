install.packages("cartogram")
install.packages("maptools")
install.packages("rgeos")

library(cartogram)
library(rgeos)
library(maptools)

#Attaching geospacial objects to the world!

data(wrld_simpl)

world_map <- fortify(wrld_simpl, region = "NAME")




## Putting 'Others' somewhere sensible


plot(wrld_simpl)


??rgeos
