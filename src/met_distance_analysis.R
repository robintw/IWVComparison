# Examines dependence of RMSE on distance to nearest Met Station

# AERONET sites
plot(met.aeronet$met_distance, met.aeronet$rmse, main="RMSE vs Distance (AERONET comparisons)")
# Correlation result
cor.test(met.aeronet$met_distance, met.aeronet$rmse)

# Radiosonde sites
plot(met.radiosonde$met_distance, met.radiosonde$rmse, main="RMSE vs Distance (Radiosonde comparisons)")
# Correlation result
cor.test(met.radiosonde$met_distance, met.radiosonde$rmse)