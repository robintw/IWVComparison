temp <- read.csv("data/TEMP_Messages_Converted.csv")
abep <- mlist.radiosonde$ABEP

# Subset down to the relevant WMO ID
sub <- temp[temp$WMO_ID == 3502,]

# Convert to zoo, remove duplicates, round to nearest hour, and
# make sure it is POSIXct indexed
sub_zoo = zoo(sub, order.by=strptime(sub$timestamp, format="%Y-%m-%d %H:%M:%S"))
sub_zoo <- sub_zoo[!duplicated(index(sub_zoo))]
index(sub_zoo) <- round_date(index(sub_zoo), 'hour')
index(sub_zoo) <- as.POSIXct(index(sub_zoo))

# Merge, and just get the indices where there were ABEP data in the first place
res <- merge(abep, sub_zoo)
subres <- res[index(abep)]
