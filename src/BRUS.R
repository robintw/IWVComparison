# Brussels supersite

# Nothing major to report

radiosonde <- as.xts(mlist.radiosonde$BRUS)
aeronet <- as.xts(mlist.aeronet$BRUS)

sub.rad <- radiosonde["2007"]
sub.aero <- aeronet["2007"]

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


df <- as.data.frame(aeronet)
plot(df$PWC, df$error)
plot(df$PWC, abs(df$error))
smoothScatter(df$iwv, abs(df$error), ylim=c(0, 4))

