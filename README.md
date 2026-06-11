EcoMetrics PH: 2025 Philippine Solid Waste Management Dashboard
EcoMetrics PH is a diagnostic data analytics environment designed to evaluate, validate, and visualize the operational and statistical realities of the 2025 Philippine regional solid waste pipelines. By engineering an analytical dashboard, this project helps administrative bodies optimize localized resource allocation, uncover deep compliance gaps, and pinpoint systemic administrative breakdowns.
👥 Authors

    Leader: Malonzo, Jed Gabriel D.
    Members: Abrazado, King C., Day, Isaac J., Madonan, Chromeranz P., Santos, Joshua M.
    Institution: Technological Institute of the Philippines - Quezon City
    Course: IT 030 - Data Analytics

🎯 Project Objectives
The primary goal is to address visibility failures in waste tracking by answering five key research questions:

    Which regions/provinces are the primary drivers of waste generation?
    What is the current gap between waste generation and successful diversion?
    Does "Segregation at Source" directly correlate with higher collection efficiency?
    Are there significant data anomalies or reporting discrepancies in provincial records?
    Where do the most significant statistical contradictions exist?

📊 Data Source
The analytical asset utilized is the official Consolidated Assessment of 2025 Regional SWM Data provided by the Department of Environment and Natural Resources (DENR).

    Data Type: Tabular Spreadsheet (CSV).
    Key Metrics: Total LGUs, segregation compliance, estimated waste generation, diversion weights (MRF/Co-processing), and collection efficiency scores.

🛠️ Tech Stack & Libraries
This project implements a full data analytics pipeline within the R runtime environment.

    Core Framework: R Shiny for interactive web application development.
    Data Manipulation: tidyverse (dplyr, tidyr) for cleaning and preprocessing.
    Visualizations:
        ggplot2: Foundational statistical plots.
        plotly: Interactive features (hover, zoom, selection).
        leaflet: Geospatial mapping and performance tracking.

🚀 How to Run the Application

    Clone the Repository:
    Install Required R Packages: Open R or RStudio and run:
    Launch the App: Ensure Consolidated_SWM_Raw_2025.csv is in the same directory as app.R. Open app.R and click "Run App" or execute shiny::runApp().

📈 Key Dashboard Features
The dashboard is organized into four diagnostic tabs:

    Overview: A bar chart identifying top waste drivers by province (e.g., NCR at 4.3M tons/year).
    Diversion Gap: A scatter plot visualizing the discrepancy between generation and collection, highlighting outliers like Bulacan and Laguna.
    Policy Correlation: A regression plot showing the moderate positive correlation (r = 0.42) between segregation compliance and operational efficiency.
    Anomaly Detection: A data registry listing the top 10 LGU discrepancies for immediate administrative validation.

📂 Repository Structure

    app.R: The complete Shiny application code (UI and Server logic).
    Consolidated_SWM_Raw_2025.csv: The cleaned dataset used by the application.
    README.md: This project documentation file.

This project was submitted in partial fulfillment of the requirements for IT 030 - Data Analytics (May 2026).
