# TIXI supersite

#radiosonde <- as.xts(mlist.radiosonde)
aeronet <- as.xts(mlist.aeronet$GODE)

sub.rad <- radiosonde["2012"]
sub.aero <- aeronet["2012"]

# Plot whole range
# good example of seasonal sampling and what looks like anomalous points,
# but aren't, and radiosonde consistently over-estimates
plot(radiosonde$iwv)
lines(radiosonde$pwc, col='red')
lines(aeronet$PWC, col='blue')
lines(aeronet$iwv)


# Removing the spike gives better statistics
# far closer to what is expected from the summation
ind <- radiosonde["2005-11-12/2005-11-20", which.i=TRUE]
sub.rad <- radiosonde[-ind]

summary(sub.rad$error)
summary(radiosonde$error)
