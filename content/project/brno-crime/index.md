---
title: "Brno Crime"
subtitle: "[DATASET]"
date: "2019-01-24"

weight: 3

summary: Visualization of crime in Brno.

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
  - "crime"
---

Let's start by including a few libraries ...

    library(tidyverse)
    library(magrittr)
    library(wrapr)

    library(cowplot)
    library(ggplot2)

    library(plotly)
    library(formattable)

    # custom color scale
    # inspired by https://github.com/drsimonj/blogR/blob/master/Rmd/creating_corporate_colors_ggplot2.Rmd
    source(file = "code/drsimonj.R", local = T)

    # set default ggplot theme due to cowplot usage
    theme_set(theme_grey())

Define some helper functions for future uusage

    get_colname <- function(.data, idx) { colnames(.data)[idx] %>% as.name() }
    get_density <- function(x, ...) {
      dens <- density(x, ...)
      ix <- findInterval(x, dens$x)
      return(dens$y[ix])
    }

    # ---- Types of crimes in our data ----

    assign_crime_cat <- function(v, ...) {
      sapply(v, function(x) {
        case_when(
          x < 200 ~ "Violent crime",
          x < 300 ~ "Sexual harassment",
          x < 500 ~ "Robbery & Burglary",
          x < 580 ~ "Fraud",
          x < 630 ~ "Vandalism",
          x < 690 ~ "Drugs, Weapons & Dealing",
          x < 800 ~ "Other criminal activities",
          x < 900 ~ "Financial and economical criminal acts",
          x >= 900 ~ "Military crimes"
        )
      })
    }

Get the data for the crime

> Data is available at:
> [DATA.BRNO](https://data.brno.cz/dataset/?id=kriminalita-v-brne)

    dat <- readxl::read_xlsx("data/criminality/raw/trestni_cinnost_2016.xlsx")

This data is not very polished

<table>
<caption>Brno crime data</caption>
<thead>
<tr class="header">
<th align="left">Útvar městské části (okres) PČR</th>
<th align="left">Základní útvar PČR, kde došlo k činu</th>
<th align="right">Stadium TČ, 1-příparava, 2-pokus, 3-dokonaný</th>
<th align="right">Druh TČ, 11-zločin, 18-přečin</th>
<th align="right">Takticko-statistická klasifikace činu</th>
<th align="right">Spácháno na ulici-1, ne-2</th>
<th align="right">Čin spáchán na : viz číselník</th>
<th align="right">Použití zbraně : viz číselník</th>
<th align="right">Druh použité zbraně : viz číselník</th>
<th align="left">Datum spáchání činu, či zahájení konání</th>
<th align="left">Datum ukončení konání činu (pokud jiné datum)</th>
<th align="right">Předmět zájmu pachatele č. 1</th>
<th align="left">Předmět zájmu pachatele nebo vztah pachatele k oběti - text</th>
<th align="right">Předmět zájmu pachatele č. 2</th>
<th align="left">Předmět zájmu pachatele nebo vztah pachatele k oběti - text__1</th>
<th align="right">Předmět zájmu pachatele č. 3</th>
<th align="left">Předmět zájmu pachatele nebo vztah pachatele k oběti - text__2</th>
<th align="left">Celková způsobená škoda v Kč</th>
<th align="left">Hlavní kvalifikace činu - paragraf TZ</th>
<th align="left">První odstavec</th>
<th align="left">Druhý odstavec</th>
<th align="left">Souběhový paragraf</th>
<th align="left">Odstavec souběhu</th>
<th align="left">Druhý souběhový paragraf</th>
<th align="left">Odstavec souběhu__1</th>
<th align="left">Datum zahájení trestního řízení</th>
<th align="left">Datum ukončení trestního řízení</th>
<th align="right">Způsob ukončení trestního řízení</th>
<th align="left">Způsob ukončení trestního řízení - text (kde je kód &quot;0&quot; tam ještě řízení nemusí být ukončeno</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">NA</td>
<td align="left">NA</td>
<td align="right">NA</td>
<td align="left">NA</td>
<td align="right">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="right">NA</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Brno - město</td>
<td align="left">OOP BRNO - STŘED</td>
<td align="right">3</td>
<td align="right">18</td>
<td align="right">121</td>
<td align="right">2</td>
<td align="right">6</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="left">2015-08-28 00:00:00</td>
<td align="left">2015-08-29 00:00:00</td>
<td align="right">601</td>
<td align="left">vlastní dítě</td>
<td align="right">0</td>
<td align="left">nic</td>
<td align="right">0</td>
<td align="left">nic</td>
<td align="left">0</td>
<td align="left">195</td>
<td align="left">1</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2016-01-01</td>
<td align="left">2016-04-14</td>
<td align="right">1</td>
<td align="left">zjištění pachatele</td>
</tr>
<tr class="odd">
<td align="left">Brno - město</td>
<td align="left">OOP BRNO - STŘED</td>
<td align="right">3</td>
<td align="right">11</td>
<td align="right">131</td>
<td align="right">2</td>
<td align="right">6</td>
<td align="right">3</td>
<td align="right">8</td>
<td align="left">2016-02-15 04:00:00</td>
<td align="left">1900-01-02 00:00:00</td>
<td align="right">620</td>
<td align="left">bez vztahu</td>
<td align="right">24</td>
<td align="left">valuty a devizy - bankovky</td>
<td align="right">0</td>
<td align="left">nic</td>
<td align="left">11773</td>
<td align="left">173</td>
<td align="left">1</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2016-02-15</td>
<td align="left">2016-04-01</td>
<td align="right">1</td>
<td align="left">zjištění pachatele</td>
</tr>
<tr class="even">
<td align="left">Brno - město</td>
<td align="left">OOP BRNO - STŘED</td>
<td align="right">3</td>
<td align="right">11</td>
<td align="right">131</td>
<td align="right">1</td>
<td align="right">6</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="left">2016-02-13 02:00:00</td>
<td align="left">1900-01-02 00:00:00</td>
<td align="right">620</td>
<td align="left">bez vztahu</td>
<td align="right">162</td>
<td align="left">Kufry, aktovky, kabelky, peněženky, pásky</td>
<td align="right">11</td>
<td align="left">občanské průkazy</td>
<td align="left">5500</td>
<td align="left">173</td>
<td align="left">1</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2016-02-13</td>
<td align="left">2016-05-02</td>
<td align="right">5</td>
<td align="left">odloženo podle § 159a/5 tr. řádu</td>
</tr>
<tr class="odd">
<td align="left">Brno - město</td>
<td align="left">OOP BRNO - STŘED</td>
<td align="right">3</td>
<td align="right">11</td>
<td align="right">131</td>
<td align="right">2</td>
<td align="right">6</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="left">2016-03-01 17:00:00</td>
<td align="left">2016-03-01 17:00:00</td>
<td align="right">620</td>
<td align="left">bez vztahu</td>
<td align="right">152</td>
<td align="left">svrchní oblečení</td>
<td align="right">0</td>
<td align="left">nic</td>
<td align="left">7781</td>
<td align="left">173</td>
<td align="left">1</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2016-03-02</td>
<td align="left">2016-09-09</td>
<td align="right">1</td>
<td align="left">zjištění pachatele</td>
</tr>
<tr class="even">
<td align="left">Brno - město</td>
<td align="left">OOP BRNO - STŘED</td>
<td align="right">3</td>
<td align="right">11</td>
<td align="right">131</td>
<td align="right">1</td>
<td align="right">6</td>
<td align="right">0</td>
<td align="right">0</td>
<td align="left">2016-05-12 19:00:00</td>
<td align="left">2016-05-13 01:00:00</td>
<td align="right">620</td>
<td align="left">bez vztahu</td>
<td align="right">21</td>
<td align="left">peníze</td>
<td align="right">0</td>
<td align="left">nic</td>
<td align="left">0</td>
<td align="left">173</td>
<td align="left">1</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2016-05-13</td>
<td align="left">2016-09-21</td>
<td align="right">1</td>
<td align="left">zjištění pachatele</td>
</tr>
</tbody>
</table>

Let's fix that a little bit

    # fix names
    colnames(dat) %<>% make.names()

    # filter rows where all columns are NA
    dat %<>%
      filter_all(any_vars(!is.na(.))) %>% as.data.frame() %>%
      transform(`Celková.způsobená.škoda.v.Kč` = currency(
        `Celková.způsobená.škoda.v.Kč`, symbol = "CZK", digits = 0L, sep = " "))

    col_e <- readxl::read_xls("data/criminality/raw/sloupec_e.xls")
    col_g <- readxl::read_xls("data/criminality/raw/sloupec_g.xls")
    col_h <- readxl::read_xls("data/criminality/raw/sloupec_h.xls")
    col_i <- readxl::read_xls("data/criminality/raw/sloupec_i.xls")

Categorize crimes

    dat %<>%
      group_by(Takticko.statistická.klasifikace.činu) %>%
      mutate(crime.category = factor(assign_crime_cat(Takticko.statistická.klasifikace.činu)))

    ## reorder factors
    dat$crime.category %<>% factor(unique(assign_crime_cat(seq(1, 1000, 50))))

Plot crimes by category

    plot.crimes.by.category <- ggplot(dat, aes(x = factor(Takticko.statistická.klasifikace.činu))) +
      geom_bar(aes(fill = crime.category)) +
      theme(
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),

        panel.background = element_blank(),

        plot.title = element_text(hjust = 0.5)
      ) +
      ylab("Number of crimes") +
      labs(
        fill = "Crime category",
        title = "Crime in Brno by Category"
      )

![](project/brno-crime/figure/unnamed-chunk-7-1.png)

Damage caused by crime incidents
--------------------------------

    dat.damage <- dat %>%
      select(Základní.útvar.PČR..kde.došlo.k.činu,
             Celková.způsobená.škoda.v.Kč,
             crime.category) %>%
      filter(str_detect(crime.category, "Robbery|Fraud"))

Initial exploration

    ggplot(dat.damage, aes(x = '', y = Celková.způsobená.škoda.v.Kč)) +
      geom_jitter(width = 0.2) +  # add some jitter to see the underlying data more clearly
      scale_y_continuous(labels = function(x, ...) {
        currency(x, ..., digits = 0L, symbol = "CZK", sep = ' ')
      }) +
      ylab("Total damage in CZK") +
      labs(title = "Damage caused by crime incidents") +
      theme(
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),

        plot.title = element_text(hjust = 0.5),

        panel.background = element_blank()
      )

![](project/brno-crime/figure/unnamed-chunk-9-1.png)

As we can see, there are some incredible outliers, let's get rid of them
by selecting .95p

    # 95% quantile
    dat.95q <- dat[which(dat$Celková.způsobená.škoda.v.Kč < quantile(dat$Celková.způsobená.škoda.v.Kč, .95)),]

    # density of the data points
    dens.95q <- get_density(dat.95q$Celková.způsobená.škoda.v.Kč, adjust = 5, n = 50)

And give it another shot, this time with coloring by density.

    plot.scatter <- ggplot(dat.95q, aes(x = `Celková.způsobená.škoda.v.Kč`, y = '')) +
      geom_jitter(aes(color = dens.95q), width = 0.2, show.legend = F) +
      theme(
        axis.line.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),

        axis.title.x = element_text(
          margin = margin(t = 10)),

        panel.background = element_blank(),

        plot.title = element_text(
          hjust = 0.5, vjust = 0.2, margin = margin(b = 20))
      ) +
      scale_x_continuous(
        breaks = {
          dat.95q %>% select(Celková.způsobená.škoda.v.Kč) %.>% seq(min(.), max(.), by=25000) %>% round(1)
        },
        labels = function(x, ...) {
          currency(x, ..., digits = 0L, symbol = "CZK", sep = ' ')
        }) +
      xlab("Damage in CZK") +
      labs(title = "Damage caused by crime incidents")

    plot.scatter

![](project/brno-crime/figure/unnamed-chunk-12-1.png)

Marginal density plot
---------------------

    plot.density <- ggplot(dat.95q, aes(x = `Celková.způsobená.škoda.v.Kč`)) +
      geom_density() +
      theme(
        axis.line.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),

        panel.background = element_blank(),

        plot.title = element_text(
          hjust = 0.5, vjust = 0.2, margin = margin(b = 20))
      )

    ggdraw(insert_xaxis_grob(plot.scatter, plot.density))

![](project/brno-crime/figure/unnamed-chunk-14-1.png)

Comparison between Facets
-------------------------

    dat.95q <- dat.95q %>% group_by(Základní.útvar.PČR..kde.došlo.k.činu) %>%
      mutate(mu = mean(Celková.způsobená.škoda.v.Kč)) %>%
      mutate(med = median(Celková.způsobená.škoda.v.Kč))

    # aquire total damage done by the place of crime
    dat.total <- dat.95q %>%
      group_by(Základní.útvar.PČR..kde.došlo.k.činu) %>%
      mutate(total.damage = sum(Celková.způsobená.škoda.v.Kč, na.rm = T) / 1e6) %>%
      mutate(total.damage.ratio = sum(Celková.způsobená.škoda.v.Kč, na.rm = T) / n()) %>%
      mutate(total.incidents = n()) %>%
      select(
        Základní.útvar.PČR..kde.došlo.k.činu,
        total.damage, total.damage.ratio, total.incidents
      ) %>%
      unique()

    plot.jitter <- ggplot(dat.95q, aes(x = '', y = `Celková.způsobená.škoda.v.Kč`)) +
      geom_jitter(aes(color = dens.95q), width = 0.2, show.legend = F) +
      facet_wrap(vars(`Základní.útvar.PČR..kde.došlo.k.činu`), strip.position = 'bottom') +
      geom_hline(  # total mean line
        aes(yintercept = mu),
        alpha = 0.4,
        linetype = 'dashed') +
      ylab("Damage in CZK") +
      labs(
        title = "Damage caused by crime incidents") +
      theme(
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(
          margin = margin(r = 10)
        ),
        plot.title = element_text(
          hjust = 0.5, vjust = 0.2, margin = margin(b = 20))
      )

![](project/brno-crime/figure/unnamed-chunk-17-1.png)

    plot.dtotal <- ggplot(dat.total, aes(x = Základní.útvar.PČR..kde.došlo.k.činu,
                          y = total.damage)) +
      # geom_col(aes(fill = Základní.útvar.PČR..kde.došlo.k.činu)) +
      geom_col(aes(fill = total.incidents)) +
      geom_hline(  # total mean line
        aes(yintercept = mean(total.damage)),
        alpha = 0.4,
        linetype = 'dashed') +
      scale_fill_drsimonj(palette = 'cool', discrete = F) +
      ylab("Damage in millions (CZK)") +
      xlab("Brno organization unit") +
      labs(
        fill = "Organization unit",
        title = "Total Damage caused by Crime Incident") +
      theme(
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(
          angle = -30,
          margin = margin(t = -5)
        ),
        axis.title.x = element_text(
          margin = margin(t = 15)
        ),
        axis.title.y = element_text(
          margin = margin(r = 15)
        ),
        plot.title = element_text(
          hjust = 0.5, vjust = 0.2, margin = margin(b = 20))
      )

![](project/brno-crime/figure/unnamed-chunk-19-1.png)

    plot.dpi <- ggplot(dat.total, aes(x = Základní.útvar.PČR..kde.došlo.k.činu,
                          y = total.damage.ratio)) +
      # geom_col(aes(fill = Základní.útvar.PČR..kde.došlo.k.činu)) +
      geom_col(aes(fill = total.incidents)) +
      geom_hline(  # total mean line
        aes(yintercept = mean(total.damage.ratio)),
        alpha = 0.4,
        linetype = 'dashed') +
      scale_fill_drsimonj(palette = 'cool', discrete = F) +
      ylab("Damage in CZK") +
      xlab("Brno organization unit") +
      labs(
        fill = "Organization unit",
        title = "Total Damage per Crime Incident") +
      theme(
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(
          angle = -30,
          margin = margin(t = -5)
        ),
        axis.title.x = element_text(
          margin = margin(t = 15)
        ),
        axis.title.y = element_text(
          margin = margin(r = 15)
        ),
        plot.title = element_text(
          hjust = 0.5, vjust = 0.2, margin = margin(b = 20))
      )

![](project/brno-crime/figure/unnamed-chunk-21-1.png)

Use cowplot to plot the partial plot

    plot_grid(plot.dtotal + theme(axis.text.x = element_blank(),
                                  axis.title.x = element_blank()) + guides(fill = FALSE),
              plot.dpi + guides(fill = FALSE),
              align = 'hv', nrow = 2)

![](project/brno-crime/figure/unnamed-chunk-22-1.png)

Stolen goods
------------

    dat.stolen.goods <- dat[dat$Předmět.zájmu.pachatele.nebo.vztah.pachatele.k.oběti...text != 'nic',]

There is quite a lot of levels

    ## levels
    levels(factor(dat.stolen.goods$Předmět.zájmu.pachatele.nebo.vztah.pachatele.k.oběti...text))

Filter robberies, thefts, financial frauds etc...

    # Refresher on our categories:

    ### x < 200 ~ "Violent crime",
    ### x < 300 ~ "Sexual harassment",
    ### x < 500 ~ "Robbery & Burglary",
    ### x < 580 ~ "Fraud",
    ### x < 630 ~ "Vandalism",
    ### x < 690 ~ "Drugs, Weapons & Dealing",
    ### x < 800 ~ "Other criminal activities",
    ### x < 900 ~ "Financial and economical criminal acts",
    ### x >= 900 ~ "Military crimes"

    dat.stolen.goods %<>%
      filter(between(Takticko.statistická.klasifikace.činu, 300, 900))

Count number of crimes and the damage

    plot.stolen.goods <- ggplot(
      dat.stolen.goods, aes(x = factor(Předmět.zájmu.pachatele.nebo.vztah.pachatele.k.oběti...text))) +
      geom_bar(aes(fill = crime.category)) +
      theme(
        axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),

        axis.title.y = element_text(
          margin = margin(r = 10)
        ),
        axis.title.x = element_text(
          margin = margin(t = 10)
        ),

        panel.background = element_blank(),

        plot.title = element_text(hjust = 0.5)
      ) +
      xlab("Stolen goods") +
      ylab("Number of crimes") +
      labs(
        fill = "Crime category",
        title = "Crime in Brno by Stolen Goods"
      )

Plot interactively (if applicable)

> ⚠ NOTE: will be rendered as JPEG in embedded markdown notebooks) ⚠

    plot.stolen.goods  # (ggplotly(plot.stolen.goods))

![](project/brno-crime/figure/unnamed-chunk-27-1.png)

And what interests us the most.. which part of Brno has the highest criminality in general?
-------------------------------------------------------------------------------------------

    plot.itotal <- ggplot(dat, aes(x = factor(str_remove(Základní.útvar.PČR..kde.došlo.k.činu, "OOP BRNO -")))) +
      geom_bar(aes(fill = crime.category)) +
      theme(
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),

        axis.text.x = element_text(
          angle = -30,
          margin = margin(t = -5, b = 20)
        ),

        panel.background = element_blank(),

        plot.title = element_text(hjust = 0.5)
      ) +
      ylab("Number of crimes") +
      xlab("Brno OOP unit") +
      labs(
        fill = "Crime category",
        title = "Crime in Brno by Category"
      )

Much better to explore these interactively (if possible)

![](project/brno-crime/figure/unnamed-chunk-29-1.png)

### Geospatial

    library(sf)

    shapefile  <- st_read("data/shape_files/moc/Městské_obvody_a_městské_části__polygony.shp")
    shape.brno <- shapefile %>%
      filter(str_detect(NAZ_ZUJ, 'Brno')) %>%
      fortify()

    ### transform and unify municipality names
    shape.brno$NAZ_ZUJ %<>%
      sapply(str_remove, 'Brno-') %>%
      sapply(str_to_title) %>%
      str_replace("^.*?-", "")

Now the tricky part. OOP are special police departments and there is not
any shape file for them. We can try to merge them based on the
municipality units.

    df.brno.oop <- readxl::read_xls("data/brno_data/Seznam_ulic_mesta_Brna_s_odkazy.xls")
    df.brno.oop %<>%
      mutate(OOP = str_remove(OOP, pattern="OOP ")) %>%
      mutate(OOP = str_to_title(OOP)) %>%
      select(OOP, NAZ_ZUJ = `Městská část`) %>%
      mutate(NAZ_ZUJ = str_to_title(NAZ_ZUJ)) %>%
      mutate(NAZ_ZUJ = str_replace(NAZ_ZUJ, "^.*?-", "")) %>%
      select(OOP, NAZ_ZUJ) %>%
      unique()


    df.brno <- merge(shape.brno, df.brno.oop, by = "NAZ_ZUJ")

    # pre-process
    dat.total$Základní.útvar.PČR..kde.došlo.k.činu %<>%
      sapply(str_remove, "OOP ") %>%
      sapply(str_replace, " - ", "-") %>%
      sapply(str_to_title)

    dat.total %<>%
      rename(OOP = Základní.útvar.PČR..kde.došlo.k.činu)

    # merge with brno moc
    df.brno %<>% merge(dat.total, by = "OOP") %>%
      transform(OOP = factor(OOP)) %>%
      unique()

    ggplot(data = df.brno) +
      geom_sf(aes(fill = NAZ_ZUJ, geometry = geometry)) +
      coord_sf(datum = NA) +
      # scale_fill_drsimonj(discrete = T) +
      labs(
        title = "Brno municipality units",
        fill = 'Municipality unit') +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5))

![](project/brno-crime/figure/unnamed-chunk-32-1.png)

Fill by total damage

    df.brno %<>%
      group_by(NAZ_ZUJ) %>%
      mutate(incidents.in.ZUJ = sum(total.incidents)) %>%
      mutate(damage.in.ZUJ = sum(total.damage))

    plot.geom.damage <- ggplot(data = df.brno, aes(label = NAZ_ZUJ)) +
      geom_sf(aes(fill = damage.in.ZUJ, geometry = geometry)) +
      geom_label(
        aes(x = SX, y = SY, size=1, alpha=0.4), label.size = 0.10, show.legend = F) +
      coord_sf(datum = NA) +
      scale_fill_drsimonj(discrete = F) +
      labs(
        title = "Crime in Brno by damage caused",
        fill = 'Damage in CZK (Millions)') +
      theme_void() +
      theme(plot.title = element_text(hjust = 0.5))

![](project/brno-crime/figure/unnamed-chunk-35-1.png)

Fill by total number of crimes

    plot.geom.incidents <- ggplot(data = df.brno, aes(label = NAZ_ZUJ)) +
      geom_sf(aes(fill = incidents.in.ZUJ, geometry = geometry)) +
      geom_label(
        aes(x = SX, y = SY, size=1, alpha=0.4), label.size = 0.10, show.legend = F) +
      coord_sf(datum = NA) +
      scale_fill_drsimonj(discrete = F) +
      labs(
        title = "Crime in Brno",
        fill = 'Number of incidents') +
      theme_void() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )

![](project/brno-crime/figure/unnamed-chunk-37-1.png)

And the last, my favourite -- Wordcloud
---------------------------------------

    library(ggwordcloud)

Prepare the data

    dat.stolen.goods %<>%
      group_by(Předmět.zájmu.pachatele.nebo.vztah.pachatele.k.oběti...text) %>%
      mutate(total.crimes = n(), total.damage = sum(Celková.způsobená.škoda.v.Kč)) %>%
      select(
        items = Předmět.zájmu.pachatele.nebo.vztah.pachatele.k.oběti...text,
        total.crimes,
        total.damage
      ) %>%
      transform(items = factor(items)) %>%
      unique()

    # truncate words
    dat.stolen.goods %<>%
      mutate(items.trunc = sapply(as.character(items), str_trunc, width = 10))

    # get the quantile
    q.90 <- dat.stolen.goods %>%
      pull(total.crimes) %>%
      quantile(.90)

    # set the angle randomly + based on the quantile
    dat.stolen.goods %<>%
      mutate(angle = sample(seq(-60, 60, 15), n(), replace = T))
    dat.stolen.goods[which(dat.stolen.goods$total.crimes > q.90),]$angle <- 0

Plot the wordcloud

    set.seed(42)
    ggplot(dat.stolen.goods, aes(label = items.trunc,
                                 size  = total.crimes,
                                 color = items.trunc)) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = 30) +
      theme_minimal()

![](project/brno-crime/figure/unnamed-chunk-40-1.png)

Color by total damage (DevConf style)

    set.seed(42)
    ggplot(dat.stolen.goods, aes(label = items.trunc,
                                 size  = total.crimes,
                                 color = total.damage)) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = 30) +
      theme_minimal() +
      scale_color_gradient(low = '#8e82e4', high = 'purple')

![](project/brno-crime/figure/unnamed-chunk-41-1.png)

Lets get fancy

    plot.wordcloud <- ggplot(dat.stolen.goods, aes(label = items.trunc,
                                                   size  = total.crimes,
                                                   color = total.damage,
                                                   angle = angle)) +
      geom_text_wordcloud_area(
        mask = png::readPNG("img/brno_znak.filled.png"),
        rm_outside = T  # some of those will get removed, no time to figgle parameters
      ) +
      scale_size_area(max_size = 24) +
      theme_minimal() +
      scale_color_gradient(low = 'darkred', high = 'red')

![](project/brno-crime/figure/unnamed-chunk-43-1.png)

    brno.title <- ggdraw() + draw_label(
      "BRNO",
      colour = 'red',
      size = 60,
      fontfamily = 'Overpass',
      fontface = 'bold'
    )

    brno.emblem <- ggdraw() +
      draw_image(png::readPNG("img/brno_znak.red.transparent.png")) +
      draw_plot(plot.wordcloud)

    plot_grid(brno.title, brno.emblem, ncol = 1, rel_heights = c(0.2, 1))

![](project/brno-crime/figure/unnamed-chunk-45-1.png)

Save the processed data (if applicable)

    # write_csv(df.brno, 'brno.crime.incidents.csv')
