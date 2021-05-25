# delimit ;

*cd "[directory where do-files are saved]";

cap log close;
log using "Built/gravity2b_log", replace;
  
use "Built/cpsmonthly_gravity", clear;

rename occ2dig_dd occ2dig;
rename occ2dig_dd_t1 occ2dig_t1;

**********************************************************************
********* GENERATE ESTIMATES OF LOWER BOUND OF THETA *****************
**********************************************************************;

*** Generate hourly wage rate ***;
* Divide weekly earnings by usual hours;
gen w_hr = ernhrly if ernhrly~=-1;
replace w_hr = ernwkly/hrusl if ernwkly~=-1 & hrusl>0 & w_hr==.;
	* hrusl is sometimes -1 (missing) or -4 (variable hours);
* Use actual hours if usual hours missing;
replace w_hr = ernwkly/hract if ernwkly~=-1 & hract>0 & w_hr==.;
	
* Merge with CPI data to deflate to constant dollars; 
sort mdate;
merge mdate using "cpi_monthly_clean", 
	uniqusing keep(adj_factor79) nokeep;
drop _merge;

* Generate real wages (in 1979 dollars);
gen rw_hr=w_hr/adj_factor;


*** Generate year variable ***;
gen year=year(dofm(mdate));
	* dofm converts mdate to day format, which is needed for year() fn to work;
* Month indicator;
gen month=month(dofm(mdate));

	
*** Adjust top-coded wages: multiply by 1.4 ***;

* Hourly earnings: top-coded at $99.99;
replace rw_hr=rw_hr*1.4 if ernhrly==99.99;
* Weekly earnings: top-coded at $999 before 1988;
replace rw_hr=rw_hr*1.4 if ernwkly==999 & year<=1988;
* Top-coded at $1923 ($100k/year) from 1989 to 1997;
replace rw_hr=rw_hr*1.4 if ernwkly==1923 & year>=1989 & year<=1997;
* Top-coded at $2884.61 ($150k/year) from 1998 onwards;
replace rw_hr=rw_hr*1.4 if ernwkly==2884.61 & year>=1998;

*** Trim extreme wages ***;
replace rw_hr=. if rw_hr<1 | rw_hr>100;

*** Log wages ***;
gen logrw=ln(rw_hr);


*** Generate weights that include weekly hours of work ***;
gen weight = sswgt*hrusl if hrusl>0;
replace weight = sswgt*hract if hract>0 & weight==.;

*** Generate dummies and interactions for wage regression ***;
quietly tab educ if educ>-1, gen(educ_); 

foreach num of numlist 18(1)65 {;
	gen agedums_`num'=(age==`num'); 
};
	
* Interactions of educ dummies and a quartic in age;
foreach var of varlist educ_1-educ_4 { ;
	gen `var'age = `var'*age;
	gen `var'age2 = `var'*age^2;
	gen `var'age3 = `var'*age^3;
	gen `var'age4 = `var'*age^4;
};

* Month dummies;
quietly tab month, gen (m_);

*** Generate wage residuals ***;
	* One reg per gender per year (so pooling all the monthly obs for that year);
	* Have to exclude one educ gp from the educ_age interactions to avoid multicolinearity;
gen resid=.;
foreach g of numlist 0 1 { ;
	foreach y of numlist 1994(1)2013 { ;
		reg logrw educ_2-educ_4 agedums_18-agedums_64 
			educ_2age* educ_3age* educ_4age* m_2-m_12			
			if year==`y' & sex==`g' [pweight=weight]; 
		predict resid`y'`g' if e(sample), resid;
		replace resid=resid`y'`g' if e(sample);
		drop resid`y'`g';
	};
};


*** Drop dummies and interactions ***;
drop educ_1-educ_4 agedums_* educ_*age* m_*;



*** Generate log wages and residual wages 1 month ahead ***;
sort pid mdate;
foreach var in logrw resid { ;
	by pid (mdate) : 
		gen `var'_t1=`var'[_n+1] if mdate[_n+1]==mdate+1
			& bad[_n+1]==0 & match[_n+1]==1;
	label var `var'_t1 "`var' 1 month ahead";
};

	
gen aux=1 if logrw_t1<.;
tempfile temp1;
save `temp1', replace;
	
****************************************
********* COLLAPSE TO SD'S *************
****************************************;
collapse (sd) sd=logrw_t1 (rawsum) n=aux [w=sswgt], by(occ2dig mdate);

drop if occ2dig==.; 
	* People who have missing occ in t but valid wages in t+1;
	
tab mdate if sd==.;
	* sd missing only for months where matching is not possible (1995m5-1995m8 and
	* final month in the sample);
drop if sd==.;

* log wages have s.d. pi/(theta * sqrt(6));
* solve for theta;
gen thetaest = _pi/(sd*sqrt(6));

label var thetaest "Estimate of {&theta} (lower bound)";
sum n, det;
hist thetaest if n>=100, title("Full Sample") xscale(range(1 10))
	xlabel(1(1)10) name(thetahist_full, replace);

sum thetaest if n>=100, det;

**************************************************************
*** GENERATE ESTIMATES OF THETA BASED ON RESTRICTED SAMPLE ***
**************************************************************;
*Based on std dev of log wages within common demographic groups;
use `temp1', clear;

keep if age>=25 & age<=30;

collapse (sd) sd=logrw_t1 (rawsum) n=aux [w=sswgt],
	by (occ2dig mdate sex);

drop if occ2dig==.; 
	* People who have missing occ in t but valid wages in t+1;
	
tab mdate if sd==.;

* log wages have s.d. pi/(theta * sqrt(6));
* solve for theta;
gen thetaest = _pi/(sd*sqrt(6));

label var thetaest "Estimate of {&theta}";
sum n, det;
hist thetaest if n>=15, title("Young Workers") xscale(range(1 10))
	xlabel(1(1)10) name(thetahist_young, replace);

sum thetaest if n>=15, det;

scalar theta50=r(p50);
scalar theta25=r(p25);
scalar theta75=r(p75);
scalar theta90=r(p90);
scalar theta10=r(p10);



***********************************************************
*** GENERATE ESTIMATES OF THETA BASED ON RESIDUAL WAGES ***
***********************************************************;
use `temp1', clear;
drop aux;
gen aux=1 if resid_t1<.;

collapse (sd) sd=resid_t1 (rawsum) n=aux [w=sswgt], by(occ2dig mdate);

drop if occ2dig==.; 
	* People who have missing occ in t but valid wages in t+1;

tab mdate if sd==.;
	* sd missing only for months where matching is not possible (1995m5-1995m8 and
	* final month in the sample);
drop if sd==.;

* log wages have s.d. pi/(theta * sqrt(6));
* solve for theta;
gen thetaest = _pi/(sd*sqrt(6));

label var thetaest "Estimate of {&theta} (lower bound)";
sum n, det;
hist thetaest if n>=100, title("Residual Wages") xscale(range(1 10))
	xlabel(1(1)10) name(thetahist_resid, replace);

sum thetaest if n>=100, det;

graph combine thetahist_full thetahist_resid thetahist_young;


*** GENERATE ESTIMATES YEAR BY YEAR ***;
	* Obtain median across occupation-month cells for each year;
gen year=year(dofm(mdate));
collapse (p25) p25=thetaest (median) p50=thetaest (p75) p75=thetaest, by(year);
twoway line p25 p50 p75 year;


log close;
