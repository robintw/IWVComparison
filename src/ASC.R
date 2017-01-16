# Ascension Island supersite

radiosonde <- as.xts(mlist.radiosonde$ASC1)
aeronet <- as.xts(mlist.aeronet$ASC1)

sub.rad <- radiosonde["1997/1999"]
sub.aero <- aeronet["2003"]

# Plot a representative example from 2003 - this shows
# that AERONET and GPS are very consistent with each other,
# and radiosonde is a bit out
plot(sub.aero$iwv)
lines(sub.rad$pwc, col='red')
lines(sub.aero$PWC, col='blue')

# Plot whole range
plot(aeronet$iwv)
lines(radiosonde$pwc, col='red')
lines(aeronet$PWC, col='blue')

# There are some strange things going on with the GPS at the beginning of
# the time series...so remove those
ind <- aeronet["1998-01/1999-10", which.i=TRUE]
sub.aero <- aeronet[-ind]
ind <- radiosonde["1998-01/1999-10", which.i=TRUE]
sub.rad <- radiosonde[-ind]

mean(aeronet$error)
mean(sub.aero$error)

mean(abs(aeronet$error))
mean(abs(sub.aero$error))

sd(aeronet$error)
sd(sub.aero$error)

rmse(aeronet$error)
rmse(sub.aero$error)

cor(aeronet$iwv, aeronet$PWC)
cor(sub.aero$iwv, sub.aero$PWC)


mean(radiosonde$error)
mean(sub.rad$error)

mean(abs(radiosonde$error))
mean(abs(sub.rad$error))

sd(radiosonde$error)
sd(sub.rad$error)

rmse(radiosonde$error)
rmse(sub.rad$error)

cor(radiosonde$iwv, radiosonde$pwc)
cor(sub.rad$iwv, sub.rad$pwc)
