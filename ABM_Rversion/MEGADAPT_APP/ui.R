#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
#######################################################################################################
navbarPage(title="MEGADAPT APP",
           # Application title

           mainPanel(img(src="MEGADAPT_picture_inicio.png",
               height=600, 
               width=1260,
               align="Center")
               ,
           theme=shinytheme("lumen")
           ),
#######################################################################################################           
           tabPanel(tags$h2("Introduction"),
                    tags$div(
                      actionButton("Iniciar",inputId = "setup")
                    ),
                    tags$div(
                      
                      img(src="MEGADAPT_picture_inicio.png",
                          height=200, 
                          width=460),
                      tags$i(tags$h2("Text Here", align = "Left"))
                    )
                    
                    ),
#######################################################################################################           
           tabPanel(tags$h2("Study Area"),
                    tags$div(
                      tags$h4("Text About Mexico City")
                    )
            ),
#######################################################################################################
           tabPanel(tags$h2("Mental Model"),
                     tags$div(),
                    tags$div(
                      selectInput("criteria1", "Criteria1:",
                                  list("Abastecimiento"="Abast",
                                       "Antiguedad A" = "cyl", 
                                       "Antiguedad D" = "am", 
                                       "Basura" = "basura",
                                       "Capacidad drenaje"="Capacidad_D",
                                       "Capacidad red distribucion"="Capacidad_Ab",
                                       "Calidad_agua"="cal_agua",
                                       "Encharcamientos"="encharcamientos",
                                       "Escasez de agua"="water_scarcity",
                                       "Escurrimiento"="Escu",
                                       "Falla" = "gear",
                                       "Falta" = "falta",
                                       "Falta" = "falta", 
                                       "Falta" = "falta",
                                       "Gasto-hidraulico"="gast_hy",
                                       "Hundimientos"="hund",
                                       "Innundaciones"="flood",
                                       "Monto"="monto",
                                       "Peticiones Delegacionales"="per_del",
                                       "Peticiones de Usuarios" ="pet_deU",
                                       "Precipitaciones"="rain",
                                       "Presion Hidraulica"="Presion Hidraulica",
                                       "Presion de medios" ="pres_de_med",
                                       "Presion social" ="social_pressure"
                                       )
                                  )
                      
                    ),
                    tags$div(
                      selectInput("criteria2", "Criteria2:",
                                  list("Abastecimiento"="Abast",
                                       "Antiguedad A" = "cyl", 
                                       "Antiguedad D" = "am", 
                                       "Basura" = "basura",
                                       "Capacidad drenaje"="Capacidad_D",
                                       "Capacidad red distribucion"="Capacidad_Ab",
                                       "Calidad_agua"="cal_agua",
                                       "Encharcamientos"="encharcamientos",
                                       "Escasez de agua"="water_scarcity",
                                       "Escurrimiento"="Escu",
                                       "Falla" = "gear",
                                       "Falta" = "falta",
                                       "Falta" = "falta", 
                                       "Falta" = "falta",
                                       "Gasto-hidraulico"="gast_hy",
                                       "Hundimientos"="hund",
                                       "Innundaciones"="flood",
                                       "Monto"="monto",
                                       "Peticiones Delegacionales"="per_del",
                                       "Peticiones de Usuarios" ="pet_deU",
                                       "Precipitaciones"="rain",
                                       "Presion Hidraulica"="Presion Hidraulica",
                                       "Presion de medios" ="pres_de_med",
                                       "Presion social" ="social_pressure"
                                  )
                      )
                      
                    ),
                    mainPanel()
            ),
#######################################################################################################           
              tabPanel(tags$h2("Site Suitability"),
                    tags$div(
                      plotOutput("plot2")
                    )
           ),
#######################################################################################################           
           tabPanel(tags$h2("Site selection"),
                      tags$div(
                        numericInput(inputId="budget", label="Budget", value = 750,min =240,max =  2400, step = 10,width = 100) 
                        
                      )
           ),
#######################################################################################################           
           tabPanel(tags$h2("Biophisical Models"),
                    tags$div(
                    )
           ),
#######################################################################################################
           tabPanel(tags$h2("Run Simulation"),
                    tags$div(
                      actionButton("Go","Run_simulation")
                    ),
                    mainPanel(
                      plotOutput("plot3")
                    )
                    
           ),
#######################################################################################################           
            tabPanel(tags$h2("Contact"),
                    tags$div(
                    )
           )
)
#######################################################################################################
