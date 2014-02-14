# Calculate overall regressions

print("AERONET:")
m <- lm(m.aeronet$PWC ~ m.aeronet$iwv + 0)
print(m$coefficients[1])
print(summary(m)$r.squared)