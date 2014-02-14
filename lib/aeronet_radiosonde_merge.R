diff_from_hour <- function(datetime)
{
  datetime <- as.POSIXct(datetime)
  rounded <- round_date(datetime, "hour")
  diff <- datetime - rounded
  return(diff/60)
}

aeronet_radiosonde_merge <- function(aeronet.name, radiosonde.name)
{ 
  # Read the AERONET data for the station
  path = list.files("data/AERONET/", paste("920801_130914_", aeronet.name, ".", "lev20", sep=""))
  if (length(path) == 0)
  {
    print("No data for AERONET")
    return(NA)
  }
  aeronet.filename = paste("data/AERONET/", path, sep="")
  if (!file.exists(aeronet.filename))
  {
    print("No data for AERONET")
    return(NA)
  }
  
  # Load AERONET data
  aeronet <- import_aeronet_data(aeronet.filename)
  aeronet <- as.xts(aeronet)
  aeronet <- aeronet$PWC * 10
  
  # Filter to remove outliers
  # (outliers defined as points outside +- 3 SDs)
  above_low_threshold = aeronet > mean(aeronet) - 3*sd(aeronet)
  above_high_threshold = aeronet < mean(aeronet) + 3*sd(aeronet)
  
  aeronet <- aeronet[above_low_threshold & above_high_threshold,]
  
  # Remove items when the index is NA (ie. invalid - eg. 1am at BST/GMT switchover)
  aeronet <- aeronet[!is.na(index(aeronet))]
  
  # Remove rows in either dataset where anything is NA
  aeronet <- aeronet[!is.na(aeronet)]  
  
  if (length(aeronet) <= 1)
  {
    print(length(aeronet))
    print("Len < 2, skipping")
    return(NA)
  }
  
  print(paste("AERONET data from", start(aeronet), "to", end(aeronet), "loaded"))
  
  
  if (nrow(aeronet) == 0)
  {
    print("No AERONET rows")
    return(NA)
  }
  
  
  
  # Read the radiosonde data for the station
  
  corrected_radiosonde_name <- correct_radiosonde_name(radiosonde.name)
  radiosonde <- read_radiosonde_for_dates(corrected_radiosonde_name, start(aeronet), end(aeronet))
  if (is.na(radiosonde[1]) && length(radiosonde) == 1) return(NA)
  index(radiosonde) <- round_date(index(radiosonde), "hour")
  
  print(paste("Radiosonde data from", start(radiosonde), "to", end(radiosonde), "loaded"))
    
  # Exclude any duplicated times from the radiosonde data
  radiosonde <- radiosonde[!duplicated(index(radiosonde))]
  
  # Filter to remove outliers
  # (outliers defined as points outside +- 3 SDs)
  above_low_threshold = radiosonde$pwc > mean(radiosonde$pwc) - 3*sd(radiosonde$pwc)
  above_high_threshold = radiosonde$pwc < mean(radiosonde$pwc) + 3*sd(radiosonde$pwc)
  
  radiosonde <- radiosonde[above_low_threshold & above_high_threshold,]
  #if (nrow(radiosonde) == 0) return(NA)
  
  # Remove all measurements <= 0.5mm
  # as there are quite a few very low anomalies
  #browser()
  radiosonde <- radiosonde[radiosonde$pwc > 0.5]
  
  radiosonde <- radiosonde[!is.na(index(radiosonde))]
  aeronet <- aeronet[!is.na(index(aeronet))]
  
  ind <- index(aeronet)

  time_diffs <- diff_from_hour(as.POSIXct(ind))
  
  aeronet <- aeronet[time_diffs < 10]
  
  index(aeronet) <- round_date(as.POSIXct(index(aeronet)), "hour")
  
  #browser()
  m <- merge(aeronet, radiosonde, all=FALSE)

  if (length(m) == 0)
  {
    return(NA)
  }
  else
  {
    m$error <- m$PWC - m$pwc
    
    return(m)
  }
  
}
