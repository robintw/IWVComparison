# Code to run IWV comparison

This repository contains all of the code used to produce the comparisons shown in the paper _A global comparison of integrated water vapour estimates from WMO radiosondes, AERONET sun photometers and GPS for the 17 year period from 1997 to 2013_ by Wilson, Hansen, Bingley and Milton.

The code is written in the R programming language, and has been tested with v3.3.2. It uses the [ProjectTemplate library](http://projecttemplate.net/) as a framework to enable easy reproducibility. The code is licensed for use under the MIT license - but if you use it in an academic project then we would appreciate you citing the above paper. 

## Quickstart
To go from nothing to a situation where you can run the individual analyses used in the paper, follow the steps below:

1. Install R (using the appropriate installer from the [R homepage](https://www.r-project.org/))
2. Clone this repository (`git clone git@github.com:robintw/IWVComparison.git`)
3. Load R and change to the cloned directory (`setwd("~/code/IWVComparison")`
4. Run the `go.r` file (`source("go.r")`)

The final step above will automatically install the required libraries, and then run the `ProjectTemplate` function `load.project()`. For reference, the required libraries are:

- `lubridate`
- `chron`
- `zoo`
- `xts`
- `Bolstad`
- `xtable`
- `quantmod`
- `stringr`
- `R.utils`
- `sp`

By default, running `load.project()` will load _cached_ comparison data. This means that you can play around with the data and analyses without running the whole validation from scratch, which takes a long time! The cached data is stored in `.RData` files inside the `cache` directory.

To run any of the analyses, simply run a file within the `src` folder (see _Running the analyses_ below).

## Running the comparisons
To force the running of the comparisons (as opposed to loading the validation data from the cache files), open `config/global.dcf` and change the first two lines to be:

```
data_loading: FALSE
cache_loading: TRUE
```

and then run `load.project()`. The comparisons will then be run, which involves loading all of the raw data for all three measurement sources (radiosonde, sun photometer and GPS), matching observations temporally and spatially, and then calculating the comparison statistics.

## Running the analyses
All specific analyses (such as overall validation statistics, statistics per time period or radiosonde type) can be performed by running the appropriate file in the `src` directory. For example, `source("height_difference_met_station.R")`.

## Raw data required
Some of the data required for running this code is provided in the repository, but some cannot be redistributed due to licensing constraints. In the latter case, instructions are provided as to how to acquire the data.

### Data provided
The following data is provided in this repository, in the `data` folder:

- `gps_met.csv`: CSV file listing the meteorological station used to provide the relevant meteorological information used in the GPS IWV estimation procedure. Information includes distance between the met station and the GPS station (horizontal and vertical). Produced as part of the GPS IWV estimation procedure.
- `Locations/aeronet_locations.txt`: List of AERONET locations, downloaded from the [AERONET website](http://aeronet.gsfc.nasa.gov).
- `Locations/coordinates_file.bl06gd07_tts_hourly.*`: List of GPS locations. Provided by BIGF.
- `Locations/midas_stations_by_message_type.*`: Original list of meteorological stations, from the MIDAS data selection interface.
- `Locations/UAPLT.csv` and `Locations/UATMP.csv`: Processed lists of relevant meteorological stations extracted from `midas_stations_by_message_type`.

### Data not provided

#### AERONET
Level 2.0 AERONET data was used, downloaded from the AERONET website. To download for reproducing the analysis, choose _Download All Sites_  under _AEROSOL OPTICAL DEPTH (V2)_ on the left-hand side, and then choose the _Level 2.0 AOD_ _All Points_ link (the top link on the page, at the time of writing).

Extract this file to the `data/AERONET` folder.

#### GPS
GPS IWV estimates produced by the British Isles continuous GNSS Facility (BIGF) were provided by Richard Bingley and Dionne Hansen at the BIGF. To acquire this data, please contact the BIGF as listed [on their website](http://bigf.ac.uk/staff_contact). The list of files which must be acquired are provided in `data/BIGF/list_of_files.txt`, and all files should be placed in the `data/BIGF`  folder.

#### Radiosonde
Radiosonde data is provided by the UK Met Office via the British Atmospheric Data Centre ([BADC](http://badc.nerc.ac.uk/)). To acquire this data you must create a BADC account and request access to the data - see [the BADC registration page](https://services.ceda.ac.uk/cedasite/register/info/) for details.

Once you have access to the dataset via BADC, you can download via FTP. Simply connect to `ftp://ftp.ceda.ac.uk/badc/ukmo-rad/data/` using your BADC username and password, and download the folders listed in `data/RadiosondeMetO/downloads_needed.txt`. An easy way to do this if you're using OS X or Linux is to fill in your username and password in `download_ftp.sh` and then run `./download_ftp.sh`. Regardless how you obtain the data, you should ensure the site folders (eg. `camborne`) are directly underneath the `data/RadiosondeMetO` folder.

## Code structure
In general the code is well-commented and should be relatively self-explanatory. However, the following notes/tips may be useful:

1. Reading the `ProjectTemplate` [documentation](blah) is recommended. This will explain how all of the various code files fit together. In brief: all of the files in `lib` are sourced when `load.project()` is run, and this means that _all_ of these functions are available to run from any other file in the project. The files in `src` are run manually to perform specific analyses.
2. The actual comparison itself (data loading and temporal/spatial matching) is performed by the `.R` files in the `data` folder.
3. The comparison process produces various temporary datasets with slightly strange names. `mlist.X` (where `X` is a comparison like `aeronet`, `radiosonde` or `ar`) is a _list_ of merged dataframes. Each entry in the list (keyed by station name) contains all of the merged observations for that comparison. `m.X` is basically a `concat` of the above list - ie. all observations put together. Having both of these allows efficient calculation of both overall and site-specific statistics. `val.X` is the final validation statistics for that particular comparison, on a site level.
4. This work originally started as a detailed validation of the GPS data, so if only one 'side' of the comparison is mentioned then the other 'side' is GPS. For example, the file `run_aeronet_validations.r` will actually run a comparison between AERONET and GPS data.
5. Abbreviations that are used in the paper are also used in the code - for example: `AR` for AERONET-Radiosonde comparison.
