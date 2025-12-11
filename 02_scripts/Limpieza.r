# ------------------------------------------------------------------------------
#                              Análisis Homicidios 2024
#                                       Limpieza
#
# Objetivo:
#   Procesar y preparar los microdatos de defunciones 2024 del INEGI
#   para análisis de homicidios.
# ------------------------------------------------------------------------------


pacman::p_load("dplyr", "ggplot2", "lubridate", "data.table", "janitor", "stringr",
               "httr", "jsonlite", "stringi", "ggthemes", "scales", "purrr", "tibble", "readxl", "tidyr",
               "sf", "viridis", "foreign", "here", "fs")

Sys.setlocale("LC_ALL", "es_MX.UTF-8")

options(scipen = 999)


#Cargamos tablas de datos_brutos

defunciones_24 <- foreign::read.dbf("01_datos_brutos/DEFUN24.dbf", as.is = TRUE) %>% 
  clean_names

catalogo_causas <- read.dbf("01_datos_brutos/CATMINDE.dbf")

localidades <- fread("01_datos_brutos/AGEEML_2025111494885.csv", encoding = "Latin-1") %>% 
  clean_names() %>% 
  mutate(clave_localidad = str_pad(cvegeo, side = "left", pad = "0", width = 9)) %>% 
  select(-cvegeo)

#Generamos listas de claves para clasificar causa de muerte
claves_arma_de_fuego <- catalogo_causas %>% 
  filter(str_detect(DESCRIP, "AGRESION CON DISPARO")) %>% 
  pull(CVE) %>% 
  as.character() %>% 
  unique()

claves_arma_blanca <- catalogo_causas %>% 
  filter(str_detect(DESCRIP, "AGRESION CON OBJETO CORTANTE")) %>% 
  pull(CVE) %>% 
  as.character() %>% 
  unique()

claves_fuerza_corporal <- catalogo_causas %>% 
  filter(str_detect(DESCRIP, 
                    regex("AGRESION POR AHORCAMIENTO, ESTRANGULAMIENTO Y SOFOCACION|CON FUERZA CORPORAL"))) %>% 
  pull(CVE) %>% 
  as.character() %>% 
  unique()


#Generamos el DF limpio
homicidios_clean <- defunciones_24 %>% 
  clean_names() %>% 
  filter(tipo_defun == 2 &
           anio_ocur == 2024) %>% 
  mutate(fecha_ocurr = make_date(year = anio_ocur,
                           month = mes_ocurr,
                           day = dia_ocurr),
         fecha_nac = make_date(year = anio_nacim,
                               month = mes_nacim,
                               day = dia_nacim)) %>% 
  mutate(clave_localidad = str_pad(paste0(ent_ocurr, mun_ocurr, loc_ocurr), side = "left", pad = "0", width = 9),
         clave_municipio = substr(clave_localidad, 1,5)) %>% 
  mutate(cat_causa_def = case_when(causa_def %in% claves_arma_de_fuego ~ "Arma de Fuego",
                                   causa_def %in% claves_arma_blanca ~ "Arma Blanca",
                                   causa_def %in% claves_fuerza_corporal ~ "Fuerza Corporal",
                                   T ~ "Otro")) %>% 
  left_join((localidades %>% 
               select(clave_localidad, nom_ent, nom_mun, nom_loc, lat_decimal, lon_decimal)), by = "clave_localidad")






