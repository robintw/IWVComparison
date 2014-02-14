library(zoo)

# Function to take the first two cols of data and convert to one Date/Time
f <- function(d, t) as.chron(paste(as.Date(chron(d, format='d:m:y')), t))

# Takes aeronet data and returns a zoo class.
import_aeronet_data <- function(filename)
{
  colClasses <- c("character", "character", rep("NULL", 10), "numeric", rep("NULL",6), "numeric", rep("NULL",25))
  r = read.zoo(filename, sep=',', na.strings = "N/A", header=T, skip=4, index = 1:2, FUN=f, colClasses=colClasses, as.is=F, dec=".")
  names(r) <- c("AOT", "PWC")
  
  # Warning: this conversion was added to fix problems
  # with the output format of start(aeronet) for use in
  # AERONET-Radiosonde comparison
  # Remove if it causes problems with BIGF validation
  index(r) <- as.POSIXct(index(r))
  
  return(r)
}

