# getwd()
# setwd("../AJJJ_Group_Project")

library('dplyr')
library('plotly')

# This is reading the data for past 5 years datasets
data.2012 <- read.csv("data/ACS_12_1YR_S0201/ACS_12_1YR_S0201.csv", stringsAsFactors = FALSE)
data.2013 <- read.csv("data/ACS_13_1YR_S0201/ACS_13_1YR_S0201.csv", stringsAsFactors = FALSE)
data.2014 <- read.csv("data/ACS_14_1YR_S0201/ACS_14_1YR_S0201.csv", stringsAsFactors = FALSE)
data.2015 <- read.csv("data/ACS_15_1YR_S0201/ACS_15_1YR_S0201.csv", stringsAsFactors = FALSE)
data.2016 <- read.csv("data/ACS_16_1YR_S0201/ACS_16_1YR_S0201.csv", stringsAsFactors = FALSE)

# This is the function that does data wrangling. This function calculates the each population by educational attainment.
educationByState <- function(dataset) {
  
  if (c("Estimate..EDUCATIONAL.ATTAINMENT...Less.than.high.school.diploma") %in% names(dataset)) {
    dataset$NumLessThanHighSchool <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Less.than.high.school.diploma / 100
    dataset$NumHighSchool <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...High.school.graduate..includes.equivalency. / 100
    dataset$NumAssociates <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Some.college.or.associate.s.degree / 100
    dataset$NumBachelors <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Bachelor.s.degree / 100
    dataset$NumGraduate <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Graduate.or.professional.degree / 100  
  } else {
    dataset$NumLessThanHighSchool <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over...Less.than.high.school.diploma / 100
    dataset$NumHighSchool <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over...High.school.graduate..includes.equivalency. / 100
    dataset$NumAssociates <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over...Some.college.or.associate.s.degree / 100
    dataset$NumBachelors <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over...Bachelor.s.degree / 100
    dataset$NumGraduate <- dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over * dataset$Estimate..EDUCATIONAL.ATTAINMENT...Population.25.years.and.over...Graduate.or.professional.degree / 100
  }
  
  pieinfo <- group_by(dataset, Geography) %>% summarize(totalLessThanHighSchool = sum(NumLessThanHighSchool))
  pieinfo2 <- group_by(dataset, Geography) %>% summarize(totalHighSchool = sum(NumHighSchool))
  pieinfo <- merge(pieinfo, pieinfo2, by = "Geography")
  pieinfo3 <- group_by(dataset, Geography) %>% summarize(totalAssociates = sum(NumAssociates))
  pieinfo <- merge(pieinfo, pieinfo3, by = "Geography")
  pieinfo4 <- group_by(dataset, Geography) %>% summarize(totalBachelors = sum(NumBachelors))
  pieinfo <- merge(pieinfo, pieinfo4, by = "Geography")
  pieinfo5 <- group_by(dataset, Geography) %>% summarize(totalGraduate = sum(NumGraduate))
  pieinfo <- merge(pieinfo, pieinfo5, by = "Geography")
  
  pieinfo$totalNumberEducationalAttainment <- pieinfo$totalLessThanHighSchool + pieinfo$totalHighSchool + pieinfo$totalAssociates + pieinfo$totalBachelors + pieinfo$totalGraduate
  return(pieinfo)
}

educationInfo2012 <- educationByState(data.2012)
educationInfo2013 <- educationByState(data.2013)
educationInfo2014 <- educationByState(data.2014)
educationInfo2015 <- educationByState(data.2015)
educationInfo2016 <- educationByState(data.2016)

# This function creates the dataset that sums all the population by education attainments, and returns the filtered data by state
chooseState <- function(state) {
  
  totalEducation <- data.2012 %>% select("Geography") %>% unique()
  totalEducation$totalNumLessThanHighSchool <- educationInfo2012$totalLessThanHighSchool + educationInfo2013$totalLessThanHighSchool + educationInfo2014$totalLessThanHighSchool + educationInfo2015$totalLessThanHighSchool + educationInfo2016$totalLessThanHighSchool
  totalEducation$totalNumHighSchool <- educationInfo2012$totalHighSchool + educationInfo2013$totalHighSchool + educationInfo2014$totalHighSchool + educationInfo2015$totalHighSchool + educationInfo2016$totalHighSchool
  totalEducation$totalNumAssociates <- educationInfo2012$totalAssociates + educationInfo2013$totalAssociates + educationInfo2014$totalAssociates + educationInfo2015$totalAssociates + educationInfo2016$totalAssociates
  totalEducation$totalNumBachelors <- educationInfo2012$totalBachelors + educationInfo2013$totalBachelors + educationInfo2014$totalBachelors + educationInfo2015$totalBachelors + educationInfo2016$totalBachelors
  totalEducation$totalNumGraduate <- educationInfo2012$totalGraduate + educationInfo2013$totalGraduate + educationInfo2014$totalGraduate + educationInfo2015$totalGraduate + educationInfo2016$totalGraduate
  totalEducation$totalNumEducationalAttainment <- educationInfo2012$totalNumberEducationalAttainment + educationInfo2013$totalNumberEducationalAttainment + educationInfo2014$totalNumberEducationalAttainment + educationInfo2015$totalNumberEducationalAttainment + educationInfo2016$totalNumberEducationalAttainment

  filterStateTotalEducation <- totalEducation %>% filter(Geography == state)
  return(filterStateTotalEducation)
}

# This function creates the pie chart of population by education attainments
makePieChartEducation <- function(stateName) {
  information <- chooseState(stateName)
  peopleNum <- c(information$totalNumLessThanHighSchool, information$totalNumHighSchool , information$totalNumAssociates, information$totalNumBachelors, information$totalNumGraduate)
  education <- c('less than high school', 'high school', 'associates', 'bachelors', 'graduate')
  data <- data.frame(peopleNum, education)
  p <- plot_ly(data, labels = ~education, values = ~peopleNum, type = 'pie',
               textposition = 'insie', 
               textinfo = 'label+percent',
               insidetextfont = list(color = "#FFFFFF"),
               hoverinfo = peopleNum,
               showlegend = FALSE) %>%
    layout(title= paste0('Educational Attainment in ', stateName),
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
}