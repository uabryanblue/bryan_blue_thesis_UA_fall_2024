# bryan_blue_thesis_UA_fall_2024

EFFECTS OF IN SITU LEAF WARMING ON NET PHOTOSYNTHETIC CO~2~ ASSIMILATION IN *THEOBROMA CACAO* L. (cacao):  A STUDY IN THE BIOSPHERE 2 TROPICAL RAINFOREST

Bryan P. Blue ^a^, Bonnie L. Hurwitz ^b^ , Gene A. Giacomelli ^b^ , Joost van Haren ^c,d^

A partial thesis fulfillment to the Department of Biosystems Engineering, College of Agriculture, Life and Environmental Sciences at the University of Arizona.

# LI-COR Data Processing and Exploration

## Configuration

> [**!!! Output from the DATA_LOGGER_ANALYSIS project is required for this project !!!**]{.underline}
>
> **../DATA_LOGGER_ANALYSIS/00_wrangle_DL_logs.qmd** Produces this file:
>
> `../DATA_LOGGER_ANALYSIS/data_clean/climate_hour_stats.csv`
>
> The following qmd in this project assumes that the `climate_hour_stats.csv` file exists:
>
> **05_2024_bryan_blue_thesis_model_log_main.qmd**

The analysis did not use LI-COR Excel output; the text logs were processed and combined using custom R code.

Files should be assumed to be in UTF-8 format to accommodate special characters.

DO NOT directly open the CSV files in Excel; unexpected conversions to dates and numeric values will occur. Changes made in the CSV file in Excel will cause errors if they are used in this project. A good practice is to use the Data Import option from an empty Excel sheet and then save it as a native Excel .xlsx file.

Configure the project in Visual Studio Code to use the `renv` package manager and ensure `renv::activate()` runs before the analysis scripts.

## Folders

`./output` Rendered Quarto output, system generated `/renv` renv package manage files, to keep the same packages and versions that were used in the original analysis\
`./data_raw` [**TREAT AS READ ONLY!!!**]{.underline} This is the original data for this project that has not been manipulated in any way. There is no reason to modify these files.\
`./data_user` user files for input or R output for final tables\
`./data_clean` temporary location of intermediate files for analysis, auto-created\
`./figures` all script graphs are stored here. Any folders beneath this level have folder names corresponding to the script that generated them. e.g.

`./figures/05/` is created from `05_2024_bryan_blue_thesis_model_log_main.qmd`

# Run Scripts

To reproduce the output, run the scripts in numeric order based on the qmd prefix.

*Be sure to restart R before running each script or if unexpected results are given after running multiple scripts.* For unknown reasons, some instability is present in R, the Visual Studio Code environment, or somewhere else.

## Initialize Data for the Project

These two scripts process LI-COR text log files from `./data_raw` into usable CSV files in `./data_clean`.

01_data_wrangle_LICOR_logs.qmd\
02_data_load_clean_LICOR_logs.qmd

## Analyze the Data

These can be run after the qmd [Initialize Data for the Project] 01\_ and 02\_ have been completed.\
The main information used for the thesis is obtained by running these scripts.\
The code output overlaps. There are also portions of data exploration or data validation before performing ANOVA and other statistical tests.\
`03_all_data_trends_level_2.qmd`\
`05_2024_bryan_blue_thesis_model_log_main.qmd`

Some, but not all, plots in `./figures/03/` and `./figures/05/` were used in the thesis or journal article based on the need for explanations in those documents.
