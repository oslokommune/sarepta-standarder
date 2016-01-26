Teknisk arkiv!
===================


Innledning 
----------

Hvis du ikke har **GitExtension** eller tilsvarende anbefales det at du laster ned og installerer dette. 

--------------
**Teknisk arkiv workflow:**
![Teknisk arkiv workflow](https://git.sarepta.test.ehelse.no/publisert/teknisk-arkiv/raw/master/sarepta-workflow.png)


> Blå = **master**-branch i hovedrepository (publisert materiale)<br />
> Orange = **release**-branch i forket repository (intent publisert materiale er i praksis like blå)<br />
> Lilla = **develop**-branch i forket repository (f.eks. features klar til release)<br />
> Grønn = **feature**-brancher (f.eks. ny versjon av en standard)<br />
> Generelt om workflows: https://www.atlassian.com/git/tutorials/comparing-workflows

---------

For innholdsprodusenter og -ansvarlige
--------------------------------------

**LAST NED EGEN KOPI**

> *Clone* er en engangsjobb for å laste ned en kopi av hele repoet.

**GitExt Clone...** (Via høyreklikk i Utforskeren)

1. Skriv inn URL til repoet som skal klones
2. Skriv inn stien til mappen du har dine repo
3. Skriv inn undermappen det aktuelle repoet skal ligge
4. Trykk **Clone**

----------
**SYNKRONISER MED GitLab SERVEREN**

> Bruk denne for å laste ned siste endringer fra serveren. Bør kjøres med jevne mellomrom.

 1. Åpne **GitExt Browse**
 2. Velg Commands → **Pull...**
 3. Under Merge Options, velg **"Rebase current branch ..."**
 4. Trykk **Pull**

----------
**LEGGE TIL NYE FILER**

1. Jobb mot *riktig branch*:
	1. Hvis du ikke allerede har en **feature**-branch å jobbe mot, opprett en ny branch (se "***Opprette branch***" lenger ned)
	2. Sjekk at navnet på den aktuelle feature-branchen står i verktøylinja.
	
2. *Sjekk inn* filer på aktuell branch:
	1. Høyreklikk på repoet (rotmappen) og velg **GitExt Browse**
	2. Trykk **Commit** i verktøylinja (<kbd>Ctrl</kbd> + <kbd>Space</kbd>)
	3. Velg filer som skal inngå i commit og trykk **Stage**
	4. Skriv inn **Commit message**
	5. Trykk deretter **Commit**. <br />Man kan gjøre flere commits før man pusher til serveren.
	
3. Lagre endringer *til serveren*:
	1. Velg Commands → **Push...** (<kbd>Ctrl</kbd> + <kbd>Up</kbd>)
	2. Dobbeltsjekk at du pusher til riktig branch (altså feature-branchen)
	3. Trykk **Push**

----------
**OPPDATERE FILER**

Samme prosedyre som "*Legg til nye filer*".

----------
**OPPRETTE BRANCH**

1. Høyreklikk på repoet (rotmappen) og velg **GitExt Browse**
2. Velg Commands → **Pull...** (henter siste endringer fra serveren)
2. Velg Commands → **Create branch...**
3. Skriv inn navnet på den nye feature-branchen. <br/>Sørg for at "*Checkout after create*" er merket av.
4. Trykk **Create branch**
5. Navnet på den nye branchen skal nå vises i verktøylinja.<br/>Branchen ligger foreløpig kun lokalt.

----------
**SE HISTORIKK**

- Per fil:

   1. Åpne **GitExt Browse**. 
   2. Velg fanen **File tree**
   3. Bla deg frem til aktuell fil.
   4. Høyreklikk på fila og trykk **File history**.<br/>I  fanen **Blame** kan du se hvem som har gjort hvilke endringer på fila.
	
- Per commit:

   1. Åpne **GitExt Browse**. 
   2. Velg fanen **Diff**
   3. Trykk på den aktuelle commiten for å se endringer siden forrige commit.<br />Her ser du også hvem som har lagt til en commit.



For innholdsprodusenter
-----------------

>Innholdsprodusenter skal kun lagre endringer til egne ***feature*** brancher og trenger bare å forholde seg til *Feature Branch Workflow*.

**Feature branch workflow:**
![Feature Branch Workflow](https://www.atlassian.com/git/images/tutorials/collaborating/comparing-workflows/feature-branch-workflow/01.svg)

> Blå = **develop** branch (materiale klar til godkjenning)<br />
> Lilla = **feature-1** branch (f.eks. materiale under utvikling)<br />
> Grønn = **feature-2** branch (f.eks. ny versjon av en standard)<br />
> Referanse: https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow

**SAMARBEIDE MED ANDRE OM EN ARBEIDSVERSJON**

1. Start samarbeid:

	1. Opprett en ny **myFeature**-branch (se "***Opprette branch***" lenger opp)
	2. Velg Commands → **Push...** (<kbd>Ctrl</kbd> + <kbd>Up</kbd>)
	3. Dobbeltsjekk at du pusher til riktig branch (altså aktuell feature-branch)
	4. Trykk **Push**

----------
**SENDE TIL GODKJENNING**

1. Åpne GitLab i nettleseren
2. Naviger til prosjektet → **Merge Requests** (på venstre side)
3. **Assign to** settes til innholdsansvarlig
2. Source branch ***myFeature***
3. Target branch ***develop***
5. Klikk **Submit new merge request**



For innholdsansvarlig
---------------------
>Kun innholdsansvarlige kan publisere til branchene ***develop***, ***release*** og ***master***.

**PUBLISERE EN VERSJON**

Dette gjøres via **merge requests** (eller pull request som det også heter)

1. En innholdsprodusent oppretter en merge request:<br/>Er interessert i å vite hvordan dette foregår, se "***Sende til godkjenning***" lenger opp.

2. *Akseptere* en merge request:

	1. Åpne GitLab i nettleseren
	2. Naviger til prosjektet → finn **Merge Requests** (på venstre side)
	3. Velg aktuell merge request i listen og se gjennom commits
	4. For å publisere, trykk **Accept Merge Request**.
	5. Voila! <br/>Alle har nå tilgang til endringene.