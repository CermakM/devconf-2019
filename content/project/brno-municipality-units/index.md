---
title: "Brno Municipality Units"
subtitle: "[DATASET]"
date: "2019-01-23"

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

      show(head(d))

      if (drop) {
        .data %<>% select(-c(!!lng, !!lat)) %>% mutate(lat = d$lat, lng = d$lng)
      } else {
        .data %<>%  mutate(lat = d$lat, lng = d$lng)
      }

      return(.data)
    }

Get the shape files for Brno base map


    shapefile.cr.moc <- st_read("data/shape_files/moc/Městské_obvody_a_městské_části__polygony.shp")

    df.brno.moc <- shapefile.cr.moc %>%
      filter(str_detect(NAZ_ZUJ, 'Brno')) %>%
      fortify()

    # preprocessing
    df.brno.moc$NAZ_ZUJ <- df.brno.moc$NAZ_ZUJ %>%
      sapply(str_to_title) %>%
      str_replace("^.*?-", "")

    df.brno.obyv <- read_csv("data/brno_data/spravni_jednotky_obyvatele.csv")

    df.brno <- merge(df.brno.moc, df.brno.obyv, by.x = "NAZ_ZUJ", by.y = "districts")

Peek at the data

    head(df.brno)
    ## Simple feature collection with 6 features and 20 fields
    ## geometry type:  POLYGON
    ## dimension:      XY
    ## bbox:           xmin: -610939.6 ymin: -1170375 xmax: -593310.3 ymax: -1150483
    ## epsg (SRID):    NA
    ## proj4string:    +proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=30.28813975277778 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +units=m +no_defs
    ##     NAZ_ZUJ OBJECTID KOD_MOaMC     NAZ_ZKR_MO      NAZ_MOaMC KOD_OBEC
    ## 1  Bohunice       76    551082  Brno-Bohunice  Brno-Bohunice   582786
    ## 2  Bosonohy       92    551325  Brno-Bosonohy  Brno-Bosonohy   582786
    ## 3    Bystrc       81    551198    Brno-Bystrc    Brno-Bystrc   582786
    ## 4 Černovice       74    551066 Brno-Černovice Brno-Černovice   582786
    ## 5   Chrlice       91    551317   Brno-Chrlice   Brno-Chrlice   582786
    ## 6 Ivanovice       94    551376 Brno-Ivanovice Brno-Ivanovice   582786
    ##   NAZ_OBEC KOD_ZUJ KOD_OKRES KOD_LAU1   NAZ_LAU1 KOD_KRAJ KOD_CZNUTS
    ## 1     Brno  551082     40711   CZ0642 Brno-město     3115      CZ064
    ## 2     Brno  551325     40711   CZ0642 Brno-město     3115      CZ064
    ## 3     Brno  551198     40711   CZ0642 Brno-město     3115      CZ064
    ## 4     Brno  551066     40711   CZ0642 Brno-město     3115      CZ064
    ## 5     Brno  551317     40711   CZ0642 Brno-město     3115      CZ064
    ## 6     Brno  551376     40711   CZ0642 Brno-město     3115      CZ064
    ##          NAZ_CZNUTS        SX       SY SHAPE_Leng SHAPE_Area id population
    ## 1 Jihomoravský kraj -600545.2 -1163337   10195.83    3017709  8      13026
    ## 2 Jihomoravský kraj -604417.9 -1161660   13888.64    7147886 24       2366
    ## 3 Jihomoravský kraj -607059.7 -1155566   39812.76   27242244 13      23539
    ## 4 Jihomoravský kraj -595373.0 -1162892   10449.32    6291806  6       6955
    ## 5 Jihomoravský kraj -595592.3 -1168729   16026.03    9492907 23       3187
    ## 6 Jihomoravský kraj -600046.7 -1152829   10054.77    2446103 26       1672
    ##                         geometry
    ## 1 POLYGON ((-601002.7 -116196...
    ## 2 POLYGON ((-605152.2 -116007...
    ## 3 POLYGON ((-608145.9 -115048...
    ## 4 POLYGON ((-596356.1 -116148...
    ## 5 POLYGON ((-596347.5 -116673...
    ## 6 POLYGON ((-599444.4 -115172...

<br>

### Brno population

Start simple

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

![](project/brno-municipality-units/figure/unnamed-chunk-4-1.png)


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

![](project/brno-municipality-units/figure/unnamed-chunk-5-1.png)

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

![](project/brno-municipality-units/figure/unnamed-chunk-7-1.png)

And color it accordingly

    population_graph +
      geom_col(aes(fill = population)) +
      scale_fill_gradient(
        breaks = split_points,
        low = muted('blue'), high = muted('red'),
        guide = 'legend')

![](project/brno-municipality-units/figure/unnamed-chunk-8-1.png)

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

![](project/brno-municipality-units/figure/unnamed-chunk-10-1.png)

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

![](project/brno-municipality-units/figure/unnamed-chunk-12-1.png)

... And add some fancy stuff, like custom coloring and legend based on
the splits above

    # population map
    map.population <- map.population +
      scale_fill_gradient(
        low = muted('blue'), high = muted('red'),
        breaks = round(sort(df.brno$population)[floor(split_points)], -3),
        name = "Number of citizens",
        guide = guide_legend(
          keyheight = unit(3, units = 'mm'),
          keywidth = unit(12, units = 'mm'),
          label.position = 'bottom',
          title.position = 'top',
          nrow = 1)
        )

![](project/brno-municipality-units/figure/unnamed-chunk-14-1.png)

And labels for the municipality units

    map.population <- map.population +
      geom_label(
        aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=0.4),
        label.size = 0.15, show.legend = F
        ) +
      labs(title = "Brno Population per MOC")

![](project/brno-municipality-units/figure/unnamed-chunk-16-1.png)

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

![](project/brno-municipality-units/figure/unnamed-chunk-17-1.png)

Kepler.gl
---------

Awesome 3D interactive spatial data visualization tool.

![](img/brno-data-population.png)

> 💡 TIP: Check out [kepler.gl](http://kepler.gl/) and try the
> [demo](http://kepler.gl/#demo)
