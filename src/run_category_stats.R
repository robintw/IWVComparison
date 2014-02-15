# Run all of the category statistics and save to CSV

cat.stats.radiosonde <- run_category_stats_radiosonde()
cat.stats.aeronet <- run_category_stats_aeronet()
cat.stats.ar <- run_category_stats_ar()

# TODO: Add CSV writing code here!
write.csv(cat.stats.radiosonde, "results/Category_Stats_Radiosonde.csv")
write.csv(cat.stats.aeronet, "results/Category_Stats_AERONET.csv")
write.csv(cat.stats.ar, "results/Category_Stats_AERONET-Radiosonde.csv")