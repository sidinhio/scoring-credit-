/*Analyse approfondie*/

/*1 Stabilité du défuat*/
Proc gchart data= train;
title "Dégradation du risque par âge";
vbar AGEPRS/ subgroup= &y midpoints=18 to 113 by 10;
run;
quit; 

proc freq data = Base ;
tables top_degrad_dd_3*DATDELHIS / nofreq nocum  norow out=Stabilite_score;
run;

proc GPLOT data=Base(where=(top_degrad_dd_3=1));
	plot top_degrad_dd_3*DATDELHIS;

run;

DATA Stabilite_score2(where = (top_degrad_dd_3=1));
    SET Stabilite_score;
RUN;


/*Situation FAmiliale*/
proc freq data = train ;
	TABLES CODSITFAM/ nofreq nocum  norow out=CODSITFAM;
	FORMAT CODSITFAM CODSITFAMformat.;
run;

/*Catégorie socio pro*/
proc freq data = train ;
	TABLES CODACVPRO2/ nofreq nocum  norow ;
		FORMAT CODACVPRO2 $CODACVPROformat.;
run;

