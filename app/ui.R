library(rdflib)
library(magrittr)
library(shiny)
library(shinydashboard)

# Define UI for ontology viewer application

  
  # Application title
  header <- dashboardHeader(title = "Ontology Query Service", titleWidth = 275)
  
  # sidebar with controls to provide tabs (possible tab for the future includes "ontology selection" to switch between
  # different ontologies to query) 
  
  sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Query Ontology", tabName = "Query", icon = icon("question-circle"))
    )
  )


  # display interactive session to choose from a set of pre-defined competency questions that the ontology
  # is supposed to answer
  
  body <- dashboardBody(
    selectInput("dataset", "Choose a question to be answered by the ontology:", 
                choices = c("What are the final products?", "Which materials are being used?")),
    
    numericInput("obs", "Number of observations to view:", 10),
    
    tableOutput("view")
  )

  dashboardPage(header, sidebar, body, skin = "yellow")