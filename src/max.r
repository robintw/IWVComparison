get_max <- function(filename)
{
  b <- read_bigf(filename)
  return(max(b$iwv))
}

files <- list.files("./data/BIGF/", pattern="*.tts")
sapply(paste("./data/BIGF/", files, sep=""), get_max)