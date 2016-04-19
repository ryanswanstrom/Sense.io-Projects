
# Load Data
# ---------
#
# Download and load list of colleges with data science degrees
#system('wget -N https://github.com/ryanswanstrom/awesome-datascience-colleges/raw/master/data_science_colleges.csv')
library('RCurl')
URL = 'https://raw.githubusercontent.com/ryanswanstrom/awesome-datascience-colleges/master/data_science_colleges.csv'
file = getURL(URL)
ds_colleges <- read.csv(text=file,strip.white=TRUE,stringsAsFactors=FALSE)
head(ds_colleges)
summary(ds_colleges$STATE)

## Just get US programs
US_ds_colleges = ds_colleges[ds_colleges$COUNTRY == 'US' & ds_colleges$STATE != '',]
summary(US_ds_colleges$STATE)

## count by state
US_ds_colleges_by_state = data.frame(table(US_ds_colleges$STATE))
US_ds_colleges_by_state
library('plyr')
US_ds_colleges_by_state=rename(US_ds_colleges_by_state, c("Var1"="state", "Freq"="num_ds"))

## Remove the empty row
#US_ds_colleges_by_state = US_ds_colleges_by_state[US_ds_colleges_by_state$state != '',]
#US_ds_colleges_by_state$state = as.character(US_ds_colleges_by_state$state)

require(devtools)
install_github('ramnathv/rCharts@dev')
install_github('ramnathv/rMaps')
#install.packages('rjson')
#library('rjson')
library('rMaps')


#' Draw an interactive choropleth map
#' Fixes the problem of not displaying the lowest value
#' 
#' 
#' 
ichoropleth <- function(x, data, pal = "Blues", ncuts = 5, animate = NULL, play = F, map = 'usa', legend = TRUE, labels = TRUE, ...){
  d <- Datamaps$new()
  fml = lattice::latticeParseFormula(x, data = data)
  data = transform(data, 
    fillKey = cut(
      fml$left, 
      quantile(fml$left, seq(0, 1, 1/ncuts)),
      ordered_result = TRUE,
      include.lowest = TRUE
    )
  )
  fillColors = brewer.pal(ncuts, pal)
  d$set(
    scope = map, 
    fills = as.list(setNames(fillColors, levels(data$fillKey))), 
    legend = legend,
    labels = labels,
    ...
  )
  if (!is.null(animate)){
    range_ = summary(data[[animate]])
    data = dlply(data, animate, function(x){
      y = toJSONArray2(x, json = F)
      names(y) = lapply(y, '[[', fml$right.name)
      return(y)
    })
    d$set(
      bodyattrs = "ng-app ng-controller='rChartsCtrl'"  
    )
    d$addAssets(
      jshead = "http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.1/angular.min.js"
    )
    if (play == T){
      d$setTemplate(chartDiv = sprintf("
        <div class='container'>
         <button ng-click='animateMap()'>Play</button>
         <span ng-bind='year'></span>
         <div id='{{chartId}}' class='rChart datamaps'></div>
        </div>
        <script>
          function rChartsCtrl($scope, $timeout){
            $scope.year = %s;
              $scope.animateMap = function(){
              if ($scope.year > %s){
                return;
              }
              map{{chartId}}.updateChoropleth(chartParams.newData[$scope.year]);
              $scope.year += 1
              $timeout($scope.animateMap, 1000)
            }
          }
       </script>", range_[1], range_[6])
      )
      
    } else {
      d$setTemplate(chartDiv = sprintf("
        <div class='container'>
          <input id='slider' type='range' min=%s max=%s ng-model='year' width=200>
          <span ng-bind='year'></span>
          <div id='{{chartId}}' class='rChart datamaps'></div>          
        </div>
        <script>
          function rChartsCtrl($scope){
            $scope.year = %s;
            $scope.$watch('year', function(newYear){
              map{{chartId}}.updateChoropleth(chartParams.newData[newYear]);
            })
          }
       </script>", range_[1], range_[6], range_[1])
      )
    }
    d$set(newData = data, data = data[[1]])
    
  } else {
    d$set(data = dlply(data, fml$right.name))
  }
  return(d)
}

ichoropleth(num_ds ~ state, data = US_ds_colleges_by_state, pal='Oranges',ncuts=3)

## divide by colleges per state, how many programs are offered as a percentage of the total number of colleges/universities per state
# read in the opendata of colleges listed by state
state_colleges = read.csv('postscndryunivsrvy2013dirinfo.csv',strip.white=TRUE,stringsAsFactors=FALSE)
state_colleges_count = data.frame(table(state_colleges$STABBR))

state_colleges_count=rename(state_colleges_count, c("Var1"="state", "Freq"="total"))

## Merge with data science college list

state_colleges_count = merge(state_colleges_count, US_ds_colleges_by_state, by='state', all.x=TRUE)

# convert NA to 0, remove non states
state_colleges_count[is.na(state_colleges_count$num_ds),]$num_ds = 0
state_colleges_count = state_colleges_count[!(state_colleges_count$state %in% c('FM','GU','PW','PR','MP','MH','AS','VI')),]

# calculate percentage
state_colleges_count$percent = state_colleges_count$num_ds/state_colleges_count$total

## Plot Just the Count
#ichoropleth(ds_colleges ~ state, data = state_colleges_count, pal='YlOrRd',ncuts=4)


## Plot the Percentage
ichoropleth(percent*100 ~ state, data = state_colleges_count, pal='Oranges',ncuts=3)


## Declare a winning state
state_colleges_count[order(-state_colleges_count$percent),]

