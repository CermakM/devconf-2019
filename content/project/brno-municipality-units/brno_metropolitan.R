library(lubridate)
library(magrittr)
library(nlme)
library(tidyverse)
library(wrapr)

library(rgdal)
library(sf)


library(ggmap)
library(ggplot2)
library(plotly)

library(scales)
library(viridis)


# --- 
# helper functions
# ---

EPSG <- rgdal::make_EPSG()

#' Get CRS projection string.
get_proj4string <- function(code) { EPSG[which(EPSG$code == code),]$prj4 }

#' Transform coordinate system of given data frame.
transform_crs <- function(
  .data, lng, lat, from_crs, to_crs = '+proj=longlat +datum=WGS84 +no_defs',
  drop = F) {
  
  lng <- enquo(lng)
  lat <- enquo(lat)
  
  d <- .data %>%
    select(!!lng, !!lat) %>%
    set_colnames(c("lng", "lat"))
    
  coordinates(d) <- c("lng", "lat")
  proj4string(d) <- CRS(from_crs)

  d <- spTransform(d, CRS(to_crs))
  
  show(head(d))
  
  if (drop) {
    .data %<>% select(-c(!!lng, !!lat)) %>% mutate(lat = d$lat, lng = d$lng)
  } else {
    .data %<>%  mutate(lat = d$lat, lng = d$lng)
  }
  
  return(.data)
}


# ---
# Brno obyvatelstvo
# ---

shapefile.cr.moc <- st_read("datasets/brno_data/shape_files/cities/Městské_obvody_a_městské_části__polygony.shp")

df.brno.moc <- shapefile.cr.moc %>%
  filter(str_detect(NAZ_ZUJ, 'Brno')) %>%
  fortify()

### mutate municipality names
df.brno.moc$NAZ_ZUJ <- df.brno.moc$NAZ_ZUJ %>%
  sapply(str_to_title) %>%
  str_replace("^.*?-", "")

df.brno.obyv <- read_csv("datasets/brno_data/spravni_jednotky_obyvatele.csv")

df.brno <- merge(df.brno.moc, df.brno.obyv, by.x = "NAZ_ZUJ", by.y = "districts")

ggplot(data = df.brno[order(df.brno$population),], aes(label = NAZ_ZUJ)) +
  geom_sf(aes(fill = population)) +
  coord_sf(datum = NA) +
  scale_fill_gradient(breaks = ,low = muted('blue'), high = muted('red'), guide='legend') + 
  geom_label(
    aes(x = SX, y = SY, size=2, alpha=0.4), label.size = 0.15, show.legend = F) +
  labs(fill = "Population") +
  theme_void()

ggplot(data = df.brno) +
  geom_boxplot(aes(y = population))

ggplot(data = df.brno, aes(x = NAZ_ZUJ, y = population)) +
  geom_col() +
  theme(
    axis.text.x = element_text(angle = 90)
  )

ggplot(data = df.brno, aes(x = NAZ_ZUJ, y = population)) +
  geom_col() +
  theme(
    axis.text.x = element_text(angle = 90)
  )

df.brno$NAZ_ZUJ %<>% factor(levels = df.brno$NAZ_ZUJ[order(df.brno$population)])

### find split points

split_points <- c(5.5, 9.5, 16.5, 20.5, 25.5, 26.5)

population_graph <- ggplot(data = df.brno, aes(x = NAZ_ZUJ, y = population)) +
  geom_col() +
  geom_vline(xintercept = split_points, linetype='dashed', color='red') + 
  theme(
    axis.text.x = element_text(angle = 90)
  )

ggplotly(population_graph)

### mark split group

group_by_indices <- function(a, indicies) {
  .indicies <- sort(unique(indicies))
  grp <- c(1:length(a))
  
  grp[1:.indicies[.indicies[1]]] <- 1
  
  r <- 2
  for (i in c(2:length(.indicies))) {
    grp[.indicies[i-1]:.indicies[i]] <- r
    r <- r + 1
  }
  
  grp[.indicies[length(.indicies)]:length(a)] <- r
  
  return(grp)
}


df.brno$group[order(df.brno$population)] <- df.brno$population %>%
  sort() %>%
  group_by_indices(floor(split_points))

map.base <- ggplot(data = df.brno[order(df.brno$population),]) +
  geom_sf() +
  coord_sf(datum = NA)

map.population <- map.base +
  geom_sf(aes(fill = population, alpha)) +
  coord_sf(datum = NA) +
  scale_fill_viridis(
    trans = 'log',
    breaks = round(sort(df.brno$population)[floor(split_points)], -3),
    name = "Number of citizens",
    guide = guide_legend(keyheight = unit(3, units = 'mm'), keywidth = unit(12, units = 'mm'),
                         label.position = 'bottom',
                         title.position = 'top',
                         nrow = 1)
    ) +
  # geom_label(aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=0.4), label.size = 0.15, show.legend = F) +
  theme_void()


### plot traffic accidents

df.accidents = read_csv("datasets/brno_data/clean/accidents.csv")

colnames(df.accidents) %<>% str_replace_all(" ", ".") %>% tolower()

### Set Coordinate System
### projected CRS: WGS 84 / Pseudo-Mercator, EPSG:3857

df.brno$geometry %<>% st_transform(4326)
df.accidents <- transform_crs(df.accidents, get_proj4string(3857),
                              lng = x, lat = y, drop = F)

df.accidents %<>%
  mutate_at(vars(day.of.the.week), funs(str_sub(., end = 3L)))

### by collision type
ggplot(data = df.accidents) +
  geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
  facet_wrap(vars(type.of.the.accident)) +
  labs(title = "Brno Accidents", subtitle = "by Collision Type") + 
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

### by collision place
ggplot(data = df.accidents) +
  geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
  facet_wrap(vars(`place`)) +
  labs(title = "Brno Accidents", subtitle = "by Collision Place") + 
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

### by vehicle type
ggplot(data = df.accidents) +
  geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
  facet_wrap(vars(`vehicle.type`)) +
  labs(title = "Brno Accidents", subtitle = "by Vehicle Type") + 
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_blank()
  )

### by vehicle type (free scales)
ggplot(data = df.accidents) +
  geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
  facet_wrap(vars(`vehicle.type`), scales = 'free') +
  labs(title = "Brno Accidents", subtitle = "by Vehicle Type") + 
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

map.base +
  geom_point(data = df.accidents, aes(x = lng, y = lat, color = factor(day.of.the.week)), alpha=0.8) +
  geom_label(data = df.brno, aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=0.4),
             label.size = 0.15,
             show.legend = F)


map.accidents <- map.base +
  geom_point(data = df.accidents, aes(x = lng, y = lat, color = light.injuries, size = light.injuries), alpha=0.8) +
  geom_label(data = df.brno, aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=0.4),
             label.size = 0.15,
             show.legend = F) +
  scale_color_gradient(low = '#ffffb2', high = '#b30000', guide = 'legend') +
  labs(color = "Injuries", size = "Injuries") +
  labs(title = "Brno Accidents") + 
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

### heat points

palette <- grDevices::colorRampPalette(rev(rainbow(10, end = 4/6)))

map.base +
  geom_point(data = df.accidents, aes(x = lng, y = lat,
                                      col = grDevices::densCols(df.accidents$lng, df.accidents$lat, 
                                                                colramp = palette)),
             shape = 15, size=1.5, show.legend = F
  ) +
  scale_color_identity()

### overlay intensity and the base map
library(cowplot)

map.heat <- ggplot(data = df.accidents, aes(x = lng, y = lat)) +
  stat_density_2d(aes(fill = ..level.., alpha = ..level..), n = 100,
                  geom = 'polygon', show.legend = F) +
  scale_fill_distiller(palette = 'Spectral', direction = -1) +
  theme_void()

ggdraw(map.base) + draw_plot(map.heat)

# interactive

library(leaflet)
library(leaflet.extras)

brno.center = list(lng = 16.606837, lat = 49.195060)
brno.bbox <- st_bbox(df.brno$geometry) %>%
  setNames(c("lng1", "lat1", "lng2", "lat2")) %>%
  as.list()

leaflet(df.brno, options = leafletOptions(minZoom = 12)) %>%
  # basemap
  addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
  # zoom to Brno
  setView(lng = brno.center$lng, lat = brno.center$lat, zoom = 12) %>%
  # municipality boundaries
  addPolygons(
    fillOpacity = 0,
    color = '#cccccc',
    weight = 2,
    label = ~NAZ_ZUJ, labelOptions = labelOptions(textsize = '13px')) %>%
  # heatmap
  addHeatmap(lng = df.accidents$lng, lat = df.accidents$lat,
             radius = 5, blur = 15, minOpacity = 0.05) %>%
  # control
  addDrawToolbar(
    editOptions = editToolbarOptions(),
    singleFeature = T) %>%
  addResetMapButton() %>%
  addScaleBar(position = 'bottomleft')
