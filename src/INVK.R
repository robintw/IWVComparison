# Analysis of INVK error over time

# Basically due to measurements in Jan 2010 which were utterly insane
# it was radiosonde's fault, and no radiosonde type was recorded then...
# ...weird
invk <- mlist.radiosonde$INVK
x.invk <- as.xts(invk)
ind <- x.invk["2010-01", which.i=TRUE]
plot(x.invk[-ind]$error)
summary(x.invk[-ind]$error)
