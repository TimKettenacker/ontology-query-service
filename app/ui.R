library(rdflib)
library(magrittr)
library(shiny)
library(shinydashboard)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Reactivity"),
  
  # Sidebar with controls to provide a caption, select a dataset, and 
  # specify the number of observations to view. Note that changes made
  # to the caption in the textInput control are updated in the output
  # area immediately as you type
  sidebarPanel(
    textInput("caption", "Caption:", "Data Summary"),
    
    selectInput("dataset", "Choose a question to be answered by the ontology:", 
                choices = c("What are the final products?", "Which materials are being used?")),
    
    numericInput("obs", "Number of observations to view:", 10)
  ),
  
  
  # Show the caption, a summary of the dataset and an HTML table with
  # the requested number of observations
  mainPanel(
    h3(textOutput("caption")), 
    
    verbatimTextOutput("summary"), 
    
    tableOutput("view")
  )
))