---
title: Dotfiles
---
## Oversikt

Dette er alle innstillingene jeg bruker for å håndtere tekst, og med det kunnskap, i jobb og fritid. Kodebrønnen er organisert med en README.md, et `install.sh`-skript og en mappe per kommandolinjeverktøy jeg bruker. 

## Mål

Hovedmålet er at jeg, når jeg får meg jobb, blir en effektiv og fornøyd rådgiver, som er i stand til å produsere mye med høy kvalitet. 

For å gjøre dette så har jeg følgende delmål:
- Erstatte MS Office/Google Workspace, Obsidian og Rstudio med én base, sånn at jeg bare har én versjon av kunnskapen min
- Ha et oppsett jeg kan gjenskape på en jobb-PC med minimalt med endringer
- Ha et oppsett som kan bruke server-kraft for dataanalyse

## Gjøreliste

Obsidian:
- Preview av tabeller og vim-navigering i dem (Markview)
- Spellcheck-mode, så jeg ikke sender avgårde feilstavelser (nvim-spell)
- Automatiske lister, og hotkeys for dem (basic)
- Filnavn og titler som automatisk samsvarer (vanskelig, tror jeg)
- Autocomplete av andre notater og referanser (Obsidian.nvim og pandoc-noe)
- Åpne telescope-funn i en ny buffer ved siden av
- Globale søk for telescope

Generelt
- Gjøre om filstrukturen til noe som er mer brukanes
- Flytte prosjektene inn i Zellij, sånn at jeg raskt kan bytte mellom prosjekter
- Integrere OpenCode og REPL med Zellij
- Sette opp Supermaven for å få autocomplete
- Finne ut av hvordan man egentlig holder styr på filene (harpoon?)
- Finne ut hvor langt jeg kan pushe windows terminal stilene, og om jeg kan bestemme fonter og farger selv. Og hva som egentlig bestemmer fargene i neovim akkurat nå 
- Fikse sånn at Radian og Zellij har lesbare farger med mitt lyse tema

## Innboks

Nå har jeg tenkt å skrive om utgangspunktet jeg har fått gjennom `kickstart.nvim`, og ha en struktur jeg faktisk forstår. Jeg tror det er noen helt konkrete filer jeg trenger:
- init.lua, selvsagt
- options.lua - alt som har med vim.opt å gjøre, er jeg ganske sikker på
- autocmd.lua - jeg har hørt mye om dem, men jeg veit faktisk ikke helt hva de er
- keybinds.lua - alle de forskjellige kombinasjonene jeg har valgt meg
- plugins/
    - alle sammen

Dette bryter litt med hva det er jeg har tenkt med feature-pakker, og er en form for horisontal inndeling etter teknologi, heller enn en vertikal en som fokuserer på hva jeg skal gjøre. Jeg kan prøve å se om jeg kan heller tenke på det som features, og heller dele inn hver fil. Men jeg tror faktisk den horisontale er det enkleste å få til. 

Jeg er også litt usikker på om jeg har lyst til å konfigurere ting i mason eller direkte i lsp pluginen. Jeg tror jeg egentlig liker det best i mason, spesielt siden det gjør det enkelere å tenke rundt det. Og det går mye raskere. Både air, og marksman fungerte uten problemer. 

Dette er sluttpunktet i en lang reise der jeg har lett etter verktøy som hjelper meg med å holde oversikt over all informasjonen jeg har, og dele den med andre. Jeg vil også hjelpe meg selv i fremtiden, og lage masse flak/notater/memos jeg kan ha livet ut. Jeg tror markdown, quarto og neovim vil være hjelpsomme i lang tid fremover. Hele opplegget er ment til å gjøre det så enkelt som mulig, på marginen. 

Jeg har skjønt hvordan man bruker vim i ett dokument, og det er verdt det kun for det, men det er også mulig å bruke det for å gjøre mange endringer over en hel kodebase, noe jeg også har lyst til å gjøre. 

Mens det er hovedbruken, har jeg også lyst til å lære meg å lage enkle verktøy for å hjelpe meg og kollegaene mine. Det tror jeg faktisk ikke er så veldig mye vanskeligere enn å laste ned riktig LSP og bare skrive koden sånn som jeg burde. 

På sikt så hadde det vært gøy å bygge noen broer til plattformene, hvor de tar alt som er skrevet og gjør det om til versjonskontrollerte markdown-dokumenter som jeg kan fuzzy finne  og jobbe på, og så automatisk bygge dem tilbake. De avanserte "jobbe samtidig i samme fil" har jeg aldri noen sinne vært borte i at har blitt brukt på et kontor. 

Jeg vil også ha cold folds! Det hadde vært dritdigg. nvim oregami. Og jeg har lyst til å rydde opp i setupet også. Men nå er jeg jo faktisk i gang! Det glemmer jeg hele tiden.

Ah, jeg har brukt skikkelig mye tid på å prøve å få noe som ligner på dataview for å lese frontmatter, når løsningen bare er å lage en shinyapp i en kodeblock, og så bruke den mens jeg 

yaml12, sammen med en shinyapp interactive greie er en utrolig mye smudere løsning, enn alt dette tullet jeg har holdt på med. Jeg tror også jeg kan kutte masse vrøvl fra configen min på denne måten, og lære meg å lage ting som faktisk kan være brukbart for andre også. 

Gjøreliste, notater og varetelling/økonomistyring er alle sammen mye mer dashboards/shiny apps enn de er tekstredigering. Uansett så vil det hjelpe å skrive skikkelig. 

Jeg vil også ha et prøveprosjekt med å lage den visualiseringa av bindingstabellene til pappa. 

Hvis det funker så kan jeg vurdere å lage en pakke for det, men det virker som om det funker godt. 

Jeg burde også tenke gjennom en AGENTS.md, sånn at jeg kan slippe aien litt mer løs. Og siden jeg skal gå over til å løse alt med frontmatter, så kan jeg helt fint bare samle alle tingene i mapper som jeg kaller src. Det tror jeg er det beste. 
