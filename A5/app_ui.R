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
  p("This report covers the topic of carbon and greenhouse gas (GHG) emissions worldwide. This subject is important because as global temperatures rise and climate change threatens ecological, social, and economic stability, we mustn't ignore the fact that the primary driver of this change is the ever-growing amounts of CO2 and GHG emissions. However, no one country is responsible for the climate crisis and the production and consumption of greenhouse gasses are not equally distributed across the globe."),
  h3("Variables and Measurments"),
  p("Our World Data provides data on CO2 and GHG emissions in different countries. Using their dataset, the first variable I decided to look at was just overall annual total production-based emissions of carbon dioxide (CO2), including land-use change, measured in million tonnes (not including emissions embedded in traded goods). The next variables I used to look at distribution of emissions. One of the total greenhouse gas emissions including land-use change and forestry, measured in tonnes of carbon dioxide-equivalents per capita. Another is consumption CO2, which is the annual consumption-based emissions of carbon dioxide (CO2), measured in tonnes per person.  I also look at annual percentage growth in total production-based emissions of carbon dioxide (CO₂), excluding land-use change in each country. Finally, I wanted to analyze the annual net carbon dioxide (CO₂) emissions embedded in trade for each country, measured in million tonnes. A positive value means the country is a net importer, while negative is net exporter."),
  p("Something else that I was interested in was the different sources of co2 emissions and how they appear differently across the globe. The next page will show what percent of shares in global carbon emission different regions are responsible for."),
  h3("Values"),
  p("Using the Our World Data dataset, here are the statistics I found:"),
  textOutput("Value1"),
  textOutput("Value2"),
  textOutput("Value3"),
  textOutput("Value4"),
  textOutput("Value5")
)



# ___________________________ INTERACTIVE PAGE _________________________________

widget_one <- sliderInput(
  inputId = "year",
  label = "Year",
  min = 1950,
  max = 2021,
  value = c(1995, 2019)
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

widget_three <- checkboxGroupInput(
  inputId = "region", 
  label = "Region",
  choices = c("Asia", "Europe", "North America", "South America",
              "Australia", "Africa"),
  selected = c("Asia", "Europe", "South America")
)


page_two <- tabPanel(
  "Interactive Chart",
  titlePanel("Share of Global CO2"),
  sidebarLayout(
    sidebarPanel(
      widget_one,
      widget_two,
      widget_three
      ),
    mainPanel(
      plotlyOutput(outputId = "chart"),
      p("This is a bar graph that shows you the annual production-based emissions of CO2 (on the y-axis) from a CO2 source selected. You can choose emissions from coal, flaring, gas, land use change, oil, and other industries. The default graph will show the global share of CO2 production-based emissions from the total of all sources.  With the year shown on the x-axis, which you can also change the range for with the year slider input, you can view regional trends of emissions (decreasing or increasing) over time. For instance, in the default graph, you can see how Asia’s share of global CO2 emissions has increased, while South America has stayed fairly low. The different colors of the bar graph indicate the different regions (Asia, Europe, North America, South America, Australia, and Africa.")
    )
  )
)


# __________________________________ UI ______________________________________

ui <- navbarPage(
  theme = shinythemes::shinytheme("journal"),
  "Assignment 2: CO2 Trends",
  page_one,
  page_two
)

