# Análisis de Homicidios 2024

Este proyecto tiene como objetivo analizar los datos de homicidios en México correspondientes al año 2024. Utiliza datos oficiales proporcionados por el Instituto Nacional de Estadística y Geografía (INEGI) y herramientas de procesamiento en R para descargar, extraer y preparar los datos para su análisis.

## Funcionalidad de la Aplicación

El proyecto automatiza el proceso de descarga y extracción de microdatos de defunciones y catálogos necesarios para el análisis. Esto incluye:

1. **Descarga de Microdatos de Defunciones 2024**  
   Se obtiene un archivo comprimido (ZIP) desde el sitio oficial del INEGI que contiene los microdatos de defunciones del año 2024. Estos datos incluyen información detallada sobre las defunciones registradas en el país.

2. **Descarga del Catálogo AGEEML**  
   Se descarga un catálogo de claves geográficas (AGEEML) que permite interpretar y relacionar las ubicaciones geográficas de los datos.

3. **Extracción de Archivos**  
   Los archivos ZIP descargados se descomprimen automáticamente en una carpeta específica del proyecto para su posterior procesamiento.

4. **Preparación para el Análisis**  
   Los datos descargados se preparan para ser utilizados en análisis estadísticos y visualizaciones que permitan identificar patrones y tendencias en los homicidios.

## Tecnologías Utilizadas

El proyecto está desarrollado en **R**, un lenguaje de programación especializado en análisis de datos y estadística. A continuación, se describen las principales herramientas y paquetes utilizados:

- **[pacman](https://github.com/trinker/pacman)**: Facilita la carga e instalación de paquetes en R.
- **[foreign](https://cran.r-project.org/web/packages/foreign/index.html)**: Permite trabajar con formatos de datos externos, como DBF.
- **[fs](https://fs.r-lib.org/)**: Proporciona funciones para manejar rutas y sistemas de archivos.
- **[here](https://here.r-lib.org/)**: Simplifica la gestión de rutas relativas dentro del proyecto.

## Estructura del Proyecto

El proyecto está organizado en las siguientes carpetas:

- **`01_datos_brutos/`**: Contiene los archivos descargados y extraídos, incluyendo los microdatos de defunciones y el catálogo AGEEML.
- **`02_scripts/`**: Contiene los scripts en R que automatizan la descarga y extracción de datos.

## Cómo Usar el Proyecto

1. **Requisitos Previos**  
   - Instalar R y RStudio en tu computadora.
   - Instalar los paquetes necesarios ejecutando el siguiente comando en R:
     ```r
     install.packages(c("pacman", "foreign", "fs", "here"))
     ```

2. **Ejecutar el Script**  
   - Abre el archivo `02_scripts/Obtener_datos_INEGI.r` en RStudio.
   - Ejecuta el script para descargar y extraer los datos.

3. **Resultados**  
   - Los datos descargados estarán disponibles en la carpeta `01_datos_brutos/` para su análisis.

## Público Objetivo

Este proyecto está diseñado para analistas de datos, investigadores y cualquier persona interesada en estudiar los homicidios en México. Aunque el código está escrito en R, los pasos están automatizados para que incluso personas con conocimientos básicos puedan utilizarlo.

## Notas Importantes

- **Conexión a Internet**: Es necesaria para descargar los archivos desde el sitio del INEGI.
- **Formato de Datos**: Los microdatos de defunciones están en formato DBF, que es un formato de base de datos utilizado comúnmente en aplicaciones estadísticas.

## Créditos

- **INEGI**: Por proporcionar los datos oficiales utilizados en este análisis.
- **Autor del Proyecto**: Abel V.

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Puedes usarlo, modificarlo y distribuirlo libremente, siempre y cuando se otorgue el crédito correspondiente.
