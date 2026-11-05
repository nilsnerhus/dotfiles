# Et forsvar for *veldig* skarpe økser

Abraham Lincon skal ha sagt "hvis du gir meg seks timer til å hogge et tre, vil jeg bruke de første fire kvesse øksa mi". Han sa det aldri, men her er vi likevel. Denne samlingen med verktøy er for å jobbe raskt og effektivt med tekst.

I bunn og grunn handler det om Neovim (som er et program for å skrive og redigere tekst) og Quarto, som er et program for å ta teksten du skriver her, og lage dokumentene, presentasjonene og bøkene man trenger av dem (som nettsider i '.html' eller utskrevne dokumenter i '.pdf'). Bare se hvor pen [masteroppgaven min er](https://nilsnerhus.github.io/oppgave/).

De kalles 'dotfiles' fordi nesten alle navnene på filene med innstillinger starter med '.'. Programmene kjører i terminalen, som du kan nå ved å laste ned (eller bare bruke) Windows terminal eller noe lignende. For å installere det må man kopiere denne mappa på en maskin som kjører Linux (eller Windows Subsystem for Linux), og skrive følgende kommando:

```sh
./install.sh
```

Da skjer det mye, men det viktigste er at man installerer Homebrew, som igjen laster ned alle programmene jeg har bedt om. Etter det kjører Stow, som kobler sammen innstillingene i denne mappa med systemet du kjører på.
