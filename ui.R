# getwd()
# setwd("../AJJJ_Group_Project")

library(plotly)
library(shiny)
source("piechart_education.R")
source("piechart_race.R")
source("babyplot.R")

ui <- fluidPage(
  # Title
  titlePanel("Child-Woman Ratio (Birthrate) Analysis"),
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
            
            h4("Our team has designed four analytical maps that show the change of birthrate overtime within the last five years from 2012 to 2016.
                The purpose of this project is to give the scholarly audiences perception of how certain race populations
                have a higher or lower probability of higher or lower birthrates while factoring in education, income and geographic 
                location through the art of data science. In this analysis, we implemented four maps using RStudio, which showed us the 
                statistics of child-woman ratio by state per year, income versus child-woman ratio analysis based on income per year for every state, 
                the changes of child-woman ratio per year for every state, race populations on average over the last five years, and the education
                attainment per year for every state. This project was designed by a group of four innovative Informatics students who are passionate 
                to make a difference in the world through data science. We believe that through this project on birthrate statistics and fields 
                such as race populations, geographic location and education and in the US will allow scholarly audiences to learn, analyze,
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
                        choices = list('Alabama' = 'Alabama', 'Alaska' = 'Alaska', 'Arizona' = 'Arizona', 'Arkansas' = 'Arkansas',
                                       'California' = 'California', 'Colorado' = 'Colorado', 'Connecticut' = 'Connecticut',
                                       'Delaware' = 'Delaware', 'District Of Columbia' = 'District of Columbia', 'Florida' = 'Florida',
                                       'Georgia' = 'Georgia', 'Hawaii' = 'Hawaii', 'Idaho' = 'Idaho', 'Illinois' = 'Illinois',
                                       'Indiana' = 'Indiana', 'Iowa' = 'Iowa', 'Kansas' = 'Kansas', 'Kentucky' = 'Kentucky',
                                       'Louisiana' = 'Louisiana', 'Maine' = 'Maine', 'Maryland' = 'Maryland', 'Massachusetts' = 'Massachusetts',
                                       'Michigan' = 'Michigan', 'Minnesota' = 'Minnesota', 'Mississippi' = 'Mississippi', 'Missouri' = 'Missouri',
                                       'Montana' = 'Montana', 'Nebraska' = 'Nebraska', 'Nevada' = 'Nevada',
                                       'New Hampshire' = 'New Hampshire', 'New Jersey' = 'New Jersey', 'New Mexico' = 'New Mexico',
                                       'New York' = 'New York', 'North Carolina' = 'North Carolina', 'North Dakota' = 'North Dakota',
                                       'Ohio' = 'Ohio', 'Oklahoma' = 'Oklahoma', 'Oregon' = 'Oregon', 'Pennsylvania' = 'Pennsylvania',
                                       'Rhode Island' = 'Rhode Island', 'South Carolina' = 'South Carolina', 'South Dakota' = 'South Dakota',
                                       'Tennessee' = 'Tennessee', 'Texas' = 'Texas', 'Utah' = 'Utah', 'Vermont' = 'Vermont', 'Virginia' = 'Virginia',
                                       'Washington' = 'Washington', 'West Virginia' = 'West Virginia', 'Wisconsin' = 'Wisconsin', 'Wyoming' = 'Wyoming')
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