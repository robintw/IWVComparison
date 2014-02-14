# Write CSV files for main validation results

write.csv(val.ar, "results/Validation_AERONET-Radiosonde.csv")
write.csv(val.radiosonde, file="results/Validation_Radiosonde.csv")
write.csv(val.aeronet, file="results/Validation_AERONET.csv")
