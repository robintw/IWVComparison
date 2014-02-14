## Radiosonde Type key
# 11:   VIZ Type B time-commutated
# 21:   VIZ/Jin Yang Mark I Microsonde
# 27:   AVK-MRZ
# 47:   Meisei RS2-91
# 49:   VIZ Mark II
# 52:   Vaisala RS80-57H
# 55:   Meisei RS-01G
# 57:   Modem M2K2-DC
# 79:   Vaisala RS92/Digicora 1,2 or Marwin
# 80:   Vaisala RS92/Digicora 3
# 81:   Vaisala RS92/Autosonde
# 89:   Marl-A or Vektor-M-BAR

## Tracking system key
# 2:    Automatic with auxilliary radio direction finding
# 3:    Automatic with auxilliary ranging
# 6:    Automatic cross chain Loran-C
# 8:    Automatic satellite navigation

## Radiation correction key
# 0:    No correction
# 3:    CIMO solar corrected only
# 4:    Solar and infrared corrected automatically by radiosonde system
# 5:    Solar corrected automatically by radiosonde system
# 7:    Solar corrected as specified by country


val.radiosonde$rtype = NA
val.radiosonde$tracksys = NA
val.radiosonde$radcorr = NA

# Loop through mlist
for (name in names(mlist.radiosonde))
{
  print(name)
  # Get dataframe
  df = mlist.radiosonde[[name]]
  
  # Subset down to elements where radiosonde type has a value
  df = df[is.finite(df$RADI_SNDE_TYPE)]

  if (length(df) == 0)
  {
    print("No Data")
    next
  }

  # Are all of the metadata values the same?
  if (all(df$RADI_SNDE_TYPE == df$RADI_SNDE_TYPE[1]))
  {
    print(paste("All the same:", df$RADI_SNDE_TYPE[1]))
    if (df$RADI_SNDE_TYPE[1] != -9999999)
    {
      val.radiosonde[val.radiosonde$bigf == tolower(name),]$rtype = df$RADI_SNDE_TYPE[1]
    }
  } else
  {
    print("Oooh different!")
  }
  
  if (all(df$TRCKG_SYTM == df$TRCKG_SYTM[1]))
  {
    print(paste("All the same:", df$TRCKG_SYTM[1]))
    if (df$TRCKG_SYTM[1] != -9999999)
    {
      val.radiosonde[val.radiosonde$bigf == tolower(name),]$tracksys = df$TRCKG_SYTM[1]
    }
  } else
  {
    print("Oooh different!")
  }
  
  if (all(df$RADTN_CORTN == df$RADTN_CORTN[1]))
  {
    print(paste("All the same:", df$RADTN_CORTN[1]))
    if (df$RADTN_CORTN[1] != -9999999)
    {
      val.radiosonde[val.radiosonde$bigf == tolower(name),]$radcorr = df$RADTN_CORTN[1]
    }
  } else
  {
    print("Oooh different!")
  }
}