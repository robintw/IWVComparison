# Print the date range of data availability for all BIGF
# files

print_range <- function(filename) {
  z <- read_bigf(filename)
  s <- dates(start(z))
  e <- dates(end(z))
  short_name = substr(filename, 13, 16)
  print(paste(short_name, s, e))
}

files <- list.files("./data/BIGF/", pattern="*.tts")
lapply(paste("./data/BIGF/", files, sep=""), print_range)