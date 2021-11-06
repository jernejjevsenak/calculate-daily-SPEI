# All credits go to authors of SPEI R package
# https://cran.r-project.org/web/packages/SPEI/index.html

# Open libraries
library("lubridate")
library("SPEI")
library("lmom")
library("zoo")

# source both functions needed later
source("HargreavesPET_daily.R")
source("SPEI_daily.R")

# Open climate data
Tavg <- read.table("Tavg.csv", sep = ",", header = TRUE)
Tmax <- read.table("Tmax.csv", sep = ",", header = TRUE)
Tmin <- read.table("Tmin.csv", sep = ",", header = TRUE)
Prec <- read.table("Prec.csv", sep = ",", header = TRUE)

# Combine variables
climate <- cbind(Tavg, 
                 Tmax = Tmax[,"Tmax"], 
                 Tmin = Tmin[,"Tmin"], 
                 Prec = Prec[,"Prec"])

# Calculate difference between Tmax and Tmin
climate$T_diff <- climate$Tmax - climate$Tmin

# In some rare cases Tmin is greater than Tmax. In such cases, T_diff is set to 0
climate$T_diff = ifelse(climate$T_diff < 0, 0, climate$T_diff)

# Add latitude
climate$lat <- 15.51

# Calculate potential evapotranspiration using the Hargreaves method
climate$PET = HargreavesPET_daily(date = climate$date, tavg = climate$Tmean,
                          tdif = climate$T_diff, lat = climate$lat)

# Calculate water balance, i.e. difference between Precipitation and PET
climate$WB <- climate$Prec - climate$PET

# Update SPEI for each day based on the selected scale
climate_withSPEI <- SPEI_daily(input = climate, scale = 45)
plot(climate_withSPEI$SPEI_45, type = "l")

climate_withSPEI <- SPEI_daily(input = climate, scale = 300)
plot(climate_withSPEI$SPEI_300, type = "l")

climate_withSPEI <- SPEI_daily(input = climate, scale = 732)
plot(climate_withSPEI$SPEI_732, type = "l")
