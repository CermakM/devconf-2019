+++
title = "Slides"
language = 'en'

[slides]
# Choose a theme from https://github.com/hakimel/reveal.js#theming
theme = "white"
+++

<!-- source: https://opendata.gov.cz/informace:start -->

# Open Data

---

{{% lang lang="cz" %}}

## Definice

Otevřená data jsou dle [§ 3 odst. 11 zákona č. 106/1999 Sb. o svobodném přístupu
k informacím](https://www.zakonyprolidi.cz/cs/1999-106#p3-11):

> "Informace zveřejňované způsobem umožňujícím dálkový přístup v
otevřeném a strojově čitelném formátu, jejichž způsob ani účel následného
využití není omezen a které jsou evidovány v národním katalogu otevřených dat."

<!-- Otevřená data jsou vysoce efektivní způsob zveřejňování informací veřejného
sektoru. Pomohla například k vytvoření Hlídače smluv, Map bez bariér, Inventuru
hlasování v PSP ČR nebo obohacení mapy Prahy o vyhledávání v MHD spojích. -->

{{% /lang %}}


{{% lang lang="en" %}}

## Definition

Open data is according to the [§ 3 odst. 11 zákona č. 106/1999 Sb. o svobodném přístupu
k informacím](https://www.zakonyprolidi.cz/cs/1999-106#p3-11):

> Information published such that it allows for remote access in open, __machine-readable format__ which purpose and further usage is __in no way limited__ and which is __registered__ in national open data catalogue.

{{% /lang %}}

---

{{% lang lang="cz" %}}

## Požadavky na otevřená data

Otevřená data musí být především

-  Přístupná jako datové soubory ve strojově čitelném a otevřeném formátu s úplným a aktuálním obsahem databáze nebo agregovanou statistikou
-  Opatřená neomezujícími podmínkami užití
-  Evidovaná v Národním katalogu otevřených dat (NKOD) jako přímé odkazy na datové soubory
-  Opatřená dokumentací
-  Dostupná ke stažení bez technických překážek (registrace, omezení počtu přístupů, CAPTCHA, apod.)
-  Připravena s cílem co nejsnazšího strojového zpracování programátory apod.
-  Opatřená kontaktem na kurátora pro zpětnou vazbu (chyby, žádost o rozšíření, apod.)

{{% /lang %}}


{{% lang lang="en" %}}

## Requirements

The following requirements __must__ be met:

- Availability in convenient machine-readable open format
- Access is not restricted or conditioned (ie., by registration) and reuse is permitted
- Registered in national open data catalogue with direct data links
- Curated, contact to the curator is provided for feedback or requests
- Documentation
- Actuality

{{% /lang %}}

---

## Requirements

{{< figure src="open-data-requirements.png" library="true" alt="Image source: https://www.webfirst.com/services/open-data-solutions" >}}

---

{{% lang lang="cz" %}}
## Co nejsou otevřená data?

- Webová služba zpřístupňující jednotlivé záznamy tvořící datovou sadu s omezením počtu přístupů
- Datová sada ve formátu PDF
- Datová sada ve formátu XLS formátovaná pro tisk
- Datová sada v pseudo-CSV formátu (např. jiný oddělovač než ,)

{{% /lang %}}


{{% lang lang="en" %}}

## What is _not_ Open Data?

- Web service with limited access number
- Data in PDF format
- Data in XLS print-formated
- Data in pseudo-CSV (like TSV), ie. non-standard format

{{% /lang %}}

---

{{% lang lang="en" %}}

## 5★ Open Data

{{% note %}}

{{% lang lang="cz" %}}
 - stupeň 1 - datová je dostupná v síti WWW s vhodnými podmínkami užití otevřených dat (viz Jak stanovit podmínky užití datových sad?),
 - stupeň 2 - datová sada je poskytována ve strojově čitelném formátu, který umožňuje automatizované strojové zpracování,
 - stupeň 3 - datová sada je poskytována v otevřeném formátu, tj. ve formátu s volně dostupnou specifikací,
 - stupeň 4 - na identifikaci entit v datové sadě se používají IRI,
 - stupeň 5 - datová sada splňuje standard propojených dat.
{{% /lang  %}}

{{% lang lang="en" %}}
- stage 1 - data is accessible on the internet with specific usage conditions
- stage 2 - data is in machine-readable format
- stage 3 - data is in _open_ machine-readable format, that is with open specification
- stage 4:
  - IRI (Internetional Resource Identifier) entities in the data,
  - example: distribution of books should have entities like author, or publisher accompanied by IRI specificator
- stage 5:
  - data follows _Linked data_ format, that is a structured data which can be interlinked to become more useful through semantic queries.
  - builds upon standard Web technologies (HTTP, RDF)

Distribution of data: The way of opening op the data, concrete data format

Ontology (dictionary): conceptual schema of the data, defines classes and attributes that can be used in RDF

IRI: International Resource Identifier
RDF: Resource Distribution Framework

{{% /lang %}}
{{% /note %}}

{{< figure src="open-data-steps.png" library="true" alt="Image source: https://5stardata.info/cs/" >}}

> 💡 Tip: Read more on https://5stardata.info/cs/

{{% /lang %}}


---

{{% note %}}

> Note that we can consider data to be open-ish since the ★★★

{{% /note %}}

## 5★ Open Data

{{% fragment %}}
★        make your stuff available on the Web (whatever format) under an open license ⚠
{{% /fragment %}}

{{% fragment %}}
★★       make it available as structured data (e.g., Excel instead of image scan of a table) ⚠
{{% /fragment %}}

{{% fragment %}}
★★★      make it available in a non-proprietary open format (e.g., CSV instead of Excel)
{{% /fragment %}}

{{% fragment %}}
★★★★     use URIs to denote things, so that people can point at your stuff
{{% /fragment %}}

{{% fragment %}}
★★★★★    link your data to other data to provide context
{{% /fragment %}}

<br>

{{% fragment %}}
> ⚠ Note that we can consider data to be open-ish since the ★★★
{{% /fragment %}}

---

{{< slide class="no-list"  >}}
{{% lang lang="en" %}}

## What are the costs & benefits of ★ Web data?

{{% section %}}

#### As a consumer …

- ✔ You can look at it.
- ✔ You can print it.
- ✔ You can store it locally (on your hard drive or on an USB stick).
- ✔ You can enter the data into any other system.
- ✔ You can change the data as you wish.
- ✔ You can share the data with anyone you like.
{{% /section %}}

{{% section %}}
#### As a publisher …

- ✔ It’s simple to publish.
- ✔ You do not have explain repeatedly to others that they can use your data.
{{% /section %}}


{{% /lang %}}

---

{{< slide class="no-list"  >}}
{{% lang lang="en" %}}

## What are the costs & benefits of ★★ Web data?

{{% section %}}
#### As a consumer …

you can do all what you can do with ★ Web data and additionally:

- ✔ You can directly process it with proprietary software to aggregate it, perform calculations, visualise it, etc.
- ✔ You can export it into another (structured) format.
{{% /section %}}

{{% section %}}
#### As a publisher …

- ✔ It’s still simple to publish.
{{% /section %}}


{{% /lang %}}

---

{{< slide class="no-list"  >}}
{{% lang lang="en" %}}

## What are the costs & benefits of ★★★ Web data?


{{% section %}}
#### As a consumer …

you can do all what you can do with ★★ Web data and additionally:

 - ✔ You can manipulate the data in any way you like, without the need to own any prorietary software package.
{{% /section %}}

{{% section %}}
#### As a publisher …

-  ✔ It’s still rather simple to publish.
-  ⚠ You might need converters or plug-ins to export the data from the proprietary format.
{{% /section %}}


{{% /lang %}}

---

{{< slide class="no-list"  >}}
{{% lang lang="en" %}}

## What are the costs & benefits of ★★★★ Web data?

{{% section %}}
#### As a consumer …

you can do all what you can do with ★★★ Web data and additionally:

- ✔ You can link to it from any other place (on the Web or locally).
- ✔ You can bookmark it.
- ✔ You can reuse parts of the data.
- ✔ You may be able to reuse existing tools and libraries, even if they only understand parts of the pattern the publisher used.
- ✔ You can combine the data safely with other data. URIs are a global scheme so if two things have the same URI then it’s intentional, and if so that’s well on it’s way to being 5-star data!
- ⚠ Understanding the structure of an RDF “Graph” of data can be more effort than tabular (Excel/CSV) or tree (XML/JSON) data.
{{% /section %}}

{{% section %}}
#### As a publisher …

- ✔ You have fine-granular control over the data items and can optimise their access (load balancing, caching, etc.)
- ✔ Other data publishers can now link into your data, promoting it to 5 star!
- ⚠ You typically invest some time slicing and dicing your data.
- ⚠ You’ll need to assign URIs to data items and think about how to represent the data.
- ⚠ You need to either find existing patterns to reuse or create your own.
{{% /section %}}

{{% /lang %}}

---

{{< slide class="no-list"  >}}
{{% lang lang="en" %}}

## What are the costs & benefits of ★★★★★ Web data?

{{% section %}}
#### As a consumer …

you can do all what you can do with ★★★★ Web data and additionally:

- ✔ You can discover more (related) data while consuming the data.
- ✔ You can directly learn about the data schema.
- ⚠ You now have to deal with broken data links, just like 404 errors in web pages.
- ⚠ Presenting data from an arbitrary link as fact is as risky as letting people include content from any website in your pages. Caution, trust and common sense are all still necessary.
{{% /section %}}

{{% section %}}
#### As a publisher …

- ✔ You make your data discoverable.
- ✔ You increase the value of your data.
- ✔ Your own organisation will gain the same benefits from the links as the consumers.
- ⚠ You’ll need to invest resources to link your data to other data on the Web.
- ⚠ You may need to repair broken or incorrect links.
{{% /section %}}

{{% /lang %}}

---

{{< slide class="side-by-side" >}}

{{% lang lang="cz" %}}
# Jaký je význam otevřených dat?
{{% /lang %}}

{{% lang lang="en" %}}
# What's the meaning of it?
{{% /lang %}}

---

<!---
{{% section %}}
{{% lang lang="cz" %}}
## Životní cyklus

Otevřená data jako nástroj transparentnosti – začátky využívaní otevřených dat za účelem zviditelnění a zprůhlednění veřejné správy. Role využívaná zejména v oblasti open governmentu.
Otevřená data jako „infrastruktura“ – souvisí s poznáním, že i jiná data než jenom data veřejné správy jsou zajímavá a užitečná, a že v digitálním věku a internetu věcí jsou to zejména data, který vytváří naše prostředí. Role využívaná zejména v konceptu SMART CITIES.
Otevřená data jako „normál“ – fáze životního cyklu charakteristická „návratem k realitě“. Následuje po fázi velkých očekávání a poznáním, že již nejde jenom o samotná data, ale zejména o jejich zhodnocení, o jejich uživatele a o vytváření „datových příběhů“. Publikace otevřených dat je považována za „normál“ a úsilí je zaměřeno na jejich využívání.
{{% /lang %}}

{{% lang lang="en" %}}
## Lifecycle
{{% /lang %}}

{{% /section %}}
--->

{{% section %}}

{{% note %}}

#### Transparency:

- data is becomming a tool for making public administration transparent
- open decision framework
- __OPEN GOVERNMENT__

#### Infrastructure:

- important to understand that in the digital age, it's not just government data.. there is a whole range of information that is created by our surroundings (like _IOT_). This kind of information may introduce correlations the wouldn't be immediately apperent and may lead to important decisions and changes
- __SMART CITIES__

#### Normalization:

- making data publicly available is considered "normal"
- understanding the data and its usage
- targetting public
- __DATA STORIES__




{{% /note %}}

{{% lang lang="cz" %}}## Životní cyklus {{% /lang %}}
{{% lang lang="en" %}}## Lifecycle      {{% /lang %}}

<div class="fig-row">

<div class="fig-img">
{{% fragment %}}
{{< figure src="icon-transparency.png" library="true" alt="Image source: http://sportsrecruits.com/images/sr_otg/club_transparency_icon.svg" >}}
<div class="fig-caption">Transparency</div>
{{% /fragment %}}
</div>

<div class="fig-img">
{{% fragment %}}
{{< figure src="icon-infrastructure.png" library="true" alt="Image source: http://chittagongit.com/icon/infrastructure-icon-11.html" >}}
<div class="fig-caption">Infrastructure</div>
{{% /fragment %}}
</div>

<div class="fig-img">
{{% fragment %}}
{{< figure src="icon-norm.png" library="true" alt="Image source: https://res.cloudinary.com/logrhythm/image/upload/c_scale,w_250/v1534437608/icons/nextgen-siem-data-processing-icon.png" >}}
<div class="fig-caption">Normalization</div>
{{% /fragment %}}
</div>

</div>
{{% /section %}}

{{% section %}}
{{% lang lang="cz" %}}
## Ekonomický aspekt

Otevřená data jsou především šetrným způsobem jak poskytovat informace. Vytváření PDF souborů, webových stránek či aplikací s sebou totiž nese dodatečné náklady, které v případě publikace dat v otevřené podobě odpadají. Principy otevřených dat požadují pouhé zveřejnění dat v surové podobě, nikoliv dodatečnou tvorbu PDF souborů, webových stránek či aplikací.
{{% /lang %}}

{{% lang lang="en" %}}
## Economical aspect

Open Data is convenient way to provide information. Creation of PDF files, web sites or applications requires additional costs which are usually not applicable when it comes to Open Data.

In principal, making data publicly available is merely posting them in its raw form (of course, remember the 5★).

{{% /lang %}}

{{% /section %}}

---

## FAQ

---

## Resources

- https://opendata.gov.cz
- https://5stardata.info/en/
- https://www.webfirst.com/services/open-data-solutions
- https://opendata.gov.cz/informace:d%C5%AFle%C5%BEit%C3%A9-pojmy-v-oblasti-otev%C5%99en%C3%BDch-dat

---

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
