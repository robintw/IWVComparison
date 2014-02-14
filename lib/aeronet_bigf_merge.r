diff_from_hour <- function(datetime)
{
  datetime <- as.POSIXct(datetime)
  rounded <- round_date(datetime, "hour")
  diff <- datetime - rounded
  return(diff/60)
}

aeronet_bigf_merge <- function(aeronet.name, bigf.name)
{
  # Read the BIGF data for the station
  path = list.files("data/BIGF/", bigf.name)
  if (length(path) == 0)
  {
    print("No data for BIGF")
    return(NA)
  }
  bigf.filename = paste("data/BIGF/", path, sep="")
  if (!file.exists(bigf.filename))
  {
    print("No data for BIGF")
    return(NA)
  }
  
  # Load BIGF data
  bigf <- read_bigf(bigf.filename)
  bigf <- as.xts(bigf)
  
  #bigf$iwv <- bigf$iwv
  
  print(paste("BIGF data from", start(bigf), "to", end(bigf), "loaded"))
  
  
  # Read the AERONET data for the station
  path = list.files("data/AERONET/", paste(aeronet.name, ".", "lev20", sep=""))
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
  
  #browser()
  
  # Filter to remove outliers
  # (outliers defined as points outside +- 3 SDs)
  above_low_threshold = aeronet > mean(aeronet) - 3*sd(aeronet)
  above_high_threshold = aeronet < mean(aeronet) + 3*sd(aeronet)
  
  print(paste("AERONET data from", start(aeronet), "to", end(aeronet), "loaded"))
  
  # Remove items when the index is NA (ie. invalid - eg. 1am at BST/GMT switchover)
  aeronet <- aeronet[!is.na(index(aeronet))]
  
  # Remove rows in either dataset where anything is NA
  aeronet <- aeronet[!is.na(aeronet$PWC)]
  
  # Remove all measurements <= 0.5mm
  # as there are quite a few very low anomalies
  aeronet <- aeronet[aeronet > 0.5]
  bigf <- bigf[bigf$iwv > 0.5,]
  
  #browser()
  
  if (length(aeronet) == 1)
  {
    return(NA)
  }
  
  ind <- index(aeronet)
  #browser()
  #time_diffs <- sapply(as.POSIXct(ind), diff_from_hour)
  time_diffs <- diff_from_hour(as.POSIXct(ind))
  
  aeronet <- aeronet[time_diffs < 10]
  #browser()
  index(aeronet) <- round_date(as.POSIXct(index(aeronet)), "hour")
  m <- merge(aeronet, bigf, all=FALSE)
  
  if (length(m) == 0)
  {
    return(NA)
  }
  else
  {
    m$error <- m$iwv - m$PWC
    
    return(m)
  }

}
