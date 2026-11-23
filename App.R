# ==============================================================================
# Title: app.R
# Author: Justin Villani
# Date: 2026-11-20
# Purpose: For Shiny App
# ==============================================================================


library(shiny); library(uwot); library(NMF); library(mclust)

# Data + dimension reductions
TB <- readRDS("TBnanostring.rds")
x  <- as.matrix(TB[, -1])
y  <- TB$TB_Status

set.seed(1); um <- umap(x, n_neighbors = 15)
set.seed(1); W  <- basis(nmf(sweep(x, 2, apply(x, 2, min)), 2, nrun = 10))
red <- list(PCA = prcomp(x)$x[, 1:2], UMAP = um, NMF = W)


ui <- fluidPage(
  titlePanel("TB NanoString: dimension reduction + k-means"),
  sidebarLayout(
    sidebarPanel(
      selectInput("method", "Dimension reduction", c("PCA", "UMAP", "NMF")),
      numericInput("clusters", "Cluster count", 2, min = 1, max = 9)),
    mainPanel(
      plotOutput("plot1"),
      tableOutput("tab"),
      textOutput("ari"))))


server <- function(input, output, session) {

  selectedData <- reactive({
    red[[input$method]]})

  clusters <- reactive({
    set.seed(1)
    kmeans(selectedData(), input$clusters, nstart = 25)})

  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    plot(selectedData(), col = clusters()$cluster, pch = c(16, 17)[y], cex = 2,
         xlab = paste(input$method, 1), ylab = paste(input$method, 2))
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    legend("topright", legend = levels(y), pch = c(16, 17))})

  output$tab <- renderTable({
    as.data.frame.matrix(table(cluster = clusters()$cluster, TB = y))},
    rownames = TRUE)

  output$ari <- renderText({
    paste("Adjusted Rand index:",
          round(adjustedRandIndex(clusters()$cluster, y), 3))})}

shinyApp(ui = ui, server = server)
