# Get overall RMSE for Radiosondes and AERONET comparisons
get_overall_stats <- function(df, valcol, category) {
  col <- df[,valcol]
  m <- lm(col ~ df$iwv + 0)
  res <- list(category = category,
                    rmse = rmse(df$error),
                    err_mean = mean(df$error),
                    err_sd = sd(df$error),
                    perc_err_mean = mean(df$perc_e),
                    perc_err_sd = sd(df$perc_e),
                    m = as.numeric(m$coefficients[1]),
                    R2 = summary(m)$r.squared,
                    n = nrow(df)
                    )
  
  return(res)
}

# m <- lm(m.radiosonde$radiosonde ~ m.radiosonde$iwv + 0)
# cat(paste("Radiosonde:",
#           "\nRMSE =", rmse(m.radiosonde$error),
#           "\nMean Error =", mean(m.radiosonde$error),
#           "\nSD Error =", sd(m.radiosonde$error),
#           "\nMean % Error =", mean(m.radiosonde$perc_e),
#           "\nSD % Error =", sd(m.radiosonde$perc_e),
#           "\nm", as.numeric(m$coefficients[1]),
#           "\nR2 =", summary(m)$r.squared,
#           "\nN =",nrow(m.radiosonde)))
# cat("\n\n\n")
# m <- lm(m.aeronet$PWC ~ m.aeronet$iwv + 0)
# cat(paste("AERONET:",
#           "\nRMSE =", rmse(m.aeronet$error),
#           "\nMean Error =", mean(m.aeronet$error),
#           "\nSD Error =", sd(m.aeronet$error),
#           "\nMean % Error =", mean(m.aeronet$perc_e),
#           "\nSD % Error =", sd(m.aeronet$perc_e),
#           "\nm", as.numeric(m$coefficients[1]),
#           "\nR2 =", summary(m)$r.squared,
#           "\nN =",nrow(m.aeronet)))
# cat("\n\n\n")
# m <- lm(m.ar$radiosonde ~ m.ar$PWC + 0)
# cat(paste("AERONET-Radiosonde:",
#           "\nRMSE =", rmse(m.ar$error),
#           "\nMean Error =", mean(m.ar$error),
#           "\nSD Error =", sd(m.ar$error),
#           "\nMean % Error =", mean(m.ar$perc_e),
#           "\nSD % Error =", sd(m.ar$perc_e),
#           "\nm", as.numeric(m$coefficients[1]),
#           "\nR2 =", summary(m)$r.squared,
#           "\nN =",nrow(m.ar)))