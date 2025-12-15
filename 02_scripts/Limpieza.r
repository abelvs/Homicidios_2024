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


#generamos catálogos completos de areas geoestadísticas
ageem <- fread("01_datos_brutos/AGEEML_20251114940908.csv", encoding = "Latin-1") %>% 
  clean_names() %>% 
  mutate(clave_localidad = str_pad(cvegeo, side = "left", pad = "0", width = 9),
         clave_municipio = substr(clave_localidad, 1,5),
         clave_entidad = substr(clave_localidad, 1,2)) 

localidades <- ageem %>% 
  select(clave_localidad, nom_loc, lat_decimal, lon_decimal, pob_total, ambito)

municipios <- ageem %>% 
  group_by(clave_municipio) %>% 
  summarise(nom_mun = first(nom_mun))

entidades <- ageem %>% 
  group_by(clave_entidad) %>% 
  summarise(nom_ent = first(nom_ent))

#Generamos listas de claves para clasificar causa de muerte

catalogo_causas <- read.dbf("01_datos_brutos/CATMINDE.dbf")

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

#Cargamos el catálogo de parentezco de la víctima y el presunto agresor

catalogo_parentesco <- foreign::read.dbf("01_datos_brutos/PARENTESCO.dbf", as.is = T) %>% 
  clean_names() %>% 
  mutate(par_agre_cat = case_when(cve %in% c(1:10, 19:26, 37:40, 41:44) ~ "Familiar directo",
                                    cve %in% c(13:18, 27:36, 53:60) ~ "Familiar indirecto",
                                    cve %in% c(11:12, 45:52) ~ "Parejas/Ex Parejas",
                                    cve %in% c(61:70) ~ "Conocidos/No familiares",
                                    cve %in% c(71, 72, 88, 98) ~ "Sin parentesco",
                                    cve == 99 ~ "No especificado",
                                    T ~ NA_character_)) %>% 
  rename(par_agre = cve,
         par_agre_desc = descrip)
  

#Generamos el DF limpio

homicidios_clean <- defunciones_24 %>% 
  clean_names() %>% 
  #Filtramos para obtener probables homicidios en 2024
  filter(tipo_defun == 2 &
           anio_ocur == 2024) %>% 
  #Creamos columnas de fecha agregada
  mutate(fecha_ocurr = make_date(year = anio_ocur,
                           month = mes_ocurr,
                           day = dia_ocurr),
         fecha_nac = make_date(year = anio_nacim,
                               month = mes_nacim,
                               day = dia_nacim)) %>% 
  #Categorizamos las causas de defunción acorde al catálogo
  mutate(causa_def_cat = case_when(causa_def %in% claves_arma_de_fuego ~ "Arma de Fuego",
                                   causa_def %in% claves_arma_blanca ~ "Arma Blanca",
                                   causa_def %in% claves_fuerza_corporal ~ "Fuerza Corporal",
                                   T ~ "Otro")) %>% 
  #Generamos la columna de edad en años cumplidos
  mutate(indicador_tipo_edad = case_when(substr(edad, 3,4) == "98" & substr(edad, 2,2) != "0" ~ "no especificado",
                                         substr(edad, 1,1) == "1" ~ "horas",
                                         substr(edad, 1,1) == "2" ~ "dias",
                                         substr(edad, 1,1) == "3" ~ "meses",
                                         substr(edad, 1,1) == "4" ~ "años",
                                         T ~ NA_character_),
         edad_anos = case_when(indicador_tipo_edad == "horas" ~ "0",
                               indicador_tipo_edad == "dias" ~ "0",
                               indicador_tipo_edad == "meses" ~ "0",
                               indicador_tipo_edad == "años" ~ substr(edad, 3,4),
                               indicador_tipo_edad == "no especificado" ~ NA_character_),
         edad_anos = as.integer(edad_anos)) %>% 
  #Creamos categorías limpias de año (Mantendremos los grupos de INEGI también)
  mutate(edad_rango = case_when(edad_anos < 1 ~ "<1 año",
                                edad_anos > 120 ~ ">120 años",
                                TRUE ~ as.character(cut(edad_anos, 
                                                        breaks = seq(0, 120, by = 5),
                                                        right = FALSE,
                                                        include.lowest = TRUE,
                                                        labels = paste0(seq(0, 115, by = 5),
                                                                        "-",
                                                                        seq(4, 119, by = 5))))),
         edad_cat = case_when(edad_anos == 0 & edad <= 2028 ~ "Recién nacido",
                              edad_anos == 0 & edad > 2028  ~ "Primera infancia",
                              edad_anos <= 2 ~ "Primera infancia",
                              edad_anos <= 11 ~ "Infancia",
                              edad_anos <= 17 ~ "Adolescencia",
                              edad_anos <= 29 ~ "Adulto joven",
                              edad_anos <= 44 ~ "Adulto",
                              edad_anos <= 65 ~ "Adulto maduro",
                              edad_anos > 65 ~ "Adulto mayor")) %>% 
  #Categorizamos la variable sexo
  mutate(sexo_cat = case_when(sexo == 1 ~ "Hombre",
                              sexo == 2 ~ "Mujer",
                              sexo == 9 ~ "No especificado")) %>% 
  #Generamos claves geográficas para incorporar catálogos
  mutate(clave_localidad = str_pad(paste0(ent_ocurr, mun_ocurr, loc_ocurr), side = "left", pad = "0", width = 9),
         clave_municipio = str_pad(paste0(ent_ocurr, mun_ocurr), side = "left", pad = "0", width = 5),
         clave_entidad = substr(clave_municipio, 1,2)) %>% 
  left_join(entidades, by = "clave_entidad") %>% 
  left_join(municipios, by = "clave_municipio") %>% 
  left_join(localidades, by = "clave_localidad") %>% 
  mutate(clave_localidad = ifelse(is.na(nom_loc), NA, clave_localidad),
         clave_municipio = ifelse(is.na(nom_mun), NA, clave_municipio),
         clave_entidad = ifelse(is.na(nom_ent), NA, clave_entidad)) %>% 
  #Recodificamos variable de area urbana/rural
  mutate(area_ur = recode(area_ur,
                          `1` = "Urbana",
                          `2` = "Rural",
                          `9` = "No especificada")) %>% 
  #Categorizamos la variable lugar de ocurrencia
  mutate(lugar_ocur_desc = recode(lugar_ocur,
                                   `0` = "Vivienda particular",
                                   `1` = "Vivienda colectiva",
                                   `2` = "Escuela u oficina pública",
                                   `3` = "Área deportiva",
                                   `4` = "Calle o carretera (vía pública)",
                                   `5` = "Área comercial o de servicios",
                                   `6` = "Área industrial (taller, fabrica u obra)",
                                   `7` = "Granja (rancho o parcela)",
                                   `8` = "Otro",
                                   `9` = "Se ignora",
                                   `88` = "No aplica"),
         lugar_ocur_cat = case_when(lugar_ocur %in% c(0, 1) ~ "Vivienda",
                                    lugar_ocur == 4 ~ "Vía pública",
                                    lugar_ocur %in% c(2, 3, 5, 6) ~ "Espacios públicos / laborales",
                                    lugar_ocur == 7 ~ "Rural / granja",
                                    lugar_ocur %in% c(8, 9, 88) ~ "Otros / ignorado",
                                    TRUE ~ NA_character_)) %>% 
  #Unimos los valores categorizados de parentezco del probable agresor
  left_join(catalogo_parentesco, by = "par_agre") %>% 
  #Seleccionamos variables de interés
  select(#Geográficas
         clave_entidad, nom_ent, clave_municipio, nom_mun, clave_localidad, nom_loc,
         #Edad de la víctima
         anio_nacim, mes_nacim, dia_nacim, fecha_nac, edad_anos,edad_agru, edad_rango, edad_cat,
         #Características sociodemográficas
         sexo_cat, afromex, conindig, lengua,
         #Ocurrencia de los hechos
         anio_ocur, mes_ocurr, dia_ocurr, fecha_ocurr,
         #Características de los hechos
         causa_def_cat, par_agre_cat, lugar_ocur_cat, 
         #Adicionales demográficas
         area_ur, ambito, pob_total, lat_decimal, lon_decimal)


write.csv(homicidios_clean, "03_output/Homicidios_2024_clean.csv")



