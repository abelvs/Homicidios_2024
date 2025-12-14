# 📊 Dashboard de Análisis de Homicidios en México 2024

Una aplicación web interactiva para el análisis, visualización y exploración de datos estadísticos sobre homicidios en México durante el año 2024.

## 📋 Contenido

- [Presentación](#presentación)
- [Características](#características)
- [Manual de Uso](#manual-de-uso)
- [Instalación y Configuración](#instalación-y-configuración)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Requisitos del Sistema](#requisitos-del-sistema)
- [Solución de Problemas](#solución-de-problemas)
- [Contacto y Soporte](#contacto-y-soporte)

---

## 🎯 Presentación

Esta aplicación es una herramienta profesional de análisis de datos diseñada para proporcionar información detallada sobre la incidencia de homicidios en México durante 2024. 

### Objetivo Principal

Facilitar el acceso a información estadística sobre homicidios mediante:
- Visualizaciones interactivas e intuitivas
- Análisis geográfico detallado
- Información demográfica de las víctimas
- Búsquedas avanzadas y filtros personalizables
- Tendencias temporales y patrones

### Público Objetivo

- Investigadores y académicos
- Periodistas y medios de comunicación
- Autoridades gubernamentales
- Organizaciones defensoras de derechos humanos
- Público general interesado en estadísticas

---

## ✨ Características Principales

### 📊 Dashboard General
- **Métricas principales**: total de homicidios, distribución por género, edad promedio
- **Top 15 entidades federativas** con más casos
- **Distribución por causas de muerte** (gráfico de pastel)
- **Análisis por género** (representación visual)
- **Lugares de ocurrencia** más frecuentes

### 🗺️ Análisis Geográfico
- **Mapa interactivo** con ubicación de homicidios
- **Análisis por entidad federativa** seleccionable
- **Top municipios** afectados por entidad
- **Estadísticas geográficas** detalladas
- **Análisis de causas** por región

### 👥 Análisis Demográfico
- **Pirámide etaria** de víctimas
- **Distribución por género** y edad
- **Estadísticas de edad**: media, mediana, moda, desviación estándar
- **Histograma de distribución** de edades
- **Análisis por categorías de edad** predefinidas

### 🔍 Búsqueda Avanzada
- **Tabla interactiva completa** de registros
- **Filtros de búsqueda** por entidad, municipio y causa
- **Selección personalizada** de columnas a visualizar
- **Descarga de datos** en formato CSV
- **Estadísticas** de los resultados filtrados

### 📈 Tendencias Temporales
- **Gráfico de líneas** con tendencia mensual
- **Análisis por día de la semana**
- **Distribución por mes** del año
- **Identificación de patrones** temporales

### ℹ️ Información y Documentación
- **Descripción de la aplicación**
- **Diccionario de datos** completo
- **Guía de uso** de funcionalidades

---

## 📖 Manual de Uso

### Inicio Rápido

1. **Abre la aplicación** haciendo clic en el icono o ejecutando desde terminal
2. **Observa el Dashboard General** para una vista rápida de estadísticas clave
3. **Usa el menú lateral** para navegar entre secciones
4. **Aplica filtros** según tus necesidades de análisis

### Guía por Sección

#### 1️⃣ Dashboard General (📊)

**¿Qué ver aquí?**
- Resumen ejecutivo de homicidios en el período seleccionado
- Distribuciones principales por género y causa

**Cómo usarlo:**
1. Aplica filtros en el menú lateral (entidades, causas, fechas)
2. Observa las métricas principales en las 4 tarjetas superiores
3. Explora los gráficos interactivos:
   - Pasa el cursor sobre las barras/áreas para ver valores exactos
   - Haz clic en elementos de la leyenda para mostrar/ocultar datos
   - Usa el botón 📷 en la esquina superior derecha para descargar como imagen

#### 2️⃣ Análisis Geográfico (🗺️)

**¿Qué ver aquí?**
- Mapa interactivo con ubicación de cada homicidio
- Análisis regional profundo por entidad federativa

**Cómo usarlo:**
1. **Mapa de calor (lado izquierdo)**:
   - Zoom: Usa rueda del ratón o botones +/-
   - Desplazamiento: Arrastra el mapa
   - Información: Pasa el cursor sobre los puntos
   - Los colores representan la edad de las víctimas

2. **Panel de estadísticas (lado derecho)**:
   - Visualiza municipios y localidades registradas
   - Revisa el top de municipios más afectados

3. **Análisis por entidad**:
   - Selecciona una entidad en el dropdown
   - Observa estadísticas específicas
   - Analiza municipios y causas de esa región

#### 3️⃣ Análisis Demográfico (👥)

**¿Qué ver aquí?**
- Características de las víctimas: edad, género, categorías

**Cómo usarlo:**
1. **Pirámide etaria (izquierda)**:
   - Visualiza distribución de edad de víctimas
   - Identifica grupos de riesgo

2. **Análisis por género (derecha)**:
   - Porcentajes de hombres y mujeres
   - Comparación por categorías de edad

3. **Estadísticas numéricas**:
   - Media de edad: promedio de todas las víctimas
   - Mediana: edad central
   - Moda: edad más frecuente
   - Desviación estándar: variabilidad

4. **Histograma**:
   - Visualiza distribución continua de edades

#### 4️⃣ Búsqueda Avanzada (🔍)

**¿Qué ver aquí?**
- Tabla completa de registros con acceso a datos crudos

**Cómo usarlo:**
1. **Campos de búsqueda superior**:
   ```
   🔎 Buscar por Entidad: Escribe parte del nombre (ej: "Jalisco")
   🔎 Buscar por Municipio: Filtra municipios específicos
   🔎 Buscar por Causa: Busca causas de muerte
   ```

2. **Selecciona columnas**:
   - Elige qué información mostrar (máx. 9 columnas)
   - Columnas disponibles: entidad, municipio, género, edad, causa, lugar, fecha, etc.

3. **Tabla interactiva**:
   - Haz clic en encabezados para ordenar
   - Scroll horizontal para ver más columnas
   - Scroll vertical para más registros

4. **Descarga datos**:
   - Botón 📥 "Descargar CSV"
   - Exporta resultados filtrados para análisis externo

#### 5️⃣ Tendencias Temporales (📈)

**¿Qué ver aquí?**
- Patrones de homicidios a lo largo del tiempo

**Cómo usarlo:**
1. **Gráfico de línea (arriba)**:
   - Visualiza tendencia mensual de 2024
   - Identifica picos y valles
   - Observa patrones estacionales

2. **Homicidios por día de semana (abajo izquierda)**:
   - Determina si hay días más peligrosos
   - Compara distribución entre semana y fin de semana

3. **Homicidios por mes natural (abajo derecha)**:
   - Identifica meses con mayor incidencia
   - Analiza variación estacional

### 🔧 Filtros Globales (Menú Lateral)

Los filtros se aplican a **TODA** la aplicación automáticamente.

**Cómo usar los filtros:**

1. **Filtro de Entidades**:
   - Haz clic en "Entidades" en el sidebar
   - Selecciona una o varias entidades federativas
   - Deja en blanco para incluir todas

2. **Filtro de Causa de Muerte**:
   - Selecciona tipos específicos de causas
   - Multiselección disponible
   - Vacío = todas las causas

3. **Rango de Fechas**:
   - Haz clic en el campo de fechas
   - Selecciona fecha inicial y final
   - Cubre todo el año 2024 por defecto

**Ejemplo de filtrado:**
```
Selecciono: 
- Entidades: Jalisco, Michoacán
- Causa: Arma de fuego
- Fechas: 1 Ene 2024 - 30 Jun 2024

Resultado: Solo homicidios por arma de fuego 
en esas entidades durante el primer semestre
```

### 💡 Consejos de Uso

| Acción | Resultado |
|--------|-----------|
| Pasa cursor sobre gráficos | Muestra valores exactos |
| Doble clic en leyenda | Aísla una categoría |
| Botón 📷 en gráficos | Descarga como PNG |
| Scroll en tabla | Explora más registros |
| CSV descargado | Abre en Excel o Python |

---

## 🚀 Instalación y Configuración

### Requisitos Previos

- **Python 3.8 o superior**
- **pip** (gestor de paquetes de Python)
- **Git** (opcional, para clonar el repositorio)

### Pasos de Instalación

#### 1. Clonar o descargar el proyecto

```bash
# Opción 1: Clonar con Git
git clone <tu-repositorio>
cd Homicidios_2024

# Opción 2: Descargar ZIP y extraer
# Navega a la carpeta del proyecto
cd Homicidios_2024
```

#### 2. Crear un entorno virtual (recomendado)

```bash
# En Windows
python -m venv venv
venv\Scripts\activate

# En macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

#### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

O instalar manualmente:

```bash
pip install streamlit==1.28.1 pandas==2.1.1 plotly==5.17.0 numpy==1.24.3
```

#### 4. Preparar datos

Asegúrate de que el archivo `Homicidios_2024_clean.csv` está en:
```
Homicidios_2024/
├── 03_output/
│   └── Homicidios_2024_clean.csv
├── app.py
├── README.md
└── requirements.txt
```

#### 5. Ejecutar la aplicación

```bash
streamlit run app.py
```

Verás un mensaje como:
```
  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8501
  Network URL: http://192.168.x.x:8501
```

Abre automáticamente en tu navegador o copia la URL.

### Archivo requirements.txt

Crea un archivo `requirements.txt` en la raíz del proyecto:

```
streamlit==1.28.1
pandas==2.1.1
plotly==5.17.0
numpy==1.24.3
```

---

## 💻 Tecnologías Utilizadas

### Stack Tecnológico

| Tecnología | Versión | Propósito |
|-----------|---------|----------|
| **Streamlit** | 1.28+ | Framework web para interfaz |
| **Plotly** | 5.17+ | Gráficos interactivos |
| **Pandas** | 2.1+ | Análisis y procesamiento de datos |
| **NumPy** | 1.24+ | Operaciones numéricas |
| **Python** | 3.8+ | Lenguaje de programación |

### Descripción de Tecnologías

#### 🎨 **Streamlit**
- Framework Python minimalista para crear aplicaciones web
- Permite recargar código en tiempo real (hot reload)
- Integración nativa con librerías de datos
- Componentes predefinidos (sliders, selectboxes, métricas)
- Rendimiento optimizado para dashboards y análisis
- Aplicación web sin necesidad de HTML/CSS/JavaScript

#### 📊 **Plotly**
- Librería de visualización interactiva
- Gráficos que responden a interacción del usuario
- Exportación nativa a imágenes PNG
- Mapas interactivos con Mapbox
- Múltiples tipos de gráficos profesionales (barras, líneas, pastel, mapas)
- Hover information personalizable

#### 🐼 **Pandas**
- Manipulación y transformación eficiente de datos
- Lectura de archivos CSV/Excel
- Filtrado, agrupación y pivotaje de datos
- Cálculos estadísticos avanzados
- Conversiones de tipos de datos
- Manejo de fechas y series temporales

#### 🔢 **NumPy**
- Operaciones numéricas y matriciales
- Análisis estadístico (media, mediana, desviación estándar)
- Operaciones en arrays multidimensionales
- Base para Pandas y Plotly

### Arquitectura

```
┌─────────────────────┐
│  Navegador Web      │
└──────────┬──────────┘
           │ HTTP
           ↓
┌─────────────────────┐
│ Streamlit Server    │
│  (Python)           │
└──────────┬──────────┘
           │
    ┌──────┴──────┬────────────┬─────────────┐
    ↓             ↓            ↓             ↓
┌────────┐  ┌────────┐  ┌──────────┐  ┌───────┐
│ Pandas │  │ Plotly │  │ NumPy    │  │ Cache │
│(datos) │  │(gráf.) │  │(cálculos)│  │      │
└────────┘  └────────┘  └──────────┘  └───────┘
    │
    ↓
┌──────────────────────────┐
│ Homicidios_2024_clean.csv│
└──────────────────────────┘
```

---

## 📁 Estructura del Proyecto

```
Homicidios_2024/
│
├── app.py                              # Aplicación principal
├── README.md                           # Documentación (este archivo)
├── requirements.txt                    # Dependencias Python
│
├── 03_output/
│   └── Homicidios_2024_clean.csv      # Datos fuente (CSV)
│
└── docs/ (opcional)
    ├── diccionario_datos.md            # Documentación de campos
    └── guia_avanzada.md                # Guía para desarrolladores
```

### Descripción de Archivos

- **app.py**: Código principal de la aplicación Streamlit
- **README.md**: Documentación completa (este archivo)
- **requirements.txt**: Lista de paquetes Python necesarios
- **03_output/Homicidios_2024_clean.csv**: Dataset limpio en CSV

---

## 📊 Diccionario de Datos

| Columna | Tipo | Descripción | Ejemplo |
|---------|------|-------------|---------|
| `nom_ent` | string | Nombre de la entidad federativa | "Jalisco" |
| `nom_mun` | string | Nombre del municipio | "Guadalajara" |
| `nom_loc` | string | Nombre de la localidad | "Centro" |
| `fecha_nac` | date | Fecha de nacimiento de víctima | "1985-05-15" |
| `edad_anos` | int | Edad en años cumplidos | 38 |
| `edad_cat` | string | Categoría de edad | "30-39" |
| `sexo_cat` | string | Género de la víctima | "Hombre", "Mujer" |
| `causa_def_cat` | string | Causa del fallecimiento | "Arma de fuego", "Agresión" |
| `lugar_ocur_cat` | string | Lugar de ocurrencia | "Vía pública", "Vivienda" |
| `fecha_ocurr` | date | Fecha del homicidio | "2024-03-20" |
| `lat_decimal` | float | Latitud en decimales | 20.6595 |
| `lon_decimal` | float | Longitud en decimales | -103.2494 |
| `area_ur` | string | Clasificación urbana/rural | "Urbano", "Rural" |

---

## 🔒 Consideraciones de Privacidad

Esta aplicación trabaja con datos de dominio público:

- ✅ Los datos ya están anonimizados
- ✅ Se utiliza solo para análisis estadístico
- ✅ No se almacenan datos adicionales
- ✅ Las búsquedas son locales (no envían a servidores externos)
- ✅ Cumple con estándares de protección de datos

---

## 🐛 Solución de Problemas

### ❌ Error: "No se encontró el archivo CSV"

**Causa**: El archivo de datos no está en la ruta correcta

**Solución**:
1. Verifica que `Homicidios_2024_clean.csv` existe
2. Confirma la ruta: `03_output/Homicidios_2024_clean.csv`
3. Revisa permisos de lectura del archivo
4. No cambies la estructura de carpetas

```bash
# Estructura correcta:
Homicidios_2024/
├── 03_output/
│   └── Homicidios_2024_clean.csv  ✅
└── app.py
```

### ⏱️ La aplicación es lenta

**Causa**: Demasiados datos o conexión lenta

**Solución**:
1. Reduce el rango de fechas en el filtro
2. Limita municipios/entidades seleccionadas
3. Cierra otras pestañas/aplicaciones
4. Verifica conexión a internet (Mapbox requiere conexión)
5. Reinicia la aplicación: `Ctrl+C` y `streamlit run app.py`

### 📊 Gráficos no muestran datos

**Causa**: Filtros muy restrictivos o datos vacíos

**Solución**:
1. Verifica que los filtros no excluyen todos los registros
2. Limpia filtros: deja todas opciones en blanco
3. Recarga la página: `F5` o `Ctrl+R`
4. Revisa la tabla en "Búsqueda Avanzada" para confirmar datos

### 🔴 Error: "ModuleNotFoundError: No module named 'streamlit'"

**Causa**: Paquetes no instalados

**Solución**:
```bash
# Instala las dependencias
pip install -r requirements.txt

# O instala manualmente
pip install streamlit pandas plotly numpy
```

### 🗺️ El mapa no carga en "Análisis Geográfico"

**Causa**: Conexión a internet o falta de coordenadas

**Solución**:
1. Verifica conexión a internet
2. Filtra solo registros con coordenadas válidas
3. Reinicia la aplicación
4. Limpia caché del navegador

---

## 📞 Contacto y Soporte

### Para reportar problemas:
1. Revisa la documentación en la sección "ℹ️ Información"
2. Verifica que tus filtros sean correctos
3. Consulta el diccionario de datos en esta documentación

### Consulta frecuentes:

**P: ¿Puedo exportar todos los datos?**  
R: Sí, usa "Búsqueda Avanzada" sin filtros y descarga como CSV

**P: ¿Qué significa cada color en los gráficos?**  
R: Los colores indican intensidad/cantidad. Revisa la leyenda en cada gráfico

**P: ¿Los datos se actualizan automáticamente?**  
R: No, debes reemplazar el CSV manualmente

**P: ¿Funciona sin conexión a internet?**  
R: Sí, excepto la sección "Análisis Geográfico" que usa mapas en línea

---

## 📄 Licencia

Este proyecto utiliza herramientas open-source bajo licencias MIT y BSD.

- **Streamlit**: Apache License 2.0
- **Plotly**: MIT License
- **Pandas**: BSD License
- **NumPy**: BSD License

---

## ✍️ Información del Proyecto

**Desarrollado con Streamlit**  
Aplicación de análisis de datos de homicidios | 2024  
Última actualización: 2024  
Versión: 1.0

---

**¡Gracias por usar esta aplicación!**
