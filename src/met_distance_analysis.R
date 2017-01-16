# Examines dependence of RMSE on distance to nearest Met Station
gps_met <- read.csv('data/Locations/gps_met.csv')


# AERONET sites
gps_met_aeronet <- gps_met
gps_met_aeronet$station <- toupper(gps_met_aeronet$station)
met.aeronet <- merge(gps_met_aeronet, val.aeronet, by.x = 'station', by.y = 'bigf')
plot(met.aeronet$met_distance, met.aeronet$rmse, main="RMSE vs Distance (AERONET comparisons)")
# Correlation result
cor.test(met.aeronet$met_distance, met.aeronet$rmse)

# Radiosonde sites
met.radiosonde <- merge(gps_met, val.radiosonde, by.x = 'station', by.y = 'bigf')
plot(met.radiosonde$met_distance, met.radiosonde$rmse, main="RMSE vs Distance (Radiosonde comparisons)")
# Correlation result
cor.test(met.radiosonde$met_distance, met.radiosonde$rmse)
