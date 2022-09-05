/*Découpage dynamique*/
%macro KDE_discretisation (tab,var_quanti,deb,fin,incr);
proc kde data=&tab (where=(top_NDB=0))
out = kdeimpaye0_&var_quanti ;
var &var_quanti ;
title "kde &var_quanti";
run;
proc kde data=&tab (where=(top_NDB=1))
out = kdeimpaye1_&var_quanti;
var &var_quanti;
title "kde &var_quanti";
run;
data tab_dens_&var_quanti;
merge kdeimpaye0_&var_quanti (rename=(density=dens0))
 kdeimpaye1_&var_quanti (rename=(density=dens1));
by &var_quanti;
run;
proc gplot data=tab_dens_&var_quanti;
plot (dens1 dens0)*&var_quanti /overlay haxis= &deb to &fin by &incr; 
symbol1 color=red
 interpol=join
 value=dot
 height=0.1;
symbol2 color= green
 interpol=join
 value=dot
 height=0.1;
title "courbes de densité &var_quanti";
run;
quit;
Proc DataSets LIBRARY=WORK ;
 Delete kdeimpaye0_&var_quanti ;
Run ;
Proc DataSets LIBRARY=WORK ;
 Delete kdeimpaye1_&var_quanti ;
Run ;
quit;
%mend; 

%macro decoupage_dynamique(Tab,Var,deb,fin,incr);
%do i=&deb %to &fin %by &incr;
%do j=&deb %to &fin-&i %by &incr;
data essai;
set &tab;
D_&var = 1*(&Var<&i) + 2*(&i<=&Var<&i+&j)+3*(&i+&j<=&Var);
run;
Proc Freq data=essai;
tables &y*D_&var/chisq;
output out=resultat n chisq;
title "critére automatique &var";
run;
Data resultat;
set resultat; 
T=sqrt((_pchi_/N)/sqrt(df_pchi));
class1=&i;
class2=&i+&j;
run;
data test_&var;
set test_&var resultat ;
keep t and class1 and class2 ;
run;
%end;
%end;
proc sql;
select class1, class2, T
from test_&var
where t=(select max(T) from test_&var);
title "critére automatique &var";
quit;
/*Proc DataSets LIBRARY=WORK ;
 Delete Essai ;
Run*/ ;
/*Proc DataSets LIBRARY=WORK ;
 Delete resultat ;
Run*/ ;
quit;
%mend;

%decoupage_dynamique(essai,cout_bien_finance,0,4,1);

proc freq data=essai;
tables D_cout_bien_finance;
run;


%decoupage_dynamique(Base,dMONTANT_EPARGNE,0,20,1);


%decoupage_dynamique(Base,dMONTANT_EPARGNE,-26450.28,44776900.18,20000);


proc means data = base;
var MONTANT_EPARGNE;
title "valeurs manquantes variables quantitatives";
run; /* => Des soldes minimums négatifs;   ages < 18 : corriger */
