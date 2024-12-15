# copy of data_raw exists in original_dat_raw
Although data_raw is considered read only, these data files needed to be cleaned up.  
  
## NO data was manipulated, file locations were changed
Two dataloggers, DL1 and DL2 recorded data. If one malfunctioned, the best data set was placed into the DL1 folder in different ways depending on the situation.  
  
### R scripts only scan DL1 folders
This could be done in a better way, but this solution was chosen. All original files are in the data_raw_original folder under the root of this project. 

- DL1 data was all incorrect, DL2 was okay, DL1 copy was created and DL2 data was placed into a DL1 folder.
- logs that contained duplicated data from the microSD card not being erased before being placed back into the data logger were left and duplicates were scrubbed out in the R code
