library(shiny)
library(shinydashboard)
library(shinyWidgets)
# Resources
# https://github.com/mcpasin/PlayingGoogleAnalyticsDataViz/blob/master/app.R
# https://github.com/dreamRs/shinyWidgets
# http://shinyapps.dreamrs.fr/shinyWidgets/
# https://github.com/nik01010/dashboardthemes
# https://github.com/gyang274/ygdashboard
# https://www.spruko.com/demo/redash/dark-horizontal/index.html#
# https://rinterface.com/shiny/shinydashboardPlus/
# https://divadnojnarg.github.io/blog/awesomedashboards/
# http://code.markedmondson.me/gentelellaShiny/
# Icon Values from https://fontawesome.com/icons?from=io
########### GLobal
enableBookmarking(store = "url")
###########HEADER
header<- dashboardHeader(title = "Basic dashboard",titleWidth = 450)
###########SIDEBAR
sidebar <- dashboardSidebar(
    sidebarMenu(id = "sidebar",
                menuItem("DataLinks", tabName = "DataLinks", icon = icon("external-link-alt"),badgeLabel = "new", badgeColor = "green"),
                menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                menuItem("Widgets", tabName = "widgets", icon = icon("th"),badgeLabel = "new", badgeColor = "green"),
        
        menuItem("Source code for Data",href="https://github.com/CSSEGISandData/COVID-19", icon=icon("github")
    )
))

######################## BODY
### INFO BOX
InfoBoxes1 <- fluidRow(
    # A static infoBox
    valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
    # Dynamic infoBoxes
    valueBoxOutput("progressBox"),
    infoBoxOutput("approvalBox")
)
### PretyChekbox
pretycheckbox1<- prettyCheckboxGroup(
    inputId = "checkgroup2",
    label = "Click me!", thick = TRUE,
    choices = c("Click me !", "Me !", "Or me !"),
    animation = "pulse", status = "info"
)
### PrettyKnob
knobInput1<- knobInput(
    inputId = "myKnob",
    label = "jQuery knob example:",
    value = 0,
    min = -100,
    displayPrevious = TRUE, 
    lineCap = "round",
    fgColor = "#428BCA",
    inputColor = "#428BCA"
)
### Sliderinput
Sliderinput1 <- sliderTextInput(
    inputId = "mySliderText", 
    label = "Your choice:", 
    grid = TRUE, 
    force_edges = TRUE,
    choices = c("Strongly disagree",
                "Disagree", "Neither agree nor disagree", 
                "Agree", "Strongly agree")
)
###Sliderinput2
slideinput2 <- sliderInput("slider", "Number of observations:", 1, 100, 50)
### PickerInput
Pickerinput1 <- pickerInput(
    inputId = "myPicker", 
    label = "Select/deselect all + format selected", 
    choices = LETTERS, 
    options = list(
        `actions-box` = TRUE, 
        size = 10,
        `selected-text-format` = "count > 3"
    ), 
    multiple = TRUE
)

### BODY
body <-  dashboardBody(InfoBoxes1, tabItems(
    # First tab content
    tabItem(tabName = "dashboard",
            fluidRow(
                box(title = "Controls", slideinput2),pretycheckbox1, knobInput1,Sliderinput1,Pickerinput1)),
    # Second tab content
    tabItem(tabName = "widgets", 
            h2("Widgets tab content"),
            textInput("Id", "Label"),
            checkboxInput("caps", "Capitalize"),
            verbatimTextOutput("out"),
            bookmarkButton()),
    tabItem(tabName = "DataLinks",
            fluidRow( 
            box(
                title = "Link to Different Data", status = "success", solidHeader = TRUE,
                collapsible = TRUE, width = '100%', includeMarkdown("proteomiclinks.md")
            )))))

############UI
ui <- dashboardPage(skin="red",
    header,
    sidebar,
    body
   )


server <- function(input, output) { 
    setwd("F:/FINAL_CODES/R_Codes/Corona/ShinyApp/Corona")
    output$progressBox <- renderValueBox({
        valueBox(
            paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
            color = "purple"
        )
    })
    output$approvalBox <- renderInfoBox({
        infoBox(
            "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
            color = "yellow"
        )
    })
    
    output$textWithHTML <- renderUI({
        rawText <- readLines('markdow.md') # get raw text
        
        # split the text into a list of character vectors
        #   Each element in the list contains one line
        splitText <- stringi::stri_split(str = rawText, regex = '\\n')
        # wrap a paragraph tag around each element in the list
        replacedText <- lapply(splitText, p)
        return(replacedText)
    })
    
    }

shinyApp(ui, server)