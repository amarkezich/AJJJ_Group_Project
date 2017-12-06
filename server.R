# getwd()
# setwd("../AJJJ_Group_Project")

library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
source("piechart_education.R")
source("piechart_race.R")
source("babyplot.R")

# a dataframe used to match the user input from slider bar.
index.finder <- data.frame(year = c("2012", "2013", "2014", "2015", "2016"))

# stores datasets in a list
data.collection <- list("2012" = data.2012, "2013" = data.2013, "2014" = data.2014,
                        "2015" = data.2015, "2016" = data.2016)


server <- function(input, output) {
  
  # Reactive dataset for map data that changes by user input.
  map.data <- reactive({
    row.index <- which(index.finder$year == input$year)
    data.20xx <- data.collection[[row.index]]
    data.20xx <- mutate(data.20xx, number.of.children =
                 data.20xx$Estimate..SEX.AND.AGE...Total.population * (data.20xx$Estimate..SEX.AND.AGE...Under.5.years / 100))
    
    total.fertility <- group_by(data.20xx, Geography) %>%
                       summarize(fertility = sum(Estimate..FERTILITY...Women.15.to.50.years))
    
    total.number.of.children <- group_by(data.20xx, Geography) %>%
                                summarize(children = sum(number.of.children))
    
    map.data <- merge(total.number.of.children, total.fertility, by = "Geography")
    map.data <- mutate(map.data, child.woman.ratio = children / fertility * 1000)
    map.data <- mutate(map.data, code = c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE",
                                                      "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA",
                                                      "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN",
                                                      "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM",
                                                      "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI",
                                                      "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                                      "WV", "WI", "WY"))
  })
  
  # Reactive dataset for income vs CWR graph that changes by user input.
  income.data <- reactive({
    row.index <- which(index.finder$year == input$year2)
    data.20xx <- data.collection[[row.index]]
    data.20xx <- mutate(data.20xx, number.of.children =
                 data.20xx$Estimate..SEX.AND.AGE...Total.population * (data.20xx$Estimate..SEX.AND.AGE...Under.5.years / 100))
    
    incomeColumn <- "Estimate..INCOME.IN.THE.PAST.12.MONTHS..IN."
    
    if(input$year2 == 2012) {
      incomeColumn <- paste0(incomeColumn, 2012,
                             ".INFLATION.ADJUSTED.DOLLARS....Median.household.income..dollars.")
    } else {
      incomeColumn <- paste0(incomeColumn, input$year2,
                             ".INFLATION.ADJUSTED.DOLLARS....Households...Median.household.income..dollars.")
    }
    colnames(data.20xx)[colnames(data.20xx) == incomeColumn] <- "medianIncome"
    
    total.fertility <- group_by(data.20xx, Geography) %>%
      summarize(fertility = sum(Estimate..FERTILITY...Women.15.to.50.years))
    
    total.number.of.children <- group_by(data.20xx, Geography) %>%
      summarize(children = sum(number.of.children))
    
    median.income <- group_by(data.20xx, Geography) %>% summarize(MedianIncome = mean(medianIncome))
    
    income.data <- merge(total.number.of.children, total.fertility, by = "Geography")
    income.data <- mutate(income.data, child.woman.ratio = children / fertility * 1000)
    income.data <- merge(income.data, median.income)
  })
  
  
  # Draw map
  output$plot1 <- renderPlotly({
    boundaries <- list(color = toRGB("white"), width = 2)
    
    map.layout <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    
    p <- plot_geo(map.data(), locationmode = 'USA-states') %>%
      add_trace(
        z = ~child.woman.ratio, text = ~Geography, locations = ~code,
        color = ~child.woman.ratio, colors = 'Greens'
      ) %>%
      colorbar(title = "Child-Woman Ratio") %>%
      layout(
        title = paste0(input$year, ' Child-Woman Ratio by State<br>(Hover for breakdown)'),
        geo = map.layout
      )
  })
  

  # Income vs. CWR
  output$plot2 <- renderPlotly({
    p <- plot_ly(data = income.data(), x = ~MedianIncome, y = ~child.woman.ratio, color = ~Geography)%>% 
      layout(title = 'Income vs. CWR',
             xaxis = list(title = 'Income'),
             yaxis = list(title = 'Child-Woman Ratio'))
  })
  
  # pie-chart of ethnic group distribution and educational attainment
  output$plot3 <- renderPlotly({
    if (input$sort.by == "Race") {
      makePieChartRace(input$state)
    } else {
      makePieChartEducation(input$state)
    }
  })
  
  # a graph showing changes in CWR over 5 years in selected state.
  output$plot4 <- renderPlotly({
    makeGraph(input$state)
  })
}

shinyServer(server)