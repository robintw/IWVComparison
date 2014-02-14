#locs <- read.csv("data/radiosonde_bigf_locs.csv", stringsAsFactors=FALSE)
#locs <- subsmbr

locs <- get_radiosonde_matches()

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

mlist.radiosonde = list()

for (i in 1:nrow(locs))
{
  l <- locs[i,]
  #bigf_names <- strsplit(l$bigf_names, ", ")[[1]]
  
  print(paste("###### Running validation for", l$radiosonde, "and", l$bigf))
  m.temp <- radiosonde_bigf_merge(l$radiosonde, tolower(l$bigf))  
  
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
    m.temp$perc_e <- (m.temp$error / m.temp$pwc) * 100
    
    locs[i,]$rmse <- rmse(m.temp$error)
    model <- lm(m.temp$pwc ~ m.temp$iwv + 0)
    locs[i,]$m <- model$coefficients[1]
    #locs[i,]$c <- model$coefficients[1]
    locs[i,]$r2 <- summary(model)$r.squared
    locs[i,]$e_mean <- mean(m.temp$error)
    locs[i,]$e_sd <- sd(m.temp$error)
    locs[i,]$perc_e_mean <- mean(m.temp$perc_e)
    locs[i,]$perc_e_sd <- sd(m.temp$perc_e)
    
    locs[i,]$corr <- cor(m.temp$pwc, m.temp$iwv)
    
    locs[i,]$n <- nrow(m.temp)
    
    # Old code from before 1st Sept
    #mlist.radiosonde[[bigf_names[1]]] = m.temp
    mlist.radiosonde[[l$bigf]] = m.temp
  }

  
}

# Remove the src_id column, not needed any more
val.radiosonde <- na.omit(locs)
val.radiosonde$src_id <- NULL
val.radiosonde$bigf <- tolower(val.radiosonde$bigf)
val.radiosonde$radiosonde <- tolower(val.radiosonde$radiosonde)

#val.radiosonde <- val.radiosonde[!is.na(val.radiosonde$rmse),]

l <- lapply(mlist.radiosonde, coredata)
m.radiosonde <- do.call('rbind', l)
m.radiosonde <- as.data.frame(m.radiosonde)

cache('val.radiosonde')
cache('m.radiosonde')
cache('mlist.radiosonde')