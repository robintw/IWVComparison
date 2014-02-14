conv <- function(y,m,d,t) {
  date_str <- paste(m,"/", d, "/", y, " ", sep="")
  time_str <- paste(t, ":00", sep="")
  date <- chron(date_str, time_str)
  as.POSIXct(date, tz="GMT")
}

read_bigf <- function(filename) {
 z <- read.zoo(filename, index=2:5, FUN = conv)
 names(z) <- c("station_id", "ztd", "zwd", "iwv")
 
 # Remove IWVs less than or equal to 0
 z <- z[!z$iwv <= 0]
 
 # Filter to remove outliers
 # (outliers defined as points outside +- 3 SDs)
 above_low_threshold = z$iwv > mean(z$iwv) - 3*sd(z$iwv)
 above_high_threshold = z$iwv < mean(z$iwv) + 3*sd(z$iwv)
 
 z <- z[above_low_threshold & above_high_threshold]

 
 return(z)
}

data_for_time <- function(filename, date_string) {
  z <- read_bigf(filename)
  x <- as.xts(z)
  #val <- c(substr(filename, 0, 4), x["2006-06-17 12:00:00"]$iwv)
  subs <- x[date_string]
  if (length(subs) == 0) {
    val <- NA
  }
  else
  {
    val <- subs$iwv[[1]]
  }
  name <- substr(filename, 0, 4)
  print(paste(name, val, sep=","))
  return(data.frame(station=name, iwv=val))
}