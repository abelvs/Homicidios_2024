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
