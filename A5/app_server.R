library("shiny")
library("rsconnect")
library("htmltools")
library("dplyr")
library("tidyr")
library("ggplot2")
library("plotly")
library("shinythemes")

#### Sourcing & Data ####
data <- read.csv("https://github.com/owid/co2-data/raw/master/owid-co2-data.csv", stringsAsFactors = FALSE)
source("https://raw.githubusercontent.com/info201a-au2022/a5-emma-esteboss/main/A5/app_ui.R")

## Exploration Stuff ####
unique(data$country)
length(unique(data$country)) # 269
unique(data$year)
colnames(data)

### Editing Data Frame ###
a5_data <- data %>%
  filter(year >= 1950) %>%
  select("country", "year", "iso_code", "population", "gdp", 
         "co2", "co2_growth_abs", 
         "co2_growth_prct", "co2_including_luc", 
         "co2_including_luc_growth_abs", "co2_including_luc_growth_prct", 
         "co2_including_luc_per_capita", "co2_including_luc_per_gdp", 
         "co2_per_capita", "co2_per_gdp", 
         "consumption_co2", "consumption_co2_per_capita", 
         "cumulative_co2", "cumulative_co2_including_luc", 
         "cumulative_luc_co2", "energy_per_capita", 
         "energy_per_gdp", "ghg_excluding_lucf_per_capita", 
         "ghg_per_capita", "land_use_change_co2", 
         "land_use_change_co2_per_capita", "methane", 
         "methane_per_capita", "share_global_co2", 
         "share_global_co2_including_luc", "share_global_cumulative_co2", 
         "share_global_cumulative_co2_including_luc", "share_global_cumulative_luc_co2", 
         "share_global_luc_co2", "total_ghg", 
         "total_ghg_excluding_lucf", "trade_co2", 
         "trade_co2_share")

# ----------------------------- ### VALUES ### ---------------------------------

# Value 1 ______________________________________________________________________
# Country with the highest / lowest GHG per capita (and what 
# are those values) in 2019?

ghg_percapita <- a5_data %>%
  select("country", "year", "ghg_per_capita") %>%
  filter(year == 2019) %>%
  drop_na(ghg_per_capita)

ghg_percap_lowest_country <- ghg_percapita %>%
  filter(ghg_per_capita == min(ghg_per_capita)) %>%
  pull(country)

ghg_percap_lowest <- ghg_percapita %>%
  filter(ghg_per_capita == min(ghg_per_capita)) %>%
  pull(ghg_per_capita)

ghg_percap_highest_country <- ghg_percapita %>%
  filter(ghg_per_capita == max(ghg_per_capita)) %>%
  pull(country)

ghg_percap_highetst <- ghg_percapita %>%
  filter(ghg_per_capita == max(ghg_per_capita)) %>%
  pull(ghg_per_capita)

# Value 2 ______________________________________________________________________
# Top 5 countries for consumption CO2 per capita in 2020?

avg_consumption_percap <- a5_data %>%
  select("country", "year", "consumption_co2_per_capita") %>%
  filter(year == 2020) %>%
  drop_na(consumption_co2_per_capita) %>%
  arrange(-consumption_co2_per_capita) %>%
  head(consumption_co2_per_capita, n=5) %>%
  pull(country)

# Value 3 ______________________________________________________________________
# Country with highest / lowest CO2 growth? Trade_CO2?

# data frame
co2_growth <- a5_data %>%
  select("country", "year", "co2_growth_prct", "co2_including_luc_growth_prct")

co2_growth_lowest_country <- co2_growth %>%
  filter(year == 2021) %>%
  drop_na(co2_growth_prct) %>%
  filter(co2_growth_prct == min(co2_growth_prct)) %>%
  pull(country)

co2_growth_lowest <- co2_growth %>%
  filter(year == 2021) %>%
  drop_na(co2_growth_prct) %>%
  filter(co2_growth_prct == min(co2_growth_prct)) %>%
  pull(co2_growth_prct)

co2_growth_lowest2021_in1990 <- co2_growth %>%
  filter(year == 2000,
         country == co2_growth_lowest_country) %>%
  pull(co2_growth_prct)

# The country with the lowest co2 growth percentage was Bosnia and Herzegovina
# with a score of -35.192 growth in 2021. Two decades earlier (in 2000)
# it was 32.063 percent.

co2_growth_highest_country <- co2_growth %>%
  filter(year == 2021) %>%
  drop_na(co2_growth_prct) %>%
  filter(co2_growth_prct == max(co2_growth_prct)) %>%
  pull(country)

co2_growth_highest <- co2_growth %>%
  filter(year == 2021) %>%
  drop_na(co2_growth_prct) %>%
  filter(co2_growth_prct == max(co2_growth_prct)) %>%
  pull(co2_growth_prct)

co2_growth_highest2021_in1990 <- co2_growth %>%
  filter(year == 2000,
         country == co2_growth_highest_country) %>%
  pull(co2_growth_prct)

# The country with the highest co2 growth percentage was Libya
# with a score of 27.252 percent growth in 2021. Two decades earlier (in 2000)
# it was 5.461 percent.

# Value 4 ______________________________________________________________________
# Country with highest / lowest trade CO2?

# data frame
trade_co2data <- a5_data %>%
  select("country", "year", "trade_co2") %>%
  filter(year == 2020) %>%
  drop_na(trade_co2) %>%
  filter(country != "Upper-middle-income countries") %>%
  filter(country != "Asia") %>%
  filter(country != "High-income countries") %>%
  filter(country != "European Union (28)") %>%
  filter(country != "European Union (27)") %>%
  filter(country != "Europe")

trade_co2_lowest_country <- trade_co2data %>%
  filter(trade_co2 == min(trade_co2)) %>%
  pull(country)

trade_co2_lowest <- trade_co2data %>%
  filter(trade_co2 == min(trade_co2)) %>%
  pull(trade_co2)

trade_co2_highest_country <- trade_co2data %>%
  filter(trade_co2 == max(trade_co2)) %>%
  pull(country)

trade_co2_highest <- trade_co2data %>%
  filter(trade_co2 == max(trade_co2)) %>%
  pull(trade_co2)

# Value 5 ______________________________________________________________________
# Global difference of CO2 from 1990 to 2021?

co2_emissions <- a5_data %>%
  select("country", "year", "co2_including_luc", "co2") %>%
  rename("CO2" = "co2") %>%
  group_by(year)

co2_1950 <- co2_emissions %>%
  filter(year == 1950) %>%
  summarize(CO2 = sum(CO2, na.rm = TRUE),
            co2_including_luc = sum(co2_including_luc, na.rm = TRUE)) %>%
  pull(CO2)
  
co2_1990 <- co2_emissions %>%
  filter(year == 1990) %>%
  summarize(CO2 = sum(CO2, na.rm = TRUE),
            co2_including_luc = sum(co2_including_luc, na.rm = TRUE)) %>%
  pull(CO2)

co2_2021 <- co2_emissions %>%
  filter(year == 2021) %>%
  summarize(CO2 = sum(CO2, na.rm = TRUE),
            co2_including_luc = sum(co2_including_luc, na.rm = TRUE)) %>%
  pull(CO2)

co2_difference1950to2021 <- co2_2021 - co2_1950

# ---------------------- ### INTERACTIVE SECTION ### ---------------------------

### Editing Data Frame ###
continents <- c("Asia", "Europe", "North America", "South America",
                "Australia", "Africa")
chart_data <- data %>%
  filter(year >= 1950) %>%
  select("country", "year", 
         "share_global_co2", 
         "share_global_coal_co2",
         "share_global_flaring_co2",
         "share_global_gas_co2", 
         "share_global_luc_co2", 
         "share_global_oil_co2", 
         "share_global_other_co2") %>%
  filter(country %in% continents) %>%
  rename("region" = country)

### Server ###
server <- function(input, output) {
  output$chart <- renderPlotly({
    shiny_chart_data <- chart_data %>%
      filter(year %in% (input$year[1]:input$year[2])) %>%
      filter(region %in% c(input$region)) %>%
      select("region", "year", input$source)
    plot <- ggplot(data = shiny_chart_data) +
      geom_bar(mapping = aes(x = year, 
                             y = .data[[input$source]],
                             fill = region),
               stat = "identity",
               position = "dodge") +
      theme(axis.text.x = element_text(angle = 60)) +
      labs(title = "Global Share in Different CO2 Sources",
           caption = "This is what the data shows.",
           x = "Year",
           y = "Share of CO2 (percentage)"
      )
    shiny_chart <- ggplotly(plot)
    shiny_chart
  })
}




