# getwd()
# setwd("../AJJJ_Group_Project")

library(plotly)
library(shiny)
source("piechart_education.R")
source("piechart_race.R")
source("babyplot.R")

ui <- fluidPage(
  # Title
  titlePanel("Child-Woman Ratio Analysis"),
  mainPanel( # decides what goes into main panel
    
    tabsetPanel(
      type = "tabs",
      
      ## Home panel that includes the short introduction of the project and CWR map.
      tabPanel(
        "Home",
        sidebarLayout(
          sidebarPanel (
             sliderInput("year", "Choose year", min = 2012, max = 2016, value = 2014)
          ),
          mainPanel(
            plotlyOutput("plot1"),
            
            h4("The purpose of the project, source of the data, and any pertinent information about the topic area are introduced.
                You may also want to include links to the code, or information about the team.
                Our team has designed four analytical maps that show the change of birthrate overtime within the last four years.
                The purpose of this project is to give the scholarly audiences perception of how certain race populations
                have a higher probability of higher birthrate while factoring in education, income and geographic location through the art of data science. 
                In this analysis, we implemented four maps using R Studio, which showed us the statistics of 
                This project was designed by a group of four innovative informatic students who are passionate to make a difference in a world through data science.
                We believe that through this project on birthrates statistics and fields such as race populations,
                geographic location and  education and  in the US will allow scholarly audiences to learn, analyze,
                and apply the knowledge extracted from big data.")
          )
        )
      ),
      
      # Provide a graph that shows the relationship between median household income and CWR.
      tabPanel(
        "Income vs. CWR",
        sidebarLayout(
          sidebarPanel (
            sliderInput("year2", "Choose year", min = 2012, max = 2016, value = 2014)
          ),
          mainPanel(
            plotlyOutput("plot2")
          )
        )
      ),
      
      ## Provide a graph showing changes in CWR over 5 years in selected state, and averaged distribution of each ethnic group
      ## and educational attainment
      tabPanel(
        "State Analysis",
        sidebarLayout(
          sidebarPanel (
            selectInput("state", "Choose State",
                        choices = list(Alabama = 'Alabama', Alaska = 'Alaska', Arizona = 'Arizona', Arkansas = 'Arkansas',
                                       California = 'California', Colorado = 'Colorado', Connecticut = 'Connecticut',
                                       Delaware = 'Delaware', DistrictOfColumbia = 'District of Columbia', Florida = 'Florida',
                                       Georgia = 'Georgia', Hawaii = 'Hawaii', Idaho = 'Idaho', Illinois = 'Illinois',
                                       Indiana = 'Indiana', Iowa = 'Iowa', Kansas = 'Kansas', Kentucky = 'Kentucky',
                                       Louisiana = 'Louisiana', Maine = 'Maine', Maryland = 'Maryland', Massachusetts = 'Massachusetts',
                                       Michigan = 'Michigan', Minnesota = 'Minnesota', Mississippi = 'Mississippi', Missouri = 'Missouri',
                                       Montana = 'Montana', Nebraska = 'Nebraska', Nevada = 'Nevada',
                                       NewHampshire = 'New Hampshire', NewJersey = 'New Jersey', NewMexico = 'New Mexico',
                                       NewYork = 'New York', NorthCarolina = 'North Carolina', NorthDakota = 'North Dakota',
                                       Ohio = 'Ohio', Oklahoma = 'Oklahoma', Oregon = 'Oregon', Pennsylvania = 'Pennsylvania',
                                       RhodeIsland = 'Rhode Island', SouthCarolina = 'South Carolina', SouthDakota = 'South Dakota',
                                       Tennessee = 'Tennessee', Texas = 'Texas', Utah = 'Utah', Vermont = 'Vermont', Virginia = 'Virginia',
                                       Washington = 'Washington', WestVirginia = 'West Virginia', Wisconsin = 'Wisconsin', Wyoming = 'Wyoming')
            ),
            radioButtons(
              "sort.by", "Sort by", c("Race", "Education")
            )
          ),
          mainPanel(
            plotlyOutput("plot4"),
            br(),
            br(),
            plotlyOutput("plot3")
          )
        )
      )
    )
  )
)


shinyUI(ui)