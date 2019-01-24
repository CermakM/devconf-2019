+++
title = "Brno Data"
language = 'en'

[slides]
# Choose a theme from https://github.com/hakimel/reveal.js#theming
theme = "white"
+++

# Brno Data

<div class="hashtag-brno2050" style="font-family: Hashtag; font-size: 4rem;">
  <a href="https://www.instagram.com/explore/tags/brno2050/"> #brno2050 </a>
</div>

{{< slides_nav >}}

---

{{< slide class="align-center" >}}

## What is DATA.BRNO?

{{% fragment %}}
[DATA.BRNO.cz](https://data.brno.cz/en/) is an open platform for sharing data of the city of Brno.
{{% /fragment %}}

{{% fragment %}}
This portal is designed to be used by public including citizens, entrepreneurs, students, researchers and professionals, as well as journalists and developers.
{{% /fragment %}}

---

{{< slide class="align-center" >}}

## WHY?

{{% fragment %}}
Data is our _"new urban wealth"_ and we need to use it to full capacity.
{{% /fragment %}}

---

{{< slide class="align-center" >}}

## Where data comes from?

{{% fragment %}}
Data are mainly collected by the city itself, and by the city companies and other providers.
{{% /fragment %}}

---

{{< slide class="align-center" >}}

## WHAT?

<div id="brno-data-gallery" class="fig-gallery">
<div class="fig-row">

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-ekonomika_trh_prace.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">Economy</div>
  {{% /fragment %}}

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-zdravi_zivotni_prostredi.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">Health & Environment</div>
  {{% /fragment %}}

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-doprava.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">Transport</div>
  {{% /fragment %}}

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-lide_bydleni.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">People & Housing</div>
  {{% /fragment %}}

</div>

<div class="fig-row">

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-vzdelani.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">Education</div>
  {{% /fragment %}}

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-technicka_infrastruktura.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">Infrastructure</div>
  {{% /fragment %}}

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-bezpecnost.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">Safety</div>
  {{% /fragment %}}

  {{% fragment %}}
  <div class="fig-img">
  {{< figure src="icon-mesto.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
  </div>
  <div class="fig-caption">City</div>
  {{% /fragment %}}

</div>
</div>

{{% fragment %}}
> 💡 You can find not only datasets but also several useful apps and articles.
{{% /fragment %}}

---

{{% section %}}

## Words of pride

---

### Step in the right direction

<div class="hashtag-brno2050" style="font-family: Hashtag; font-size: 4rem;">
  <a href="https://www.instagram.com/explore/tags/brno2050/"> #brno2050 </a>
</div>

---

### The dashboard

<div class="fig-img">
{{< figure src="brno-data-dashboard.png" library="true" alt="Image source: https://data.brno.cz/en/" >}}
</div>

---

### Responsive and helpful administrators

{{% /section %}}

---

{{% section %}}

### Words of criticism

---

### The 5★ standards are not always met

---

### Data distribution could be better

<div class="fig-img">
{{% fragment %}}
{{< figure src="brno-data-distribution.png" library="true" >}}
{{% /fragment %}}
</div>

---

```R
library(tidyverse)

dat <- readxl::read_xlsx("datasets/brno_data/criminality/raw/trestni_cinnost_2016.xlsx")
colnames(dat)
```

```R
# > [1] "Útvar městské části (okres) PČR"
# > [2] "Základní útvar PČR, kde došlo k činu"
# > [3] "Stadium TČ, 1-příparava, 2-pokus, 3-dokonaný"
# > [4] "Druh TČ, 11-zločin, 18-přečin"
# > [5] "Takticko-statistická klasifikace činu"
# > [6] "Spácháno na ulici-1, ne-2"
# > [7] "Čin spáchán na : viz číselník"
# > [8] "Použití zbraně : viz číselník"
# > [9] "Druh použité zbraně : viz číselník"
# > [10] "Datum spáchání činu, či zahájení konání"
# > [11] "Datum ukončení konání činu (pokud jiné datum)"
# > [12] "Předmět zájmu pachatele č. 1"
# > [13] "Předmět zájmu pachatele nebo vztah pachatele k oběti - text"
# > [14] "Předmět zájmu pachatele č. 2"
# > [15] "Předmět zájmu pachatele nebo vztah pachatele k oběti - text__1"
# > [16] "Předmět zájmu pachatele č. 3"
# > [17] "Předmět zájmu pachatele nebo vztah pachatele k oběti - text__2"
# > [18] "Celková způsobená škoda v Kč"
# > [19] "Hlavní kvalifikace činu - paragraf TZ"
# > [20] "První odstavec"
# > [21] "Druhý odstavec"
# > [22] "Souběhový paragraf"
# > [23] "Odstavec souběhu"
# > [24] "Druhý souběhový paragraf"
# > [25] "Odstavec souběhu__1"
# > [26] "Datum zahájení trestního řízení"
# > [27] "Datum ukončení trestního řízení"
# > [28] "Způsob ukončení trestního řízení"
# > [29] "Způsob ukončení trestního řízení - text (kde je kód \"0\" tam ještě řízení nemusí být ukončeno"
```

---

### Poor ontology / schema or inconsistency in data

{{% fragment %}}

```R
dat$\`Předmět.zájmu.pachatele.nebo.vztah.pachatele.k.oběti...text\` %>%
  factor() %>%
  levels()
```

```R
# >   [1] "airbagy"                                              "antiradary"
# >   [3] "bankomaty"                                            "barevné kovy,výrobky a odpad z nich"
# >   [5] "bez vztahu"                                           "bílé rase"
# >   [7] "bižuterie"                                            "bratr"
# >   ...
# >  [23] "dítě ve vzdál.poměru (synovec,neteř...)"              "dítě ve vzt. ke známé osobě (soused,známý)"
# >  [25] "dítě ve vztahu spolužáka,kamaráda"                    "dítě,kde jeden z rodičů je druh-družka,přítel"
# >  ....
# >  [95] "manžel"                                               "manželka"
# >  [97] "masné konzervy a hotová jídla v konzervách"           "matka"
# >  ....
# > [115] "nátěrové hmoty,latexy,klihy,lepidla,barviva"          "nic"
# > .....
# > [145] "ostatní - zásilky a přepravované věci"                "ostatní - zbraně /mimo historických/"
# > [147] "ostatní - zemědělské výrobky a výr. těžby dřeva"      "ostatní - zvířectvo včetně včelstva"
# > [149] "ostatní -osobní doklady a předtisky"                  "ostatní -starožitnosti, umělecké předměty"
# > [151] "ostatní -tabákové výrobky"                            "ostatní (kopie filmů,hračky,společen.hry)"
# > .....
# > [243] "vniknutí do obydlí za užití lsti - útoky na senior"   "výbušniny a pyrotech. výrobky"
# > .....
# > [261] "zlato zpracované a klenoty,šperky"                    "žlutohnědé rase / indiáni, asiati, australští dom."
# > [263] "zobrazovací zařízení /terminál,monitor/"              "zvěř spárkatá /tuzemská/"
```
{{% /fragment %}}

---

### Still not enough data

I.e., data that is expected to be present, is not:

- city state reports in machine-readable format
- population data
- transport data
- urban grid (?)
- shapefiles

---

### Important data not available in machine readable format

<div class="fig-img">
{{% fragment %}}
{{< figure src="brno-data-pdf.png" library="true" >}}
{{% /fragment %}}
</div>

---

### Sometimes, too _"user friendly"_

<div class="fig-img">
{{% fragment %}}
{{< figure src="brno-data-user-friendly.png" library="true" >}}
{{% /fragment %}}
</div>

---

### Dashboard Applications built on proprietary software ([ESRI](https://www.esri.com/en-us/home0))

---

### Most of the data available in Czech language only

---

### Hard to navigate from applications to datasets

{{% /section %}}

---

## FAQ

---

# Thank You!

{{< slides_nav >}}

---

## Resources

<!--
## Themes

- black: Black background, white text, blue links (default)
- white: White background, black text, blue links
- league: Gray background, white text, blue links
- beige: Beige background, dark text, brown links
- sky: Blue background, thin dark text, blue links
- night: Black background, thick white text, orange links
- serif: Cappuccino background, gray text, brown links
- simple: White background, black text, blue links
- solarized: Cream-colored background, dark green text, blue links
-->
