/*******
  Credit Risk Scorecards: Development and Implementation using SAS
  (c)  Mamdouh Refaat
********/


/*******************************************************/
/* Macro SCCSV */
/*******************************************************/
%macro SCCSV(SCDS,BasePoints, BaseOdds, PDO, IntOpt,FileName);
/* writing the scorecard generated by the scorecard dataset to an output
  file FileName generating CSV format readable by MS Excel
  If The option IntOpt=1 then we convert the points to integer values
  otherwise they are left as numbers */

/* direct the output to the filename */

proc sort data=&SCDS;
by VarType VarName;
run;

data _null_;
set &SCDS nobs=nx;
by VarType VarName;
file "&FileName";
length cond $300.;

if _N_ =1 then do;
	put 'Automatically Generated Scorecard , , , , , ';
	put ', , , , ,';
	put 'Scorecard Scale, , , , ';
	put "Odds, 1, to,  &BaseOdds ,  at , &BasePoints , Points ";
    put " PDO,  &PDO, , , , ";
	put', , , ,'; 
end; 

%if &IntOpt=1 %then xPoints=int(Points);
%else xPoints=Points; ;

if VarName="_BasePoints_" then do;
    put ' ,,,,,, Points ';
	put ' ,,,,,, =======';
	put "Base Points, ,,,,," xPoints;
                            end;
 else do;
   if first.VarName then do;
	put VarName ", , , ,";
	put '--------------, , , ,';
                      end;

    /* The rule */
    if VarType=1 then  do;/* continuous */
	if      first.VarName then  cond=',,,,<=,'||UL ; 
	else if  last.VarName then  cond=',,,,> ,'||LL ;
    else cond=',>,'|| compress(LL)||', AND , <=,'||UL ; 
                       end; 
    else if VarType=2 then /* nominal string */
	cond = ',,, '|| (compress(Category))|| ",,"; 

	else /* nominal numeric */
	cond=' ,, ,'|| compress(N_Category)|| ",,"; 
	
	put "      " cond ", " xPoints;

 end;

run;


%mend;
