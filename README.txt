# Homicidios 2024 - México

Repositorio para el análisis de homicidios en México durante 2024. Incluye scripts para obtener, limpiar y procesar datos del INEGI, así como visualizaciones y reportes.

## Estructura

- `01_datos_brutos/` – Carpeta inicialmente vacía; se pobla al ejecutar `Obtener_datos_INEGI.r`.  
- `02_scripts/` – Scripts de limpieza, transformación y análisis.  
- `03_output/` – Gráficos, catálogos y tablas intermedias.  
- `04_output/` – ppt y PDF con visualizaciones  y texto de análisis.  

## Uso

1. Clonar el repositorio.  
2. Ejecutar `02_scripts/Obtener_datos_INEGI.r` para descargar los datos brutos (requiere conexión a internet).  
3. Ejecutar los scripts de análisis según necesidad.  

## Requisitos

- R >= 4.2  
- Conexión a internet para descargar los datos del INEGI.  
- Paquetes R: `dplyr`, `ggplot2`, `lubridate`, `data.table`, `janitor`, `stringr`, `httr`, `jsonlite`, `stringi`, `ggthemes`, `scales`, `purrr`, `tibble`, `readxl`, `tidyr`, `sf`, `viridis`, `foreign`, `here`, `fs`.  
- Recomendada instalación con `pacman::p_load()`.

