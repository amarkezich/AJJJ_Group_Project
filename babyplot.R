# getwd()
# setwd("../AJJJ_Group_Project")

library(dplyr)
library(plotly)

# This calculates the babyPopulation in this past 5 years
dataset2012 <- mutate(data.2012, babyPopulation = data.2012$Estimate..SEX.AND.AGE...Total.population * (data.2012$Estimate..SEX.AND.AGE...Under.5.years/100) )
dataset2013 <- mutate(data.2013, babyPopulation = data.2013$Estimate..SEX.AND.AGE...Total.population * (data.2013$Estimate..SEX.AND.AGE...Under.5.years/100) )
dataset2014 <- mutate(data.2014, babyPopulation = data.2014$Estimate..SEX.AND.AGE...Total.population * (data.2014$Estimate..SEX.AND.AGE...Under.5.years/100) )
dataset2015 <- mutate(data.2015, babyPopulation = data.2015$Estimate..SEX.AND.AGE...Total.population * (data.2015$Estimate..SEX.AND.AGE...Under.5.years/100) )
dataset2016 <- mutate(data.2016, babyPopulation = data.2016$Estimate..SEX.AND.AGE...Total.population * (data.2016$Estimate..SEX.AND.AGE...Under.5.years/100) )

# This calculates child woman ratio by each row
babyPopulation <- function(dataName ,year) {
  totalBaby <- group_by(dataName, Geography) %>% summarize(totalBabyPopulation = sum(babyPopulation))
  totalWomen <- group_by(dataName, Geography) %>% summarize(totalWomen = sum(Estimate..FERTILITY...Women.15.to.50.years))
  totalBaby <- mutate(totalBaby, cwr = (totalBaby$totalBabyPopulation/totalWomen$totalWomen)*1000)
  return(totalBaby)
}

totalBaby2012 <- babyPopulation(dataset2012)
totalBaby2013 <- babyPopulation(dataset2013)
totalBaby2014 <- babyPopulation(dataset2014)
totalBaby2015 <- babyPopulation(dataset2015)
totalBaby2016 <- babyPopulation(dataset2016)

# This filteres the data by stateName
filterData <- function(dataName, stateName) {
  data <- filter(dataName, Geography == stateName)
  return(data)
}

# This function makes the graph that shows child women ratio by year.
makeGraph <- function(stateName) {
  data2012 <- filterData(totalBaby2012, stateName)
  data2013 <- filterData(totalBaby2013, stateName)
  data2014 <- filterData(totalBaby2014, stateName)
  data2015 <- filterData(totalBaby2015, stateName)
  data2016 <- filterData(totalBaby2016, stateName)
  
  year <- c("2012", "2013", "2014", "2015", "2016")
  number <- c(data2012$cwr, data2013$cwr, data2014$cwr, data2015$cwr, data2016$cwr)
  
  df <- data.frame(year, number)
  
  plotData <- plot_ly(df, x = ~year, y = ~number, type = 'scatter', mode = 'lines', 
                      line = list(color = 'rgb(205, 12, 24)', width = 3)) %>% 
    layout(title = paste0('Changes in Child-Woman Ratio in ', stateName),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Child-Woman Ratio'))
}

