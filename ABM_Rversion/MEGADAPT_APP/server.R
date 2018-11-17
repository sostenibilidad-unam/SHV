#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("setup.R")




#read setup code


# Define server logic required to draw 
shinyServer(function(input, output,session) {

  model <- eventReactive(input$Go,{
    Budget=input$budget
    source("cycle.R")
    studyArea_CVG@data$id = rownames(studyArea_CVG@data)
    studyArea_CVG.points = fortify(studyArea_CVG, region="id")
    studyArea_CVG.df = join(studyArea_CVG.points, studyArea_CVG@data, by="id")
    
return(studyArea_CVG.df)
})
output$plot3<-renderPlot({
  Out_model<-model()
  

  ggplot(Out_model) + 
    aes(long,lat,group=group,fill=antiguedad_D) + 
    geom_polygon() +
    geom_path(color="white") +
    coord_equal() +
    scale_fill_continuous("Age")
  
},width = 1000,height = 1000)
  
   output$plot2<-renderPlot({
     Output_value_function@data$id = rownames(Output_value_function@data)
     Output_value_function.points = fortify(Output_value_function, region="id")
     Output_value_function.df = join(Output_value_function.points, Output_value_function@data, by="id")
     
     ggplot(Output_value_function.df,aes(long,lat,group=group,fill=distance_ideal_A1_D)) + 
       geom_polygon() +
       geom_path(color="white") +
       coord_equal() +
       scale_fill_continuous("Distance")

   },height = 400,width = 600)
})