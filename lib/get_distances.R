# Reads a BIGF or IGS locations file and does the correct
# conversions to the longitude values
read_locs_file <- function(filename) {
  # Read the file
  bigf_sites <- read.table(filename)
  names(bigf_sites) <- c('Name', 'Lon_OLD', 'Lat', 'Elevation')
  
  # Convert the weird longitude given in the file to something sensible
  bigf_sites$Lon = bigf_sites$Lon_OLD
  bigf_sites$Lon[bigf_sites$Lon > 180] = -1 * (360 - bigf_sites$Lon[bigf_sites$Lon > 180])
  
  return(bigf_sites)
}

get_matches_df <- function(bigf_sites, other_sites, distance_threshold, is_radiosonde=FALSE) {
  res <- spDists(bigf_sites, other_sites, longlat=T)
  closest.dists <- apply(res, 1, min)
  closest.sites <- apply(res, 1, which.min)
  
  within_thresh.dists <- closest.dists[closest.dists <= distance_threshold]
  within_thresh.other_sites <- closest.sites[closest.dists <= distance_threshold]
  within_thresh.bigf_sites <- which(closest.dists <= distance_threshold)
  
  within_thresh.bigf_names <- bigf_sites[within_thresh.bigf_sites,]$Name
  within_thresh.other_names <- other_sites[within_thresh.other_sites,]$Name
  
  if (is_radiosonde == TRUE)
  {
    within_thresh.src_id <- other_sites[within_thresh.other_sites,]$src_id
    matches <- data.frame(bigf=within_thresh.bigf_names,
                          radiosonde=within_thresh.other_names,
                          dist=within_thresh.dists,
                          src_id=within_thresh.src_id)
    
    return(matches)
  }
  else
  {
    matches <- data.frame(bigf=within_thresh.bigf_names,
                          aeronet=within_thresh.other_names,
                          dist=within_thresh.dists)
    
    return(matches)
  }
  

}

get_aeronet_radiosonde_matches <- function()
{
  # Read the AERONET locations and put into a SpatialPointsDataFrame as above
  aeronet_locs <- read.csv("data/Locations//aeronet_locations.txt", skip=1, col.names=c('Name', 'Lon', 'Lat', 'Elevation'))
  aeronet_sites <- SpatialPointsDataFrame(aeronet_locs[c('Lon', 'Lat')], aeronet_locs['Name'], proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Read the Radiosonde site locations
  ## Steps to get into a form that we can read here:
  ## 1. Convert to KMZ to KML file
  ### unzip midas_stations_by_message_type.kmz
  ## 2. Convert KML to CSV for the two radiosonde messages types: UAPLT and UATEMP
  ### ogr2ogr -f CSV UAPLT.csv midas_stations_by_message_type.kml -sql "select * from UAPLT" -lco GEOMETRY=AS_XY
  ### ogr2ogr -f CSV UATMP.csv midas_stations_by_message_type.kml -sql "select * from UATEMP" -lco GEOMETRY=AS_XY
  uaplt_locs <- read.csv("data/Locations/UAPLT.csv")
  uatmp_locs <- read.csv("data/Locations/UATMP.csv")
  radiosonde_locs <- rbind(uaplt_locs, uatmp_locs)
  radiosonde_locs$src_id <- str_trim(str_match(radiosonde_locs$Description, "src_id:</b><td>(.+?)<tr>"))[,2]
  radiosonde_locs$Name <- str_trim(str_match(radiosonde_locs$Description, "Name:</b><td>(.+?)<tr>"))[,2]
  radiosonde_locs <- subset(radiosonde_locs, select= -Description)
  
  radiosonde_sites <- SpatialPointsDataFrame(radiosonde_locs[c('X', 'Y')], radiosonde_locs[c('Name', 'src_id')], proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Get BIGF and AERONET sites within 25km of each other
  
  matches.aeronet.radiosonde <- get_matches_df(aeronet_sites, radiosonde_sites, 25, is_radiosonde=TRUE)
  names(matches.aeronet.radiosonde) <- c('aeronet', 'radiosonde', 'dist', 'src_id')
  return(matches.aeronet.radiosonde)
}

get_aeronet_matches <- function()
{
  # Read the lists of UK and Global BIGF site locations and combine them
  uk_sites <- read_locs_file("./data/Locations/coordinates_file.bl06gd07_tts_hourly.bgf")
  global_sites <- read_locs_file("./data/Locations/coordinates_file.bl06gd07_tts_hourly.igs")
  
  combined_sites <- rbind(uk_sites, global_sites)
  
  # Put into a SpatialPointsDataFrame with the location + the name
  bigf_sites <- SpatialPointsDataFrame(combined_sites[c('Lon', 'Lat')], combined_sites['Name'], proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Read the AERONET locations and put into a SpatialPointsDataFrame as above
  aeronet_locs <- read.csv("data/Locations//aeronet_locations.txt", skip=1, col.names=c('Name', 'Lon', 'Lat', 'Elevation'))
  aeronet_sites <- SpatialPointsDataFrame(aeronet_locs[c('Lon', 'Lat')], aeronet_locs['Name'], proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  matches.bigf.aeronet <- get_matches_df(bigf_sites, aeronet_sites, 25)
  
  return(matches.bigf.aeronet)
}

get_radiosonde_matches <- function()
{
  # Read the lists of UK and Global BIGF site locations and combine them
  uk_sites <- read_locs_file("./data/Locations/coordinates_file.bl06gd07_tts_hourly.bgf")
  global_sites <- read_locs_file("./data/Locations/coordinates_file.bl06gd07_tts_hourly.igs")
  
  combined_sites <- rbind(uk_sites, global_sites)
  
  # Put into a SpatialPointsDataFrame with the location + the name
  bigf_sites <- SpatialPointsDataFrame(combined_sites[c('Lon', 'Lat')], combined_sites['Name'], proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  
  # Read the Radiosonde site locations
  ## Steps to get into a form that we can read here:
  ## 1. Convert to KMZ to KML file
  ### unzip midas_stations_by_message_type.kmz
  ## 2. Convert KML to CSV for the two radiosonde messages types: UAPLT and UATEMP
  ### ogr2ogr -f CSV UAPLT.csv midas_stations_by_message_type.kml -sql "select * from UAPLT" -lco GEOMETRY=AS_XY
  ### ogr2ogr -f CSV UATMP.csv midas_stations_by_message_type.kml -sql "select * from UATEMP" -lco GEOMETRY=AS_XY
  uaplt_locs <- read.csv("data/Locations/UAPLT.csv")
  uatmp_locs <- read.csv("data/Locations/UATMP.csv")
  radiosonde_locs <- rbind(uaplt_locs, uatmp_locs)
  radiosonde_locs$src_id <- str_trim(str_match(radiosonde_locs$Description, "src_id:</b><td>(.+?)<tr>"))[,2]
  radiosonde_locs$Name <- str_trim(str_match(radiosonde_locs$Description, "Name:</b><td>(.+?)<tr>"))[,2]
  radiosonde_locs <- subset(radiosonde_locs, select= -Description)
  
  radiosonde_sites <- SpatialPointsDataFrame(radiosonde_locs[c('X', 'Y')], radiosonde_locs[c('Name', 'src_id')], proj4string=CRS("+proj=longlat +datum=WGS84"))
  
  # Get BIGF and AERONET sites within 25km of each other
  
  matches.bigf.radiosonde <- get_matches_df(bigf_sites, radiosonde_sites, 25, is_radiosonde=TRUE)
  
  return(matches.bigf.radiosonde)
}