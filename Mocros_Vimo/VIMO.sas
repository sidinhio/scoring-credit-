/*___________________________________________________________________
  ¦ MACRO:       VIMO                                               ¦
  ¦ JOB:         Data Quality                                       ¦
  ¦ PROGRAMMER:  Mahmoud Azimaee                                    ¦
  ¦ DATE:        April 2011                                         ¦
  ¦ DESCRIPTION: For a given table, this Macro generates a VIMO     ¦ 
  ¦              Table as it has been described in MCHP Data Quality¦ 
  ¦              framework. It will be in Excel format and saved in:¦ 
  ¦              /dq/saswork/[USERNAME]/                            ¦
  ¦              under name of [Dataset name]_VIMO.xls              ¦
  ¦ PARAMETERS:  DS= Name of Dataset                                ¦	
  ¦              INVALIDS= Option to turn Invalid checks on or off  ¦	  
  ¦              (Default value=ON)                                 ¦	  
  ¦              MEMNUM= List number of cluster members that you    ¦	  
  ¦              want to include in VIMO Table separated by blank.  ¦	  
  ¦              Drop this parameter if it is not a clustered.      ¦	  
  ¦              MUNCODES= List of variables containing mun codes,  ¦	  
  ¦              separated by blank.                                ¦	  
  ¦              POSTALS= List of variables containing postal codes,¦	  
  ¦              separated by blank.                                ¦	  
  ¦ EXAMPLE:     %VIMO(health.MHCPL_virustests_19922010);           ¦
  ¦              %VIMO(DS=health.MHCPL_virustests_19922010,         ¦
  ¦                    INVALIDS=OFF);                               ¦
  ¦              %VIMO (DS=HEALTH.mhmed_1997apr, MEMNUM=23 24 25);  ¦
  ¦              %VIMO (DS=social.hcm_edi_2006jan, MEMNUM=3 ,       ¦
  ¦                    POSTALS=POSTAL p_code_original CL_POSTAL     ¦ 
  ¦                    P_CODE P_CODE_E POSTAL_CODE POSTAL_CODE_HCM);¦
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


**********************************************************************;



%MACRO VIMO(DS= ,INVALIDS=ON, MEMNUM= ,POSTALS=, MUNCODES=);

%PUT ___________________________________________________________________;
%PUT ¦ Centre Muraz Burkina Faso (Health Program)                       ¦;
%PUT ¦ MACRO:        VIMO                                               ¦;
%PUT ¦ JOB:          Data Quality                                       ¦;
%PUT ¦ PROGRAMMER:   Sidi TRAORE 	                                    ¦;
%PUT ¦ DATE:         April 2018                                         ¦;
%PUT ¦ Running for:  &DS;
%PUT ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯;

   %LET INVALIDS=%UPCASE(&INVALIDS);
   %LET VARN=;
   %GLOBAL CLUSTER LIB_ORIG;
/*   Check if Cluster Member has been defined then select thoes cluster members and copy and set them together */
/*   in a_devel domain (temporarily) and target this dataset instead of the original clustered dataset.*/

   %IF &MEMNUM NE %THEN %DO;
   		%LET CLUSTER=YES;
		libname a_devel sasspds 'devel' host='spds' serv='5190' user="&spdsuser" passwd="&spdspw" aclspecial=yes;
		%LET MEMN=%EVAL(%SYSFUNC(COUNTC(&MEMNUM,' '))+1);
		%LET CLS = %UPCASE(%SCAN(&DS,2,"."));
		%DO I=1 %TO &MEMN;
			%LET MEM=%SCAN(&MEMNUM,&I," ");
			%LET MEM= set &DS (MEMNUM=&MEM); ;
		 data a_devel.DATA&I;
			&MEM;;
		 run;
		 %PUT a_devel.&CLS ;
		data a_devel.&CLS;
			set a_devel.data1 - a_devel.data&MEMN;
		run;
		%END;
		%GETVARLIST (&DS);
		%LET LIB_ORIG=&LIB;
		%Let DS=a_devel.&CLS;
	%END;
*******************************************************************;
   PROC FORMAT; 
      VALUE $MISSCH " " = "Missing"
                    OTHER = "Nonmissing";
   RUN;
   %GETVARLIST (&DS);
   %GETFORMAT(&LIB..&DSN);

*******************************************************************;

      %* If there are any numeric variables, do the following;
   %IF &NVARLIST NE %THEN %DO;
		proc summary data=&LIB..&DSN N NMISS MEAN MIN MAX ;
			var &NVARLIST;
			output out=nvout;
			run;
		* Calculate Medians ;
		proc means data=&LIB..&DSN noprint qmethod=p2;
			var &NVARLIST ;
			output out=medians (drop= _TYPE_ _FREQ_) Median= / autoname;
			run;
		proc transpose data=medians out=medians (drop=_LABEL_ rename=(_NAME_=VARNAME COL1=MEDIAN) );
			run;
		data Medians;
			set medians;
			VARNAME=UPCASE(SUBSTR(VARNAME,1,LENGTH(VARNAME)-7));
			LABEL VARNAME='Variable Name';
			run;

		PROC TRANSPOSE data=NVOUT 
					   out=NVOUT;
			run;
		data NVOUT;
			set NVOUT;
			Retain N;
			if _NAME_ = '_FREQ_' then N=COL2;
			MISSING=N-COL1;
			PERCENT=100*MISSING/N;
			if _NAME_ in ('_TYPE_','_FREQ_') then delete;
			Type='Num ';
			_NAME_ = UPCASE (_NAME_);
			Rename _NAME_ = VARNAME _LABEL_ = VARLABEL COL1=NONMISSING COL2=MIN COL3=MAX COL4=MEAN COL5=STD;
			LABEL _NAME_='Variable Name'
				  _LABEL_='Variable Label'
				  PERCENT='% of Missing Values';
			drop N;
			run;

		proc sort data=NVOUT;
			by varname;
			run;
		proc sort data=MEDIANS;
			by varname;
			run;
		Data NVOUT;
			Merge NVOUT MEDIANS;
			by VARNAME;
			run;

		data NVOUT DTOUT PHINOUT; 
			merge NVOUT(in=in_NVOUT) contents (keep=varname format phin);
			by varname;
			if in_NVOUT;
			VARNAME=UPCASE(VARNAME);
			if format='YYMMDDD10.' then do;
				Type='Date';
				output DTOUT; 
				delete;
				end;
			if phin=1 then do;
				Type='ID';
				output PHINOUT; 
				delete;
				end;
			output NVOUT;
			drop format phin;
			run;
	%END;

*******************************************************************;

      %* If there are any character variables, do the following;

	%IF &CVARLIST NE %THEN %DO;

    	%AUTOLEVEL(&DS);
		%LET VARN=;
	    %GETVARLIST(&DS);
		%LET VARN=%SYSFUNC(COUNTC(&CVARLIST,' '));
		%LET VARN=%EVAL(&VARN+1);
		%LET GROUP=%SYSFUNC(CEILZ(%EVAL(&VARN)/300));

	      %* If there are any character variables, do the following;
			proc contents data=&LIB..&DSN out=content_C noprint;
				run;
			data content_C;
				set content_C (where=(type=2));
				I + 1;
				keep NAME LABEL I;
				run;
			%DO J=1 %TO &GROUP;
				%IF %EVAL(&J*300) > &VARN %THEN %LET ENDI=&VARN;
					%ELSE %LET ENDI=%EVAL(&J*300);
				%LET STARTI=%EVAL((&J*300)-299);
				%DO I=&STARTI %TO &ENDI ;
				%PUT &I &J &STARTI &ENDI ;
					%LET VARNAME&I= ;
					%LET LEVEL&I= ;
					PROC SQL NOPRINT;
					    SELECT NAME INTO :VARNAME&I    
					    FROM CONTENT_C  
					    WHERE I = &I; 
						quit;
					%LET VAR=&&VARNAME&I;
					proc sql;
						create table CVMISS&I as
							select "&VAR" as VARNAME,
							NMISS(&VAR) as Missing 
								from &LIB..&DSN
								where &VAR is MISSING
							group by &VAR;
						quit;
				%END;
				Data CVOUT&J;
					Set CVMISS&STARTI - CVMISS&ENDI;
					run;
				proc datasets library=work;
					delete CVMISS&STARTI - CVMISS&ENDI;
					run;
					quit;
			%END;
			Data CVOUT;
				Set CVOUT1 - CVOUT&GROUP;
				run;
			%GETNOBS(&LIB..&DSN);
			proc sort data=CVOUT;
				by VARNAME;
				run;
			proc sort data=CONTENT_C;
				by NAME;
				run;
			data CVOUT;
				merge CVOUT CONTENT_C (rename=(NAME=VARNAME LABEL=VARLABEL));
				by VARNAME;
				if Missing=. then missing=0;
				NONMISSING=SYMGETN('NO') - Missing;
				PERCENT=100*MISSING/(MISSING+NONMISSING);
				Type='Char';
				drop I;
				run;
			proc datasets library=work;
				delete CVOUT1 - CVOUT&GROUP CONTENT_C;
			run;
			quit;
			proc sort data=CVOUT;
				by VARNAME;
				run;

	%END;

*******************************************************************;


	*DM 'Clear log' ;
	DM 'Clear Out' ;
	data miss;
		length min_t $ 40 VARNAME $32;
		%IF (&NVARLIST NE ) AND (&CVARLIST NE ) %THEN set phinout nvout cvout dtout;;
    	%IF (&NVARLIST EQ ) AND (&CVARLIST NE ) %THEN set cvout;;
        %IF (&NVARLIST NE ) AND (&CVARLIST EQ ) %THEN set phinout nvout dtout;;

		if type='ID' then do;
			min=.;
			max=.;
			mean=.;
			STD=.;
			MEDIAN=.;
			end;
		if type='Date' then do; 
			min_t=put(min,YYMMDDD10.); 
			max_t=put(max,YYMMDDD10.); 
			mean=.;
			STD=.;
			MEDIAN=.;
			end;
		if type ^='Date' then do; 
			min_t=put(min,$10.); 
			max_t=put(max,$10.); 
		end;
		if type ^in ('Date','Num') then do;
			min_t=' ';
			max_t=' ';
			end;
		VARNAME=UPCASE(VARNAME);
		drop min max;
		rename min_t=MIN max_t=MAX;
		run;

	proc sort data=Miss;
		by VARNAME;
		run;
	data Clevel;
		set clevel;
		VAR=UPCASE(VAR);
		run;
	proc sort data=Clevel;
		by VAR;
		run;
	data Miss;
		merge Miss (in=a) Clevel (in=b rename=(VAR=VARNAME) );
		by VARNAME;
		if a;
		if b then Min=Level;
		if TYPE='ID' then order=1;
		if TYPE='Num' then order=2;
		if TYPE='Char' then order=3;
		if TYPE='Date' then order=4;
		drop Level;
		run;
	 %IF &NVARLIST NE %THEN %DO;
		%OUTLIER(&LIB..&DSN);
		data miss;
			merge miss outlier;
			by varname;
			outlier=100*(outlier_n/(MISSING + NONMISSING));
			if TYPE in ('Date','ID') then outlier=.;
			invalid=.;
			valid=100 - sum(invalid, percent,outlier);
			run;
	%END;
	%ELSE %DO;
		data miss;
			set miss;
			by varname;
			outlier=.;
			outlier_n=.;
			invalid=.;
			valid=100 - sum(invalid, percent,outlier);
			run;
	%END;
	%IF &INVALIDS^=OFF %THEN %DO;
		%INVALID(DS=&DS);
		proc sort data=miss;
			by varname;
			run;
		%IF &POSTALS^= OR &MUNCODES^= %THEN %POSTMUN(POSTALS=&POSTALS , MUNCODES=&MUNCODES); ;
		proc sort data=invalid NODUPKEY;
			by varname;
			run;
		data miss;
			%IF &POSTALS^= OR &MUNCODES^= %THEN merge miss invalid (rename=(invalid=invalid_n)) POSTMUN;
				%ELSE merge miss invalid (rename=(invalid=invalid_n)); ;
			by varname;
			invalid= 100*(invalid_n / (missing+nonmissing));
			valid=100 - sum(invalid, percent,outlier);
			run;
		proc sort data=Miss;
			by order;
			run;
		proc sql;
		   create table miss_temp as
		   	select 
				type
				,Varname
				,varlabel
				,Valid
				,Invalid
				,percent as Missing
				,outlier
				,min
				,max
				,mean
				,MEDIAN
				,std
				,invalid_codes as Comment
			from miss;
			quit;
	%END;
	%IF &INVALIDS=OFF & (&POSTALS^= OR &MUNCODES^= )%THEN %DO;
		%POSTMUN(POSTALS=&POSTALS , MUNCODES=&MUNCODES);
		data miss;
			merge miss POSTMUN;
			by varname;
			invalid= 100*(invalid_n / (missing+nonmissing));
			valid=100 - sum(invalid, percent,outlier);
			run;
		proc sort data=Miss NODUPKEY;
			by VARNAME;
			run;
		proc sort data=Miss;
			by order;
			run;
		proc sql;
		   create table miss_temp as
		   	select 
				type
				,Varname
				,varlabel
				,Valid
				,Invalid
				,percent as Missing
				,outlier
				,min
				,max
				,mean
				,MEDIAN
				,std
				,invalid_codes as Comment
			from miss;
			quit;
	%END;
	%IF &INVALIDS=OFF & &POSTALS= & &MUNCODES= %THEN %DO;
		data miss;
			length INVALID_CODES $ 500 ;
			set miss;
			run;
		proc sort data=Miss NODUPKEY;
			by VARNAME;
			run;
		proc sort data=Miss;
			by order;
			run;
		proc sql;
		   create table miss_temp as
		   	select 
				type
				,Varname
				,varlabel
				,Valid
				,Invalid
				,percent as Missing
				,outlier
				,min
				,max
				,mean
				,MEDIAN
				,std
				,invalid_codes as Comment
			from miss;
		quit;
	%END;

	*********************************;
	*** Note: Outlier and Invalid columns are not mutually exclusive and then Valid Percentage might be negative. The 
	          Following codes force Valid percentage to zero if it has a negative value;

	data miss_temp;
		set miss_temp;
		if valid < 0 then valid=0 ;
		run;
	data miss;
		set miss;
		if valid < 0 then valid=0 ;
		run;	
	*********************************;

	%IF &MEMNUM ^= %THEN %DO;
		%LET FILENAME= %SYSFUNC(COMPRESS(&MEMNUM));
		%LET FILENAME= &DSN&FILENAME._VIMO.xls;
	%END;

	%ELSE %LET FILENAME= &DSN._VIMO.xls;
	PROC EXPORT DATA= WORK.Miss_temp
	            OUTFILE= "/dq/saswork/&spdsuser/&FILENAME"		/* Location where excel is output */
	            DBMS=XLS REPLACE;
	RUN;
	proc print data=MISS Label noobs round;
		title1 'Data Quality Assurance Report';
		title2 'Manitoba Centre for Health Policy';
		title3 "Data Set: &LIB..&DSN";
		title4 'Missing values and Max/Min for All Data Elements';
		var type varname varlabel Valid Invalid percent outlier min max mean MEDIAN std;
		run;
	proc datasets library=work;
		delete temp Contents clevel content_c content_n CVOUT 
			   DTOUT  MISS_TEMP NVOUT OUTLIER PHINOUT; *MISS;
	run;
	%IF &MEMNUM NE %THEN %DO;
		proc datasets library=a_devel;
			delete Data1 - Data&MEMN &CLS; 
		run;
	%END;
		quit;
	%SYMDEL  CLUSTER CVARLIST DSN LIB NO NVARLIST NVFMT CVFMT;
%MEND VIMO;



