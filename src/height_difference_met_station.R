# Read in GPS-Met data and pre-processes
gpsmet <- read.csv("data/Locations//GPS_Met.csv")
gpsmet <- subset(gpsmet, select=c('Station', 'Lat', 'Lon', 'GPS_Height', 'Met_Height'))
gpsmet$Station <- tolower(gpsmet$Station)

val.aeronet$bigf <- tolower(val.aeronet$bigf)

# Merge with AERONET data
merged.aeronet <- merge(val.aeronet, gpsmet, by.x='bigf', by.y='Station')
# Calculate the height difference
merged.aeronet$height_diff <- merged.aeronet$GPS_Height - merged.aeronet$Met_Height
# Plot and calculate correlation
plot(merged.aeronet$height_diff, merged.aeronet$e_mean, ylab="Mean Error (mm)", xlab="GPS-Met Height Difference (m)", main="GPS-Met Height Effects: AERONET validation")
cor(merged.aeronet$height_diff, merged.aeronet$e_mean)

# Merge with Radiosonde data
merged.radiosonde <- merge(val.radiosonde, gpsmet, by.x='bigf', by.y='Station')
# Calculate the height difference
merged.radiosonde$height_diff <- merged.radiosonde$GPS_Height - merged.radiosonde$Met_Height
# Plot and calculate correlation
plot(merged.radiosonde$height_diff, merged.radiosonde$e_mean, ylab="Mean Error (mm)", xlab="GPS-Met Height Difference (m)", main="GPS-Met Height Effects: Radiosonde validation")
cor(merged.radiosonde$height_diff, merged.radiosonde$e_mean)