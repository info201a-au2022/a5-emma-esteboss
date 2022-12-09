library("shiny")
library("rsconnect")
library("htmltools")
library("dplyr")
library("ggplot2")
library("plotly")
library("shinythemes")

#### Sourcing & Data ####
source("https://github.com/info201a-au2022/a5-emma-esteboss/raw/main/A5/app_server.R")

# ________________________________ INTRO PAGE __________________________________

page_one <- tabPanel(
  "Introduction",
  titlePanel("Exploring CO2 and GHG Emmissions Data"),
  h2("Intoduction"),
  p("This report looks at ")
)


# ___________________________ INTERACTIVE PAGE _________________________________

widget_one <- sliderInput(
  inputId = "year",
  label = "Year",
  min = 1950,
  max = 2021,
  value = 2021
)

widget_two <- selectInput(
  inputId = "source",
  label = "Source of CO2",
  choices = list("CO2 (all sources)" = "share_global_co2",
                 "Coal" = "share_global_coal_co2",
                 "Flaring" = "share_global_flaring_co2",
                 "Gas" = "share_global_gas_co2",
                 "Land Use Change" = "share_global_luc_co2",
                 "Oil" = "share_global_oil_co2",
                 "Other Industry" = "share_global_other_co2")
)

widget_three <-sliderInput(
  inputId = "range",
  label = "Range of Data",
  min = 0,
  max = 100,
  value = c(0, 25)
)

page_two <- tabPanel(
  "Interactive Chart",
  titlePanel("Share of Global CO2"),
  sidebarLayout(
    sidebarPanel(
      widget_one,
      widget_two,
      widget_three
      )
    ),
    mainPanel(
      plotlyOutput(outputId = "chart"),
      p("Caption goes here")
    )
)


# __________________________________ UI ______________________________________

ui <- navbarPage(
  theme = shinythemes::shinytheme("journal"),
  "Assignment 2: CO2 Trends",
  page_one,
  page_two
)

