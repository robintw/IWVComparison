# Generate CSV files with category-based statistics in them

# Add an extra category for All measurements
ClassifiedValAERONET$All <- 1
ClassifiedValRadiosonde$All <- 1

cat.stats.radiosonde <- process_all_categories(ClassifiedValRadiosonde, 'radiosonde', mlist.radiosonde)
cat.stats.aeronet <- process_all_categories(ClassifiedValAERONET, 'PWC', mlist.aeronet)
write.csv(cat.stats.aeronet, "results/CategoryStats_AERONET.csv")
write.csv(cat.stats.radiosonde, "results/CategoryStats_Radiosonde.csv")
