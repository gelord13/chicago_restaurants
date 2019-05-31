
#Import data
chi_rest <- readOGR(".", "chicago_restaurant")


# Convert to sf
chi_rest <- st_as_sf(chi_rest)


# Clean Data
chi_rest <- subset(chi_rest, select = -c(AKA.Name, License.., Facility.T, 
                                         City, State, Zip, 
                                         Inspection, Inspecti_1))

chi_rest2 <- head(chi_rest, 100)


# Define UI for application that filters map points based on year and minimum population
ui <- fluidPage(
  
  # Application title
  titlePanel("Restaurants in Chicago"),
  
  # Sidebar with a slider input for year, numeric input for population 
  sidebarLayout(
    sidebarPanel(
      
      selectInput("Risk", label = h3("Risk"), 
                  choices = list("Risk 1 (High)" = 1,
                                 "Risk 2 (Medium)" = 2,
                                 "Risk 3 (Low)" = 3), 
                  selected = 1),
      
      
      radioButtons("Results", label = h3("Results"), 
                   choices = list("Passed" = 1,
                                  "Passed w/ Conditions" = 2,
                                  "Fail" = 3), 
                   selected = 1)
    ),
    
    # Show the map and table
    mainPanel(
      leafletOutput("chi_rest2")
    )
  )
)

# Define server logic required to draw a map and table
server <- function(input, output) {
  
  
  output$chi_rest2 <- renderLeaflet({
    leaflet(data = chi_rest2) %>%
      addTiles() %>%
      addMarkers()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)




# I tried to plot the entire data set but it is too large and would crash r every 
# time. 
# After cutting the data down, the shapefile plotted but it was in the wwrong 
# location
# I have tried changing the CRS (which is currently set to (
# +proj=utm +zone=16 +datum=WGS84 +units=m +no_defs).
# after trying to run
#  I tried st_set_crs() andmake_EPSG() but neither worked