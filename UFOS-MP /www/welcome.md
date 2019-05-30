<link href="styleMD.css" rel="stylesheet"></link>
# Welcome to UFO Sightings Shiny app! 
The authors of this shiny app  are:

<div class="center-block row" >

<div class=col-sm-6>
<img class="img-circle" src="paula.jpeg" width="200" height = "200"/>
<p> Paula Manzano Izquierdo </br>(<a href = "mailto:pamaiz@gmail.com">pamaiz@gmail.com</a>)</p>
</div>
  <div>
  <img class="img-circle" src="michael.jpeg" width="200" height = "200"/> 
  <p> Michael Michailidis </br>(<a href="mailto:michaelcmichailidis@gmail.com">michaelcmichailidis@gmail.com</a>)</p>
  </div>
</div> 

## About UFO Sightings Shiny app
This Shiny applications provides a friendly interface to let the users explore and analyse UFO Sightings dataset. The different features are separated by the following tabs:  

*  **Dataset**: This tab presents the two datasets used for the analysis. It is conformed by two subtabs:
  * **UFOs Dataset**: 
  * **Airports Dataset**: 
*  **Data Exploration**: This tab allows the user to explore the different variables of the dataset as well as the relationship between themselves. It is conformed by three subtabs:
  * **Map Visualization**: 
  * **Heatmap Visualization**: 
  * **Bubble Chart Visualization**:
 

## About UFO Sightings dataset
This dataset contains over 22,000 reports of UFO sightings in USA over the last century. It is conformed by the following variables:  

* **datetime**: Contains date and time of sighting 
*  **country**: Country of Sighting (USA only)
*  **city**: City in which UFO was sighted
*  **state**: State in which UFO was sighted
*  **shape**: Shape of the UFO
*  **duration (seconds)**: Duration of the Sighting in seconds
*  **latitude**: Latitude coordinate of the sighting
*  **longitude**: Longitude coordinate of the sighting

## Packages and libraries
This Shiny app uses several functions from a large quantity of packages. So in order for this app to work the next packages have to be install:

* shiny
* shinydashoard
* shinycssloaders
* shinyalert
* mapproj
* maps
* plotly
* dplyr


To install new packages execute the following command:

```
install.packages("name of the package")
```

And to add them to the environment:  

```
library(name of the packages)
```  



