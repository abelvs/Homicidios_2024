# ------------------------------------------------------------------------------
#                         Análisis Homicidios 2024
#                            Descarga de Datos
#
# Descripción:
#   Script para descargar y extraer los microdatos de defunciones 2024 del INEGI,
#   así como el catálogo AGEEML, para su posterior procesamiento.
# ------------------------------------------------------------------------------


pacman::p_load("foreign", "fs")

Sys.setlocale("LC_ALL", "es_MX.UTF-8")

options(scipen = 999)


#Defunciones 2024----
#Definimos rutas

url_def  <- "https://www.inegi.org.mx/contenidos/programas/edr/microdatos/defunciones/2024/defunciones_base_datos_2024_dbf.zip"

dest_dir <- here("01_datos_brutos")

zip_path_def <- path(dest_dir, "defunciones_2024.zip")

#Descargamos archivo

download.file(url_def, zip_path_def, mode = "wb")

#Extraemos ZIP

unzip(zip_path_def, exdir = dest_dir)


#Catálogo de claves----
url_ageeml <- "https://www.inegi.org.mx/contenidos/app/ageeml/min_con_acento_baja.zip"

zip_path_ageeml <- path(dest_dir, "ageeml_2025.zip")

download.file(url_ageeml, zip_path_ageeml, mode = "wb")

unzip(zip_path_ageeml, exdir = dest_dir)

# Limpieza de archivos ZIP----
file_delete(zip_path_def)
file_delete(zip_path_ageeml)

# Mensaje de confirmación
cat("Archivos ZIP eliminados después de la extracción.\n")


