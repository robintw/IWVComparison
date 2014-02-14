locs <- get_aeronet_radiosonde_matches()

#locs <- mar

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

mlist.ar = list()

for (i in 1:nrow(locs))
{
  l <- locs[i,]
  
  print(paste("###### Running validation for", l$aeronet, "and", l$radiosonde))
  m.temp <- aeronet_radiosonde_merge(l$aeronet, l$radiosonde)  
  if (is.na(m.temp[1]) && length(m.temp) == 1)
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
    m.temp$perc_e <- (m.temp$error / m.temp$pwc) * 100.0
    
    locs[i,]$rmse <- rmse(m.temp$error)
    model <- lm(m.temp$pwc ~ m.temp$PWC + 0)
    locs[i,]$m <- model$coefficients[1]
    #locs[i,]$c <- model$coefficients[1]
    locs[i,]$r2 <- summary(model)$r.squared
    locs[i,]$e_mean <- mean(m.temp$error)
    locs[i,]$e_sd <- sd(m.temp$error)
    locs[i,]$perc_e_mean <- mean(m.temp$perc_e)
    locs[i,]$perc_e_sd <- sd(m.temp$perc_e)
    
    locs[i,]$corr <- cor(m.temp$pwc, m.temp$PWC)
    
    locs[i,]$n <- nrow(m.temp)
    
    # Old code from before 1st Sept
    #mlist.radiosonde[[bigf_names[1]]] = m.temp
    mlist.ar[[l$radiosonde]] = m.temp
    
    #browser()
  }
  
  
  
}

# Remove the src_id column, not needed any more
val.ar <- na.omit(locs)
val.ar$src_id <- NULL
#val.ar$bigf <- tolower(val.ar$bigf)
val.ar$radiosonde <- tolower(val.ar$radiosonde)

l <- lapply(mlist.ar, coredata)
m.ar <- do.call('rbind', l)
m.ar <- as.data.frame(m.ar)

cache('val.ar')
cache('m.ar')
cache('mlist.ar')