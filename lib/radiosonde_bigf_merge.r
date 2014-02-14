correct_radiosonde_name <- function(radiosonde.name)
{
  if (radiosonde.name == "DUMONT D URVILLE")
  {
    return("dumont_durville")
  }
  
  corrected_radiosonde_name <- str_replace_all(tolower(radiosonde.name), "[^a-z.'-]", "_")
  corrected_radiosonde_name <- str_replace_all(corrected_radiosonde_name, "_+", "_")
  corrected_radiosonde_name <- str_replace_all(corrected_radiosonde_name, "_$", "")
  
  return(corrected_radiosonde_name)
}


radiosonde_bigf_merge <- function(radiosonde.name, bigf.name)
{
  # Read the BIGF data for the station
  path = list.files("data/BIGF/", bigf.name)
  if (length(path) == 0)
  {
    print("No data for BIGF")
    return(NA)
  }
  filename = paste("data/BIGF/", path, sep="")
  if (!file.exists(filename))
  {
    print("No data for BIGF")
    return(NA)
  }
  
  bigf <- read_bigf(filename)
  index(bigf) <- as.POSIXct(index(bigf))
  
  
  print(paste("BIGF data from", start(bigf), "to", end(bigf), "loaded"))
  
  
  # Read the radiosonde data for the station
  
  corrected_radiosonde_name <- correct_radiosonde_name(radiosonde.name)
  radiosonde <- read_radiosonde_for_dates(corrected_radiosonde_name, start(bigf), end(bigf))
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
  # Remove all measurements <= 0.5mm
  # as there are quite a few very low anomalies
  radiosonde <- radiosonde[radiosonde$pwc > 0.5,]
  bigf <- bigf[bigf$iwv > 0.5, ]
  
  merged <- merge(bigf, radiosonde, all=FALSE)
  
  if (length(merged) == 0)
  {
    return(NA)
  }
  else
  {
    merged$error = merged$iwv - merged$pwc
    
    return(merged)
  }
  
  return(merged)
}