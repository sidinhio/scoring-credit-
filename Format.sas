
data quantiles;
	set quantiles ;
	If CODSITFAM = 0 then CODSITFAM_REC = 3;
	If CODSITFAM = 1  then CODSITFAM_REC = 1;
	If CODSITFAM = 2 then CODSITFAM_REC  = 2;
	If CODSITFAM = 3 then CODSITFAM_REC = 3;
	If CODSITFAM = 4 then CODSITFAM_REC = 3;
	If CODSITFAM = 5 then CODSITFAM_REC = 3;
run; /*Recoder la situation matrimoniale*/



data quantiles;
	set quantiles ;
	If CODACVPRO2 = "1"  then CODACVPRO_REC = 3;
	If CODACVPRO2 = "2"  then CODACVPRO_REC = 1;
	If CODACVPRO2 = "3" then CODACVPRO_REC  = 1;
	If CODACVPRO2 = "4" then CODACVPRO_REC = 1;
	If CODACVPRO2 = "5" then CODACVPRO_REC = 1;
	If CODACVPRO2 = "6" then CODACVPRO_REC = 1;
	If CODACVPRO2 = "7" then CODACVPRO_REC = 3;
	If CODACVPRO2 = "8" then CODACVPRO_REC = 2;
	If CODACVPRO2 = "9" then CODACVPRO_REC =2;
run; /*Recoder la CSP CODACVPRO2*/



/*Format recodage*/
PROC FORMAT;
    VALUE AGEformat
	  LOW -< 18 = "< 18 ans"
	  18 -< 25 = "[18 - 25 ans["
	  25 -< 30 = "[25 - 30 ans["
	  30 -< 40 = "[30 - 40 ans["
	  40 -< 50 = "[40 - 50 ans["
	  50 -< 60 = "[50 - 60 ans["
	  60 - HIGH   = "> 60 ans";
RUN;

PROC FORMAT;
    VALUE AGEformatN
	  LOW -< 30 = "< 30 ans"
	  30 -< 60 = "[30 - 60 ans["
	  60 - HIGH   = "> 60 ans";
RUN;

PROC FORMAT;
    VALUE AGEformatDem
	  LOW -< 24 = "< 24 ans"
	  24 -< 29 = "[24 - 29 ans["
	  29 -< 43 = "[29 - 43 ans["
	  43 - HIGH   = "> 43 ans";
RUN;

PROC FORMAT;
    VALUE AGEformatLogique
	  LOW -< 24 = "< 24 ans"
	  24 -< 60= "[24 - 70 ans["
	  60 - HIGH   = "> 70 ans";
RUN;


PROC FORMAT;
    VALUE CODSITFAMformat
	  0 = "Inconnu"
	  1 = "Célibataire"
	  2 = "Marié(e)"
	  3 = "Séparé (e)"
	  4 = "Divorcé(e)"
	  5 = "Veuf(ve)";
RUN;

PROC FORMAT;
    VALUE CODSITFAMformatN
	  1 = "Célibataire"
	  2 = "Marié(e)"
	  3 = "Autres";
RUN;


PROC FORMAT;
    VALUE CODSITFAMRecFormat
	  1 = " En couple "
	  2 = "Pas en couple"
	  3 = "Autres";
RUN;

PROC FORMAT;
    VALUE $CODACVPROformat
	  "1" = "Agriculteurs exploitants"
	 "2"= "Artisans, commerçants et chefs d'entreprise"
	  "3" = "Cadres et professions intellectuelles supérieures"
	  "4" = "Professions Intermédiaires"
	  "5" = "Employés"
	  "6" = "Ouvriers"
	  "7" = "Retraités"
	  "8" = "Autres personnes sans activité professionnelle"
	  "9" = "Autres personnes sans activité professionnelle";
RUN;


PROC FORMAT;
    VALUE $CODACVPROformatN
	  "1" = "Agriculteurs exploitants"
	 "2"= "Artisans, commerçants et chefs d'entreprise"
	  "3" = "Cadres et professions intellectuelles supérieures"
	  "4" = "Professions Intermédiaires"
	  "5" = "Employés"
	  "6" = "Ouvriers"
	  "7" = "Retraités"
	  "8" = "Autres personnes sans activité professionnelle"
	  "9" = "Autres personnes sans activité professionnelle";
RUN;


PROC FORMAT;
    VALUE CODACVPROformatnum
	  1 = "Agriculteurs exploitants"
	  2 = "Artisans, commerçants et chefs d'entreprise"
	  3 = "Cadres et professions intellectuelles supérieures"
	  4 = "Professions Intermédiaires"
	  5 = "Employés"
	  6 = "Ouvriers"
	  7 = "Retraités"
	  8 = "Autres personnes sans activité professionnelle"
	  9 = "Autres personnes sans activité professionnelle";
RUN;

/*Les indicateusr*/

PROC FORMAT;
    VALUE LITIGEformat
	  0 = "Non litigieux"
	  1 = "Litigieux";
RUN;

PROC FORMAT;
    VALUE TOPPGformat
	  0 = "Créditrice"
	  1 = "Débitrice";
RUN;



/*Format  pour la discrétisation*/

PROC FORMAT;
    VALUE REVENUformat
	  LOW   -<8 = "1"
	  8-< 15 = "2"
	  15 - HIGH   = "3";
RUN;



PROC FORMAT;
    VALUE MONTANT_EPARGNEformat
	  LOW - < 5 = "1"
	  5 -  < 15 = "2"
	  15 -  HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE CRTAD_AG_NBJDE_BAformat
	  LOW   -< 8 = "1"
	  8 -< 15 = "2"
	  15 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE CRTAD_AG_SOLDE_T1format
	  LOW   -< 10 = "1"
	  10 -< 16 = "2"
	  16 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE MNTTOTMVTAFFformat
	  LOW   -< 8 = "1"
	  8 -< 15 = "2"
	  15 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE IREVENU_M2format
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE NBJDEPDPformat
	  LOW   -< 11 = "1"
	  11  -< 17 = "2"
	  17 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE SLDFINMMSCPTformat
	  LOW   -< 8 = "1"
	  8 -< 15 = "2"
	  15 - HIGH   = "3";
RUN;



PROC FORMAT;
    VALUE MINSOLDE_PARformat
	  LOW   -< 11 = "1"
	  11 -< 17= "2"
	  17 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE MNTTOTMVTAFFGLISS_M12format
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE CRTAD_AG_SOLDE_Tformat
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE ANCIENNETEformat
	  LOW   -< 9 = "1"
	  9 -< 15= "2"
	  15 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE CRTAD_IND_0038format
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE MNTECSCRDIMMformat
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;



PROC FORMAT;
    VALUE epargne_resformat
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE epargne_resformat
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;

PROC FORMAT;
    VALUE NBJDEPLSformat
	  LOW   -< 7 = "1"
	  7 -< 13 = "2"
	  13 - HIGH   = "3";
RUN;


