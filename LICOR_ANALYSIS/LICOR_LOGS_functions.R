# common functions for LICOR-LOGS project

# convert Data_plant_id to experiment number
# 2 = 2
# 1 = 3-1
# 3 = 3-2
plantid_to_experiment <-function(Data_plant_id) {
  
  if (Data_plant_id == '1') {
    expnum <- '3-1'
    
  } else if (Data_plant_id == '3') {
    expnum <- '3-2'
  }else if (Data_plant_id == '2') {
    expnum <- '2'
  } else {
    expnum <- 'UNKNOWN EXPERIMENT'
  }
  return(expnum)
}


read_and_clean_data <- function(filename) {
  # fname <- here(DATAUSER, "final_raw_data.csv")
  finaldata <- read_csv(filename, # "final_raw_data.csv"
                        col_names = TRUE, 
                        show_col_types = FALSE) 
  
  # change any value in the df that is < zero to NA, invalid data
  finaldata[finaldata < 0] <- NA
  
  # try to auto convert all data types, not all work
  finaldata <- type.convert(finaldata, as.is = TRUE)
  # convert values that were not correctly auto converted
  finaldata$Data_leaftype <- as.factor(finaldata$Data_leaftype)
  # put the factors in order which will help with plots and other analysis
  finaldata$Data_leaftype <- factor(finaldata$Data_leaftype,
                         levels = c('Treatment','Control', 'Reference'), ordered = TRUE)
  finaldata$Filenames_filename <- as.factor(finaldata$Filenames_filename)
  finaldata$Data_plant_id <- as.factor(finaldata$Data_plant_id)
  
  # NOTE: this observation is turned into a date, not date/time, this is not correct
  # are new variable for "date" needs added
  # finaldata$SysObs_date <-  as.POSIXct(finaldata$SysObs_date, format = "%Y%m%d %H:%M:%S")
  # finaldata$SysObs_date <-     as.Date(finaldata$SysObs_date)
  
  # 3 Data_leaftype values are valid: Treatment, Control, Reference
  # ignore other values for Data_leaftype
  # Data_plant_id is an experiment reference: 1 is non-working installation
  # 2 and 3 are level 2 and 3 working experiments
  finaldata <- finaldata %>% 
    filter((Data_leaftype == "Treatment" |
              Data_leaftype == "Control" |
              Data_leaftype == "Reference") &
             (Data_plant_id == "2" |
                Data_plant_id == "3" |
                Data_plant_id == "1" )) 
  
  # Q was set to 500 on 11/17/2023 and 3/13/2024
  # for some readings. These need removed it should be Q of 700
  finaldata <- finaldata %>% 
    filter(LeafQ_Qin > 690.0) %>%
    # 11/22/2023 DATA, IT LOOKS OKAY
    # filter(SysObs_time > 1668543540) %>% 
    arrange(SysObs_date)
  

  
  return(finaldata)
}



# read in the LI-COR data with:
#    group (original)
#    name (converted with spaces replaced with underscores)
#    unit (original)
# convert to dataframe so that values can be referenced by row and column by names
# this is UTF-8 data which contains special characters
load_LICOR_variable_descriptions <- function(filename) {
  # load into a dataframe with variable names, units
  select_logdata_fields <- read_csv("data_user/input/select_logdata_fields.csv", 
                                    col_names = FALSE, show_col_types = FALSE)
  select_logdata_fields <- as.data.frame(select_logdata_fields)
  
  # the programs variable names are the group underscore variable name e.g. GasEx_A
  # LI-COR supplies a group 'GasEx', name 'A', and units (varies by group/name combinations)
  groups <- select_logdata_fields[1,]
  variables <- select_logdata_fields[2,]
  std_names <- paste(groups, variables, sep='_')

  # values are referenced by the internal program variable names, std_names
  colnames(select_logdata_fields) <- std_names
  rownames(select_logdata_fields) <- c('group', 'name', 'units')
  
  return(select_logdata_fields)
}

# climate_hour_data: hourly averages of climate data
read_climate_hour_data <- function(filename) {
  climate_hour_data <- read_csv(filename, 
                                col_names = TRUE,
                                show_col_types = FALSE) 
  climate_hour_data$sensor_MAC <- as.factor(climate_hour_data$sensor_MAC)
  
  return(climate_hour_data)
}

# TC_hour_data: hourly averages of calibrated thermocouples
read_TC_hour_data <- function(filename) {
  TC_hour_data <- read_csv(filename, 
                           col_names = TRUE,
                           show_col_types = FALSE) 
  TC_hour_data$sensor_MAC <- as.factor(TC_hour_data$sensor_MAC)
  
  return(TC_hour_data)
}
