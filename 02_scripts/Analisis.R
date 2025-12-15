# ------------------------------------------------------------------------------
#                              Análisis Homicidios 2024

# ------------------------------------------------------------------------------


pacman::p_load("dplyr", "ggplot2", "lubridate", "data.table", "janitor", "stringr",
               "httr", "jsonlite", "stringi", "ggthemes", "scales", "purrr", "tibble", "readxl", "tidyr",
               "sf", "viridis", "foreign", "here", "fs")

Sys.setlocale("LC_ALL", "es_MX.UTF-8")

options(scipen = 999)


#Cargamos base limpia de homicidios

df <- fread("03_output/Homicidios_2024_clean.csv")

#Grupos de edad---- 

#Distribución demográfica

table(df$sexo_cat)

hist(df$edad_anos)

#Plot rangos de edad y genero

rangos_sexo <- df %>% 
  mutate(edad_rango = factor(edad_rango, 
                             levels = c( "<1 año",
                                         "0-4", "5-9", "10-14", "15-19",
                                         "20-24", "25-29", "30-34", "35-39",
                                         "40-44", "45-49", "50-54", "55-59",
                                         "60-64", "65-69", "70-74", "75-79",
                                         "80-84", "85-89", "90-94", "95-99"))) %>% 
  group_by(edad_rango, sexo_cat) %>% 
  tally(name = "n") %>% 
  mutate(porc = case_when(sexo_cat == "Hombre" ~ n/28229,
                          sexo_cat == "Mujer" ~ n/3572,
                          sexo_cat == "No especificado" ~ n/264)) %>% 
  filter(sexo_cat != "No especificado") %>% 
  mutate(n = ifelse(sexo_cat == "Hombre", n*-1, n),
         porc = ifelse(sexo_cat == "Hombre", porc*-1, porc))


  
morado <- "#8b438d"
verde <- "#3daa57"
marron <- "#320a1d"
sem_1 <- "#f3e721"
sem_2 <- "#f0742a"
sem_3 <- "#d61c23"
  

rangos_sexo %>% 
  ggplot(aes(x = edad_rango, y = porc, fill = sexo_cat))+
  geom_col()+
  coord_flip()+
  geom_text(data = subset(rangos_sexo, sexo_cat == "Hombre"),
            aes(label = percent(abs(round(porc, 4)))),
            nudge_y= -0.011,
            fontface = "bold")+
  geom_text(data = subset(rangos_sexo, sexo_cat == "Mujer"),
            aes(label = percent(abs(round(porc, 4)))),
            nudge_y= 0.011,
            fontface = "bold")+
  scale_fill_manual(values = c("Hombre" = morado,
                               "Mujer" = verde))+
  scale_y_continuous(limits = c(-0.18,0.16),
                     breaks = seq(-0.18, 0.16, 0.03),
                     labels = function(x) percent(abs(round(x, 4))))+
  theme_minimal()+
  theme(legend.position = "right",
        panel.grid = element_blank())+
  labs(x = "", y = "Porcentaje",
       fill = "",
       caption = "Elaboración propia con datos del INEGI")

ggsave("03_output/Piramide_pob.png",
       width = 10,
       height = 6,
       dpi = 300)

#Identificamos una mayor proporción de mujeres víctimas de homicidio en los grupos menores a 10 años



menores_10 <- df %>% 
  filter(edad_anos <=10) %>% 
  group_by(edad_anos, sexo_cat) %>% 
  tally(name = "n") %>% 
  filter(sexo_cat != "No especificado") %>% 
  mutate(n = ifelse(sexo_cat == "Hombre", n*-1, n))

table(df$sexo_cat[df$edad_anos<=10])
#El número de víctimas se iguala


menores_10 %>% 
  ggplot(aes(x = edad_anos, y = n, fill = sexo_cat))+
  geom_col()+
  coord_flip()+
  geom_text(data = subset(menores_10, sexo_cat == "Hombre"),
            aes(label = abs(n)),
            nudge_y= -0.5,
            fontface = "bold",
            size = 5)+
  geom_text(data = subset(menores_10, sexo_cat == "Mujer"),
            aes(label = abs(n)),
            nudge_y= 0.5,
            fontface = "bold",
            size = 5)+
  scale_x_continuous(breaks = seq(-14,14,1),
                     expand = c(0,0))+
  scale_y_continuous(labels = function(x) abs(round(x, 4)))+
  scale_fill_manual(values = c("Hombre" = morado,
                               "Mujer" = verde))+
  theme_minimal()+
  theme(legend.position = "right")+
  labs(x = "", y = "Víctimas",
       fill = "",
       title = "Distribución por sexo de víctimas de homicidio de 10 años o menos",
       subtitle = "Total de homicidios por años cumplidos",
       caption = "Elaboración propia con datos del INEGI")+
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        panel.grid = element_blank())

ggsave("03_output/Vict_10_o_menos.png",
       width = 10,
       height = 7,
       dpi = 300)


#Los medios de agresión o causas de muerte siguen también un patrón diferente en este grupo. Baja arma de fuego, sube

tabla_proporciones_medios <- df %>% 
  mutate(grupo_edad = if_else(edad_anos <= 10, "<= 10 años", "> 10 años")) %>% 
  count(grupo_edad, causa_def_cat) %>% 
  group_by(grupo_edad) %>% 
  mutate(total = sum(n),
         proporcion = n / total) %>% 
  ungroup() %>% 
  filter(!is.na(grupo_edad))

#Sube "otros", pero en realidad lo que sube son las categorías de "Medio no especificado"; No hau información detallada para este grupo de edad
tabla_proporciones_medios_detalle <- df %>% 
  mutate(grupo_edad = if_else(edad_anos <= 10, "<= 10 años", "> 10 años"),
         causa_def_cat = ifelse(causa_def_cat == "Otro", causa_def_detalle, causa_def_cat)) %>% 
  count(grupo_edad, causa_def_cat) %>% 
  group_by(grupo_edad) %>% 
  mutate(total = sum(n),
         proporcion = n / total) %>% 
  ungroup() %>% 
  filter(!is.na(grupo_edad)) 

df_lollipop <- tabla_proporciones_medios %>% 
  select(grupo_edad, causa_def_cat, proporcion) %>% 
  pivot_wider(names_from = grupo_edad,
              values_from = proporcion)

ggplot(df_lollipop) +
  geom_segment(aes(x = `> 10 años`,
                   xend = `<= 10 años`,
                   y = causa_def_cat,
                   yend = causa_def_cat),
               linewidth = 1.2,
               color = "grey70") +
  geom_point(aes(x = `> 10 años`, y = causa_def_cat, color = "> 10 años"),
             size = 3) +
  geom_point(aes(x = `<= 10 años`, y = causa_def_cat, color = "<= 10 años"),
             size = 4) +
  geom_text(aes(x = `> 10 años`,
                y = causa_def_cat,
                label = scales::percent(`> 10 años`, accuracy = 1),
                color = "> 10 años"),
            fontface = "bold",
            hjust = 0,
            vjust = -1,
            show.legend = F) +
  geom_text(aes(x = `<= 10 años`,
                y = causa_def_cat,
                label = scales::percent(`<= 10 años`, accuracy = 1),
                color = "<= 10 años"),
            fontface = "bold",
            hjust = 0,
            vjust = -1,
            show.legend = F) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_color_manual(name = "Grupo de edad",
                     values = c("<= 10 años" = morado,
                                "> 10 años"  = verde)) +
  labs(x = "Proporción de casos",
       y = NULL,
       title = "Cambio en la proporción de causas de muerte",
       subtitle = "Menores de 10 años vs población mayor",
       caption = "Elaboración propia con datos del INEGI") +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title.position = "plot",
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

ggsave("03_output/Lollipop_causas_10_o_menos.png",
       width = 7,
       height = 5,
       dpi = 300)


#Distribución geográfica----

cat_ent <- fread("03_output/Catalogo_entidades.csv",
                 encoding = "UTF-8") %>% 
  mutate(cve_ent = str_pad(clave_entidad, side = "left", pad = "0", width = 2)) %>% 
  select(-c(V1, clave_entidad))

tabla_edos <- df %>% 
  count(clave_entidad) %>% 
  mutate(cve_ent = str_pad(clave_entidad,
                           side = "left",
                           pad = "0",
                           width = 2)) %>% 
  left_join(cat_ent, by = "cve_ent") %>% 
  mutate(tasa_100 = (n/pob_ent)*100000)

tabla_edos_cumsum <- tabla_edos %>% 
  arrange(-n) %>% 
  mutate(cumsum= cumsum(n),
         cumporc = cumsum/32065)

mean(tabla_edos$tasa_100, na.rm = T)

(112.393042-27.98803)/27.98803

#Colima lidera al país por tasa de homicidios


sf_ent <- st_read("01_datos_brutos/Shp_ent/sf_ent.shp") %>% 
  left_join(tabla_edos, by = "cve_ent")




ggplot()+
  geom_sf(data = sf_ent,
          aes(fill = tasa_100))+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  theme_void()+
  labs(fill = "Tasa de homicidios por cada 100 mil habitantes")+
  theme(legend.position = "bottom")


ggsave("03_output/Nal_tasa_100.png",
       width = 10,
       height = 7,
       dpi = 300)

ggplot()+
  geom_sf(data = sf_ent,
          aes(fill = n))+
  scale_fill_gradient(low = "grey90",
                      high = verde)+
  theme_void()+
  labs(fill = "Total de homicidios")+
  theme(legend.position = "bottom")


ggsave("03_output/Nal_total.png",
       width = 10,
       height = 7,
       dpi = 300)

#Analisis municipal

cat_mun <- fread("03_output/Catalogo_municipios.csv") %>% 
  mutate(cvegeo = str_pad(clave_municipio, side = "left", width = 5, pad = "0")) %>% 
  select(-c(clave_municipio, V1))

tabla_mun <- df %>% 
  mutate(cvegeo = str_pad(clave_municipio, side = "left", width = 5, pad = "0")) %>% 
  count(cvegeo) %>% 
  left_join(cat_mun, by = "cvegeo") %>% 
  mutate(tasa_100 = (n/pob_mun)*100000) 
  
tabla_mun_mex <- tabla_mun %>% 
  mutate(ent = substr(cvegeo, 1,2)) %>% 
  filter(ent == "15")

tabla_bc <- tabla_mun_mex <- tabla_mun %>% 
  mutate(ent = substr(cvegeo, 1,2)) %>% 
  filter(ent == "02") %>% 
  adorn_totals()


sf_mun <- st_read("01_datos_brutos/Shp_mun/sf_municipal.shp") %>% 
  left_join(tabla_mun)%>% 
  mutate(n = ifelse(is.na(n), 0, n),
         tasa_100 = ifelse(is.na(tasa_100), 0, tasa_100))

ggplot()+
  geom_sf(data = sf_mun, aes(fill = tasa_100),
          color = "grey50",
          size = 0.1,
          show.legend = F)+
  scale_fill_gradient(low = "grey90",
                      high = morado,
                      trans = "sqrt")+
  geom_sf(data = sf_ent, fill = "transparent",
          color = "grey20",
          size = 0.45)+
  theme_void()+
  labs(fill = "Tasa")

ggsave("03_output/Nal_Munis_tasa.png",
       width = 10,
       height = 7,
       dpi = 300)

#Zoom estados-

conc_loc <- df %>% 
  group_by(clave_localidad) %>% 
  summarise(clave_entidad = first(clave_entidad),
            lat_decimal = first(lat_decimal),
            lon_decimal = first(lon_decimal),
            n = n()) %>% 
  mutate(clave_entidad = str_pad(clave_entidad, side = "left", pad = "0", width = 2))

entidad = "06"
ggplot()+
  geom_sf(data = (sf_mun %>% 
                    filter(cve_ent ==entidad)), 
          aes(fill = n))+
  geom_point(data = (conc_loc %>% 
                       filter(clave_entidad == entidad)),
             aes(y= lat_decimal,
                 x = lon_decimal,
                 size = n),
             color = marron)+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  coord_sf(xlim = c(-104.75, -103.29),
           ylim = c(18.65, 19.5))+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill = "",
       size = "")


ggsave("03_output/Col_dist.png",
       width = 7,
       height = 7,
       dpi = 800)



entidad = "11"
ggplot()+
  geom_sf(data = (sf_mun %>% 
                    filter(cve_ent ==entidad)), 
          aes(fill = n))+
  geom_point(data = (conc_loc %>% 
                       filter(clave_entidad == entidad)),
             aes(y= lat_decimal,
                 x = lon_decimal,
                 size = n),
             color = marron)+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill = "",
       size = "")


ggsave("03_output/Gto_dist.png",
       width = 7,
       height = 7,
       dpi = 800)



entidad = "27"
ggplot()+
  geom_sf(data = (sf_mun %>% 
                    filter(cve_ent ==entidad)), 
          aes(fill = n))+
  geom_point(data = (conc_loc %>% 
                       filter(clave_entidad == entidad)),
             aes(y= lat_decimal,
                 x = lon_decimal,
                 size = n),
             color = marron)+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill = "",
       size = "")


ggsave("03_output/Tab_dist.png",
       width = 7,
       height = 7,
       dpi = 800)



entidad = "08"
ggplot()+
  geom_sf(data = (sf_mun %>% 
                    filter(cve_ent ==entidad)), 
          aes(fill = n))+
  geom_point(data = (conc_loc %>% 
                       filter(clave_entidad == entidad)),
             aes(y= lat_decimal,
                 x = lon_decimal,
                 size = n),
             color = marron)+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill = "",
       size = "")


ggsave("03_output/Chih_dist.png",
       width = 7,
       height = 7,
       dpi = 800)

entidad = "15"
ggplot()+
  geom_sf(data = (sf_mun %>% 
                    filter(cve_ent ==entidad)), 
          aes(fill = n))+
  geom_point(data = (conc_loc %>% 
                       filter(clave_entidad == entidad)),
             aes(y= lat_decimal,
                 x = lon_decimal,
                 size = n),
             color = marron)+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill = "",
       size = "")


ggsave("03_output/Mex_dist.png",
       width = 7,
       height = 7,
       dpi = 800)

entidad = "02"
ggplot()+
  geom_sf(data = (sf_mun %>% 
                    filter(cve_ent ==entidad)), 
          aes(fill = n))+
  geom_point(data = (conc_loc %>% 
                       filter(clave_entidad == entidad)),
             aes(y= lat_decimal,
                 x = lon_decimal,
                 size = n),
             color = marron)+
  scale_fill_gradient(low = "grey90",
                      high = morado)+
  theme_void()+
  theme(legend.position = "bottom")+
  labs(fill = "",
       size = "")


ggsave("03_output/BC_dist.png",
       width = 7,
       height = 7,
       dpi = 800)



cond_indigena <- df %>% 
  filter(conindig == 1) %>% 
  mutate(edad_cat = factor(edad_cat,
         levels = c("Recién nacido", "Infancia", "Adolescencia",
                    "Adulto joven", "Adulto", "Adulto maduro", "Adulto mayor"))) %>% 
  group_by(edad_cat,
           sexo_cat) %>% 
  filter(!is.na(edad_cat)) %>% 
  tally()

cond_indigena %>% 
  ggplot(aes(x = sexo_cat, y = edad_cat, fill = n)) +
    geom_tile(color = "white") +                     # celdas con borde blanco
    geom_text(aes(label = n), color = "black") +    # número dentro de la celda
    scale_fill_gradient(low = "grey90", high = "#6A0DAD") + # gradiente gris -> morado
    labs(x = "Sexo", y = "Grupo de edad", fill = "Cantidad") +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size = 12))

cond_lengua <- df %>% 
  filter(lengua == 1) %>% 
  mutate(edad_cat = factor(edad_cat,
                           levels = c("Recién nacido", "Infancia", "Adolescencia",
                                      "Adulto joven", "Adulto", "Adulto maduro", "Adulto mayor"))) %>% 
  group_by(edad_cat,
           sexo_cat) %>% 
  filter(!is.na(edad_cat)) %>% 
  tally()

cond_lengua %>% 
  ggplot(aes(x = sexo_cat, y = edad_cat, fill = n)) +
  geom_tile(color = "white") +                     # celdas con borde blanco
  geom_text(aes(label = n), color = "black") +    # número dentro de la celda
  scale_fill_gradient(low = "grey90", high = "#6A0DAD") + # gradiente gris -> morado
  labs(x = "Sexo", y = "Grupo de edad", fill = "Cantidad") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))

cond_afromex <- df %>% 
  filter(afromex == 1) %>% 
  mutate(edad_cat = factor(edad_cat,
                           levels = c("Recién nacido", "Infancia", "Adolescencia",
                                      "Adulto joven", "Adulto", "Adulto maduro", "Adulto mayor"))) %>% 
  group_by(edad_cat,
           sexo_cat) %>% 
  filter(!is.na(edad_cat)) %>% 
  tally()

cond_afromex %>% 
  ggplot(aes(x = sexo_cat, y = edad_cat, fill = n)) +
  geom_tile(color = "white") +                     # celdas con borde blanco
  geom_text(aes(label = n), color = "black") +    # número dentro de la celda
  scale_fill_gradient(low = "grey90", high = "#6A0DAD") + # gradiente gris -> morado
  labs(x = "Sexo", y = "Grupo de edad", fill = "Cantidad") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))

#Completitud de datos----

#General
df_missing <- df %>%
  select(starts_with("comp_")) %>%
  summarise(across(everything(), ~ sum(. == 0))) %>%  # proporción de registros incompletos
  pivot_longer(everything(), names_to = "variable", values_to = "obs_sin_info") %>% 
  mutate(variable = str_remove(variable, "comp_"),
         variable = str_to_title(variable),
         prop_incompleto = obs_sin_info/32065)


df_missing %>% 
  ggplot(aes(x = reorder(variable, -prop_incompleto), y = prop_incompleto))+
  geom_col(fill = morado) +
  geom_text(aes(label = percent(round(prop_incompleto, 3))),
            nudge_y = .069,
            fontface = "bold",
            size = 4)+
  geom_text(aes(label = paste0("(", comma(obs_sin_info), ")")),
            nudge_y = 0.03,
            size = 3)+
  scale_y_continuous(labels = percent_format(accuracy = 1)) +
  labs(x = "Variable", y = "% de registros incompletos") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        panel.grid = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(title = "Porentaje de registros incompletos por categoría",
       subtitle = "(Total de registros)",
       caption = "Elaboración propia con datos de INEGI")


ggsave("03_output/Registros_incompletos.png",
       width = 10,
       height = 5,
       dpi = 300)

#Por entidad
df_missing_por_ent <- df %>% 
  group_by(nom_ent) %>% 
  summarise(total = n(),
            across(starts_with("comp_"), ~ 1 - mean(.),.names = "{.col}"),
            .groups = "drop") %>% 
  pivot_longer(cols = starts_with("comp_"),
               names_to = "variable",
               values_to = "prop_incompleto") %>% 
  mutate(variable = str_remove(variable, "comp_"),
         variable = str_remove(variable, "_prop_incompleto"),
         variable = str_to_title(variable))%>% 
  mutate(total_incompleto = prop_incompleto * total) %>% 
  group_by(nom_ent) %>% 
  mutate(mean_incompleto = mean(prop_incompleto, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(nom_ent = reorder(nom_ent, mean_incompleto))%>% 
  group_by(variable) %>% 
  mutate(mean_incompleto = mean(prop_incompleto, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(variable = reorder(variable, -mean_incompleto))

df_missing_por_ent %>% 
ggplot(aes(x = variable,
           y = nom_ent,
           fill = prop_incompleto)) +
  geom_tile(color = "white", linewidth = 0.3) +
  geom_text(aes(label = comma(round(total_incompleto)),
                color = prop_incompleto >= 0.5),
            size = 3)+
  scale_color_manual(
    values = c("FALSE" = "black", "TRUE" = "white"),
    guide = "none"
  )+
  scale_fill_gradient(low = "grey90",
                      high = morado,
                      labels = scales::percent_format(accuracy = 1)) +
  labs(x = "Variable",
       y = "Entidad federativa",
       fill = "% incompleto",
       title = "Proporción de registros con información incompleta") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank())

ggsave("03_output/Heat_completitud.png",
       width = 15,
       height = 12,
       dpi = 800)

