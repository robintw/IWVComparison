generate_stats <- function(f, name, table)
{
  res <- list(bigf="", aeronet=name,
               dist=f(table$dist),
               n=f(table$n),
               rmse=f(table$rmse),
               corr=f(table$corr),
               m=f(table$m),
               c=f(table$c),
               r2=f(table$r2),
               e_mean=f(table$e_mean),
               e_sd=f(table$e_sd),
               perc_e_mean=f(table$perc_e_mean),
               perc_e_sd=f(table$perc_e_sd))
  
  return(res)
}

print_val_tables <- function(table, station_type)
{
  stats1 <- generate_stats(min, "Min", table)
  stats2 <- generate_stats(mean, "Mean", table)
  stats3 <- generate_stats(max, "Max", table)
  
  
  if (station_type == "Radiosonde")
  {
    names(stats1)[names(stats1)=="aeronet"] <- "radiosonde"
    names(stats2)[names(stats2)=="aeronet"] <- "radiosonde"
    names(stats3)[names(stats3)=="aeronet"] <- "radiosonde"
  }
  
  print(names(table))
  print(names(stats1))
  
  table <- rbind(table, stats1, stats2, stats3)
  
  # Give new column names
  old_names <- colnames(table)
  colnames(table) <- c("BIGF site", paste(station_type, "site"), "Distance (km)", "$n$", "RMSE", "Correlation", "$m$", "$c$", "$r^2$", "Mean Error", "SD Error", "Mean % Error", "SD % Error")
  
  # Print
  myxtable(table)
}