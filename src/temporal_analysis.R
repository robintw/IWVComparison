# Performs an analysis of temporal trend in error
# for all radiosonde validations that have more than
# a year of data

for (i in 3:length(mlist.radiosonde)-1)
{
  extracted <- mlist.radiosonde[[i]]$error/mlist.radiosonde[[i]]$iwv
  if (length(extracted) < 365)
  {
    print(paste("Skipped", names(mlist.radiosonde)[i], length(extracted)))
    next
  }
  extracted <- na.exclude(extracted)
  plot(extracted, main=names(mlist.radiosonde)[i])
  plot(SMA(extracted, n=100), main=names(mlist.radiosonde)[i])
}


