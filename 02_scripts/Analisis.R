# ------------------------------------------------------------------------------
#                              Análisis Homicidios 2024

# ------------------------------------------------------------------------------


pacman::p_load("dplyr", "ggplot2", "lubridate", "data.table", "janitor", "stringr",
               "httr", "jsonlite", "stringi", "ggthemes", "scales", "purrr", "tibble", "readxl", "tidyr",
               "sf", "viridis", "foreign", "here", "fs")

Sys.setlocale("LC_ALL", "es_MX.UTF-8")

options(scipen = 999)


#Cargamos base limpia de homicidios

df_homicidios <- fread("03_output/Homicidios_2024_clean.csv")

#Análsis exploratorio----
