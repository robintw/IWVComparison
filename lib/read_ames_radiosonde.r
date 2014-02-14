read_ames_radiosonde <- function(filename)
{
  #print(paste("Opening file", filename))
  # Open the connection so that it stays open for the whole time
  f <- file(filename, open="rt")
  
  #print(filename)
  
  daily_result <- data.frame(timestamp=rep(as.POSIXct("1970-01-01 00:00:00"), 62), pwc=rep(NA, 62))
  
  # Read the first line, if it is character(0) then we've got EOF
  # so exit
  hdr_line = readLines(f, n=1)
  if (identical(hdr_line, character(0))) break

  
  # Parse the header
  header <- strsplit(hdr_line, " +")
  nlines = as.numeric(header[[1]][1])
  
  # Read the data lines under this header into a temp variable
  # so we can skip to the next header
  temp <- readLines(f, n=nlines-1)
  
  i = 1
  
  # Loop indefinitely
  while (1)
  {  
    dateline = readLines(f, n=1)
    #print(dateline)
    #browser()
    #print(dateline)
    if (identical(dateline, character(0))) break
    
    dateline <- str_replace(dateline, ":99", ":00")
    timestamp = strptime(dateline, "%Y%m%d %H:%M")
    #browser()
    
    params_line = strsplit(readLines(f, n=1), " +")
    n_levels = as.numeric(params_line[[1]][1])
    
    wmo_id = as.numeric(readLines(f, n=1))
    #print(wmo_id)
    station_name = readLines(f, n=1)
    station_country = readLines(f, n=1)
    
    main_data = readLines(f, n=n_levels)
    main_data_str = paste(main_data, sep="", collapse="\n")
    
    if (main_data_str == "")
    {
      next()
    }
    
    t = textConnection(main_data_str)
    
    
    
    df <- read.table(t)
    names(df) <- c("level_number", "pressure", "altitude", "air_temperature", "dew_point_temperature", "wind_dir", "wind_speed")
    
    df[] <- lapply(df, function(x) {replace(x, x == 9999999.0, NA)})
    
    df$dew_point_temperature <- df$dew_point_temperature - 273.15
    df$pressure = df$pressure / 100
    df$e <- 6.11 * 10^(  (7.5*df$dew_point_temperature) / (237.7 + df$dew_point_temperature)  )
    df$mixing_ratio <- 621.97 * (  df$e / (df$pressure - df$e)   )
    
    #browser()
    
    # Remove rows with an NA in the mixing ratio
    df <- df[!is.na(df$mixing_ratio),]
    
    if (nrow(df) < 5)
    {
      close(t)
      next
    }
    
    pwc <- integral(df$pressure, df$mixing_ratio)$value / 100

    # Any PWC over 60 or less than 0 is obviously an error so skipped
    # (reference to http://www.springerreference.com/docs/html/chapterdbid/30434.html
    # which says max over equator is 44 - so not going to be over 60 in UK!)
    if (pwc > 60 || pwc < 0 )
    {
      close(t)
      next
    }
    
    daily_result[i,]$timestamp = timestamp
    daily_result[i,]$pwc = pwc
    daily_result[i,]$wmo_id = wmo_id
    
    #daily_result[i,] = c(as.POSIXct(date+time, origin=as.POSIXct("1970-01-01 00:00:00")), pwc)
    i = i+1
    close(t)
  }
  close(f)
  #browser()
  daily_result = na.exclude(daily_result)
  daily_result = daily_result[!duplicated(daily_result$timestamp),]
  
  
  ts <- daily_result$timestamp
  
  
  daily_result$timestamp <- NULL
  
  if (nrow(daily_result) > 0)
  {
    daily_result$wmo_id = wmo_id
  }
  
  #browser()
  
  #z <- as.zoo(daily_result, order.by = ts)
  z <- zoo(daily_result, order.by = ts)
  
  return(z)
}
