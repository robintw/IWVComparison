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
plot(merged.aeronet$height_diff, merged.aeronet$rmse, ylab="Mean Error (mm)", xlab="GPS-Met Height Difference (m)", main="GPS-Met Height Effects: AERONET validation")
cor(merged.aeronet$height_diff, merged.aeronet$rmse)

# Merge with Radiosonde data
merged.radiosonde <- merge(val.radiosonde, gpsmet, by.x='bigf', by.y='Station')
# Calculate the height difference
merged.radiosonde$height_diff <- merged.radiosonde$GPS_Height - merged.radiosonde$Met_Height
# Plot and calculate correlation
plot(merged.radiosonde$height_diff, merged.radiosonde$rmse, ylab="Mean Error (mm)", xlab="GPS-Met Height Difference (m)", main="GPS-Met Height Effects: Radiosonde validation")
cor(merged.radiosonde$height_diff, merged.radiosonde$rmse)


print("Maximum height differences:")
print(max(merged.aeronet$height_diff))
print(max(merged.radiosonde$height_diff))

all_height_diffs <- c(merged.radiosonde$height_diff, merged.aeronet$height_diff)
print("Percentage of heights < 200m")
print(ecdf(abs(all_height_diffs))(200))
