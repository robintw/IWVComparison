# Perth supersite

radiosonde <- as.xts(mlist.radiosonde$PERT)
aeronet <- as.xts(mlist.aeronet$PERT)

sub.rad <- radiosonde["2012"]
sub.aero <- aeronet["2012"]

# Generally overall consistency
plot(sub.aero$iwv)
points(sub.rad$iwv, col='black')
points(sub.rad$pwc, col='red')
points(sub.aero$PWC, col='blue')

# Plot whole range
plot(radiosonde$iwv)
lines(aeronet$iwv, col='black')
lines(radiosonde$pwc, col='red')
lines(aeronet$PWC, col='blue')

plot(SMA(aeronet$error, n=100))
