
get_close_stations <- function()
{
  bigf <- readOGR("./data", "BIGF_UK_Locs")
  uaplt <- readOGR("./data", "UAPLT")
  uatmp <- readOGR("./data", "UATMP")
  radiosonde <- rbind(uaplt, uatmp)
  
  df_bigf <- as.data.frame(bigf)
  df_bigf <- df_bigf[,c(4,1,3)]
  
  df_radiosonde <- as.data.frame(radiosonde)
  df_radiosonde <- df_radiosonde[,c(11,12,7)]
  
  df_bigf$name <- as.character(df_bigf$name)
  
  #browser()
  
  results <- data.frame(bigf=rep(NA,nrow(df_bigf)), radiosonde=rep(NA,nrow(df_bigf)),dist=rep(NA,nrow(df_bigf)))
  
  for (i in 1:nrow(df_bigf))
  {
    bigf_bit <- as.numeric(df_bigf[i,1:2])
    r <- spDistsN1(as.matrix(df_radiosonde[,1:2]), bigf_bit, longlat=TRUE)
    index <- which(r == min(r))[1]
    
    bigf_id <- df_bigf[i,]$name
    #print(df_bigf[i,])
    radiosonde_id <- df_radiosonde[index,]$Snippet
    dist <- r[index]
    
    if (dist < 25)  print(paste(bigf_id, "and", radiosonde_id, ":", dist, "km"))
    results[i,]$bigf <- bigf_id
    results[i,]$radiosonde <- as.character(radiosonde_id)
    results[i,]$dist <- dist
  }
  
  return(results)
}
