repository: bryan_blue_thesis_UA_fall_2024

# EFFECTS OF IN SITU LEAF WARMING ON NET PHOTOSYNTHETIC CO~2~ ASSIMILATION IN *THEOBROMA CACAO* L. (cacao):  A STUDY IN THE BIOSPHERE 2 TROPICAL RAINFOREST

Bryan P. Blue ^a^, Bonnie L. Hurwitz ^b^ , Gene A. Giacomelli ^b^ , Joost van Haren ^c,d^

A partial thesis fulfillment to the Department of Biosystems Engineering, College of Agriculture, Life and Environmental Sciences at the University of Arizona.

# Folders

`./output` Rendered Quarto output, system generated `/renv` renv package manage files, to keep the same packages and versions that were used in the original analysis\
`./data_raw` [**TREAT AS READ ONLY!!!**]{.underline} This is the original data for this project. There is no reason to modify these files.\
`./data_user` user files for input or R output for final tables.\
`./data_clean` temporary location of intermediate files for analysis, auto-created.\
`./figures` all plots and visualizations are stored here.

# Data Logger Data Analysis

*Biosphere 2 tropical rain forest sensor and control data analysis.*

Files from all heating devices and aspirated temperature/relative humidity file processing.

[**pure orginal copy of all data in `data_raw` exists in .`./data_raw_original`**]{.underline}

## NO data was manipulated, file locations were changed

In the local copy of raw_data there was data from two data loggers, DL1 and DL2. If one malfunctioned, the best data set was placed into the DL1 folder. This script only processed data from the DL1 folder, these manual movements were performed to account for this.

### R Scripts Only Scan DL1 Folders

This could be done in a better way, but this solution was chosen. All original files are in the data_raw_original folder under the root of this project.

-   If DL1 data was all incorrect/missing and DL2 was okay, a DL1 copy subfolder was created and DL2 data was placed into the DL1 folder.
-   logs that contained any duplicated data from the microSD card were left and duplicates were scrubbed out in the R code

# Running Scripts

Quarto scripts are run in sequential order based on the prefix of the filename. e.g. `00_wrangle_DL_logs.qmd` would be run first as it is the lowest prefix of "00\_"

## Run First

These scripts load, scrub and create files for future analysis.

lvl1 can be ignored unless there is interest in the rain forest basin conditions next to the mountain.

lvl2 = experiment 2 on the terrace\
lvl3 = experiment 3-1 mountain top, 1st of 2 experiments\
lvl3a = experiment 3-2 mountain top, 2nd of 2 experiments

`00_wrangle_DL_logs.qmd01_lvl1_DL_logs.qmd01_lvl2_DL_logs.qmd01_lvl3_DL_logs.qmd01_lvl3a_DL_logs.qmd`

# Leaf Heating and Control Unit

*("Temperature Relay Control" aka TRC in the code)*

`02_TRC_analysis.qmd`\
The leaf heating portion of the experiment data is analyzed in this script. There are large sections of data exploration as well as the statistical results. Only portions were used in the thesis or article based on explanation needs.

# Climate Analysis

*(Installation specific temperature/relative humidity and Biosphere 2 tower sensor data.)*

`02_climate_analysis.qmd`\
There are large sections of data exploration as well as the statistical results. Only portions were used in the thesis or article based on explanation needs.
