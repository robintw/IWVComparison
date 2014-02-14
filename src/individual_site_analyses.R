agg_monthly <- function(ts)
{
  ep <- endpoints(ts, 'months')
  res <- period.apply(ts, INDEX=ep, FUN=mean)
  return(res)
}

agg_yearly <- function(ts)
{
  ep <- endpoints(ts, 'years')
  res <- period.apply(ts, INDEX=ep, FUN=mean)
  return(res)
}

write_csv_with_date_format <- function(ts, filename, format=NA)
{
  if (is.na(format))
  {
    write.zoo(ts, filename, sep=',')
  }
  else
  {
    write.zoo(zoo(coredata(ts), format(index(ts), format)), filename, sep=',')
  }
}

camb.radiosonde <- mlist.radiosonde$CAMB
camb.radiosonde <- subset(camb.radiosonde, select=-c(station_id, zwd, ztd))

camb.radiosonde.monthly <- agg_monthly(camb.radiosonde)
camb.radiosonde.yearly <- agg_yearly(camb.radiosonde)

write_csv_with_date_format(camb.radiosonde, 'results/CAMB_Radiosonde.csv')
write_csv_with_date_format(camb.radiosonde.monthly, "results/CAMB_Radiosonde_Monthly.csv", "%Y-%m")
write_csv_with_date_format(camb.radiosonde.yearly, "results/CAMB_Radiosonde_Yearly.csv", "%Y")

lerw.radiosonde <- mlist.radiosonde$LERW
lerw.radiosonde <- subset(lerw.radiosonde, select=-c(station_id, zwd, ztd))

lerw.radiosonde.monthly <- agg_monthly(lerw.radiosonde)
lerw.radiosonde.yearly <- agg_yearly(lerw.radiosonde)

write_csv_with_date_format(lerw.radiosonde, 'results/LERW_Radiosonde.csv')
write_csv_with_date_format(lerw.radiosonde.monthly, "results/LERW_Radiosonde_Monthly.csv", "%Y-%m")
write_csv_with_date_format(lerw.radiosonde.yearly, "results/LERW_Radiosonde_Yearly.csv", "%Y")

hers.radiosonde <- mlist.radiosonde$HERS
hers.radiosonde <- subset(hers.radiosonde, select=-c(station_id, zwd, ztd))

hers.radiosonde.monthly <- agg_monthly(hers.radiosonde)
hers.radiosonde.yearly <- agg_yearly(hers.radiosonde)

write_csv_with_date_format(hers.radiosonde, 'results/HERS_Radiosonde.csv')
write_csv_with_date_format(hers.radiosonde.monthly, "results/HERS_Radiosonde_Monthly.csv", "%Y-%m")
write_csv_with_date_format(hers.radiosonde.yearly, "results/HERS_Radiosonde_Yearly.csv", "%Y")
