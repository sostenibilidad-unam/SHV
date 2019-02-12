#procedure to read a climate scenario from table
#read table with id of scenarios
#based on argument climate_scenario select a row from the table
#create s string variable with the same of the csv with the climate data
#read the climate scenario
#The data frame with the values for the climate scenrios 
#is called in the cycle procedure 

Table_climate_scenarios=as.data.frame(read.csv("../geosimulation/runoff/db_escenarios_prec_esc_ids.csv",header = T))

#generate the path to the place where the data frame of the scenario is stored

scenario_name=Table_climate_scenarios[which(Table_climate_scenarios$id==scenario),]$path

print(scenario_name)

#to test I added to scenrio 1 the following path
#"../../data/" which is the same as "path_td" variable
#read the file and save it inside the run
runoff_scenario=read.csv(paste0("../geosimulation/runoff/outputs/", scenario_name),sep=",")
