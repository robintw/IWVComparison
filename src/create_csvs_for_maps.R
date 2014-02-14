# Load all of the BIGF sites
uk_sites <- read_locs_file("./data/Locations/coordinates_file.bl06gd07_tts_hourly.bgf")
global_sites <- read_locs_file("./data/Locations/coordinates_file.bl06gd07_tts_hourly.igs")
combined_sites <- rbind(uk_sites, global_sites)
combined_sites$Name <- tolower(combined_sites$Name)

# Merge to create CSV for Radiosonde sites
res <- merge(val.radiosonde, combined_sites, by.x='bigf', by.y='Name')
write.csv(res, 'results/Map_RadiosondeVal.csv')

combined_sites$Name <- toupper(combined_sites$Name)
# Merge to create CSV for AERONET sites
res <- merge(val.aeronet, combined_sites, by.x='bigf', by.y='Name')
write.csv(res, 'results/Map_AERONETVal.csv')