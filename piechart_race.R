library(dplyr)
library(plotly)

# This is the function that gets the population by different race.
countingRaces <- function(stateName, race, fileName) {
  file <- fileName
  value <- 0
  if(race %in% file$Population.Group) {
    raceNumber <- filter(file, Geography == stateName) %>% filter(Population.Group == race)
    if (length(raceNumber$Estimate..SEX.AND.AGE...Total.population) == 0) {
      value <- 0
      
    } else {
      value <- raceNumber$Estimate..SEX.AND.AGE...Total.population + value
    }
  }
  return(value)
}

# This is the function that gets the mean of the population group.
countingPopulation <- function(stateName, race) {
  count <- 0
  count2012 <- countingRaces(stateName, race, data.2012)
  if (count2012 > 0) {
    count = count + 1
  } 
  count2013 <- countingRaces(stateName, race, data.2013)
  if (count2013 > 0) {
    count = count + 1
  } 
  count2014 <- countingRaces(stateName, race, data.2014)
  if (count2014 > 0) {
    count = count + 1
  } 
  count2015 <- countingRaces(stateName, race, data.2015)
  if (count2015 > 0) {
    count = count + 1
  } 
  count2016 <- countingRaces(stateName, race, data.2016)
  if (count2016 > 0) {
    count = count + 1
  } 
  
  value <- (count2012 + count2013 + count2014 + count2015 + count2016) / count
  return(value)
}

# This makes pie chart that shows us distribution of ethnic group
makePieChartRace <- function(stateName) {
  countingWhite <- countingPopulation(stateName, 'White alone')
  countingBlack <- countingPopulation(stateName, 'Black or African American alone')
  countingAsian <- countingPopulation(stateName, 'Asian alone(400-499')
  countingIndian <- countingPopulation(stateName, 'American Indian and Alaska Native alone (300, A01-Z99)')
  countingIslander <- countingPopulation(stateName, 'Native Hawaiian and Other Pacific Islander alone (500-599)')
  countingOthers <- countingPopulation(stateName, 'Some other race alone')
  races <- c(countingWhite, countingBlack, countingAsian, countingIndian, countingIslander, countingOthers)
  racestitle <- c('white', 'black', 'asian', 'American Indian and Native alone', 'Native Hawiian and Other Pacific Islander alone', 'Some other race alone')
  data <- data.frame(racestitle, races)
  p <- plot_ly(data, labels = ~racestitle, values = ~races, type = 'pie',
               textposition = 'insie', 
               textinfo = 'label+percent',
               insidetextfont = list(color = "#FFFFFF"),
               hoverinfo = races,
               showlegend = FALSE) %>%
    layout(title= paste0('Ethinic Groups in ', stateName),
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
}