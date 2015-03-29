# Ifi-ordenen

Dette er en enkel nettside for Ifi-ordenen.

Den skal ligge på [ordenen.ifi.uio.no](http://ordenen.ifi.uio.no) og bare bestå av kompilerte HTML-, CSS- og JS-filer.

Den har to sider:

1. Forside: Introduksjon av ordenen, oversikt over medlemmer
2. Medlemside: Alle medlemmer har en egen side

Siden blir generert vha [Wintersmith](http://wintersmith.io/), [Sass](http://sass-lang.com/) og [Compass](http://compass-style.org/), som blir prosessert vha [Grunt](http://gruntjs.com/). [Live-server](https://github.com/tapio/live-server) er brukt for å være mer effektiv i utviklingen.

For å bygge siden, kjør `grunt build`. Anbefalt oppsett for utvikling er å kjøre i gang `grunt` i ett vindu, og `live-server` i et annet.