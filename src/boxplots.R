boxplot(abs(m.radiosonde$error), abs(m.aeronet$error), abs(m.ar$error), outline = FALSE, names=c('G-R', 'G-A', 'A-R'))
grid()

boxplot(m.radiosonde$error, m.aeronet$error, m.ar$error, outline = FALSE, names=c('G-R', 'G-A', 'A-R'))
grid()