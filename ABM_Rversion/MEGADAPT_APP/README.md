# MEGADAPT Integrated model

## Folder structure

* MEGADAPT_APP<br/><br/>
  * systems_models
    * flooding_ponding
    * scarcity
    * health
  * geosimulation
    * urbanization
    * runoff
  * mcda
    * residents
    * SACMEX
  * Integrated_model
    


## Requirements

Libraries needed to run the MEGADAPT integrated model:

"assertthat", "backports", "base64enc", "BBmisc", "BH", "bindr", "bindrcpp", "broom", "callr", "cellranger", "checkmate",
"cli", "clipr", "coda", "colorspace", "crayon", "crosstalk", "curl", "data.table", "DBI", "dbplyr", "digest", "dplyr", 
"ecr", "evaluate", "fansi", "fastmatch", "forcats", "gbm", "ggplot2", "glmmADMB", "glue", "gramEvol", "gridExtra", "gtable"
"haven", "hexbin", "highr", "hms", "htmltools", "htmlwidgets", "httpuv", "httr", "jsonlite", "knitr", "labeling", "later"
"lazyeval", "lubridate", "magrittr", "maptools", "markdown", "mco", "mime", "misc3d", "modelr", "munsell", "NLP", "openssl"
"parallelMap", "ParamHelpers", "pillar", "pkgconfig", "plogr", "plot3D", "plotly", "plyr", "processx", "promises", "ps"
"pscl", "purrr", "R2admb", "R6", "RColorBrewer", "Rcpp", "RcppArmadillo", "readr", "readxl", "rematch", "reprex","reshape2"
"rJava", "RJSONIO", "rlang", "rmarkdown", "rprojroot", "rstudioapi", "rvest", "scales", "selectr", "shiny", "slam", "smoof"
"sourcetools", "sp", "stringi", "stringr", "tibble", "tidyr", "tidyselect", "tidyverse", "tinytex", "tm", "utf8",
"viridisLite", "whisker", "withr", "xfun", "xml2", "xtable", "yaml"

To install dependencies run ../pakages.R

## How to Run

### Run from terminal

To run the integrated model from command line you have to give a set of parameters

- effectivity_newInfra = The efectivenes of watter authority New Infraestructutre action in range (0,1)
- effectivity_mantenimiento = The efectivenes of watter authority Mantainance action in range (0,1)
- decay_infra = The decay intencity of infraestructure over time in range (0,1)
- time_simulation = The simulation time in years
- Budget = The number of census blocks that water authority can upgrade per year in range (0,2428) 
- scenario = The scenario id from table geosimulation/runoff/
- repetition = The number of repetition for the same set of parameters

example run:

./run_MEGADAPT_Cluster.R 0.25 0.25 0.25 0.25 1500 1 1

### Run in cluster

To run the integrated model in a cluster with condor_ht:

- Build parameter space with python configuring parameter_space.py and runit to create the jobs file
      parameter_space.py > trial.sub
- Tell condor_ht to run the jobs
      condor_submit trial.sub
      

## Inputs and outputs

## Model description
