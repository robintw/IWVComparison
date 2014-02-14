# Examine the errors at different magnitudes of IWVs

iwv = m.radiosonde$iwv
error = m.radiosonde$error

plot(iwv, error, xlab="IWV", ylab="IWV Error")
print(cor(iwv, error))
plot(iwv, error/iwv, xlab="IWV", ylab="IWV Error (Normalised)")
print(cor(iwv, error/iwv))
