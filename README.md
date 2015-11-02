# Ifi-ordenen

Dette er en enkel nettside for Ifi-ordenen.

Den skal ligge på [ordenen.ifi.uio.no](http://ordenen.ifi.uio.no) og bare bestå av kompilerte HTML-, CSS- og JS-filer.

Den har to sider:

1. Forside: Introduksjon av ordenen, oversikt over medlemmer
2. Medlemside: Alle medlemmer har en egen side

Siden blir generert vha [Wintersmith](http://wintersmith.io/), [Sass](http://sass-lang.com/) og [Compass](http://compass-style.org/), som blir prosessert vha [Grunt](http://gruntjs.com/). [Live-server](https://github.com/tapio/live-server) er brukt for å være mer effektiv i utviklingen.

For å bygge siden, kjør `grunt build`. Anbefalt oppsett for utvikling er å kjøre i gang `grunt` i ett vindu, og `live-server` i et annet.

## Eksisterende innhold

* Mottagere av Ifi-ordenen
* Tildelinger (hierarkisk, alfabetisk, etter år)
* Om ordenen
* Ordbok
* Pingvingarden
* Om siden

## Fremtidig innhold

* Ordenstegn
* Nyheter
* Engelske oversettelser (til vurdering)
* Oversikt over foreninger (til diskusjon)

## Hvordan oppdatere ordenen.ifi.uio.no

* Navigér til bygget: `cd build`
* Sjekk at du er på riktig branch: `git checkout ordenen`
* Bygg ny versjon: `grunt ordenen`
* Commit endringer: `git add . && git commit -m "<Begrunnelse>"`
* Push endringer: `git push origin ordenen`
* Logg inn på en av Ifi sine servere: `ssh <brukernavn>@login.ifi.uio.no`
* Navigér til nettsidens mappe: `cd /projects/ifi-ordenen/www_docs`
* Pull endringer: `git pull origin ordenen`
* Sjekk at rettigheter er som de bør være