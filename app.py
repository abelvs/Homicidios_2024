import streamlit as st
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px
import numpy as np
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')

# ==============================================================================
# CONFIGURACIÓN DE PÁGINA
# ==============================================================================
st.set_page_config(
    page_title="Análisis de Homicidios MX 2024",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ==============================================================================
# ESTILOS CSS PERSONALIZADOS
# ==============================================================================
st.markdown("""
    <style>
    :root {
        --primary-color: #1f77b4;
        --secondary-color: #ff7f0e;
        --success-color: #2ca02c;
        --danger-color: #d62728;
    }
    
    body {
        background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    }
    
    .main {
        padding: 2rem;
    }
    
    .metric-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 1.5rem;
        border-radius: 10px;
        color: white;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    
    .metric-value {
        font-size: 2.5rem;
        font-weight: bold;
        margin: 0.5rem 0;
    }
    
    .metric-label {
        font-size: 0.9rem;
        opacity: 0.9;
    }
    
    h1 {
        color: #1f2937;
        font-weight: 700;
        margin-bottom: 1.5rem;
    }
    
    h2 {
        color: #374151;
        font-weight: 600;
        margin-top: 1.5rem;
    }
    </style>
""", unsafe_allow_html=True)

# ==============================================================================
# CARGAR DATOS
# ==============================================================================
@st.cache_data
def load_data():
    df = pd.read_csv('03_output/Homicidios_2024_clean.csv', index_col=0)
    df['fecha_ocurr'] = pd.to_datetime(df['fecha_ocurr'], errors='coerce')
    return df

try:
    df = load_data()
except FileNotFoundError:
    st.error("❌ No se encontró el archivo CSV. Asegúrate de que esté en la ruta: 03_output/Homicidios_2024_clean.csv")
    st.stop()

# ==============================================================================
# FUNCIONES AUXILIARES
# ==============================================================================
def create_metric_card(label, value, color="🔴"):
    """Crea una tarjeta métrica personalizada"""
    return f"""
    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                padding: 1.5rem; border-radius: 10px; color: white; 
                box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center;">
        <p style="margin: 0; opacity: 0.9; font-size: 0.9rem;">{label}</p>
        <p style="margin: 0.5rem 0; font-size: 2rem; font-weight: bold;">{color} {value}</p>
    </div>
    """

def get_top_entities(df, n=10):
    """Obtiene las entidades con más homicidios"""
    return df['nom_ent'].value_counts().head(n)

def get_top_municipalities(df, n=10):
    """Obtiene los municipios con más homicidios"""
    return df[df['nom_mun'].notna()]['nom_mun'].value_counts().head(n)

def get_cause_stats(df):
    """Estadísticas por causa de muerte"""
    return df['causa_def_cat'].value_counts()

def get_age_stats(df):
    """Estadísticas por grupo de edad"""
    return df['edad_cat'].value_counts()

def get_gender_stats(df):
    """Estadísticas por género"""
    return df['sexo_cat'].value_counts()

def get_location_stats(df):
    """Estadísticas por lugar de ocurrencia"""
    return df['lugar_ocur_cat'].value_counts()

# ==============================================================================
# SIDEBAR - NAVEGACIÓN
# ==============================================================================
with st.sidebar:
    st.image("https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Coat_of_arms_of_Mexico_%28golden_linear%29.svg/960px-Coat_of_arms_of_Mexico_%28golden_linear%29.svg.png", width=80)
    
    st.markdown("---")
    st.title("🗂️ Navegación")
    
    page = st.radio(
        "Selecciona una sección:",
        options=[
            "📊 Dashboard General",
            "🗺️ Análisis Geográfico",
            "👥 Análisis Demográfico",
            "🔍 Búsqueda Avanzada",
            "📈 Tendencias Temporales",
            "ℹ️ Información"
        ],
        label_visibility="collapsed"
    )
    
    st.markdown("---")
    st.subheader("📋 Resumen Ejecutivo")
    col1, col2 = st.columns(2)
    with col1:
        st.metric("Total Homicidios", len(df), delta=None)
    with col2:
        st.metric("Entidades", df['nom_ent'].nunique())
    
    # Filtros globales
    st.markdown("---")
    st.subheader("🔧 Filtros")
    
    entities_filter = st.multiselect(
        "Entidades",
        options=sorted(df['nom_ent'].dropna().unique()),
        default=None
    )
    
    causes_filter = st.multiselect(
        "Causa de muerte",
        options=sorted(df['causa_def_cat'].dropna().unique()),
        default=None
    )
    
    date_range = st.date_input(
        "Rango de fechas",
        value=(df['fecha_ocurr'].min().date(), df['fecha_ocurr'].max().date()),
        key="date_range"
    )
    
    # Aplicar filtros
    df_filtered = df.copy()
    if entities_filter:
        df_filtered = df_filtered[df_filtered['nom_ent'].isin(entities_filter)]
    if causes_filter:
        df_filtered = df_filtered[df_filtered['causa_def_cat'].isin(causes_filter)]
    if date_range:
        df_filtered = df_filtered[
            (df_filtered['fecha_ocurr'].dt.date >= date_range[0]) &
            (df_filtered['fecha_ocurr'].dt.date <= date_range[1])
        ]

# ==============================================================================
# PÁGINA: DASHBOARD GENERAL
# ==============================================================================
if page == "📊 Dashboard General":
    st.title("📊 Dashboard General - Homicidios 2024")
    
    # Métricas principales
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        st.markdown(create_metric_card("Total Homicidios", f"{len(df_filtered):,}", "⚠️"), unsafe_allow_html=True)
    
    with col2:
        tasa_hombres = (df_filtered['sexo_cat'] == 'Hombre').sum()
        st.markdown(create_metric_card("Víctimas Hombres", f"{tasa_hombres:,}", "👨"), unsafe_allow_html=True)
    
    with col3:
        tasa_mujeres = (df_filtered['sexo_cat'] == 'Mujer').sum()
        st.markdown(create_metric_card("Víctimas Mujeres", f"{tasa_mujeres:,}", "👩"), unsafe_allow_html=True)
    
    with col4:
        edad_promedio = df_filtered['edad_anos'].mean()
        st.markdown(create_metric_card("Edad Promedio", f"{edad_promedio:.1f}", "📅"), unsafe_allow_html=True)
    
    st.markdown("---")
    
    # Gráficas principales
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("🏆 Top 15 Entidades")
        top_entities = df_filtered['nom_ent'].value_counts().head(15)
        fig = px.bar(
            x=top_entities.values,
            y=top_entities.index,
            orientation='h',
            color=top_entities.values,
            color_continuous_scale='Reds',
            labels={'x': 'Número de Homicidios', 'y': 'Entidad'}
        )
        fig.update_layout(height=400, showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("🎯 Causas de Muerte")
        causes = df_filtered['causa_def_cat'].value_counts()
        fig = px.pie(
            values=causes.values,
            names=causes.index,
            color_discrete_sequence=px.colors.sequential.RdBu
        )
        fig.update_layout(height=400)
        st.plotly_chart(fig, use_container_width=True)
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("👥 Distribución por Género")
        gender = df_filtered['sexo_cat'].value_counts()
        fig = px.pie(
            values=gender.values,
            names=gender.index,
            color_discrete_map={'Hombre': '#3b82f6', 'Mujer': '#ec4899', 'No especificado': '#9ca3af'},
            hole=0.4
        )
        fig.update_layout(height=350)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("📍 Lugar de Ocurrencia")
        places = df_filtered['lugar_ocur_cat'].value_counts().head(10)
        fig = px.bar(
            x=places.index,
            y=places.values,
            labels={'x': 'Lugar', 'y': 'Cantidad'},
            color=places.values,
            color_continuous_scale='Blues'
        )
        fig.update_xaxes(tickangle=45)
        fig.update_layout(height=350, showlegend=False)
        st.plotly_chart(fig, use_container_width=True)

# ==============================================================================
# PÁGINA: ANÁLISIS GEOGRÁFICO
# ==============================================================================
elif page == "🗺️ Análisis Geográfico":
    st.title("🗺️ Análisis Geográfico")
    
    col1, col2 = st.columns([2, 1])
    
    with col1:
        st.subheader("🌍 Mapa de Calor - Ubicación Geográfica")
        
        # Filtrar coordenadas válidas
        df_geo = df_filtered.dropna(subset=['lat_decimal', 'lon_decimal'])
        
        if len(df_geo) > 0:
            fig = px.scatter_mapbox(
                df_geo,
                lat='lat_decimal',
                lon='lon_decimal',
                hover_name='nom_mun',
                hover_data={'lat_decimal': False, 'lon_decimal': False, 'nom_ent': True},
                color='edad_anos',
                size_max=15,
                zoom=3,
                mapbox_style="carto-positron",
                color_continuous_scale='Viridis'
            )
            fig.update_layout(height=600)
            st.plotly_chart(fig, use_container_width=True)
        else:
            st.warning("No hay datos geográficos disponibles con los filtros seleccionados")
    
    with col2:
        st.subheader("📊 Estadísticas Geográficas")
        
        st.metric("Municipios registrados", df_filtered['nom_mun'].nunique())
        st.metric("Localidades", df_filtered['nom_loc'].nunique())
        st.metric("Casos con coordenadas", len(df_geo))
        
        st.markdown("---")
        st.subheader("🏙️ Top Municipios")
        top_mun = df_filtered[df_filtered['nom_mun'].notna()]['nom_mun'].value_counts().head(8)
        for i, (mun, count) in enumerate(top_mun.items(), 1):
            st.write(f"{i}. **{mun}**: {count} homicidios")
    
    st.markdown("---")
    
    st.subheader("🗺️ Análisis por Entidad Federativa")
    selected_entity = st.selectbox(
        "Selecciona una entidad para ver detalles",
        options=sorted(df_filtered['nom_ent'].dropna().unique())
    )
    
    entity_data = df_filtered[df_filtered['nom_ent'] == selected_entity]
    
    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("Homicidios", len(entity_data))
    with col2:
        st.metric("Municipios afectados", entity_data['nom_mun'].nunique())
    with col3:
        st.metric("Edad promedio víctimas", f"{entity_data['edad_anos'].mean():.1f}")
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("Municipios en " + selected_entity)
        top_mun_entity = entity_data['nom_mun'].value_counts().head(10)
        fig = px.bar(
            x=top_mun_entity.values,
            y=top_mun_entity.index,
            orientation='h',
            color=top_mun_entity.values,
            color_continuous_scale='Oranges',
            labels={'x': 'Homicidios', 'y': 'Municipio'}
        )
        fig.update_layout(height=400, showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("Causa de Muerte")
        causes_entity = entity_data['causa_def_cat'].value_counts()
        fig = px.pie(
            values=causes_entity.values,
            names=causes_entity.index,
            color_discrete_sequence=px.colors.sequential.YlOrRd
        )
        fig.update_layout(height=400)
        st.plotly_chart(fig, use_container_width=True)

# ==============================================================================
# PÁGINA: ANÁLISIS DEMOGRÁFICO
# ==============================================================================
elif page == "👥 Análisis Demográfico":
    st.title("👥 Análisis Demográfico")
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("📊 Pirámide Etaria")
        
        # Crear grupos de edad más amplios
        df_filtered['grupo_edad'] = pd.cut(
            df_filtered['edad_anos'],
            bins=[0, 10, 20, 30, 40, 50, 60, 70, 80, 100],
            labels=['0-9', '10-19', '20-29', '30-39', '40-49', '50-59', '60-69', '70-79', '80+'],
            right=False
        )
        
        edad_counts = df_filtered['grupo_edad'].value_counts().sort_index()
        
        fig = px.bar(
            x=edad_counts.values,
            y=edad_counts.index,
            orientation='h',
            color=edad_counts.values,
            color_continuous_scale='Spectral',
            labels={'x': 'Cantidad', 'y': 'Grupo de Edad'}
        )
        fig.update_layout(height=400, showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("👨👩 Análisis por Género")
        
        col_a, col_b = st.columns(2)
        with col_a:
            st.metric("% Hombres", f"{(df_filtered['sexo_cat'] == 'Hombre').sum() / len(df_filtered) * 100:.1f}%")
        with col_b:
            st.metric("% Mujeres", f"{(df_filtered['sexo_cat'] == 'Mujer').sum() / len(df_filtered) * 100:.1f}%")
        
        gender_age = df_filtered.groupby(['sexo_cat', 'edad_cat']).size().reset_index(name='count')
        fig = px.bar(
            gender_age,
            x='edad_cat',
            y='count',
            color='sexo_cat',
            barmode='group',
            color_discrete_map={'Hombre': '#3b82f6', 'Mujer': '#ec4899'},
            labels={'edad_cat': 'Categoría de Edad', 'count': 'Número de Casos'}
        )
        fig.update_xaxes(tickangle=45)
        fig.update_layout(height=400)
        st.plotly_chart(fig, use_container_width=True)
    
    st.markdown("---")
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("🎓 Distribución de Edad Estadística")
        
        age_stats = {
            'Media': df_filtered['edad_anos'].mean(),
            'Mediana': df_filtered['edad_anos'].median(),
            'Moda': df_filtered['edad_anos'].mode()[0] if len(df_filtered['edad_anos'].mode()) > 0 else 0,
            'Desv. Estándar': df_filtered['edad_anos'].std(),
            'Mínima': df_filtered['edad_anos'].min(),
            'Máxima': df_filtered['edad_anos'].max()
        }
        
        for label, value in age_stats.items():
            st.metric(label, f"{value:.1f}")
    
    with col2:
        st.subheader("📈 Distribución de Edad (Histograma)")
        
        fig = px.histogram(
            df_filtered,
            x='edad_anos',
            nbins=30,
            color_discrete_sequence=['#6366f1'],
            labels={'edad_anos': 'Edad', 'count': 'Frecuencia'}
        )
        fig.update_layout(height=400)
        st.plotly_chart(fig, use_container_width=True)
    
    st.markdown("---")
    
    st.subheader("🔍 Análisis por Categoría de Edad")
    cat_edad = df_filtered['edad_cat'].value_counts().reset_index()
    cat_edad.columns = ['Categoría', 'Cantidad']
    
    fig = px.bar(
        cat_edad,
        x='Categoría',
        y='Cantidad',
        color='Cantidad',
        color_continuous_scale='Purples',
        labels={'Cantidad': 'Número de Homicidios'}
    )
    fig.update_xaxes(tickangle=45)
    st.plotly_chart(fig, use_container_width=True)

# ==============================================================================
# PÁGINA: BÚSQUEDA AVANZADA
# ==============================================================================
elif page == "🔍 Búsqueda Avanzada":
    st.title("🔍 Búsqueda Avanzada y Tablas Interactivas")
    
    st.subheader("📋 Tabla Completa con Filtros")
    
    # Crear columnas de búsqueda
    col1, col2, col3 = st.columns(3)
    
    with col1:
        search_entity = st.text_input("🔎 Buscar por Entidad", "")
    with col2:
        search_municipality = st.text_input("🔎 Buscar por Municipio", "")
    with col3:
        search_cause = st.text_input("🔎 Buscar por Causa", "")
    
    # Aplicar búsquedas
    table_data = df_filtered.copy()
    
    if search_entity:
        table_data = table_data[table_data['nom_ent'].str.contains(search_entity, case=False, na=False)]
    if search_municipality:
        table_data = table_data[table_data['nom_mun'].str.contains(search_municipality, case=False, na=False)]
    if search_cause:
        table_data = table_data[table_data['causa_def_cat'].str.contains(search_cause, case=False, na=False)]
    
    # Seleccionar columnas a mostrar
    cols_to_show = st.multiselect(
        "Selecciona columnas a mostrar",
        options=['nom_ent', 'nom_mun', 'sexo_cat', 'edad_anos', 'edad_cat', 
                 'causa_def_cat', 'lugar_ocur_cat', 'fecha_ocurr', 'area_ur'],
        default=['nom_ent', 'nom_mun', 'sexo_cat', 'edad_anos', 'causa_def_cat', 'fecha_ocurr']
    )
    
    st.write(f"**Resultados: {len(table_data)} registros**")
    
    # Mostrar tabla
    display_df = table_data[cols_to_show].copy()
    st.dataframe(display_df, use_container_width=True, height=400)
    
    # Descargar datos
    csv = display_df.to_csv(index=False)
    st.download_button(
        label="📥 Descargar CSV",
        data=csv,
        file_name="homicidios_filtrados.csv",
        mime="text/csv"
    )
    
    st.markdown("---")
    
    st.subheader("📊 Estadísticas de Búsqueda")
    
    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric("Total registros", len(table_data))
    with col2:
        st.metric("Entidades", table_data['nom_ent'].nunique())
    with col3:
        st.metric("Municipios", table_data['nom_mun'].nunique())
    with col4:
        st.metric("Edad promedio", f"{table_data['edad_anos'].mean():.1f}")

# ==============================================================================
# PÁGINA: TENDENCIAS TEMPORALES
# ==============================================================================
elif page == "📈 Tendencias Temporales":
    st.title("📈 Análisis de Tendencias Temporales")
    
    # Agrupar por mes
    df_time = df_filtered.copy()
    df_time['mes'] = df_time['fecha_ocurr'].dt.to_period('M')
    monthly_counts = df_time.groupby('mes').size().reset_index(name='count')
    monthly_counts['mes'] = monthly_counts['mes'].astype(str)
    
    st.subheader("📅 Homicidios por Mes (2024)")
    
    fig = px.line(
        monthly_counts,
        x='mes',
        y='count',
        markers=True,
        line_shape='linear',
        color_discrete_sequence=['#ef4444'],
        labels={'mes': 'Mes', 'count': 'Número de Homicidios'},
        title='Tendencia Mensual de Homicidios'
    )
    fig.update_layout(height=400, hovermode='x unified')
    st.plotly_chart(fig, use_container_width=True)
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("📊 Homicidios por Día de la Semana")
        
        df_time['dia_semana'] = df_time['fecha_ocurr'].dt.day_name()
        dias_orden = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        dias_es = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
        
        day_counts = df_time['dia_semana'].value_counts().reindex(dias_orden)
        day_counts.index = dias_es
        
        fig = px.bar(
            x=day_counts.index,
            y=day_counts.values,
            color=day_counts.values,
            color_continuous_scale='Reds',
            labels={'x': 'Día de la Semana', 'y': 'Cantidad'}
        )
        fig.update_layout(height=350, showlegend=False)
        st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("⏰ Homicidios por Mes Natural")
        
        df_time['mes_num'] = df_time['fecha_ocurr'].dt.month
        mes_nombres = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                       'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
        
        month_counts = df_time.groupby('mes_num').size()
        month_labels = [mes_nombres[i-1] for i in month_counts.index]
        
        fig = px.bar(
            x=month_labels,
            y=month_counts.values,
            color=month_counts.values,
            color_continuous_scale='Blues',
            labels={'x': 'Mes', 'y': 'Cantidad'}
        )
        fig.update_layout(height=350, showlegend=False)
        st.plotly_chart(fig, use_container_width=True)

# ==============================================================================
# PÁGINA: INFORMACIÓN
# ==============================================================================
elif page == "ℹ️ Información":
    st.title("ℹ️ Información y Documentación")
    
    st.markdown("""
    ## 📚 Acerca de esta Aplicación
    
    Esta es una herramienta interactiva de análisis de datos de **Homicidios en México durante 2024**.
    
    ### 🎯 Características Principales
    
    - **Dashboard General**: Visualización rápida de métricas clave
    - **Análisis Geográfico**: Mapas interactivos y análisis por entidad/municipio
    - **Análisis Demográfico**: Distribuciones por edad, género y categorías
    - **Búsqueda Avanzada**: Filtros personalizados y exportación de datos
    - **Tendencias Temporales**: Análisis de patrones a lo largo del año
    
    ### 📊 Fuentes de Datos
    
    Archivo: `Homicidios_2024_clean.csv`
    
    Columnas principales incluyen:
    - Información geográfica (entidad, municipio, localidad, coordenadas)
    - Datos demográficos (edad, género, categoría)
    - Información del incidente (fecha, causa, lugar de ocurrencia)
    - Población registrada y características del área
    
    ### 🛠️ Funcionalidades
    
    ✅ Filtros interactivos en el menú lateral  
    ✅ Gráficos dinámicos con Plotly  
    ✅ Tablas descargables en CSV  
    ✅ Análisis estadístico completo  
    ✅ Mapas de calor geográficos  
    
    ### 📈 Navegación
    
    Usa el menú lateral para seleccionar diferentes vistas y análisis.
    Los filtros aplican globalmente a toda la aplicación.
    
    ---
    
    **Última actualización**: 2024  
    **Desarrollado con**: Streamlit + Plotly + Pandas
    """)
    
    st.markdown("---")
    
    st.subheader("📋 Diccionario de Datos")
    
    data_dict = {
        'Columna': [
            'nom_ent', 'nom_mun', 'nom_loc', 'fecha_nac', 'edad_anos', 
            'sexo_cat', 'causa_def_cat', 'lugar_ocur_cat', 'fecha_ocurr', 'lat_decimal', 'lon_decimal'
        ],
        'Descripción': [
            'Nombre de la entidad federativa',
            'Nombre del municipio',
            'Nombre de la localidad',
            'Fecha de nacimiento de la víctima',
            'Edad en años',
            'Género (Hombre, Mujer, No especificado)',
            'Causa del fallecimiento',
            'Lugar donde ocurrió el homicidio',
            'Fecha de ocurrencia del evento',
            'Latitud en coordenadas decimales',
            'Longitud en coordenadas decimales'
        ]
    }
    
    dict_df = pd.DataFrame(data_dict)
    st.dataframe(dict_df, use_container_width=True)

# ==============================================================================
# FOOTER
# ==============================================================================
st.markdown("---")
st.markdown("""
<div style="text-align: center; color: #6b7280; font-size: 0.85rem; padding: 1rem;">
    <p>Análisis de Homicidios en México 2024 | Datos procesados y visualizados con Streamlit</p>
    <p>Para reportes, contacta al equipo de análisis de datos</p>
</div>
""", unsafe_allow_html=True)
