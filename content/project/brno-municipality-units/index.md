---
title: "Brno Municipality Units"
subtitle: "[DATASET]"
date: "2019-01-26"

weight: 1

summary: Visualizaiton of Brno population per Municipality unit.

output:
  md_document:
    preserve_yaml: TRUE

image:
  # Focal point (optional)
  # Options: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight
  focal_point: "Smart"

tags:
  - "brno"
  - "dataset"
  - "open-data"
  - "population"
---

Let's start by including a few libraries ...

    # tidyverse stuff
    library(lubridate)
    library(magrittr)
    library(tidyverse)
    library(wrapr)

    # spatial data
    library(rgdal)
    library(sf)

    # mapping
    library(ggplot2)
    library(plotly)

    # color scales/palettes
    library(scales)
    library(viridis)

Define helper functions

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

      if (drop) {
        .data %<>% select(-c(!!lng, !!lat)) %>% mutate(lat = d$lat, lng = d$lng)
      } else {
        .data %<>%  mutate(lat = d$lat, lng = d$lng)
      }

      return(.data)
    }

Get the shape files for Brno base map

> Data is available at:
> [arcdata.opendata](http://arccr-arcdata.opendata.arcgis.com/datasets/34ee5c20c3b54e6b82fd111d01905843_7)


    shapefile.cr.moc <- st_read("data/shape_files/moc/Městské_obvody_a_městské_části__polygony.shp")

    df.brno.moc <- shapefile.cr.moc %>%
      filter(str_detect(NAZ_ZUJ, 'Brno')) %>%
      fortify()

    # preprocessing
    df.brno.moc$NAZ_ZUJ <- df.brno.moc$NAZ_ZUJ %>%
      sapply(str_to_title) %>%
      str_replace("^.*?-", "")

    # this dataset has been created by hand
    # from https://data.brno.cz/zpravy-o-stavu-mesta/zprava-o-stavu-mesta-2018/ (PDF)
    df.brno.obyv <- read_csv("data/brno_data/spravni_jednotky_obyvatele.csv")

    df.brno <- merge(df.brno.moc, df.brno.obyv, by.x = "NAZ_ZUJ", by.y = "districts")

    # for future usage (population density)
    df.brno %<>%
      mutate(density = population * 1e6 / SHAPE_Area)  # person / km^2

Peek at the data

<table>
<caption>Brno municipality data</caption>
<thead>
<tr class="header">
<th align="left">NAZ_ZUJ</th>
<th align="right">OBJECTID</th>
<th align="left">KOD_MOaMC</th>
<th align="left">NAZ_ZKR_MO</th>
<th align="left">NAZ_MOaMC</th>
<th align="left">KOD_OBEC</th>
<th align="left">NAZ_OBEC</th>
<th align="left">KOD_ZUJ</th>
<th align="left">KOD_OKRES</th>
<th align="left">KOD_LAU1</th>
<th align="left">NAZ_LAU1</th>
<th align="left">KOD_KRAJ</th>
<th align="left">KOD_CZNUTS</th>
<th align="left">NAZ_CZNUTS</th>
<th align="right">SX</th>
<th align="right">SY</th>
<th align="right">SHAPE_Leng</th>
<th align="right">SHAPE_Area</th>
<th align="right">id</th>
<th align="right">population</th>
<th align="right">density</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Bohunice</td>
<td align="right">76</td>
<td align="left">551082</td>
<td align="left">Brno-Bohunice</td>
<td align="left">Brno-Bohunice</td>
<td align="left">582786</td>
<td align="left">Brno</td>
<td align="left">551082</td>
<td align="left">40711</td>
<td align="left">CZ0642</td>
<td align="left">Brno-město</td>
<td align="left">3115</td>
<td align="left">CZ064</td>
<td align="left">Jihomoravský kraj</td>
<td align="right">-600545.2</td>
<td align="right">-1163337</td>
<td align="right">10195.83</td>
<td align="right">3017709</td>
<td align="right">8</td>
<td align="right">13026</td>
<td align="right">4316.5189</td>
</tr>
<tr class="even">
<td align="left">Bosonohy</td>
<td align="right">92</td>
<td align="left">551325</td>
<td align="left">Brno-Bosonohy</td>
<td align="left">Brno-Bosonohy</td>
<td align="left">582786</td>
<td align="left">Brno</td>
<td align="left">551325</td>
<td align="left">40711</td>
<td align="left">CZ0642</td>
<td align="left">Brno-město</td>
<td align="left">3115</td>
<td align="left">CZ064</td>
<td align="left">Jihomoravský kraj</td>
<td align="right">-604417.9</td>
<td align="right">-1161660</td>
<td align="right">13888.64</td>
<td align="right">7147886</td>
<td align="right">24</td>
<td align="right">2366</td>
<td align="right">331.0070</td>
</tr>
<tr class="odd">
<td align="left">Bystrc</td>
<td align="right">81</td>
<td align="left">551198</td>
<td align="left">Brno-Bystrc</td>
<td align="left">Brno-Bystrc</td>
<td align="left">582786</td>
<td align="left">Brno</td>
<td align="left">551198</td>
<td align="left">40711</td>
<td align="left">CZ0642</td>
<td align="left">Brno-město</td>
<td align="left">3115</td>
<td align="left">CZ064</td>
<td align="left">Jihomoravský kraj</td>
<td align="right">-607059.7</td>
<td align="right">-1155566</td>
<td align="right">39812.76</td>
<td align="right">27242244</td>
<td align="right">13</td>
<td align="right">23539</td>
<td align="right">864.0625</td>
</tr>
<tr class="even">
<td align="left">Černovice</td>
<td align="right">74</td>
<td align="left">551066</td>
<td align="left">Brno-Černovice</td>
<td align="left">Brno-Černovice</td>
<td align="left">582786</td>
<td align="left">Brno</td>
<td align="left">551066</td>
<td align="left">40711</td>
<td align="left">CZ0642</td>
<td align="left">Brno-město</td>
<td align="left">3115</td>
<td align="left">CZ064</td>
<td align="left">Jihomoravský kraj</td>
<td align="right">-595373.0</td>
<td align="right">-1162892</td>
<td align="right">10449.32</td>
<td align="right">6291806</td>
<td align="right">6</td>
<td align="right">6955</td>
<td align="right">1105.4059</td>
</tr>
<tr class="odd">
<td align="left">Chrlice</td>
<td align="right">91</td>
<td align="left">551317</td>
<td align="left">Brno-Chrlice</td>
<td align="left">Brno-Chrlice</td>
<td align="left">582786</td>
<td align="left">Brno</td>
<td align="left">551317</td>
<td align="left">40711</td>
<td align="left">CZ0642</td>
<td align="left">Brno-město</td>
<td align="left">3115</td>
<td align="left">CZ064</td>
<td align="left">Jihomoravský kraj</td>
<td align="right">-595592.3</td>
<td align="right">-1168729</td>
<td align="right">16026.03</td>
<td align="right">9492907</td>
<td align="right">23</td>
<td align="right">3187</td>
<td align="right">335.7243</td>
</tr>
<tr class="even">
<td align="left">Ivanovice</td>
<td align="right">94</td>
<td align="left">551376</td>
<td align="left">Brno-Ivanovice</td>
<td align="left">Brno-Ivanovice</td>
<td align="left">582786</td>
<td align="left">Brno</td>
<td align="left">551376</td>
<td align="left">40711</td>
<td align="left">CZ0642</td>
<td align="left">Brno-město</td>
<td align="left">3115</td>
<td align="left">CZ064</td>
<td align="left">Jihomoravský kraj</td>
<td align="right">-600046.7</td>
<td align="right">-1152829</td>
<td align="right">10054.77</td>
<td align="right">2446103</td>
<td align="right">26</td>
<td align="right">1672</td>
<td align="right">683.5363</td>
</tr>
</tbody>
</table>

<br>

### Brno population

Start simple and proceed from general information to more specific.

Total number of Brno citizens:

    sum(df.brno$population)

    ggplot(data = df.brno) +
      geom_boxplot(aes(y = population)) +
      ylab("Population") +
      labs(title = "Brno Population per MOC") +
      theme(
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),

        plot.title = element_text(hjust = 0.5),

        panel.background = element_blank()
      )

![](project/brno-municipality-units/figure/unnamed-chunk-5-1.png)


    ggplot(data = df.brno, aes(x = NAZ_ZUJ, y = population)) +
      geom_col() +
      xlab("Municipality unit") +
      ylab("Population") +
      labs(title = "Brno Population per MOC") +
      theme(
        axis.text.x = element_text(angle = 90),

        plot.title = element_text(hjust = 0.5),

        panel.background = element_blank()
      )

![](project/brno-municipality-units/figure/unnamed-chunk-6-1.png)

Plot population split in the intervals

    population_graph <- ggplot(data = df.brno, aes(x = NAZ_ZUJ, y = population)) +
      geom_col() +
      geom_vline(xintercept = split_points, linetype='dashed', color='red') +
      xlab("Municipality unit") +
      ylab("Population") +
      labs(title = "Brno Population per MOC") +
      theme(
        axis.text.x = element_text(angle = 90),

        plot.title = element_text(hjust = 0.5),

        panel.background = element_blank()
      )

    population_graph  # for interactive version, use ggplotly(population_graph)

![](project/brno-municipality-units/figure/unnamed-chunk-8-1.png)

And color it accordingly

    population_graph +
      geom_col(aes(fill = population)) +
      scale_fill_gradient(
        breaks = split_points,
        low = muted('blue'), high = 'red',
        guide = 'legend')

![](project/brno-municipality-units/figure/unnamed-chunk-9-1.png)

Let's plot it on the map

... Start by the base map

    # base map
    map.base <- ggplot(data = df.brno[order(df.brno$population),]) +
      geom_sf() +
      coord_sf(datum = NA) +
      theme_void() +
      theme(
        plot.title = element_text(hjust = 0.5)
      ) +
      labs(title = "Brno Base Map")

![](project/brno-municipality-units/figure/unnamed-chunk-11-1.png)

Plot the population data

    # population map

    map.population <- map.base +
      geom_sf(aes(fill = population)) +
      coord_sf(datum = NA) +
      labs(title = "Brno Population per MOC") +
      theme_void() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )

![](project/brno-municipality-units/figure/unnamed-chunk-13-1.png)

... And add some fancy stuff, like custom coloring and legend based on
the splits above

    # population map
    map.population <- map.population +
      scale_fill_gradient(
        low = muted('blue'), high = 'red',
        breaks = round(sort(df.brno$population)[floor(split_points)], -3),
        name = "Number of citizens",
        guide = guide_legend(
          keyheight = unit(3, units = 'mm'),
          keywidth = unit(12, units = 'mm'),
          label.position = 'bottom',
          title.position = 'top',
          nrow = 1)
        )

![](project/brno-municipality-units/figure/unnamed-chunk-15-1.png)

And labels for the municipality units

    map.population +
      geom_label(
        aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=0.4),
        label.size = 0.15, show.legend = F
        ) +
      labs(title = "Brno Population per MOC")

![](project/brno-municipality-units/figure/unnamed-chunk-16-1.png)

It is often practical to highlight the labels as well

    map.population <- map.population +
      geom_label(
        # logarithmig fill for smoother transition
        aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=log(population)),
        label.size = 0.15, show.legend = F
        ) +
      labs(title = "Brno Population per MOC")

![](project/brno-municipality-units/figure/unnamed-chunk-18-1.png)

Perhaps not as pretty, but a little bit clearer scale:

    map.population +
      scale_fill_viridis(
        trans = 'log2',
        breaks = round(sort(df.brno$population)[floor(split_points)], -3),
        name = "Number of citizens",
        guide = guide_legend(
          keyheight = unit(3, units = 'mm'),
          keywidth = unit(12, units = 'mm'),
          label.position = 'bottom',
          title.position = 'top',
          nrow = 1)
        )

![](project/brno-municipality-units/figure/unnamed-chunk-19-1.png)

We might also be interested in area and/or population density

    ggplot(data = df.brno[order(df.brno$SHAPE_Area),], aes(x = NAZ_ZUJ, y = SHAPE_Area / 1e6)) +
      geom_col(aes(fill = SHAPE_Area)) +
      xlab("Municipality unit") +
      ylab(expression(paste("Area [km"^2*"]"))) +
      labs(title = "Brno Area size per MOC") +
      scale_fill_gradient(
        breaks = split_points,
        low = muted('blue'), high = 'red',
        guide = 'legend') +
      theme(
        axis.text.x = element_text(angle = 90),

        plot.title = element_text(hjust = 0.5),

        panel.background = element_blank()
      )

![](project/brno-municipality-units/figure/unnamed-chunk-20-1.png)

    area.breaks <- cut(sort(df.brno$SHAPE_Area), 5, ordered_result = T) %>%
      table() %>%  # frequency as index
      as.data.frame() %>%
      set_colnames(c("interval", "idx")) %>%
      mutate(idx = cumsum(idx))

    area.breaks$label <- sort(df.brno$SHAPE_Area[area.breaks$idx] / 1e6) %>%
      round(digits = 2)

    map.area <- map.base +
      geom_sf(aes(fill = SHAPE_Area)) +
      geom_label(
        # logarithmig fill for smoother transition
        aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=SHAPE_Area),
        label.size = 0.15, show.legend = F
        ) +
      coord_sf(datum = NA) +
      labs(title = "Brno area per MOC") +
      theme_void() +
      theme(
        plot.title = element_text(hjust = 0.5)
      ) +
      scale_fill_gradient(
        low = muted('blue'), high = 'red',
        breaks = sort(df.brno$SHAPE_Area[area.breaks$idx]),
        labels = area.breaks$label,
        name = expression(paste("Area size [km"^2*"]")),
        guide = guide_legend(
          keyheight = unit(3, units = 'mm'),
          keywidth = unit(12, units = 'mm'),
          label.position = 'bottom',
          title.position = 'top',
          nrow = 1)
        )

![](project/brno-municipality-units/figure/unnamed-chunk-22-1.png)

    density.breaks <- cut(sort(df.brno$density), 5, ordered_result = T) %>%
      table() %>%  # frequency as index
      as.data.frame() %>%
      set_colnames(c("interval", "idx")) %>%
      mutate(idx = cumsum(idx))

    density.breaks$label <- sort(df.brno$density[density.breaks$idx]) %>%
      round(-2)

    density.breaks

    map.density <- map.base +
      geom_sf(aes(fill = density)) +
      geom_label(
        # logarithmig fill for smoother transition
        aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=density),
        label.size = 0.15, show.legend = F
        ) +
      coord_sf(datum = NA) +
      labs(title = "Brno population density") +
      theme_void() +
      theme(
        plot.title = element_text(hjust = 0.5)
      ) +
      scale_fill_gradient(
        low = muted('blue'), high = 'red',
        breaks = sort(df.brno$density[density.breaks$idx]),
        labels = density.breaks$label,
        name = expression(paste("Density [person / km"^2*"]")),
        guide = guide_legend(
          keyheight = unit(3, units = 'mm'),
          keywidth = unit(12, units = 'mm'),
          label.position = 'bottom',
          title.position = 'top',
          nrow = 1)
        )

![](project/brno-municipality-units/figure/unnamed-chunk-24-1.png)

Kepler.gl
---------

Awesome 3D interactive spatial data visualization tool.

![](img/brno-data-population.png)

> 💡 TIP: Check out [kepler.gl](http://kepler.gl/) and try the
> [demo](http://kepler.gl/#demo)
