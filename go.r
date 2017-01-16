# Quickstart script for the code to run the IWV comparison used in
# A global comparison of integrated water vapour estimates from WMO
# radiosondes, AERONET sun photometers and GPS for the 17 year period
# from 1997 to 2013
# by Wilson, Hansen, Bingley and Milton
#
# See README.md for more information
#
#
#
#
# Sets up system for ProjectTemplate and loads project

# Load libraries, installing them if not available

# Load DCF file and get list of libraries
d <- read.dcf("config/global.dcf", fields='libraries')

libs = strsplit(d[1,], ',')$libraries

for (lib in libs)
{
  lib = gsub(" ", "", lib)
  if (!require(lib, character.only=TRUE, quietly=TRUE))
    {
      install.packages(lib)
      #require(lib, character.only=TRUE)
    }
}

require(ProjectTemplate) || install.packages("ProjectTemplate")
load.project()