# !!! --- make sure "pid.xxxxx" is resolved to its real URL --- !!!

library(rdflib)
library(magrittr)
library(shiny)
library(shinydashboard)

# competency questions

input_file <- rdf_parse(choose.files(caption = "ontology to access"), format = c("guess"))

sparql_cq1 <- '
prefix rdfs: <http:www.w3.org/2000/01/rdf-schema#>
prefix rdf: <http:www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix schema: <http://schema.org/>
prefix : <https://pid.xxxxx.com/ontologies/D3ASupplyChainBusinessOntology#>

SELECT ?products WHERE {?products a schema:Product} ORDER BY ?products'

cq1 <- rdf_query(input_file, sparql_cq1)

sparql_cq2 <- '
prefix rdfs: <http:www.w3.org/2000/01/rdf-schema#>
prefix rdf: <http:www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix schema: <http://schema.org/>
prefix : <https://pid.xxxxx.com/ontologies/D3ASupplyChainBusinessOntology#>

SELECT ?materials WHERE {?materials a :Material} ORDER BY ?materials'

cq2 <- rdf_query(input_file, sparql_cq2)

# Define server logic required to display the selected question and its respective result
shinyServer(function(input, output) {
  # visit https://shiny.rstudio.com/articles/basics.html ("Reactivity") for details
  # By declaring datasetInput as a reactive expression we ensure that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers (it 
  #     only executes a single time)
  #
  datasetInput <- reactive({
    switch(input$dataset,
           "What are the final products?" = cq1,
           "Which materials are being used?" = cq2)
  })
  
  
  # The output$view depends on both the databaseInput reactive expression
  # and input$obs, so will be re-executed whenever input$dataset or 
  # input$obs is changed. 
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})