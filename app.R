# EcoMetrics PH: 2025 SWM Compliance Dashboard
# Phase 5: Full Dashboard Implementation

library(shiny)
library(tidyverse) # Includes dplyr, tidyr, and ggplot2
library(plotly)    # For interactive hovering and zooming
library(leaflet)   # For geospatial performance mapping

# --- DATA CLEANING & PREPROCESSING ---
# Load the raw administrative logs
swm_raw <- read.csv("Consolidated_SWM_Raw_2025.csv", stringsAsFactors = FALSE)

# Step 2: Renaming columns to R-friendly labels
colnames(swm_raw)[1:17] <- c(
  "Region", "Province", "Total_LGUs", "Segregation_Count", "Segregation_Percent",
  "Collection_Count", "Collection_Percent", "Waste_Generated", "CoProcessing",
  "MRF_Diversion", "Diversion_Percent", "Theoretical_Gen", "Waste_SLF",
  "Waste_RCA", "WTE", "Waste_Collected", "Collection_Efficiency"
)

# Step 3 & 4: Remove summary rows and fill missing Region labels
swm_clean <- swm_raw %>%
  filter(Province != "" & !is.na(Province) & !grepl("Total", Province) & !grepl("GRAND", Region)) %>%
  fill(Region, .direction = "down")

# Step 5: Convert types and clean non-numeric characters (commas, dashes)
clean_val <- function(x) {
  x <- gsub(",", "", x)
  x <- gsub("%", "", x)
  x <- ifelse(x == "-" | x == "", "0", x)
  return(as.numeric(x))
}

cols_to_fix <- c("Waste_Generated", "Waste_Collected", "MRF_Diversion", "CoProcessing", "Collection_Efficiency")
swm_clean[cols_to_fix] <- lapply(swm_clean[cols_to_fix], clean_val)
swm_clean[is.na(swm_clean)] <- 0 # Handle NAs

# Step 6: Create Derived Metrics for Research Questions
swm_clean$Diversion_Gap <- swm_clean$Waste_Generated - swm_clean$Waste_Collected
swm_clean$Calc_Efficiency <- (swm_clean$Waste_Collected / swm_clean$Waste_Generated) * 100

# --- DASHBOARD UI ---
ui <- fluidPage(
  titlePanel("EcoMetrics PH: 2025 SWM Compliance Dashboard"),
  sidebarLayout(
    sidebarPanel(
      # Sidebar for filters to address localized LGU diagnostics
      selectInput("regionFilter", "Select Region:",
                  choices = c("All", unique(swm_clean$Region)), selected = "All"),
      helpText("Select a region to update the diagnostic charts and anomaly lists.")
    ),
    mainPanel(
      # Tabbed navigation for different research views
      tabsetPanel(
        tabPanel("Overview", plotlyOutput("generationPlot")),
        tabPanel("Diversion Gap", plotlyOutput("gapPlot")),
        tabPanel("Policy Correlation", plotlyOutput("correlationPlot")),
        tabPanel("Anomaly Detection", tableOutput("anomalyTable"))
      )
    )
  )
)

# --- SERVER LOGIC ---
server <- function(input, output) {
  # Reactive data filtering based on UI inputs
  filtered_data <- reactive({
    if (input$regionFilter == "All") {
      swm_clean
    } else {
      swm_clean[swm_clean$Region == input$regionFilter, ]
    }
  })
  
  # Q1: Regional Primary Drivers
  output$generationPlot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = reorder(Province, -Waste_Generated), y = Waste_Generated, fill = Region)) +
      geom_bar(stat = "identity") +
      theme_minimal() + 
      labs(title = "Top Waste Drivers (Tons/Year)", x = "Province", y = "Generated")
    ggplotly(p)
  })
  
  # Q2: Diversion Gap Analysis
  output$gapPlot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = Waste_Collected, y = Waste_Generated, color = Region)) +
      geom_point(aes(text = paste("Province:", Province, "<br>Gap:", Diversion_Gap))) +
      geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
      labs(title = "Generation vs. Collection Gap Analysis")
    ggplotly(p, tooltip = "text")
  })
  
  # Q3: Segregation vs. Efficiency Correlation
  output$correlationPlot <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = Segregation_Percent, y = Collection_Efficiency)) +
      geom_point() + 
      geom_smooth(method = "lm") +
      labs(title = "Policy Compliance vs. Operational Success")
    ggplotly(p)
  })
  
  # Q4 & Q5: Anomaly Registry (Listing top discrepancies)
  output$anomalyTable <- renderTable({
    filtered_data() %>%
      arrange(desc(abs(Diversion_Gap))) %>%
      select(Region, Province, Waste_Generated, Waste_Collected, Diversion_Gap) %>%
      head(10)
  })
}

shinyApp(ui = ui, server = server)
