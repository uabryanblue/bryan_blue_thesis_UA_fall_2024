# common functions for experimental electronics for this project

# read_climate_log_data: find all files in all sub directories specified by DATARAW
# any file name that starts with "CLIMATE" for the Temperature Humidity Pressure sensor is read into a single df
# this is the aspirated sensor hung next to the experiment
# partial data loss: 20240202_DL
read_climate_log_data <- function() {
  # only DL1 subfolders worth of data are loaded. When this data was not 
  # collected correctly, DL2 data was moved into the DL1 folder to ensure the 
  # most comprehensive data set.
  raw_climate_dl_data <- as.vector(grep("DL1", list.files(here(DATARAW), recursive = TRUE, pattern = "^CLIMATE"), value = TRUE))  %>%
    map_df(~read_csv(here(DATARAW, .),
                     col_names = 
                       c("DL_datetime", "Obs_number", "sensor_datetime", "sensor_MAC", "temp_C", "RH", "pressure", "readings_averaged"),
                     show_col_types = FALSE,))
  
   # change data types as needed
  # remove seconds from date/time fields, only precision to minutes
  raw_climate_dl_data$DL_datetime <- format(as.POSIXct(raw_climate_dl_data$DL_datetime), "%Y-%m-%d %H:%M:00")
  raw_climate_dl_data$sensor_datetime <- format(as.POSIXct(raw_climate_dl_data$sensor_datetime), "%Y-%m-%d %H:%M:00")
  # why does this have to be done 2x, and does not work if combined in one statement above?
  raw_climate_dl_data$DL_datetime <- as.POSIXct(raw_climate_dl_data$DL_datetime)
  raw_climate_dl_data$sensor_datetime <- as.POSIXct(raw_climate_dl_data$sensor_datetime)
  # make sure we only have values with ":" style, this does NOT catch HEX values
  raw_climate_dl_data$sensor_MAC <- gsub(':', '', toupper(raw_climate_dl_data$sensor_MAC))
  raw_climate_dl_data$sensor_MAC <- as.factor(raw_climate_dl_data$sensor_MAC)
  # if sd cards were not erased before reuse there could be duplication
  # if there were any readings that were only different in seconds, they will be cleaned out
  raw_climate_dl_data <- raw_climate_dl_data %>%
    distinct(DL_datetime, sensor_datetime, sensor_MAC, .keep_all=TRUE)
  
  # raw_climate_dl_data$sensor_MAC <- as.factor(raw_climate_dl_data$sensor_MAC)
  
   
  return(raw_climate_dl_data)
}

# data has already been wrangled in 01_wrangle_DL_logs.qmd
# read straight into df
read_clean_climate_data <- function(filename) {
  clean_climate_data <- read_csv(filename, # "clean_climate_data.csv"
                                 col_names = TRUE,
                                 show_col_types = FALSE) 
  # change data types as needed
  clean_climate_data$DL_datetime <- as.POSIXct(clean_climate_data$DL_datetime)
  clean_climate_data$sensor_datetime <- as.POSIXct(clean_climate_data$sensor_datetime)
  clean_climate_data$sensor_MAC <- gsub('^:', '', clean_climate_data$sensor_MAC)
  clean_climate_data$sensor_MAC <- as.factor(clean_climate_data$sensor_MAC)
  
  return(clean_climate_data)
}

# climate_hour_data: hourly averages of climate data
read_climate_hour_data <- function(filename) {
  climate_hour_data <- read_csv(filename, 
                           col_names = TRUE,
                           show_col_types = FALSE) 
  climate_hour_data$sensor_MAC <- as.factor(climate_hour_data$sensor_MAC)
  
  return(climate_hour_data)
}

# climate_hour_data: hourly averages of climate data
read_climate_day_data <- function(filename) {
  climate_day_data <- read_csv(filename, 
                                col_names = TRUE,
                                show_col_types = FALSE) 
  climate_day_data$sensor_MAC <- as.factor(climate_day_data$sensor_MAC)
  
  return(climate_day_data)
}

# raw_TRC_dl_data: any file name that starts with "TRC" for the Temperature Relay Control unit is read into a single df
# this is the unit that regulates and controls heating to the warmed leaf, it also records temperatures
# for the Treatment, Control, Reference leaves, the controlled heating pad, and the one that is always off
# each thermocouple reading also has it's cold junction recorded
# each cold junction temperature should be the same value or errors are introduced among measurements
read_TRC_log_data <- function() {
  raw_TRC_dl_data_DL1 <- as.vector(grep("DL1", list.files(here(DATARAW), recursive = TRUE, pattern = "^TRC"), value = TRUE))  %>%
    map_df(~read_csv(here(DATARAW, .),
                     col_names = 
                       c("DL_datetime", "Obs_number", "sensor_datetime", "sensor_MAC", "T1", "T2", "T3", "T4", "T5", "CJ1", "CJ2", "CJ3", "CJ4", "CJ5"),
                     show_col_types = FALSE,))
  
  
# data in the log "20240117_DL" under the DL1 folder is bad, there was a failure while I was not attending the expewriment
# - replace with datat in that log from DL2, which is correct
# missing data is between these records
# 48E729537E2C	2023-12-20T14:00:00Z	0.428	25.461	23.83	25.033	42.593	30.406	29.507	29.926	28.873	28.721	27.592	Warming Device Control	TRC4	3	NA
# 48E729537E2C	2024-01-17T14:00:00Z	0.0825	26.4375	25.45	26.355	44.28	35.395	30.2725	30.7375	29.755	29.6175	28.3825	Warming Device Control	TRC4	3	NA
# EXCEPTION: collecte DL2 data for bad data in DL1 in this file  "data_raw\20240117_DL"
 
  raw_TRC_dl_data_DL2 <- as.vector(grep("DL2", list.files(here(DATARAW, "20240117_DL"), recursive = TRUE, pattern = "^TRC"), value = TRUE))  %>%
    map_df(~read_csv(here(DATARAW, "20240117_DL", .),
                     col_names = 
                       c("DL_datetime", "Obs_number", "sensor_datetime", "sensor_MAC", "T1", "T2", "T3", "T4", "T5", "CJ1", "CJ2", "CJ3", "CJ4", "CJ5"),
                     show_col_types = FALSE,))
  
  
  # create one file with data from original DL1 data, and exceptions in DL2
  raw_TRC_dl_data <- bind_rows(raw_TRC_dl_data_DL1, raw_TRC_dl_data_DL2)
  
  # change data types as needed
  # remove seconds from date/time fields, only precision to minutes raw_TRC_dl_data$DL_datetime <- format(as.POSIXct(raw_TRC_dl_data$DL_datetime), "%Y-%m-%d %H:%M:00")
  raw_TRC_dl_data$DL_datetime <- format(as.POSIXct(raw_TRC_dl_data$DL_datetime), "%Y-%m-%d %H:%M:00")
  raw_TRC_dl_data$sensor_datetime <- format(as.POSIXct(raw_TRC_dl_data$sensor_datetime), "%Y-%m-%d %H:%M:00")
  # why does this have to be done 2x, and does not work if combined in one statement above?
  raw_TRC_dl_data$DL_datetime <- as.POSIXct(raw_TRC_dl_data$DL_datetime)
  raw_TRC_dl_data$sensor_datetime <- as.POSIXct(raw_TRC_dl_data$sensor_datetime)
  
  # make sure we only have values with ":" style, this does NOT catch HEX values
  raw_TRC_dl_data$sensor_MAC <- gsub(':', '', toupper(raw_TRC_dl_data$sensor_MAC))
  raw_TRC_dl_data$sensor_MAC <- as.factor(raw_TRC_dl_data$sensor_MAC)
  
  # if sd cards were not erased before reuse there could be duplication
  # if there were any readings that were only different in seconds, they will be cleaned out
  raw_TRC_dl_data <- raw_TRC_dl_data %>%
    distinct(DL_datetime, sensor_datetime, sensor_MAC, .keep_all=TRUE)

    
  return(raw_TRC_dl_data)
}

# read_TC_calibration_data: thermocouple calibration data is available in a CSV file
# it needs read into it's own data frame
read_TC_calibration_data <- function(filename) {
  # TC_calibration_data <- read_csv(here(DATARAW, "manual_2_pt_TC_calibration_values.csv"),
  TC_calibration_data <- read_csv(filename, # "manual_2_pt_TC_calibration_values.csv"
                                  col_names = TRUE,
                                  show_col_types = FALSE) 
  # TC_calibration_data$TC_Name <- as.factor(TC_calibration_data$TC_Name)
  
  return(TC_calibration_data)
}

# data has already been wrangled in 01_wrangle_DL_logs.qmd
# read straight into df
read_clean_TRC_data <- function(filename) {
  clean_TRC_data <- read_csv(filename, # "clean_climate_data.csv"
                             col_names = TRUE,
                             show_col_types = FALSE) 
  # change data types as needed
  clean_TRC_data$DL_datetime <- as.POSIXct(clean_TRC_data$DL_datetime)
  clean_TRC_data$sensor_datetime <- as.POSIXct(clean_TRC_data$sensor_datetime)
  clean_TRC_data$sensor_MAC <- gsub(':', '', toupper(clean_TRC_data$sensor_MAC))
  clean_TRC_data$sensor_MAC <- as.factor(clean_TRC_data$sensor_MAC)
  
  
  return(clean_TRC_data)
}


# TC_hour_data: hourly averages of calibrated thermocouples
read_TC_hour_data <- function(filename) {
  TC_hour_data <- read_csv(filename, 
                                  col_names = TRUE,
                                  show_col_types = FALSE) 
  TC_hour_data$sensor_MAC <- as.factor(TC_hour_data$sensor_MAC)
  
  return(TC_hour_data)
}

# read_TC_mapping_data: thermocouple to 735nm mapping data is available in a CSV file
# it needs read into it's own data frame
read_TC_mapping_data <- function(filename) {
  TC_map_data <- read_csv(filename, # "TRC_calibration_mapping.csv"
                          col_names = TRUE,
                          show_col_types = FALSE) 
  TC_map_data$sensor_MAC <- gsub(':', '', toupper(TC_map_data$sensor_MAC))
  TC_map_data$sensor_MAC <- as.factor(TC_map_data$sensor_MAC)
  # TC_map_data$board_pos <- as.factor(TC_map_data$board_pos)
  # TC_map_data$TC_name <- as.factor(TC_map_data$TC_name)
  # TC_map_data$level <- as.factor(TC_map_data$level)
  return(TC_map_data)
}

# read_TC_mapping_data: thermocouple to 735nm mapping data is available in a CSV file
# it needs read into it's own data frame
read_device_mapping_data <- function(filename) {
  MAC_data <- read_csv(filename, # "device_mapping.csv"
                       col_names = TRUE,
                       show_col_types = FALSE) 
  MAC_data$MAC <- gsub(':', '', toupper(MAC_data$MAC))
  MAC_data$MAC <- as.factor(MAC_data$MAC)
  return(MAC_data)
}

