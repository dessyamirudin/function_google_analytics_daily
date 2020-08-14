### this is a code to take the raw data from GA in daily bases instead of aggregation by week, month or certain time perios

setwd("C:/xxxxxxxxxxxxxxxxx")

library(googleAnalyticsR)
## don't install this package from CRAN as there is bug
## install from github https://github.com/MarkEdmondson1234/googleAnalyticsR
library(dplyr)
library(lubridate)
ga_auth()
account_list <- ga_account_list()

account_list$viewId
account_id = 	xxxxxxx
webPropertyId = "UA-xxxxxxx"

# list all custom metrics and custom dimension
custom_dim = ga_custom_vars_list(account_id,webPropertyId,type = c("customDimensions"))
custom_metrics = ga_custom_vars_list(account_id,webPropertyId,type = c("customMetrics"))
custom_event = ga_custom_vars_list(account_id,webPropertyId,type = c("customEvents"))

## getting the raw data for certain time period. from start to end
ga_id <- xxxxxxxxxxxxxx
raw_data = google_analytics(ga_id,
                 date_range = c("yyyy-mm-dd", "yyyy-mm-dd"),
                 metrics = c("sessions","sessionDuration","avgSessionDuration"),
                 dimensions = c("date","ga:dimension1"),
                 max=-1)

#### Code for looping API call daily ###
#### If not doing it daily, many data missing, such as when using the Supermetrics ####

# create function
############################ user id and metrics ###################
user_id_metrics = function(date_start,date_end){
  fetched_data = google_analytics(ga_id,
                                  date_range = c(date_start, date_end),
                                  metrics = c("sessions","sessionDuration","avgSessionDuration","ga:metricXX"),
                                  metrics = c("ga:metricXX"),
                                  dimensions = c("date","ga:dimension1"),
                                  max=-1)
  return(fetched_data)
}

################################################# USER ID PLAY SONG ####################################################
# create empty data frame
user_id_metrics = data.frame(date=as.Date(character()),
                        dimension1=character(), 
                        sessions=numeric(), 
                        sessionDuration=numeric(),
                        avgSessionDuration=numeric(),
                        metricXX=numeric()) # other metrics

# start date and end date
obs_date_start = as.Date("yyyy-mm-dd")
obs_date_end = as.Date("yyyy-mm-dd")

# data start point
obs_date = as.character(obs_date_start)
date_decrement = obs_date_start

while(date_decrement<= obs_date_end){
  print(paste("Date : ",obs_date))
  print("                   ")
  df = user_id_metrics(obs_date,obs_date)
  # df = user_id_song(obs_date_start,obs_date_end)
  user_id_metrics = bind_rows(user_id_metrics,df)
  date_decrement = date_decrement + 1
  obs_date = as.character(date_decrement)
  print("                   ")
}