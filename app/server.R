library(rdflib)
library(magrittr)
library(shiny)
library(shinydashboard)


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

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
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
  
  # The output$caption is computed based on a reactive expression that
  # returns input$caption. When the user changes the "caption" field:
  #
  #  1) This expression is automatically called to recompute the output 
  #  2) The new caption is pushed back to the browser for re-display
  # 
  # Note that because the data-oriented reactive expressions below don't 
  # depend on input$caption, those expressions are NOT called when 
  # input$caption changes.
  output$caption <- renderText({
    input$caption
  })
  
  # The output$summary depends on the datasetInput reactive expression, 
  # so will be re-executed whenever datasetInput is invalidated
  # (i.e. whenever the input$dataset changes)
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # The output$view depends on both the databaseInput reactive expression
  # and input$obs, so will be re-executed whenever input$dataset or 
  # input$obs is changed. 
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})