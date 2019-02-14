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



## Install required R libraries

Run R and source install script from within. Like so:

	$ R
	> source('utils/install_requirements.R')
	[...] #  many calls to install.packages


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

To run the integrated model in a cluster with [HT Condor](http://htcondor.org):

- Create jobs for all parameter space:
  $ parameter_space.py > trial.sub

- Submit jobs to HTCondor:
  $ condor_submit trial.sub


## Inputs

### Initial values for census blocks

The initial values for every census block in a shpaefile located in data/

example:

data/Layer_MEGADAPT_Oct2018.shp

Nota: esto debe estandarizarse a input_census_blocks.shp

### Supermatrixes

* The matrixes for residents
  * The supermatrix for every kind of resident
* The supermatrixes for the water authority (SACMEX)
  * Distribution
	* The limit supermatrix
	* The unweighted supermatrix
	* The cluster supermatrix
  * Drainage
	* The limit supermatrix
	* The unweighted supermatrix
	* The cluster supermatrix


### Runoff scenarios

  * The runoff and precipitation for every census block for every combination of urban scenario and climate change scenario


## Outputs

The model gives as output a dataframe that is stored in a .rds object that contains all the variables that where used to run that specific run in the name

example:

effectivity_newInfra=0.25-effectivity_mantenimiento=0.25-decay_infra=0.25-Budget=1000-scenario=1-repetition=0.rds

the columns in these dataframes are:


Indicator | Name in output data-frame
-- | --
Id of census block | AGEB_ID
Municipality of each census block | municipio
Age of the infrastructure | antiguedad_D
Age of the infrastructure | antiguedad_Ab
frequency of ponding used to fit the ponding model | f_en
Number of events per year | encharca
Number of flooding events predicted by the flooding model  | nunda
Proportion of houses not connected to the potable water system | FALTA_IN
Capacity of the sewer/storm water system | capac_w
Proportion of houses not connected to the drainage system | falta_dren
Average number of days without piped water in a week | lambdas
Number of days without water in a week predicted by the water scarcity model | NOWater_week_pois
Number of  days during two weeks without piped water | NOWater_twoweeks
Number of  days during a month without piped water | days_wn_water_month
Number of days in a year without water | days_wn_water_year
Number of protests in a year | social_pressure
Sensitivity of residents to potable water scarcity. It reflects the number of interventions by the residents to modify their neighborhood | sensitivity_Ab
Sensitivity of residents to flooding. It reflects the number of interventions by the residents to modify their neighborhood | sensitivity_D
Indicator that combines the sensitivity to potable water scarcity, the exposure to water scarcity, and income | vulnerability_Ab
Indicator that combines the sensitivity to flooding, the exposure to flooding, and income | vulnerability_D
Indicator of the number interventions from sacmex associated to potable water infrastructure | Interventions_Ab
Indicator of the number interventions from sacmex associated to sewer and storm water infrastructure | Interventions_D
