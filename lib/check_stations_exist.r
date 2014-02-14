
check_bigf <- function(name)
{
  # Read the BIGF data for the station
  path = list.files("data/BIGF/", tolower(name))
  if (length(path) == 0)
  {
    return(0)
  }
  filename = paste("data/BIGF/", path, sep="")
  if (!file.exists(filename))
  {
    return(0)
  }
  return(1)
  
}

#filtered <- sapply(results$bigf, check_bigf)
