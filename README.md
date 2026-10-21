# Et forsvar for veldig skarpe økser

Min drøm er å jobbe som politisk rådgiver. Rådgivere jobber med tekst, og har skikkelig dårlig tid. Målet med disse 'dotfiles'a er å ha satt sammen skikkelig gode verktøy for det. I bunn og grunn handler det om Neovim (som er et program for å skrive og redigere tekst) og Quarto, som er et program for å ta teksten og lage dokumenttypene man trenger av dem (som '.docx' eller '.pdf').

For å installere det må man kopiere denne mappa på en maskin som kjører Linux og har Git, og kjøre skriptet:

```sh
./install.sh
```

Da skjer det mye, men det viktigste er at man installerer Homebrew, som igjen laster ned alle programmene jeg har bedt om. Etter det kjører Stow,som kobler sammen innstillingene i denne mappa med systemet du kjører på.
