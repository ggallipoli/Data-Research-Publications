# delimit ;

*cd "[directory where do-files are saved]";

use "lpd", clear;

* Drop allocation flags;
drop x*;
	
format mdate %tm;

* Keep only post-94 (b/c of dependent coding) *;
	* Now keeping also 1992 for coding error robustness check * ;
drop if mdate<m(1992m1);

* Keep only aged 18-65;
drop if age<18;
drop if age>65;

*** Generate coding system indicator ***;
gen coc="1990s" if mdate>=m(1992m1) & mdate<=m(2002m12);
replace coc="2002" if mdate>=m(2003m1) & mdate<=m(2010m12);
replace coc="2010s" if mdate>=m(2011m1) ;
label var coc "Census Occupation Coding System";


*** Convert to Autor-Dorn codes ***;
gen occ90=peio1ocd if coc=="1990s";
	merge m:1 occ90 using "occ90to_mo_dd", 
		keepusing(occ1990dd) nogen keep(1 3 4 5) update;
drop occ90;

gen occ00=peio1ocd if coc=="2002";
replace occ00=occ00/10 if occ00>-1;
merge m:1 occ00 using "occ00to_mo_dd", 
	keepusing(occ1990dd) nogen keep(1 3 4 5) update;
drop occ00;

gen occ2010=peio1ocd if coc=="2010s";
merge m:1 occ2010 using "occ10to_00_mo_dd", 
	keepusing(occ1990dd) nogen keep(1 3 4 5) update;
drop occ2010;

label var occ1990dd "David Dorn's occupation codes";

* Aggregate to 2-digit level;
do "occ_dd_aggreg";

tab occ2dig_dd;
tab occ1990dd if occ2dig_dd==.;
tab peio1ocd if occ2dig_dd==.;


**** Drop farm and military (change to missing) *****;
replace occ2dig_dd=. if occ2dig_dd==32 | occ2dig_dd==33 | occ2dig_dd==45;


* Change to missing for non-employed;
replace occ2dig_dd=. if (lfs~=1);


*** Aggregate to broad task groups ***;
gen occ_broad = 1 if occ1990dd>=4 & occ1990dd<=235;
replace occ_broad = 1 if occ1990dd>=415 & occ1990dd<=427;

replace occ_broad = 2 if occ1990dd>=243 & occ1990dd<=389;

replace occ_broad = 3 if occ1990dd>=503 & occ1990dd<=617;
replace occ_broad = 3 if occ1990dd>=628 & occ1990dd<=799;
replace occ_broad = 3 if occ1990dd>=803 & occ1990dd<=889;

replace occ_broad = 4 if occ1990dd>=405 & occ1990dd<=408;
replace occ_broad = 4 if occ1990dd>=433 & occ1990dd<=472;

replace occ_broad = 8 if occ1990dd>=473 & occ1990dd<=498;
replace occ_broad = 8 if occ1990dd==905;

label var occ_broad "4 broad occ categories (Routine/Non-Routine)";
label define broad 1 "Non-Routine Cog" 2 "Routine Cog" 
	3 "Routine Man" 4 "Non-Routine Man" 8 "Farm/Military";
label values occ_broad broad;
tab occ_broad;


************************************************************************
************** GENERATE OCC 1 AND 12 MONTHS AHEAD **********************
************************************************************************;

* First need to flag `bad' months (where id's not matched properly);
gen bad = (mdate>=m(1995m6) & mdate<=m(1995m8));
replace bad = 1 if mdate==m(1993m11) | mdate==m(1993m12);

* Generate 2-digit occ 1 month ahead;
sort pid mdate;
	by pid (mdate) : 
		gen occ2dig_dd_t1=occ2dig_dd[_n+1] if mdate[_n+1]==mdate+1
			& bad[_n+1]==0 & match[_n+1]==1;
		replace occ2dig_dd_t1=. if coc=="1990s" & coc[_n+1]~="1990s";
			* This will only happen in 2002m12
	label var occ2dig_dd_t1 "2-digit occ 1 month ahead";

* Generate 2-digit occ 12 months ahead;
  by pid (mdate) : 
		gen occ2dig_dd_t12=occ2dig_dd[_n+1] if mdate[_n+1]==mdate+12
			& bad[_n+1]==0 & intstat[_n+1]==1 & mvs_8>=.9 
			& mvs_8[_n+1]>=.9;
		replace occ2dig_dd_t12=. if coc=="1970s" & coc[_n+1]~="1970s";
		replace occ2dig_dd_t12=. if coc=="1990s" & coc[_n+1]~="1990s";
	foreach obs of numlist 2(1)7 { ; 
		by pid (mdate) : 
		replace occ2dig_dd_t12=occ2dig_dd[_n+`obs'] 
			if mdate[_n+`obs']==mdate+12 & bad[_n+`obs']==0 
			& intstat[_n+`obs']==1 & mvs_8>=.9 & mvs_8[_n+`obs']>=.9;
		replace occ2dig_dd_t12=. if mdate[_n+`obs']==mdate+12 
			& bad[_n+`obs']==0 & intstat[_n+`obs']==1 
			& mvs_8>=.9 & mvs_8[_n+`obs']>=.9 
			& coc=="1970s" & coc[_n+`obs']~="1970s";
		replace occ2dig_dd_t12=. if mdate[_n+`obs']==mdate+12 
			& bad[_n+`obs']==0 & intstat[_n+`obs']==1 
			& mvs_8>=.9 & mvs_8[_n+`obs']>=.9 
			& coc=="1990s" & coc[_n+`obs']~="1990s";
	} ;
	label var occ2dig_dd_t12 "2-digit occ 12 months ahead";
		

tempfile aux1;
save `aux1', replace;

foreach sample in "full" "CodingError" { ;
if "`sample'"=="full" { ;
* Drop 1993 for normal full sample for dependent coding period;
drop if mdate<m(1994m1);
save "Built/cpsmonthly_gravity", replace;
} ;
if "`sample'"=="CodingError" { ;
use `aux1', clear;
* Keep only 1992 for coding error robustness check;
drop if mdate>=m(1993m1);
save "Built/CodingError/cpsmonthly_gravity", replace;
} ;
} ;
use `aux1', clear;


************************************************************************
******** GENERATE BROAD OCC INDICATORS FOR EACH 2-DIGIT OCC ************
************************************************************************;

drop if occ2dig_dd==.;
collapse (mean) occ_broad, by(occ2dig_dd);
label var occ_broad "4 broad occ categories (Routine/Non-Routine)";
label values occ_broad broad;

save "Built/occ2dig_to_broad", replace;


************************************************************************
***** GENERATE FRACTION OF WORKERS WITH COLLEGE DEGREE BY OCC-YEAR *****
************************************************************************;
use "Built/cpsmonthly_gravity", clear;

gen coll=(educ==4);
replace coll=. if educ==.;
gen year=year(dofm(mdate));
rename occ2dig_dd occ2dig;
collapse coll [w=sswgt], by(occ2dig year);
save "Built/frac_coll", replace;


************************************************************************
*************** GENERATE UNIONIZATION RATES BY OCC-YEAR ****************
************************************************************************;
use "union_occ", clear;

*** Re-do same restrictions as above ***;

* Keep only post-94 (b/c of dependent coding) *;
drop if year<1994;

* Keep only aged 18-65;
drop if age<18;
drop if age>65;

*** Generate coding system indicator ***;
gen coc="1990s" if year>=1992 & year<=2002;
replace coc="2002" if year>=2003 & year<=2010;
replace coc="2010s" if year>=2011 ;
label var coc "Census Occupation Coding System";

*** Convert to Autor-Dorn codes ***;
rename occ peio1ocd;
gen occ90=peio1ocd if coc=="1990s";
	merge m:1 occ90 using "occ90to_mo_dd", 
		keepusing(occ1990dd) nogen keep(1 3 4 5) update;
drop occ90;

gen occ00=peio1ocd if coc=="2002";
replace occ00=occ00/10 if occ00>-1;
merge m:1 occ00 using "occ00to_mo_dd", 
	keepusing(occ1990dd) nogen keep(1 3 4 5) update;
drop occ00;

gen occ2010=peio1ocd if coc=="2010s";
merge m:1 occ2010 using "occ10to_00_mo_dd", 
	keepusing(occ1990dd) nogen keep(1 3 4 5) update;
drop occ2010;

label var occ1990dd "David Dorn's occupation codes";

* Aggregate to 2-digit level;
do "occ_dd_aggreg";

tab occ2dig_dd;
tab occ1990dd if occ2dig_dd==.;
tab peio1ocd if occ2dig_dd==.;

**** Drop farm and military (change to missing) *****;
replace occ2dig_dd=. if occ2dig_dd==32 | occ2dig_dd==33 | occ2dig_dd==45;

* Change to missing for non-employed;
	gen lfs = .;
	replace lfs = 1 if empstat>=10 & empstat<=12;
	replace lfs = 2 if empstat>=20 & empstat<=22;
	replace lfs = 3 if empstat>=30 & empstat<=36;
replace occ2dig_dd=. if (lfs~=1);


rename wtfinl sswgt;

rename occ2dig_dd occ2dig;

gen union_cov = (union==2 | union==3);
replace union_cov =. if union==0 | union==.;

gen union_memb = (union==2);
replace union_memb =. if union==0 | union==.;

collapse union_* [w=sswgt], by(occ2dig year);

save "Built/frac_union", replace;


***************************************************************
*************** GENERATE LICENSING INFO BY OCC ****************
***************************************************************;
use "Built/cpsmonthly_gravity", clear;

gen year=year(dofm(mdate));
rename occ2dig_dd occ2dig;

* Licensing data is for March 2010 - keep 2010 data only *;
keep if year==2010;

*** Merge in licensing data at occ00 level ***;
gen occ00=peio1ocd if coc=="2002";
replace occ00=occ00/10 if occ00>-1;
merge m:1 occ00 using "licensure_occ00.dta";
	*** Note: codes corresponding to 'miscellaneous' have been dropped by Schoellman;

*** Generate a licensing measure which weights the presence of federal and state licenses ***;
gen lic_fed_state = 0.5*fed_license+0.5*(licensed/50);
	* Ranges between 0 (for occ's with no fed or state licenses) to 1 (for 
	* occ's that are federally licensed and licensed in all 50 states);

*** Licensing measures from Schoellman paper ***;

/* (1) The baseline definition of heavily licensed occupations includes all federally licensed
occupations, plus those occupations in the top decile in terms of number of licenses issued,
which requires being covered by at least 59 licenses across all states.
CONDITION: Occupations that are "licensed" by the baseline definition in the paper:  list if fed_license == 1 | licenses >= 59 */
gen heavylic=(fed_license==1 | licenses>=59);
replace heavylic=. if fed_license==. | licenses==.;

/* (2) The first alternative definition includes all federally licensed
occupations plus the top 10% of occupations in terms of number of states covered by at
least one license. To be included in this group an occupation has to be licensed in at least
34 states */
gen heavylic2=(fed_license==1 | licensed>=34) ;
replace heavylic2=. if fed_license==. | licensed==.;

/* (3) The second definition also includes all federally licensed occupations plus the top 25% of occupations in terms of the
total number of licenses issued across all states, which requires being covered by at least
18 licenses across all states. */
gen heavylic3=(fed_license==1 | licenses>=18); 
replace heavylic3=. if fed_license==. | licenses==.;

*** Generate weighted averages for each 2-digit occupation***;
collapse licenses licensed fed_license lic_fed_state 
	shareheavy=heavylic shareheavy2=heavylic2 shareheavy3=heavylic3 
	[w=sswgt], by(occ2dig year);

drop year;
save "Built/license", replace;

