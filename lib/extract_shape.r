extract_day <- function(date_string)
{
  datetimestr = chron(date_string, "07:00:00")
  
  for (i in 1:11)
  {
    print(datetimestr)
    s <- extract_to_shp(datetimestr, format(as.POSIXct(datetimestr),"%Y_%m_%d_%H_%M_%S"))
    datetimestr = datetimestr + 1/24
  }
}

extract_to_shp <- function(date_string, filename)
{
  files <- list.files(".", pattern="a*.tts")
  res = ldply(files, data_for_time, date_string)
  station_locs <- read.csv("station_locs.txt")
  
  for_shp <- merge(res, station_locs, by="station")
  for_shp <- na.exclude(for_shp)
  s <- SpatialPointsDataFrame(for_shp[3:4], for_shp, proj4string=CRS("+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 
+y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"))
  print(bbox(s))
  print(filename)
  #writeOGR(s, ".", filename, driver="ESRI Shapefile")
  
  
  return(list(df=for_shp, shp=s))
}