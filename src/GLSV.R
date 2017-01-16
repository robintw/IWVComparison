# Kyiv supersite

radiosonde <- as.xts(mlist.radiosonde$GLSV)
aeronet <- as.xts(mlist.aeronet$GLSV)

sub.rad <- radiosonde["2012"]
sub.aero <- aeronet["2012"]

# Generally overall consistency
plot(sub.aero$iwv)
lines(sub.rad$iwv, col='black')
lines(sub.rad$pwc, col='red')
lines(sub.aero$PWC, col='blue')

# Plot whole range
plot(aeronet$iwv)
lines(radiosonde$iwv, col='black')
lines(radiosonde$pwc, col='red')
lines(aeronet$PWC, col='blue')

plot(SMA(aeronet$error, n=100))
plot(SMA(radiosonde$error, n=100))
