# TIXI supersite

radiosonde <- as.xts(mlist.radiosonde$TIXI)
aeronet <- as.xts(mlist.aeronet$TIXI)

sub.rad <- radiosonde["2012"]
sub.aero <- aeronet["2012"]

# Plot whole range
# good example of seasonal sampling and what looks like anomalous points,
# but aren't, and radiosonde consistently over-estimates
plot(radiosonde$iwv)
lines(radiosonde$pwc, col='red')
lines(aeronet$PWC, col='blue')
lines(aeronet$iwv)

# Comparison of error for the 3 technique comparisons
boxplot(as.vector(aeronet$error), as.vector(radiosonde$error), as.vector(mlist.ar$TIKSI$error), outline = FALSE)
grid()

#Boxplot of PWC ranges for GPS IWV that matches with each of the others
boxplot(as.vector(aeronet$iwv), as.vector(radiosonde$iwv), names = c('GPS (AERONET)', 'GPS (radiosonde)'))
