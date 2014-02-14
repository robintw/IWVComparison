read_radiosonde_for_dates <- function(station, start, end)
{
  start_path = paste("./data/RadiosondeMetO/", station , "/", sep="")
  
  if (!file.exists(start_path))
  {
    print("Path below does not exist:")
    print(start_path)
    #browser()
  }
  
  day(start) <- 1
  day(end) <- 1
  
  dates = seq(start, end, by="months")
    
  paths = paste(start_path, year(dates), "/", station,"_", year(dates), format(dates, "%m"), ".na",  sep="")
  
  paths = paths[file.exists(paths)]
  
  if (length(paths) == 0)
  {
    print("No data for radiosonde")
    #print(str_c("Corrected name is:",station))
    #browser()
    return(NA)
  }
  
  all_data = read_ames_radiosonde(paths[1])
  for (path in paths[-1])
  {
    temp_import <- read_ames_radiosonde(path)
    #browser()
    if (nrow(temp_import) == 0)
    {
      next
    }
    all_data = rbind(all_data, temp_import)

  }
  
  wmo_id = as.numeric(all_data$wmo_id[1])
  
  temp <- read.csv("data/TEMP_Messages_Converted.csv")
  
  
  # Subset down to the relevant WMO ID
  sub_temp <- temp[temp$WMO_ID == wmo_id,]
  
  sub_temp$WMO_ID <- as.numeric(sub_temp$WMO_ID)
#   sub_temp$RADI_SNDE_TYPE <- as.numeric(sub_temp$RADI_SNDE_TYPE)
#   sub_temp$TRCKG_SYTM <- as.numeric(sub_temp$TRCKG_SYTM)
#   sub_temp$RADTN_CORTN <- as.numeric(sub_temp$RADTN_CORTN)
  ts = sub_temp$timestamp
  
  sub_temp = subset(sub_temp, select=-timestamp)
  # Convert to zoo, remove duplicates, round to nearest hour, and
  # make sure it is POSIXct indexed
  sub_zoo = zoo(sub_temp, order.by=strptime(ts, format="%Y-%m-%d %H:%M:%S"))
  sub_zoo <- sub_zoo[!duplicated(index(sub_zoo))]
  #index(sub_zoo) <- round_date(index(sub_zoo), 'hour')
  index(sub_zoo) <- as.POSIXct(index(sub_zoo))
  
  # Merge, and just get the indices where there were ABEP data in the first place
  res <- merge(all_data, sub_zoo)
  subres <- res[index(all_data)]
  
  subres <- subset(subres, select=c('pwc', 'wmo_id', 'RADI_SNDE_TYPE', 'TRCKG_SYTM', 'RADTN_CORTN'))
  
  
  
  return(subres)
}