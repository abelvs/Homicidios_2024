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

#Análsis exploratorio---- 

#Distribución demográfica

table(df$sexo_cat)

hist(df$edad_rango)

hist(df$edad_anos)

#Plot randos de edad y genero

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
  theme(legend.position = "right")+
  labs(x = "", y = "Porcentaje",
       fill = "")

ggsave("03_output/Piramide_pob.png",
       width = 10,
       height = 5.6,
       dpi = 300)

#Identificamos una mayor proporción de mujeres víctimas de homicidio en los grupos menores a 15 años

menores_15 <- df %>% 
  filter(edad_anos <=18) 

table(menores_15$sexo_cat)













