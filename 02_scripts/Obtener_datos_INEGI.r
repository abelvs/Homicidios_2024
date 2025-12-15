# ------------------------------------------------------------------------------
#                         Análisis Homicidios 2024
#                            Descarga de Datos
#
# Descripción:
#   Script para descargar y extraer los microdatos de defunciones 2024 del INEGI,
#   así como el catálogo AGEEML y las geometrías estatal y municipal
#   para su posterior procesamiento.
# ------------------------------------------------------------------------------


pacman::p_load("foreign", "fs")

Sys.setlocale("LC_ALL", "es_MX.UTF-8")

options(scipen = 999)


#Defunciones 2024----
#Definimos rutas

url_def  <- "https://www.inegi.org.mx/contenidos/programas/edr/microdatos/defunciones/2024/defunciones_base_datos_2024_dbf.zip"

dest_dir <- here("01_datos_brutos")

zip_path_def <- path(dest_dir, "defunciones_2024.zip")

#Defunciones 2023----
#Definimos rutas

url_def  <- "https://www.inegi.org.mx/contenidos/programas/edr/microdatos/defunciones/2023/defunciones_base_datos_2023_dbf.zip"

dest_dir <- here("01_datos_brutos")

zip_path_def <- path(dest_dir, "defunciones_2023.zip")

#Descargamos archivo

download.file(url_def, zip_path_def, mode = "wb")

#Extraemos ZIP

dir.create("01_datos_brutos/Defunciones_23")
unzip(zip_path_def, exdir = "01_datos_brutos/Defunciones_23/")


#Catálogo de claves----
dir.create("01_datos_brutos/Catalogo_locs")
url_ageeml <- "https://www.inegi.org.mx/contenidos/app/ageeml/may_acento.zip"

zip_path_ageeml <- path("01_datos_brutos/Catalogo_locs/", "ageeml_2025.zip")

download.file(url_ageeml, zip_path_ageeml, mode = "wb")

unzip(zip_path_ageeml, exdir = "01_datos_brutos/Catalogo_locs/")


#Descargamos geometrias ----

lista_claves <- sprintf("%02d", 1:32)

# Función para leer geometría municipal por estado
leer_municipios_sf <- function(cve_ent) {
  url <- paste0("https://gaia.inegi.org.mx/wscatgeo/v2/geo/mgem/", cve_ent)
  st_read(url, quiet = TRUE)
}

# crear y guardar shp municipal y estatal
mun_sf <- map_dfr(lista_claves, leer_municipios_sf)

dir_create("01_datos_brutos/Shp_mun")
st_write(mun_sf, "01_datos_brutos/Shp_mun/sf_municipal.shp")



ent_sf <- sf_mun %>% 
  group_by(cve_ent) %>% 
  summarise()

dir_create("01_datos_brutos/Shp_ent")
st_write(ent_sf, "01_datos_brutos/Shp_ent/sf_ent.shp")


