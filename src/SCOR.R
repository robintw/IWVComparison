# SCOR supersite

radiosonde <- as.xts(mlist.radiosonde$SCOR)
aeronet <- as.xts(mlist.aeronet$SCOR)

sub.rad <- radiosonde["2012"]
sub.aero <- aeronet["2012"]

# High error spike for GPS IWV in Nov 2005 (12th and 18th)
plot(radiosonde$iwv)
lines(radiosonde$pwc, col='red')

# Removing the spike gives better statistics
# far closer to what is expected from the summation
ind <- radiosonde["2005-11-12/2005-11-20", which.i=TRUE]
sub.rad <- radiosonde[-ind]

summary(sub.rad$error)
summary(radiosonde$error)
