# Get stats for a subset of the data
subset_stats <- function(data, valcol, valcol2) {
  if (is.null(names(data)))
  {
    return(NULL)
  }
  print("Data:")
  print(str(data))
  print("Names:")
  print(names(data))
  print("Valcol:")
  print(valcol)
  col <- data[,valcol]
  col2 <- data[,valcol2]
  m <- lm(col ~ col2 + 0)
  res <- list(rmse = rmse(data$error),
              err_mean = mean(data$error),
              err_sd = sd(data$error),
              perc_err_mean = mean(data$perc_e),
              perc_err_sd = sd(data$perc_e),
              m = as.numeric(m$coefficients[1]),
              R2 = summary(m)$r.squared,
              n = nrow(data))
  
  #   res <- c(rmse(df$error),
  #            mean(df$error),
  #            sd(df$error),
  #            mean(df$perc_e),
  #            sd(df$perc_e),
  #            as.numeric(m$coefficients[1]),
  #            summary(m)$r.squared,
  #            nrow(df))
  
  return(res)
}