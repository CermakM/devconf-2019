---
title: "Brno Traffic Accidents"
subtitle: "[DATASET]"
date: "2019-01-23"

weight: 2

summary: Visualization of traffic accidents in Brno.

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
  - "traffic"
---

Let's start by including a few libraries ...

    library(lubridate)
    library(magrittr)
    library(tidyverse)
    library(wrapr)

    library(rgdal)
    library(sf)


    library(ggplot2)
    library(plotly)

    library(scales)
    library(viridis)

We are gonna borrow some functions and the basemap from our previous
projects (see Brno Municipality Units)

`...` (the code is left out for clarity)

### Brno Traffic Accidents

> 💡 TIP: Check out the Brno application
> [here](https://data.brno.cz/en/dopravni-nehody-na-uzemi-mesta-brna/)

Get the data for the accidents

> Data is available at:
> [DATA.BRNO](https://data.brno.cz/en/dataset/?id=dopravni-nehody)

    # data after some polishing
    df.accidents = read_csv("data/traffic/clean/accidents.csv")

    colnames(df.accidents) %<>% str_replace_all(" ", ".") %>% tolower()

    # Set Coordinate System
    # projected CRS: WGS 84 / Pseudo-Mercator, EPSG:3857

    # unify coordinate systems with df.brno
    df.accidents <- transform_crs(df.accidents,
                                  from_crs = get_proj4string(3857),
                                  to_crs = st_crs(df.brno)$proj4string,
                                  lng = x, lat = y, drop = F)

    df.accidents %<>%
      mutate_at(vars(day.of.the.week), funs(str_sub(., end = 3L)))

Plot by collision type
----------------------

    ggplot(data = df.accidents) +
      geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
      facet_wrap(vars(type.of.the.accident)) +
      xlab("Day of the Week") +
      ylab("Number of Accidents") +
      labs(
        title = "Brno Accidents",
        subtitle = "by Collision Type")

![](project/brno-traffic-accidents/figure/unnamed-chunk-8-1.png)

      theme(
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
      )

By collision place

    ggplot(data = df.accidents) +
      geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
      facet_wrap(vars(`place`)) +
      labs(title = "Brno Accidents", subtitle = "by Collision Place") +
      xlab("Day of the Week") +
      ylab("Number of Accidents") +
      theme(
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        
        axis.ticks.x = element_blank()
      )

![](project/brno-traffic-accidents/figure/unnamed-chunk-9-1.png)

By vehicle type

    p <- ggplot(data = df.accidents) +
      geom_bar(aes(x = day.of.the.week, fill = `day/night`)) +
      facet_wrap(vars(`vehicle.type`)) +
      labs(title = "Brno Accidents", subtitle = "by Vehicle Type") +
      xlab("Day of the Week") +
      ylab("Number of Accidents") +
      theme(
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      )

![](project/brno-traffic-accidents/figure/unnamed-chunk-11-1.png)

We can also to go interactive here (but note that the identifiers are
quite long)

> Exercise: Process the vehicle types

    # ggplotly(p)

Go back to our Brno base map and let's plot geo
-----------------------------------------------

First classify by day of the week

    map.base +
      geom_point(data = df.accidents, aes(x = lng, y = lat, color = factor(day.of.the.week)), alpha=0.8) +
      geom_label(data = df.brno, aes(label = NAZ_ZUJ, x = SX, y = SY, size=2, alpha=0.4),
                 label.size = 0.15,
                 show.legend = F) +
      labs(color = "Day of the week")

![](project/brno-traffic-accidents/figure/unnamed-chunk-13-1.png)

Or by number of injuries

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

![](project/brno-traffic-accidents/figure/unnamed-chunk-15-1.png)

Explore map data with heatmap-ish points
----------------------------------------

    palette <- grDevices::colorRampPalette(rev(rainbow(10, end = 4/6)))

    map.base +
      geom_point(data = df.accidents, aes(x = lng, y = lat,
                                          col = grDevices::densCols(df.accidents$lng, df.accidents$lat,
                                                                    nbin=100, colramp = palette)),
                 size=1.25, show.legend = F
      ) +
      scale_color_identity()

![](project/brno-traffic-accidents/figure/unnamed-chunk-16-1.png)

Overlay intensity and the base map

    library(cowplot)

    map.heat <- ggplot(data = df.accidents, aes(x = lng, y = lat)) +
      stat_density_2d(aes(fill = ..level.., alpha = ..level..), n = 100,
                      geom = 'polygon', show.legend = F) +
      scale_fill_distiller(palette = 'Spectral', direction = -1) +
      theme_void()

    ggdraw(map.base) + draw_plot(map.heat)

![](project/brno-traffic-accidents/figure/unnamed-chunk-17-1.png)

Interactive plots
-----------------

Leaflet

> ⚠ NOTE: will be rendered as JPEG in embedded markdown notebooks) ⚠

We need to set WGS84 CRS (the default)

    df.accidents <- transform_crs(df.accidents,
                                  from_crs = get_proj4string(3857),
                                  lng = x, lat = y, drop = F)


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

![](project/brno-traffic-accidents/figure/unnamed-chunk-19-1.png)

Kepler.gl
---------

Awesome 3D interactive spatial data visualization tool.

![](img/brno-data-accidents.png)

> 💡 TIP: Check out [kepler.gl](http://kepler.gl/) and try the
> [demo](http://kepler.gl/#demo)
