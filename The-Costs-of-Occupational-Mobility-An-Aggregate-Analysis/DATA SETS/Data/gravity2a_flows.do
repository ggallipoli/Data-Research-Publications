# delimit ;

*cd "[directory where do-files are saved]";

************************************************************
************* COLLAPSE TO FLOWS DATASET ********************
************************************************************;
foreach sample in "educ" "full" "young" "full12" "CodingError" { ;

if "`sample'"=="educ" | "`sample'"=="full" | "`sample'"=="young" | "`sample'"=="full12" { ;
use "Built/cpsmonthly_gravity", clear;
};
if "`sample'"=="CodingError" { ;
	display "FROM HERE ON FOR 1992 ONLY";
use "Built/CodingError/cpsmonthly_gravity", clear;
};

if "`sample'"=="young" { ;
	display "FROM HERE ON FOR YOUNG SAMPLE";
	drop if age>35;
};

if "`sample'"=="educ" { ;
	display "FROM HERE ON BY EDUC GP'S";
	gen coll=(educ==4);
	replace coll=. if educ==.;
};


if "`sample'"=="full" | "`sample'"=="young" | "`sample'"=="CodingError" { ;
collapse (sum) flows=sswgt if occ2dig_dd<. & occ2dig_dd_t1<., 
		by(occ2dig_dd occ2dig_dd_t1 mdate);
};

if "`sample'"=="educ" { ;
collapse (sum) flows=sswgt if occ2dig_dd<. & occ2dig_dd_t1<., 
		by(occ2dig_dd occ2dig_dd_t1 mdate coll);
};

if "`sample'"=="full12" { ;
	* Keep only individuals in month-in-sample 4 (to avoid double-counting
	* the same transitions);
keep if mis==4 ;
	
collapse (sum) flows=sswgt if occ2dig_dd<. & occ2dig_dd_t12<., 
		by(occ2dig_dd occ2dig_dd_t12 mdate);
};




* Get ALL source and destination combinations;
if "`sample'"=="full" | "`sample'"=="young" | "`sample'"=="full12" | "`sample'"=="CodingError" { ;
reshape wide flows, i(mdate occ2dig_dd) j(occ2dig_dd_t1);
reshape long flows, i(mdate occ2dig_dd) j(occ2dig_dd_t1);
};
if "`sample'"=="educ" { ;
reshape wide flows, i(mdate occ2dig_dd coll) j(occ2dig_dd_t1);
reshape long flows, i(mdate occ2dig_dd coll) j(occ2dig_dd_t1);
};
* Fill in missing values (combinations that did not exist in the data) 
* with zeros (they represent zero flows);
replace flows=0 if flows==.;

************************************************************
********* COLLAPSE MONTHLY FLOWS TO ANNUAL FLOWS ***********
************************************************************;
*** Generate year variable ***;
gen year=year(dofm(mdate));

if "`sample'"=="full" | "`sample'"=="young" | "`sample'"=="full12" | "`sample'"=="CodingError" { ;
collapse (sum) flows, by(occ2dig_dd occ2dig_dd_t1 year);
};
if "`sample'"=="educ" { ;
collapse (sum) flows, by(occ2dig_dd occ2dig_dd_t1 year coll);
};

************************************************************
*********** ATTACH TASK MEASURES AND GEN DIST **************
************************************************************;

* DOT;
merge m:1 occ2dig_dd using "dot_occ2dig_dd", keep(1 3) nogen;

tempfile aux1 aux2;
save `aux1', replace;

use "dot_occ2dig_dd", clear;
rename * *_t1;	* Attaches _t1 at the end of all variable names;  
save `aux2', replace;

use `aux1', clear;
merge m:1 occ2dig_dd_t1 using `aux2', keep(1 3) nogen;

*Generate distance measures using GED and Aptitudes;
gen d91 = [(reas91-reas91_t1)^2 + (math91-math91_t1)^2 + (lang91-lang91_t1)^2
	+ (g91-g91_t1)^2 + (v91-v91_t1)^2 + (n91-n91_t1)^2 + (s91-s91_t1)^2
	+ (p91-p91_t1)^2 + (q91-q91_t1)^2 + (k91-k91_t1)^2 + (f91-f91_t1)^2
	+ (m91-m91_t1)^2 + (e91-e91_t1)^2 + (c91-c91_t1)^2]^(1/2);

*Generate distance measures using all DOT dimensions (except svp);
gen d91alt = [d91^2 + (dcp91-dcp91_t1)^2 + (repcon91-repcon91_t1)^2 
	+ (influ91-influ91_t1)^2 + (fif91-fif91_t1)^2 + (varch91-varch91_t1)^2 
	+ (alone91-alone91_t1)^2 + (phs91-phs91_t1)^2 + (sts91-sts91_t1)^2
	+ (under91-under91_t1)^2 + (depl91-depl91_t1)^2 + (sjc91-sjc91_t1)^2]^(1/2);

*Generate G&S's angular separation-based distance measures;
gen aux1 = (reas91*reas91_t1) + (math91*math91_t1) + (lang91*lang91_t1)
	+ (g91*g91_t1) + (v91*v91_t1) + (n91*n91_t1) + (s91*s91_t1)
	+ (p91*p91_t1) + (q91*q91_t1) + (k91*k91_t1) + (f91*f91_t1)
	+ (m91*m91_t1) + (e91*e91_t1) + (c91*c91_t1);
gen aux2 = reas91^2 + math91^2 + lang91^2
	+ g91^2 + v91^2 + n91^2 + s91^2	+ p91^2 + q91^2 + k91^2 + f91^2
	+ m91^2 + e91^2 + c91^2;
gen aux3 = reas91_t1^2 + math91_t1^2 + lang91_t1^2
	+ g91_t1^2 + v91_t1^2 + n91_t1^2 + s91_t1^2	
	+ p91_t1^2 + q91_t1^2 + k91_t1^2 + f91_t1^2
	+ m91_t1^2 + e91_t1^2 + c91_t1^2;
gen angsep91 = .5 - .5*(aux1/sqrt(aux2*aux3));
drop aux1-aux3;

gen aux1 = (reas91*reas91_t1) + (math91*math91_t1) + (lang91*lang91_t1)
	+ (g91*g91_t1) + (v91*v91_t1) + (n91*n91_t1) + (s91*s91_t1)
	+ (p91*p91_t1) + (q91*q91_t1) + (k91*k91_t1) + (f91*f91_t1)
	+ (m91*m91_t1) + (e91*e91_t1) + (c91*c91_t1) + (dcp91*dcp91_t1) 
	+ (repcon91*repcon91_t1) + (influ91*influ91_t1) + (fif91*fif91_t1)
	+ (varch91*varch91_t1) + (alone91*alone91_t1) + (phs91*phs91_t1)
	+ (sts91*sts91_t1) + (under91*under91_t1) + (depl91*depl91_t1)
	+ (sjc91*sjc91_t1);
gen aux2 = reas91^2 + math91^2 + lang91^2
	+ g91^2 + v91^2 + n91^2 + s91^2	+ p91^2 + q91^2 + k91^2 + f91^2
	+ m91^2 + e91^2 + c91^2 + dcp91^2 + repcon91^2 + influ91^2 + fif91^2 
	+ varch91^2 + alone91^2 + phs91^2 + sts91^2 + under91^2 + depl91^2 
	+ sjc91^2;
gen aux3 = reas91_t1^2 + math91_t1^2 + lang91_t1^2
	+ g91_t1^2 + v91_t1^2 + n91_t1^2 + s91_t1^2	
	+ p91_t1^2 + q91_t1^2 + k91_t1^2 + f91_t1^2
	+ m91_t1^2 + e91_t1^2 + c91_t1^2 + dcp91_t1^2 + repcon91_t1^2 
	+ influ91_t1^2 + fif91_t1^2 + varch91_t1^2 + alone91_t1^2 + phs91_t1^2 
	+ sts91_t1^2 + under91_t1^2 + depl91_t1^2 + sjc91_t1^2;
gen angsep91alt = .5 - .5*(aux1/sqrt(aux2*aux3));
drop aux1-aux3;

	
*** ONet Work Activities;	
merge m:1 occ2dig_dd using "onet09_wk_occ2dig_dd", 
	keep(1 3) nogen;

tempfile aux1 aux2;
save `aux1', replace;

use "onet09_wk_occ2dig_dd", clear;
rename * *_t1;	* Attaches _t1 at the end of all variable names;  
save `aux2', replace;

use `aux1', clear;
merge m:1 occ2dig_dd_t1 using `aux2', keep(1 3) nogen;

*Generate distance measures;
gen d09 = (work1_09-work1_09_t1)^2;
foreach num of numlist 2(1)41 {;
	replace d09 = d09 + (work`num'_09-work`num'_09_t1)^2;
};
replace d09=d09^(1/2);


*Generate G&S's angular separation-based distance measures;
gen aux1 = (work1_09*work1_09_t1);
gen aux2 = work1_09^2;
gen aux3 = work1_09_t1^2;
foreach num of numlist 2(1)41 {;
	replace aux1 = aux1 + (work`num'_09*work`num'_09_t1);
	replace aux2 = aux2 + work`num'_09^2;
	replace aux3 = aux3 + work`num'_09_t1^2;
};
gen angsep09 = .5 - .5*(aux1/sqrt(aux2*aux3));
drop aux1-aux3;

drop work*;

*** ONet Skills;	
merge m:1 occ2dig_dd using "onet09_sk_occ2dig_dd", 
	keep(1 3) nogen;

save `aux1', replace;

use "onet09_sk_occ2dig_dd", clear;
rename * *_t1;	* Attaches _t1 at the end of all variable names;  
save `aux2', replace;

use `aux1', clear;
merge m:1 occ2dig_dd_t1 using `aux2', keep(1 3) nogen;

*Generate distance measures;
gen d09skill = (skill1_09-skill1_09_t1)^2;
foreach num of numlist 2(1)35 {;
	replace d09skill = d09skill + (skill`num'_09-skill`num'_09_t1)^2;
};
replace d09skill=d09skill^(1/2);

*Generate G&S's angular separation-based distance measures;
gen aux1 = (skill1_09*skill1_09_t1);
gen aux2 = skill1_09^2;
gen aux3 = skill1_09_t1^2;
foreach num of numlist 2(1)35 {;
	replace aux1 = aux1 + (skill`num'_09*skill`num'_09_t1);
	replace aux2 = aux2 + skill`num'_09^2;
	replace aux3 = aux3 + skill`num'_09_t1^2;
};
gen angsep09skill = .5 - .5*(aux1/sqrt(aux2*aux3));
drop aux1-aux3;

drop skill*;

*Generate distance measure with both;
gen d09both = [d09^2 + d09skill^2]^(1/2);


label var d91 "Distance, 1991 DOT GED and Aptitudes";
label var d91alt "Distance, 1991 DOT All";
label var d09 "Distance, 2009 ONET Work Activities";
label var d09skill "Distance, 2009 ONET Skills";
label var d09both "Distance, 2009 ONET Work Activities and Skills";
gen logd91=ln(1+d91);
gen logd91alt=ln(1+d91alt);
gen logd09=ln(1+d09);
gen logd09skill=ln(1+d09skill);
gen logd09both=ln(1+d09both);
label var logd91 "Log 1+Distance, 1991 DOT";
label var logd91alt "Log 1+Distance, 1991 DOT All";
label var logd09 "Log 1+Distance, 2009 ONET Work Activities";
label var logd09skill "Log 1+Distance, 2009 ONET Skills";
label var logd09both "Log 1+Distance, 2009 ONET Work Activities and Skills";

label var angsep91 "Distance based on ang separation, 1991 DOT GED and Apt";
label var angsep91alt "Distance based on ang separation, 1991 DOT All";
label var angsep09 "Distance based on ang separation, 2009 ONET Work Act";
label var angsep09skill "Distance based on ang separation, 2009 ONET Skills";

if "`sample'"!="CodingError" { ;
sum logd* angsep* if occ2dig_dd!=occ2dig_dd_t1 & year==2011, det;

corr logd91 angsep91* logd91alt logd09 angsep09* logd09skill logd09both
	if occ2dig_dd!=occ2dig_dd_t1 & year==2011;
};

*************************************************************************
***************************** GEN TASK INT ******************************
*Generate chg in task intensity measures
;
gen int91 = reas91^2 + math91^2 + lang91^2 + g91^2 + v91^2 + n91^2 
	+ s91^2 + p91^2 + q91^2 + k91^2 + f91^2 + m91^2 + e91^2 + c91^2;

gen int91_t1 = reas91_t1^2 + math91_t1^2 + lang91_t1^2 + g91_t1^2 + v91_t1^2 
	+ n91_t1^2 + s91_t1^2 + p91_t1^2 + q91_t1^2 + k91_t1^2 + f91_t1^2 
	+ m91_t1^2 + e91_t1^2 + c91_t1^2;

gen dint91 = int91_t1-int91;

label var int91 "Task Intensity, 1991 DOT";

label var dint91 "Chg in Task Intensity, 1991 DOT";


************************************************************
************* ATTACH BROAD OCC INDICATORS ******************
************************************************************;

merge m:1 occ2dig_dd using "Built/occ2dig_to_broad", 
	keep(1 3) nogen;

save `aux1', replace;

use "Built/occ2dig_to_broad", clear;
rename * *_t1;	* Attaches _t1 at the end of all variable names;  
save `aux2', replace;

use `aux1', clear;
merge m:1 occ2dig_dd_t1 using `aux2', keep(1 3) nogen;


*************************************************************************
******************* GENERATE SWITCHER SHARES ****************************
*************************************************************************;
* Total number per source occ in each year;
rename occ2dig_dd occ2dig;
rename occ2dig_dd_t1 occ2dig_t1;
if "`sample'"=="full" | "`sample'"=="young" | "`sample'"=="full12" | "`sample'"=="CodingError" { ;
sort year occ2dig;
by year occ2dig : egen n=sum(flows);
};
if "`sample'"=="educ" { ;
sort coll year occ2dig;
by coll year occ2dig : egen n=sum(flows);
};
label var n "size of occ2dig";
gen share=flows/n;
label var share "flows/n";
gen aux1=share if occ2dig==occ2dig_t1;
if "`sample'"=="full" | "`sample'"=="young" | "`sample'"=="full12" | "`sample'"=="CodingError" { ;
by year occ2dig : egen aux2=max(aux1);
};
if "`sample'"=="educ" { ;
by coll year occ2dig : egen aux2=max(aux1);
};
gen normsw=share/aux2 if occ2dig~=occ2dig_t1;
label var normsw "(sw_kj/n) / (sw_kk/n)";
drop aux1 aux2;
sum normsw, det;
gen lognormsw=ln(normsw);

* Generate alternative measure of switchers from k to j as fraction of total 
* switchers from k;
if "`sample'"=="full" { ;
gen flows_aux = flows if occ2dig!=occ2dig_t1;
by year occ2dig : egen aux1=sum(flows_aux);
gen sw_frac = flows_aux/aux1;
by year occ2dig : egen test = sum(sw_frac);
sum test, det;
drop flows_aux aux1 test;
gen logsw_frac = ln(sw_frac);
};


* Add 1-digit occ code;
foreach x in dig dig_t1 { ;
	gen occ1`x'=01 if occ2`x'>=2 & occ2`x'<=3;
	replace occ1`x'=02 if occ2`x'>=4 & occ2`x'<=16;
	replace occ1`x'=03 if occ2`x'>=17 & occ2`x'<=18;
	replace occ1`x'=04 if occ2`x'>=19 & occ2`x'<=25;
	replace occ1`x'=05 if occ2`x'>=26 & occ2`x'<=31;
	replace occ1`x'=06 if occ2`x'>=32 & occ2`x'<=33;
	replace occ1`x'=07 if occ2`x'>=35 & occ2`x'<=37;
	replace occ1`x'=08 if occ2`x'>=38 & occ2`x'<=40;
	replace occ1`x'=09 if occ2`x'>=41 & occ2`x'<=44;
	label var occ1`x' "1-digit occ code (DD)";
};

* Generate dummies for common 1-digit code and main task intensity;
gen common_maj=(occ1dig==occ1dig_t1);
gen common_tint=(tint91==tint91_t1);



*** Occ dummies - Source ***
=1 if occ is source
;
forvalues i=1(1)45 {			;
	gen src_`i'=(occ2dig==`i')	;
}						;
foreach var of varlist src_1-src_45 {		;
	quietly sum `var'				;
	if r(max)==0 {				;
		drop `var'				;
		di "`var' is being dropped"	;
	}						;
}							;

*** Occ dummies - Destination ***
=1 if occ is destination
;
forvalues i=1(1)45 {			;
	gen dst_`i'=(occ2dig_t1==`i')	;
}						;
foreach var of varlist dst_1-dst_45 {	;
	quietly sum `var'				;
	if r(max)==0 {				;
		drop `var'				;
		di "`var' is being dropped"	;
	}						;
}							;



* Year dummies;
quietly sum year;
forvalues i=`r(min)'(1)`r(max)' {	;
	gen y_`i'=(year==`i')	;
}	;

* Dummies for different task-group switches;
sort occ_broad occ_broad_t1;
egen task_pair=concat(occ_broad occ_broad_t1);
destring task_pair, replace;
foreach num of numlist 11(1)14 18 21(1)24 28 31(1)34 38 41(1)44 48 81(1)84 88 {;
gen task_pair_`num'=(task_pair==`num');
};

gen task_pair_same = 1 if task_pair==11 | task_pair==22 | task_pair==33
		| task_pair==44 | task_pair==88;
replace task_pair_same = 0 if task_pair_same==.;

* Generate dummies for switching into occupations from different task groups;
gen switch_to_nrc=1 if occ_broad_t1==1 & occ_broad!=1;
replace switch_to_nrc=0 if switch_to_nrc==.;
gen switch_to_rc=1 if occ_broad_t1==2 & occ_broad!=2;
replace switch_to_rc=0 if switch_to_rc==.;
gen switch_to_rm=1 if occ_broad_t1==3 & occ_broad!=3;
replace switch_to_rm=0 if switch_to_rm==.;
gen switch_to_nrm=1 if occ_broad_t1==4 & occ_broad!=4;
replace switch_to_nrm=0 if switch_to_nrm==.;


*************************************************************************
*********** DISPLAY A FEW MEASURES TO MAKE EXAMPLE TABLE ****************
*************************************************************************;
browse occ2dig occ2dig_t1 reas91-c91 reas91_-c91_ 
	angsep91 angsep09 if year==2012 
	& ((occ2dig==43 & occ2dig_t1==44) | (occ2dig==8 & occ2dig_t1==30));
	
	
if "`sample'"=="full" { ;	
save "Built/gravity_flows", replace;
};

if "`sample'"=="young" { ;
save "Built/Young/gravity_flows", replace;
};
if "`sample'"=="educ" { ;
save `aux1', replace;
keep if coll==1;
drop coll;
save "Built/Coll/gravity_flows", replace;
use `aux1', clear;
keep if coll==0;
drop coll;
save "Built/HS/gravity_flows", replace;
};
if "`sample'"=="full12" { ;
rename *t1 *t12; /* Changes t1 to t12; */
save "Built/Long/gravity_flows", replace;
};
if "`sample'"=="CodingError" { ;
save "Built/CodingError/gravity_flows", replace;
};

};


