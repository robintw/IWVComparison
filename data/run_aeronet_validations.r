#locs <- read.csv("data/aeronet_bigf_locs.csv", stringsAsFactors=FALSE)

locs <- get_aeronet_matches()

locs$n <- rep(NA, nrow(locs))
locs$rmse <- rep(NA, nrow(locs))
locs$corr <- rep(NA, nrow(locs))
locs$m <- rep(NA, nrow(locs))
#locs$c <- rep(NA, nrow(locs))
locs$r2 <- rep(NA, nrow(locs))
locs$e_mean <- rep(NA, nrow(locs))
locs$e_sd <- rep(NA, nrow(locs))
locs$perc_e_mean <- rep(NA, nrow(locs))
locs$perc_e_sd <- rep(NA, nrow(locs))


#locs <- locs[locs$run == 1,]

mlist.aeronet = list()

for (i in 1:nrow(locs))
{
  l <- locs[i,]
  print(paste("###### Running validation for", l$aeronet, "and", l$bigf))
  m.temp <- aeronet_bigf_merge(l$aeronet, tolower(l$bigf))
  
  
  if (is.na(m.temp) || (is.na(m.temp[1]) && length(m.temp) == 1))
  {
    locs[i,]$rmse <- NA
    locs[i,]$m <- NA
    #locs[i,]$c <- NA
    locs[i,]$corr <- NA
    locs[i,]$r2 <- NA
    locs[i,]$n <- NA
    locs[i,]$e_mean <- NA
    locs[i,]$e_sd <- NA
    locs[i,]$perc_e_mean <- NA
    locs[i,]$perc_e_sd <- NA    
  }
  else
  {
    # Calculate percentage error
    m.temp$perc_e <- (m.temp$error / m.temp$PWC) * 100
    
    locs[i,]$rmse <- rmse(m.temp$error)
    model <- lm(m.temp$PWC ~ m.temp$iwv + 0)
    locs[i,]$m <- model$coefficients[1]
    #locs[i,]$c <- model$coefficients[1]
    locs[i,]$r2 <- summary(model)$r.squared
    locs[i,]$e_mean <- mean(m.temp$error)
    locs[i,]$e_sd <- sd(m.temp$error)
    locs[i,]$perc_e_mean <- mean(m.temp$perc_e)
    locs[i,]$perc_e_sd <- sd(m.temp$perc_e)
    
    locs[i,]$n <- nrow(m.temp)
    
    
    locs[i,]$corr <- cor(m.temp$PWC, m.temp$iwv)
    
    mlist.aeronet[[l$bigf]] = m.temp
  }
  
}


val.aeronet <- na.omit(locs)

mla = list()

for (i in 1:length(mlist.aeronet))
{
  item <- mlist.aeronet[[i]]
  name <- names(mlist.aeronet)[i]
  
  if (length(item) == 1)
  {
    next()
  }
    mla[[name]] = item
}

m.aeronet <- do.call('rbind', mla)
m.aeronet <- as.data.frame(m.aeronet)

cache('val.aeronet')
cache('mlist.aeronet')
cache('m.aeronet')