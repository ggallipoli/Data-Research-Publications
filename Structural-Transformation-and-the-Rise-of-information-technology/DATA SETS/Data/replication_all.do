

global empIT C:\Users\Christos\Dropbox\1Publication and Research\2016 - Structural change and IT

set scheme s1color

/*

step 0: clean the z-score index
figure 1: manufacturing employment share and tech index
figure 2: earnings and IT intensity
table 1: descriptive statistics
table 2: comparison of baseline and hecker
figure 3: validating occupation IT
figure 4: distribution of tasks
figure 5: value added per hour worked
figure 6: earnings and employment premia
figure 7: examining heterogeneity in the demand for skills
figure 8: return to IT and college/C/NR
table 3: rise of IT employment
misc: create adao estimates
table 4: comparison of elasticity estimates
figure 9: comparison of physical computer investment
figure 10: IT intensity and real value of shipments
figure 11: IT intensity and real output

*/


****************** clean the z-score index (see onet_skills_intensity for formation)


***** get the average from 2002-2016: dont include email or automation in the score
use "$giodropbox\ONET\ONet_TS_2002_2016_v3.dta",clear
saveold "$empIT\data\onet\onet_2002_2016.dta",replace
tostring soc2010,replace
gen temp1=substr(soc2010,1,2)
gen temp2=substr(soc2010,3,4)
replace soc2010=temp1+"-"+temp2
drop temp1 temp2
renvars COMP_AND_ELEC DRAFTING INT_W_COMP OPER_ANALYSIS PROGRAMMING RELEV_KNOWLEDGE SYST_EVAL TECH_DESIGN E_MAIL ENG_TECH MANAG_RES ANALYZE_DATA PROCESS_INF AUTOMATION \ comp_and_elec drafting int_w_comp op_analysis programming relev_knowledge sys_eval tech_design email eng_tech manag_res analyze_data process_inf automation
renvars z_NON_ROUT_COG_ANALYT z_NON_ROUT_COGN_INTERP z_ROUT_COGNITIVE z_ROUT_MANUAL z_NON_ROUT_MANUAL_PHYS \ nr_cog nr_noncog r_cog r_manual nr_manual
capture drop z_IT_Consolidated diff_IT
egen itscore=rowtotal(comp_and_elec drafting int_w_comp op_analysis programming relev_knowledge sys_eval tech_design eng_tech manag_res analyze_data process_inf)
*https://www.census.gov/people/eeotabulation/data/EEOCrosswalk2010DetailedOccupationsPUMSdetailedOccupations-01.09.13.pdf
**convert the 6 digit SOC codes into a harmonized measure for 2010 census codes
replace soc2010="11-10XX" if soc2010=="11-1011" | soc2010=="11-1031" // CEO and legislators
replace soc2010="11-9XXX" if soc2010=="11-9061" | soc2010=="11-9131" | soc2010=="11-9199" // misc managers
replace soc2010="15-113X" if soc2010=="15-1131" | soc2010=="15-1132" | soc2010=="15-1133" | soc2010=="15-1134"
replace soc2010="15-20XX" if soc2010=="15-2021" | soc2010=="15-2041" | soc2010=="15-2090"
replace soc2010="17-20XX" if soc2010=="17-2021" | soc2010=="17-2031" // biomedical and ag engineers
replace soc2010="17-21XX" if soc2010=="17-2151" | soc2010=="17-2171" // petrol, mining, geological engineers
replace soc2010="17-21YY" if soc2010=="17-2161" | soc2010=="17-2199" // misc engineers, including nuclear
replace soc2010="19-10XX" if soc2010=="19-1040" | soc2010=="19-1099" // medical scientists, others
replace soc2010="19-30XX" if soc2010=="19-3022" | soc2010=="19-3041" | soc2010=="19-3090"
replace soc2010="19-40XX" if soc2010=="19-4041" | soc2010=="19-4051" // geological, petrol technicians
replace soc2010="19-40YY" if soc2010=="19-4061" | soc2010=="19-4090" // misc life, physical
replace soc2010="23-10XX" if soc2010=="23-1011" | soc2010=="23-1020" // lawyers, judges
replace soc2010="25-90XX" if soc2010=="25-9011" | soc2010=="25-9021" | soc2010=="25-9031" | soc2010=="25-9099" // other education, training, library workers
replace soc2010="27-40XX" if soc2010=="27-4010" | soc2010=="27-4099" // broadcast and sound engineering
replace soc2010="29-112X" if soc2010=="29-1128" | soc2010=="29-1129" // other therapists
replace soc2010="29-11XX" if soc2010=="29-1161" | soc2010=="29-1171" // nurse practitioners
replace soc2010="31-909X" if soc2010=="31-9093" | soc2010=="31-9099" // healthcare support
replace soc2010="33-30XX" if soc2010=="33-3031" | soc2010=="33-3041" // misc law enforcement
replace soc2010="30-3050" if soc2010=="33-3051" | soc2010=="33-3052" // police officers
replace soc2010="33-909X" if soc2010=="33-9092" | soc2010=="33-9099" // lifegaurds and recreation
replace soc2010="35-90XX" if soc2010=="35-9011" | soc2010=="35-9099" // misc food prep
replace soc2010="37-201X" if soc2010=="37-2011" | soc2010=="37-2019" // janitors and building cleaners
replace soc2010="43-4XXX" if soc2010=="43-4021" | soc2010=="43-4151" // correspondence and order clerks
replace soc2010="43-9XXX" if soc2010=="43-9031" | soc2010=="43-9199" // misc office admin
replace soc2010="45-20XX" if soc2010=="45-2021" | soc2010=="45-2090" // misc agricultural workers
replace soc2010="45-3000" if soc2010=="45-3011" | soc2010=="45-3021" // fishing and hunting
replace soc2010="47-207X" if soc2010=="47-2072" | soc2010=="47-2073" // construction equipment operators
replace soc2010="47-XXXX" if soc2010=="47-2231" | soc2010=="47-4071" | soc2010=="47-4090" // misc construction workers
replace soc2010="47-50YY" if soc2010=="47-5010" | soc2010=="47-5071"
replace soc2010="47-50XX" if soc2010=="47-5061" | soc2010=="47-5081" | soc2010=="47-50XX" | soc2010=="47-5051" | soc2010=="47-5099" // misc extraction workers
replace soc2010="49-209X" if soc2010=="49-2093" | soc2010=="49-209X" | soc2010=="49-2094" | soc2010=="49-2095" // electrical repairers
replace soc2010="49-904X" if soc2010=="49-9041" | soc2010=="49-9045" // industrial and refractory machinery mechanics
replace soc2010="49-909X" if soc2010=="49-9081" | soc2010=="49-9092" | soc2010=="49-9097" | soc2010=="49-909X" | soc2010=="49-9093" | soc2010=="49-9099"
replace soc2010="51-4XXX" if soc2010=="51-4035" | soc2010=="51-4081" | soc2010=="51-4192" | soc2010=="51-4199" // misc metal workers
replace soc2010="51-606X" if soc2010=="51-6061" | soc2010=="51-6062" // textile bleaching
replace soc2010="51-609X" if soc2010=="51-6091" | soc2010=="51-6092" | soc2010=="51-6099"
replace soc2010="51-70XX" if soc2010=="51-7030" | soc2010=="51-7099" // misc woodworkers
replace soc2010="51-91XX" if soc2010=="51-9141" | soc2010=="51-9193" | soc2010=="51-9199" // other production workers
replace soc2010="53-40XX" if soc2010=="53-4041" | soc2010=="53-4099" // subway
replace soc2010="53-50XX" if soc2010=="53-5011" | soc2010=="53-5031" // sailors
replace soc2010="53-60XX" if soc2010=="53-6011" | soc2010=="53-60XX" | soc2010=="53-6041" | soc2010=="53-6099"
replace soc2010="53-70XX" if soc2010=="53-7011" | soc2010=="53-7041"
replace soc2010="53-71XX" if soc2010=="53-7111" | soc2010=="53-7121" | soc2010=="53-7199"
ren yeargr year
collapse itscore nr_cog nr_noncog r_cog r_manual nr_manual,by(soc2010 year)
save "$empIT\data\onet\onet_2002_2016_condense.dta",replace
collapse itscore nr_cog nr_noncog r_cog r_manual nr_manual,by(soc2010)
destring soc2010,replace
capture cluster drop _clus_*
set seed 1234
cluster kmedians itscore,k(2)
cluster kmeans itscore,k(2)
renvars _clus_1 _clus_2 \ it_kmed it_kmean
replace it_kmean=0 if it_kmean==2 // careful of the number ordering
replace it_kmed=0 if it_kmed==1
replace it_kmed=1 if it_kmed==2
*cluster wards itscore, name(cluster)
*cluster gen ward2=groups(2)
*bysort ward2: sum itscore
*gen highit_ward=0
*replace highit_ward=1 if ward2==1 // be careful of the ranking
*drop cluster_* ward2
sum itscore if it_kmean==1
sum itscore if it_kmean==0
sum itscore if it_kmed==1
sum itscore if it_kmed==0
save "$empIT\data\onet\onet_avg_2002_2016.dta",replace


****************** manufacturing employment share and tech index

import excel using "$empIT\data\bea and other\stlouis_emp_manuf_service.xls",clear firstrow sheet("data")
gen year=year(date)
gen month=month(date)
drop date
gen manuf_to_service=emp_manuf/emp_services
gen share_manuf=emp_manuf/emp_tot
gen share_serv=emp_services/emp_tot
save "$empIT\data\bea and other\stlouis_manuf_empshare.dta",replace
import excel using "$empIT\data\bea and other\stlouis_tech_index.xls",clear firstrow sheet("data")
gen year=year(date)
gen month=month(date)
drop date
save "$empIT\data\bea and other\stlouis_tech_index.dta",replace

use "$empIT\data\bea and other\stlouis_manuf_empshare.dta",clear
merge 1:1 month year using "$empIT\data\bea and other\stlouis_tech_index.dta"
keep if _merge==3
drop _merge
gen x=ym(year, month) // first convert a new var into year/month format
format x %tm // label it for stata to recognize sequencing

sort x
corr manuf_to_service techindex
local temp: di %3.2f r(rho)
cd "$giodropbox\graphics"
twoway (line manuf_to_service x,  clcolor(dknavy) clpattern(solid) yaxis(1) ytitle("manufacturing:services employment",axis(1))  clwidth(thick) ) ///
	(line techindex x,  clcolor(red*1.2) clpattern(dash) yaxis(2) ytitle("technology index",axis(2)) clwidth(thick) ) ///
	, xtitle("time") legend(order(1 "manufacturing to services employment" 2 "technology index")) ///
	note(Correlation between manufacturing to services employment and tech index = `temp')
graph2tex, epsfile(struct_it_motivation)


****************** figure 2: earnings and IT intensity


use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
bysort soc2010 year: gen nobs=_N
gen indid=1 if ind_manuf==1
replace indid=2 if ind_serv==1
collapse lincwage z_itscore nobs [aw=perwt],by(soc2010 indid)
gen lincwage2=lincwage^2
replace z_itscore=z_itscore/100

reg lincwage z_itscore [aw=nobs]
local eq "ln(earnings) =" // could put this instead `e(depvar)' 
local eq "`eq' `: display %7.2g _b[_cons]'"
local eq "`eq' `=cond(_b[z_itscore] > 0, "+", "-")'"
local eq "`eq' `: display %5.0g abs(_b[z_itscore])' T intensity, z-score"
graph twoway (lfitci z_itscore lincwage [aw=nobs]) (scatter z_itscore lincwage [aw=nobs], msymbol(oh)), ///
	legend(off) xtitle("IT intensity, z-score") ///
	ytitle("ln(annual earnings)") note("`eq'")	
graph export "$empIT\drafts\figs\scatter_itshare_earnings.pdf", as(pdf) replace


****************** table 1: descriptive statistics


use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
gen highit_occ=highit_mu

global sumstats famsize nchild age male married race_white race_black yrschool college tothours incwage wage_hourly ind_manuf ind_serv

quietly estpost sum $sumstats if highit_occ==1 [aw=perwt],d
est sto temp1
quietly estpost sum $sumstats if highit_occ==0 [aw=perwt],d
est sto temp2
quietly estpost sum $sumstats if highit_occ==1 & year==1970 [aw=perwt],d
est sto temp3
quietly estpost sum $sumstats if highit_occ==0 & year==1970 [aw=perwt],d
est sto temp4
quietly estpost sum $sumstats if highit_occ==1 & year==1980 [aw=perwt],d
est sto temp5
quietly estpost sum $sumstats if highit_occ==0 & year==1980 [aw=perwt],d
est sto temp6
quietly estpost sum $sumstats if highit_occ==1 & year==1990 [aw=perwt],d
est sto temp7
quietly estpost sum $sumstats if highit_occ==0 & year==1990 [aw=perwt],d
est sto temp8
quietly estpost sum $sumstats if highit_occ==1 & year==2000 [aw=perwt],d
est sto temp9
quietly estpost sum $sumstats if highit_occ==0 & year==2000 [aw=perwt],d
est sto temp10
quietly estpost sum $sumstats if highit_occ==1 & year>=2010 [aw=perwt],d
est sto temp11
quietly estpost sum $sumstats if highit_occ==0 & year>=2010 [aw=perwt],d
est sto temp12

la var famsize "family size"
la var nchild "number of children"
la var age "age"
la var male "male"
la var married "married"
la var race_white "white"
la var race_black "black"
la var yrschool "schooling"
la var college "college"
la var tothours "hours worked"
la var incwage "earnings"
la var wage_hourly "hourly wage"
la var ind_manuf "manufacturing"
la var ind_serv "services"
local digs "1 1 1 2 2 2 2 1 2 0 0 1 2 2"
cd "$empIT\drafts\tabs"
esttab temp1 temp2 temp3 temp4 temp5 temp6 temp7 temp8 temp9 temp10 temp11 temp12 using sumstats.tex, cells("mean(fmt(`digs'))") ///
	label se parentheses collabels(none) refcat(famsize "\midrule\textbf{\emph{Demographics}}" tothours "\midrule\textbf{\emph{Work}}", nolabel) ///
	mgroups("pooled" "1970s" "1980s" "1990s" "2000s" "2010-2015", pattern(1 0 1 0 1 0 1 0 1 0 1 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	mtitle("High" "Low" "High" "Low" "High" "Low" "High" "Low" "High" "Low" "High" "Low") nonum replace fragment

gen lwage_hourly=log(wage_hourly)	
set more off
reg lincwage highit_occ [aw=perwt],cluster(occ2010)
reg lincwage highit_occ college [aw=perwt],cluster(occ2010)
reg lincwage highit_occ if college==1 [aw=perwt],cluster(occ2010)
reg lincwage highit_occ if college==0 [aw=perwt],cluster(occ2010)
reg lwage_hourly highit_occ if college==1 [aw=perwt],cluster(occ2010)
reg lwage_hourly highit_occ if college==0 [aw=perwt],cluster(occ2010)
	
****************** table 2: comparison of baseline and hecker

use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
drop if indnaics==""

*https://www.bls.gov/opub/mlr/2005/07/art6full.pdf
gen hecker=0
replace hecker=1 if substr(indnaics,1,4)=="3254" // pharma and medical manuf
replace hecker=1 if substr(indnaics,1,4)=="3341" //
replace hecker=1 if substr(indnaics,1,4)=="3342" //
replace hecker=1 if substr(indnaics,1,4)=="3344" //
replace hecker=1 if substr(indnaics,1,4)=="3345" //
replace hecker=1 if substr(indnaics,1,4)=="3364" //
replace hecker=1 if substr(indnaics,1,4)=="5112" //
replace hecker=1 if substr(indnaics,1,4)=="5161" //
replace hecker=1 if substr(indnaics,1,4)=="5179" //
replace hecker=1 if substr(indnaics,1,4)=="5181" //
replace hecker=1 if substr(indnaics,1,4)=="5182" //
replace hecker=1 if substr(indnaics,1,4)=="5413" //
replace hecker=1 if substr(indnaics,1,4)=="5415" //
replace hecker=1 if substr(indnaics,1,4)=="5417" //
gen hecker_big=hecker
replace hecker_big=1 if substr(indnaics,1,4)=="2111" //
replace hecker_big=1 if substr(indnaics,1,4)=="2211" //
replace hecker_big=1 if substr(indnaics,1,4)=="3251" //
replace hecker_big=1 if substr(indnaics,1,4)=="3252" //
replace hecker_big=1 if substr(indnaics,1,4)=="3332" //
replace hecker_big=1 if substr(indnaics,1,4)=="3333" //
replace hecker_big=1 if substr(indnaics,1,4)=="3343" //
replace hecker_big=1 if substr(indnaics,1,4)=="3346" //
replace hecker_big=1 if substr(indnaics,1,4)=="4234" //
replace hecker_big=1 if substr(indnaics,1,4)=="5416" //
replace hecker_big=1 if substr(indnaics,1,4)=="3241" // tier 3
replace hecker_big=1 if substr(indnaics,1,4)=="3253"
replace hecker_big=1 if substr(indnaics,1,4)=="3255"
replace hecker_big=1 if substr(indnaics,1,4)=="3259"
replace hecker_big=1 if substr(indnaics,1,4)=="3336"
replace hecker_big=1 if substr(indnaics,1,4)=="3339"
replace hecker_big=1 if substr(indnaics,1,4)=="3353"
replace hecker_big=1 if substr(indnaics,1,4)=="3369"
replace hecker_big=1 if substr(indnaics,1,4)=="4861"
replace hecker_big=1 if substr(indnaics,1,4)=="4862"
replace hecker_big=1 if substr(indnaics,1,4)=="4869"
replace hecker_big=1 if substr(indnaics,1,4)=="5171"
replace hecker_big=1 if substr(indnaics,1,4)=="5172"
replace hecker_big=1 if substr(indnaics,1,4)=="5173"
replace hecker_big=1 if substr(indnaics,1,4)=="5174"
replace hecker_big=1 if substr(indnaics,1,4)=="5211"
replace hecker_big=1 if substr(indnaics,1,4)=="5232"
replace hecker_big=1 if substr(indnaics,1,4)=="5511"
replace hecker_big=1 if substr(indnaics,1,4)=="5612"
replace hecker_big=1 if substr(indnaics,1,4)=="8112"
egen occid=group(soc2010)
egen indid=group(indnaics)
gen ltothours=log(tothours)

global censX nchild famsize age male married race_white race_black yrschool

*earnings
reg lincwage highit_mu [aw=perwt],cluster(occid)
estadd local hasX "No",replace
est sto temp1
reg lincwage hecker_big [aw=perwt],cluster(occid)
estadd local hasX "No",replace
est sto temp2
reg lincwage highit_mu $censX [aw=perwt],cluster(indid)
estadd local hasX "Yes",replace
est sto temp3
reg lincwage hecker_big $censX [aw=perwt],cluster(indid)
estadd local hasX "Yes",replace
est sto temp4
*hours
reg ltothours highit_mu [aw=perwt],cluster(occid)
estadd local hasX "No",replace
est sto temp5
reg ltothours hecker_big [aw=perwt],cluster(occid)
estadd local hasX "No",replace
est sto temp6
reg ltothours highit_mu $censX [aw=perwt],cluster(indid)
estadd local hasX "Yes",replace
est sto temp7
reg ltothours hecker_big $censX [aw=perwt],cluster(indid)
estadd local hasX "Yes",replace
est sto temp8


la var highit_mu "IT (baseline)"
la var hecker_big "high-tech (hecker, 2005)"
cd "$empIT\drafts\tabs" 
esttab temp1 temp2 temp3 temp4 temp5 temp6 temp7 temp8 using robust_hecker.tex, b(2) replace ///
	star(* 0.10 ** 0.05 *** 0.01)  mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") nonum ///
	brackets se mgroups("ln(annual earnings)" "ln(annual hours)", pattern(1 0 0 0 1 0 0 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	label keep(highit_mu hecker_big) stats(r2 N hasX, ///
	label("R-squared" "Sample Size" "Controls") fmt(2 0)) ///
	parentheses nolz nogaps fragment nolines prehead("Dep. var. = ") 

****************** figure 3: validating occupation IT

use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
drop if indnaics==""
*toggle baseline definition
gen highit_occ=highit_ward
gen naics=substr(indnaics,1,3)
drop if naics=="22S" | naics=="31M" | naics=="3MS" | naics=="33M" | naics=="4M" | naics=="42S" | naics=="4MS" | naics=="52M" | naics=="53M" | naics=="92M"
*quietly gen notn = real(naics)==.
destring naics,replace
bysort naics: gen nobs=_N
collapse highit_occ nobs [aw=perwt],by(year naics)
egen yid=group(year)
tsset naics yid
gen dlhighit=(highit_occ-L.highit_occ)/L.highit_occ
save "$empIT\data\ipums\ipums_census_decadal_ITby_industry.dta",replace

use "$empIT\data\bea and other\capital_timeseries_all.dta",clear
ren naics2007_small naics2007
merge m:1 naics2007 year using "$empIT\data\bea and other\bea_output_valueadd_intermed.dta"
keep if _merge==3
drop _merge
gen output=exp(loutput)
gen KITtoY=cap_it/output
ren naics2007 naics
gen yrgrp=.
replace yrgrp=1970 if year>=1967 & year<=1973
replace yrgrp=1980 if year>=1977 & year<=1983
replace yrgrp=1990 if year>=1987 & year<=1993
replace yrgrp=2000 if year>=1997 & year<=2003
replace yrgrp=2009 if year>=2005 & year<=2009
replace yrgrp=2010 if year>=2010 & year<=2015
collapse cap_it KITtoY,by(naics yrgrp)
ren yrgrp year
egen yid=group(year)
merge 1:1 naics year using "$empIT\data\ipums\ipums_census_decadal_ITby_industry.dta"
keep if _merge==3
drop _merge
winsor2 highit_occ cap_it KITtoY,trim cuts(1 99) replace
tsset naics yid
gen dlcap_it=(cap_it-L.cap_it)/L.cap_it
gen dlKITtoY=(KITtoY-L.KITtoY)/L.KITtoY
gen lcap_it=log(cap_it)


corr lcap_it highit_occ 
local temp: di %3.2f r(rho)
twoway (lfitci lcap_it highit_occ [aw=nobs]) (scatter lcap_it highit_occ [aw=nobs],msymbol(oh)) ///
	, ytitle("ln(IT capital)") xtitle("IT employment share") ///
	note(correlation = `temp') legend(off)
graph export "$empIT\drafts\figs\validate_capIT_empIT.pdf", as(pdf) replace

	
****************** figure 4: distribution of tasks

use "$empIT\data\bea and other\national_all_dl.dta",clear
gen temp1=substr(soc2010,1,2)
gen temp2=substr(soc2010,4,4)
replace soc2010=temp1+temp2
destring soc2010,replace
merge m:1 soc2010 using "$empIT\data\onet\onet_skills_longdig.dta"
keep if _merge==3
drop _merge
gen highit_mu=cond(z_it_intense>0,1,0)
     
cd "$empIT\drafts\figs"
twoway (kdensity skillgrp_cognitive if highit_mu==1, lc(dknavy) clwidth(thick) clpattern(solid)) ///
	(kdensity skillgrp_cognitive if highit_mu==0, lc(red*1.2) clwidth(thick) clpattern(dash)), ///
	xtitle("index z-score") ytitle("density") subtitle("cognitive") ///
	legend(order(1 "high IT" 2 "low IT")) saving(temp1.gph,replace) 
twoway (kdensity skillgrp_manual if highit_mu==1, lc(dknavy) clwidth(thick) clpattern(solid)) ///
	(kdensity skillgrp_manual if highit_mu==0, lc(red*1.2) clwidth(thick) clpattern(dash)), ///
	xtitle("index z-score") ytitle("density") subtitle("manual") ///
	legend(order(1 "high IT" 2 "low IT")) saving(temp2.gph,replace) 
twoway (kdensity skillgrp_technical if highit_mu==1, lc(dknavy) clwidth(thick) clpattern(solid)) ///
	(kdensity skillgrp_technical if highit_mu==0, lc(red*1.2) clwidth(thick) clpattern(dash)), ///
	xtitle("index z-score") ytitle("density") subtitle("technical") ///
	legend(order(1 "high IT" 2 "low IT")) saving(temp3.gph,replace) 
twoway (kdensity skillgrp_social if highit_mu==1, lc(dknavy) clwidth(thick) clpattern(solid)) ///
	(kdensity skillgrp_social if highit_mu==0, lc(red*1.2) clwidth(thick) clpattern(dash)), ///
	xtitle("index z-score") ytitle("density") subtitle("social") ///
	legend(order(1 "high IT" 2 "low IT")) saving(temp4.gph,replace) 
twoway (kdensity skillgrp_service if highit_mu==1, lc(dknavy) clwidth(thick) clpattern(solid)) ///
	(kdensity skillgrp_service if highit_mu==0, lc(red*1.2) clwidth(thick) clpattern(dash)), ///
	xtitle("index z-score") ytitle("density") subtitle("service") ///
	legend(order(1 "high IT" 2 "low IT")) saving(temp5.gph,replace) 
twoway (kdensity skillgrp_general if highit_mu==1, lc(dknavy) clwidth(thick) clpattern(solid)) ///
	(kdensity skillgrp_general if highit_mu==0, lc(red*1.2) clwidth(thick) clpattern(dash)), ///
	xtitle("index z-score") ytitle("density") subtitle("general") ///
	legend(order(1 "high IT" 2 "low IT")) saving(temp6.gph,replace) 
grc1leg temp1.gph temp2.gph temp3.gph temp4.gph temp5.gph temp6.gph, row(3) col(3) legendfrom(temp1.gph) plotregion(color(white))
graph2tex, epsfile(kdensity_skill_high_low_it)


****************** figure 5: value added per hour worked

use "$empIT\data\bea and other\usa_wk_apr_2013_valueadd.dta",clear
merge 1:1 year naics3 using "$empIT\data\bea and other\usa_wk_apr_2013_output.dta"
keep if _merge==3
drop _merge
merge 1:1 year naics3 using "$empIT\data\bea and other\usa_wk_apr_2013_tothours.dta"
keep if _merge==3
drop _merge
merge 1:1 year naics3 using "$empIT\data\bea and other\usa_wk_apr_2013_emp.dta"
keep if _merge==3
drop _merge
merge 1:1 year naics3 using "$empIT\data\bea and other\usa_wk_apr_2013_capcomp.dta"
keep if _merge==3
drop _merge
merge m:1 year using "$empIT\data\bea and other\stlouis_gdp_deflator.dta"
keep if _merge==3
drop _merge
keep if year>=1950
replace gdpdefl=gdpdefl/100
replace valueadd=valueadd/gdpdefl
replace output=output/gdpdefl
replace capcomp=capcomp/gdpdefl
// only naics 53 does not merge in, but thats bc we have 531 and 532 already merging
// see "ipums_indclass" file
merge m:1 naics3 using "$empIT\data\ipums\ipums_census_indclass_clean_3dig.dta"
keep if _merge==3
drop _merge
quietly sum z_itscore,d
gen highit=cond(z_itscore>=0,1,0)
tostring naics3,replace
gen naics2=substr(naics3,1,2)
destring naics2,replace
gen ind_manuf=0
replace ind_manuf=1 if naics2==31 | naics2==32 | naics2==33
replace ind_manuf=1 if naics2==23
replace ind_manuf=1 if naics2==21 | naics2==11 // exclude mining and farming
gen ind_serv=0
replace ind_serv=1 if naics2==22 // exclude utilities
replace ind_serv=1 if naics2>=42 & naics2<=45 // trade
replace ind_serv=1 if naics2>=48 & naics2<=81
drop if ind_manuf==0 & ind_serv==0
gen indid=1 if ind_manuf==1
replace indid=2 if ind_serv==1
bysort naics3: egen empavg=mean(emp)
collapse (mean) output tothours emp valueadd capcomp [aw=empavg],by(indid highit year)
gen loutput=log(output)
gen YperN=output/emp
gen VperN=valueadd/emp
gen YperH=output/tothours
gen VperH=valueadd/tothours
gen lvalueadd=log(valueadd)
gen lVperH=log(VperH)
gen lVperN=log(VperN)
gen VperH_nocap=(valueadd-capcomp)/tothours
gen lVperH_nocap=log((valueadd-capcomp)/tothours)

sum VperH if highit==1 & indid==1 & year==1950
sum VperH if highit==1 & indid==1 & year==2010
sum VperH if highit==1 & indid==2 & year==1950
sum VperH if highit==1 & indid==2 & year==2010

twoway (line lVperH year if highit==1 & indid==1,lpattern(solid) lc(dknavy) clwidth(thick) ) ///
	(line lVperH year if highit==1 & indid==2,lpattern(dash) lc(dknavy) clwidth(thick) ) ///
	(line lVperH year if highit==0 & indid==1,lpattern(solid) lc(red*1.2) clwidth(thick) ) ///
	(line lVperH year if highit==0 & indid==2,lpattern(dash) lc(red*1.2) clwidth(thick) ) ///
	, legend(order( 1 "high IT, manufacturing" 2 "high IT, services" 3 "low IT, manufacturing" ///
	4 "low IT, services")) ytitle("ln(value added per hour worked)") xtitle("year") ///
	xscale(range(1950 2010)) xlabel(1950(10)2010) 
graph export "$empIT\drafts\figs\timeseries_va_perhour.pdf", as(pdf) replace


****************** figure 6: earnings and employment premia


use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
gen lwage_hourly=log(wage_hourly)
quietly reg lwage_hourly nchild famsize age male married race_white race_black i.yrschool [aw=perwt]
predict lwage_res,resid
gen emptot=1
drop if ind_manuf==0 & ind_serv==0
gen incwage_it_med=incwage if highit_med==1
gen incwage_nit_med=incwage if highit_med==0
gen lincwage_it_med=lincwage if highit_med==1
gen lincwage_nit_med=lincwage if highit_med==0
gen emp_it_med=1 if highit_med==1
gen emp_nit_med=1 if highit_med==0
gen wage_it_med=wage_hourly if highit_med==1
gen wage_nit_med=wage_hourly if highit_med==0
gen tothours_it_med=tothours if highit_med==1
gen tothours_nit_med=tothours if highit_med==0
gen lwage_res_it_med=lwage_res if highit_med==1
gen lwage_res_nit_med=lwage_res if highit_med==0
gen incwage_it_mu=incwage if highit_mu==1
gen incwage_nit_mu=incwage if highit_mu==0
gen lincwage_it_mu=lincwage if highit_mu==1
gen lincwage_nit_mu=lincwage if highit_mu==0
gen emp_it_mu=1 if highit_mu==1
gen emp_nit_mu=1 if highit_mu==0
gen wage_it_mu=wage_hourly if highit_mu==1
gen wage_nit_mu=wage_hourly if highit_mu==0
gen tothours_it_mu=tothours if highit_med==1
gen tothours_nit_mu=tothours if highit_mu==0
gen lwage_res_it_mu=lwage_res if highit_mu==1
gen lwage_res_nit_mu=lwage_res if highit_mu==0
gen indid=1 if ind_manuf==1
replace indid=2 if ind_serv==1
collapse (mean) incwage_* lincwage_* wage_* lwage_res_* (sum) emp_* emptot tothours_* [aw=perwt],by(year indid)
gen lincwage_prem_mu=lincwage_it_mu-lincwage_nit_mu
gen lincwage_after_prem_mu=log(incwage_it_mu)-log(incwage_nit_mu)
gen lincwage_prem_med=lincwage_it_med-lincwage_nit_med
gen lincwage_after_prem_med=log(incwage_it_med)-log(incwage_nit_med)
gen ltothours_prem_mu=log(tothours_it_mu)-log(tothours_nit_mu)
gen ltothours_prem_med=log(tothours_it_med)-log(tothours_nit_med)
gen lwage_prem_mu=log(wage_it_mu)-log(wage_nit_mu)
gen lwage_prem_med=log(wage_it_med)-log(wage_nit_med)
gen lwage_res_prem_mu=lwage_res_it_mu-lwage_res_nit_mu
gen lwage_res_prem_med=lwage_res_it_med-lwage_res_nit_med
gen lemp_prem_mu=log(emp_it_mu)-log(emp_nit_mu)
gen lemp_prem_med=log(emp_it_med)-log(emp_nit_med)
gen empshare_mu=emp_it_mu/emptot
gen empshare_med=emp_it_med/emptot

replace year=2015 if year==2013

label define grp 1 "manufacturing" 2 "services"
label values indid grp

*baseline
graph hbar lincwage_prem_mu, over(indid) over(year) label asyvars bar(1, color(dknavy)) bar(2, color(red*1.2)) ///
	legend(order(1 "manufacturing" 2 "services")) ytitle("earnings premia")  subtitle("Panel A: Earnings")
graph export "$empIT\drafts\figs\earn_prem_census_byind.pdf", as(pdf) replace
graph hbar lemp_prem_mu, over(indid) over(year) label asyvars bar(1, color(dknavy)) bar(2, color(red*1.2)) ///
	legend(order(1 "manufacturing" 2 "services")) ytitle("employment premia") subtitle("Panel B: Employment")
graph export "$empIT\drafts\figs\emp_prem_census_byind.pdf", as(pdf) replace



****************** figure 7: examining heterogeneity in the demand for skills

*this gets the raw differences between IT and nonIT between groups
use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
gen highCNR=cond(z_nr_cog>0,1,0)
gen highit_occ=highit_med
*if you want to look at residual earnings
*quietly reg lincwage famsize age male married race_white [aw=perwt]
*predict temp,res
*replace lincwage=temp
gen lincwage_itcoll=lincwage if highit_occ==1 & college==1
gen lincwage_coll=lincwage if college==1
gen lincwage_nocoll=lincwage if college==0
gen lincwage_itCNR=lincwage if highit_occ==1 & highCNR==1
gen lincwage_CNR=lincwage if highCNR==1
gen lincwage_nCNR=lincwage if highCNR==0
gen emp_itcoll=1 if highit_occ==1 & college==1
gen emp_coll=1 if college==1
gen emp_ncoll=1 if college==0
gen emp_itCNR=1 if highit_occ==1 & highCNR==1
gen emp_CNR=1 if highCNR==1
gen emp_nCNR=1 if highCNR==0
gen emp_tot=1
collapse (mean) lincwage_* (sum) emp_* [aw=perwt],by(year)
egen yid=group(year)
gen lincwage_collprem_it=lincwage_itcoll-lincwage_nocoll
gen lincwage_collprem_all=lincwage_coll-lincwage_nocoll
gen lincwage_CNRprem_it=lincwage_itCNR-lincwage_nCNR
gen lincwage_CNRprem_all=lincwage_CNR-lincwage_nCNR
gen emp_collprem_it=emp_itcoll/emp_tot
gen emp_collprem_all=emp_coll/emp_tot
gen emp_CNRprem_it=emp_itCNR/emp_tot
gen emp_CNRprem_all=emp_CNR/emp_tot

capture label drop grp
label define grp 1 "1970s" 2 "1980s" 3 "1990s" 4 "2000s" 5 "2005-2007" 6 "2013-2015"
label values yid grp

sum lincwage_collprem_it lincwage_collprem_all if year==1970
sum lincwage_collprem_it lincwage_collprem_all if year==1980
sum lincwage_collprem_it lincwage_collprem_all if year==1990
sum lincwage_collprem_it lincwage_collprem_all if year==2013
graph hbar lincwage_collprem_it lincwage_collprem_all, over(yid) label asyvars bar(1, color(dknavy)) bar(2, color(red*1.2)) ///
	legend(order(1 "college premium (among IT)" 2 "college premium (overall)")) ytitle("earnings premia") subtitle("panel A: examining the college premium")
graph export "$empIT\drafts\figs\collflatt_it_all_earnprem.pdf", as(pdf) replace	

sum lincwage_CNRprem_it lincwage_CNRprem_all if year==1970
sum lincwage_CNRprem_it lincwage_CNRprem_all if year==1980
sum lincwage_CNRprem_it lincwage_CNRprem_all if year==1990
sum lincwage_CNRprem_it lincwage_CNRprem_all if year==2013
graph hbar lincwage_CNRprem_it lincwage_CNRprem_all, over(yid) label asyvars bar(1, color(dknavy)) bar(2, color(red*1.2)) ///
	legend(order(1 "C/NR premium (among IT)" 2 "C/NR premium (overall)")) ytitle("earnings premia") subtitle("panel B: examining the C/NR premium")
graph export "$empIT\drafts\figs\CNRflatt_it_all_earnprem.pdf", as(pdf) replace	




****************** figure 8: return to IT and college/C/NR

*this looks at why the premia has declined by distinguishing between IT and nonIT
use "$empIT\data\ipums\ipums_census_annual_clean.dta",clear
gen highCNR=cond(z_nr_cog>0,1,0)
gen highit=highit_mu
gen lwage=log(incwage/tothours)

gen highit_coll=highit*college
gen highit_cnr=highit*highCNR
gen age2=age^2

global censX age age2 famsize race_white race_black married male

gen coef_coll=.
gen se_coll=.
gen coef_cnr=.
gen se_cnr=.

quietly forval t=2005/2016{
	reg lwage college highit highit_coll $censX if year==`t' [aw=perwt],cluster(soc2010)
	replace coef_coll=_b[highit_coll] if year==`t'
	replace se_coll=_se[highit_coll] if year==`t'
	reg lwage highit highCNR highit_cnr $censX if year==`t' [aw=perwt],cluster(soc2010)
	replace coef_cnr=_b[highit_cnr] if year==`t'
	replace se_cnr=_se[highit_cnr] if year==`t'
}

collapse coef_* se_*,by(year)
gen ub_coll=coef_coll+1.96*se_coll
gen lb_coll=coef_coll-1.96*se_coll
gen ub_cnr=coef_cnr+1.96*se_cnr
gen lb_cnr=coef_cnr-1.96*se_cnr

twoway (line coef_coll year, lpattern(solid) lc(dknavy) yaxis(1) ytitle("return to college x IT", axis(1)) clwidth(thick) ) ///
	(line coef_cnr year, lpattern(dash) lc(red*1.2) yaxis(2) ytitle("return to C/NR x IT", axis(2)) clwidth(thick) ) ///
	, legend(order( 1 "college x IT" 2 "C/NR x IT")) xtitle("year")
graph export "$empIT\drafts\figs\collflatt_itcollCNR_return.pdf", as(pdf) replace	


****************** table 3: rise of IT employment

*get IT share from 1980
use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
keep if year==1980
bysort county: gen nobs1980=_N
ren ind_manuf manuf1980
ren highit_med highit_med1980
ren college college1980
ren race_white white1980
ren male male1980
collapse highit_med1980 nobs1980 college1980 manuf1980 white1980 male1980,by(county)
save "$empIT\data\ipums\temp_itshare.dta",replace

use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
gen mshare=ind_manuf
drop if county==.
gen lwage=log(wage_hourly)
bysort county: drop if _N<2000
global ITx famsize lwage nchild age male married race_white race_black yrschool college
bysort county year: gen nobs=_N
collapse highit_med highit_cens mshare $ITx nobs [aw=perwt],by(county st year)
merge m:1 county using "$empIT\data\ipums\temp_itshare.dta"
keep if _merge==3
drop _merge
gen highit_med_coll1980=highit_med*college1980


*merge 1:1 county year using "$empIT\data\social explorer\countydec_all.dta"
global ITx lwage male race_white college

set more off
reg mshare highit_med,cluster(county)
estadd local hasX "No",replace
estadd local hascty "No",replace
estadd local hasyr "No",replace
estadd local hasiv "No",replace
est sto temp1
reg mshare highit_med $ITx,cluster(county)
estadd local hasX "Yes",replace
estadd local hascty "No",replace
estadd local hasyr "No",replace
estadd local hasiv "No",replace
est sto temp2
reghdfe mshare highit_med,a(county year) vce(cluster county)
estadd local hasX "No",replace
estadd local hascty "Yes",replace
estadd local hasyr "Yes",replace
estadd local hasiv "No",replace
est sto temp3
reghdfe mshare highit_med $ITx,a(county year) vce(cluster county)
estadd local hasX "Yes",replace
estadd local hascty "Yes",replace
estadd local hasyr "Yes",replace
estadd local hasiv "No",replace
est sto temp4
ivregress gmm mshare $ITx college1980 white1980 male1980 (highit_med=highit_med1980) if year>=1990 ,cluster(county)
estadd local hasX "Yes",replace
estadd local hascty "No",replace
estadd local hasyr "No",replace
estadd local hasiv "Yes",replace
est sto temp5



la var lwage "ln(wage)"
la var male "male"
la var race_white "white"
la var college "college"
la var highit_med "IT share"
cd "$empIT\drafts"	
esttab temp1 temp2 temp3 temp4 temp5 using manuf_share_it.tex, b(2) replace ///
	star(* 0.10 ** 0.05 *** 0.01) mtitles("(1)" "(2)" "(3)" "(4)" "(5)") nonum ///
	brackets se mgroups("manufacturing employment share", pattern(1 0 0 0 0) ///
	prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	label keep(highit_med lwage male race_white college) stats (r2 N hasX hascty hasyr hasiv, label("R-squared" "Sample Size" "Controls" "County FE" "Year FE" "Instrument?") fmt(2 0 1)) ///
	parentheses nolz nogaps fragment nolines prehead("Dep. var. = ") eqlabel(none) 

****************** misc: create adao estimates


*** construct the indices (pie = 100 quantiles per group)
use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
drop if year==2005
drop if wage_hourly==.

*restrict the sample to manufacturing, services, and non-missing IT
gen indid=1 if ind_manuf==1
replace indid=2 if ind_serv==1
drop if ind_manuf==0 & ind_serv==0

global forgrp college 

*define the benchmark IT measure
gen highit_occ=highit_mu

*construct the group (coll x ind) and region indices; restrict to big enough cells
egen grp=group($forgrp)
egen reg=group(st)
bysort grp reg year: drop if _N<1500
egen uid=group(grp reg year)
sort uid wage_hourly // this is important to sort first

*create the weighted quantiles, controls, and wage info
by uid: egen sumwgt=sum(perwt) // fast pctiles: http://www.nber.org/stata/efficient/percentiles.html
by uid: gen rsum=sum(perwt)
by uid: gen pie=int(100*rsum/sumwgt)
gen age_20_30=cond(age>=20 & age<30,1,0)
gen age_30_40=cond(age>=30 & age<40,1,0)
gen age_40_50=cond(age>=40 & age<50,1,0)
gen age_50pl=cond(age>=50,1,0)
bysort uid pie: gen nobs=_N
gen wage_hourly_itm=wage_hourly if highit_occ==1 & ind_manuf==1
gen wage_hourly_nitm=wage_hourly if highit_occ==0 & ind_manuf==1
gen wage_hourly_its=wage_hourly if highit_occ==1 & ind_serv==1
gen wage_hourly_nits=wage_hourly if highit_occ==0 & ind_serv==1
gen tothours_itm=tothours if highit_occ==1 & ind_manuf==1
gen tothours_nitm=tothours if highit_occ==0 & ind_manuf==1
gen tothours_its=tothours if highit_occ==1 & ind_serv==1
gen tothours_nits=tothours if highit_occ==0 & ind_serv==1

collapse (mean) nobs wage_hourly* highit_occ ind_manuf male married race_white age* (sum) tothours* ///
	[aw=perwt],by(grp pie reg college st year uid)
gen lowit=1-highit_occ
*save "$empIT\data\ipums\ipums_census_clean_pctiles.dta",replace
save "$empIT\data\ipums\ipums_census_clean_pctiles_median.dta",replace
*saveold "$giodropbox\ipums\ipums_census_clean_pctiles.dta",replace version(12)

*** get initial shares from 1980
use "$empIT\data\ipums\ipums_census_clean_pctiles.dta",clear
keep if year==1980
ren lowit lowit1980
ren ind_manuf ind_manuf1980
drop wage_hourly
keep grp reg pie lowit1980 ind_manuf1980
drop if lowit1980<=0.03 | lowit1980>=0.97 | ind_manuf1980<=0.03 | ind_manuf1980>0.97
save "$empIT\data\ipums\ipums_census_clean_pctiles1980.dta",replace
*save "$empIT\data\ipums\ipums_census_clean_pctiles1980_median.dta",replace
*saveold "$giodropbox\ipums\ipums_census_clean_pctiles1980.dta",replace version(12)

*** now run
use "$empIT\data\ipums\ipums_census_clean_pctiles.dta",clear
egen uid2=group(grp pie reg)
egen yid=group(year)
tsset uid2 yid

gen dlwage_hourly=(wage_hourly-L.wage_hourly)/L.wage_hourly
gen dltothours_itm=(tothours_itm-L.tothours_itm)/L.tothours_itm
gen dltothours_nitm=(tothours_nitm-L.tothours_nitm)/L.tothours_nitm
gen dltothours_its=(tothours_its-L.tothours_its)/L.tothours_its
gen dltothours_nits=(tothours_nits-L.tothours_nits)/L.tothours_nits
gen dlwage_hourly_itm=(wage_hourly_itm-L.wage_hourly_itm)/L.wage_hourly_itm
gen dlwage_hourly_nitm=(wage_hourly_nitm-L.wage_hourly_nitm)/L.wage_hourly_nitm
gen dlwage_hourly_its=(wage_hourly_its-L.wage_hourly_its)/L.wage_hourly_its
gen dlwage_hourly_nits=(wage_hourly_nits-L.wage_hourly_nits)/L.wage_hourly_nits
*drop if part of the group is missing in the prior year
local todrop "dltothours_itm dltothours_nitm dltothours_its dltothours_nits dlwage_hourly_itm dlwage_hourly_nitm dlwage_hourly_its dlwage_hourly_nits"
quietly foreach var in `todrop'{
	drop if `var'==-1
}
****
winsor2 dltothours* dlwage_hourly*,replace trim cuts(1 99)
drop if year==1980 // this is the baseline year
drop if dlwage_hourly==.
merge m:1 grp reg pie using "$empIT\data\ipums\ipums_census_clean_pctiles1980.dta"
keep if _merge==3
drop _merge
merge m:1 st using "$empIT\data\social explorer\state1980.dta"
keep if _merge==3
drop _merge
drop if pie>95 | pie<5 // restrict to 6th-95th quantiles (p 28 of his paper)
*****
egen nid=group(uid) // (updated group on g,r,t)
drop uid uid2
gen waged2=cond(pie>=40 & pie<=60,1,0)
gen waged3=cond(pie>70,1,0)
******
gen lowitm1980=lowit1980*ind_manuf1980
gen lowits1980=lowit1980*(1-ind_manuf1980)
gen highitm1980=(1-lowit1980)*ind_manuf1980
gen highits1980=(1-lowit1980)*(1-ind_manuf1980)

global adaoX male married race_white waged2 waged3 age_30_40 age_30_40 age_50pl

*preset if only doing one equation
gen d1=.
gen d2=.
gen d3=.
gen d4=.
*preset if using four equations
gen b1=.
gen b2=.
gen b3=.
gen b4=.
gen c1=.
gen c2=.
gen c3=.
gen c4=.
*preset the pvalue cells
gen pvb1=.
gen pvb2=.
gen pvb3=.
gen pvb4=.
gen pvc1=.
gen pvc2=.
gen pvc3=.
gen pvc4=.
gen pvd1=.
gen pvd2=.
gen pvd3=.
gen pvd4=.

*unweighted
quietly sum nid,d
forval i=1/`r(max)'{
    ***one equation***
	capture quietly reg dlwage_hourly lowitm1980 lowits1980 highitm1980 $adaoX if nid==`i'
	capture quietly replace d1=_b[_cons] if nid==`i'
	capture quietly replace d2=_b[lowitm1980] if nid==`i'
	capture quietly replace d3=_b[lowits1980] if nid==`i'
	capture quietly replace d4=_b[highitm1980] if nid==`i'
    capture local t1=_b[lowitm1980]/_se[lowitm1980]
	capture quietly replace pvd1=2*ttail(e(df_r),abs(`t1')) if nid==`i'
	capture local t2=_b[lowits1980]/_se[lowits1980]
	capture quietly replace pvd2=2*ttail(e(df_r),abs(`t2')) if nid==`i'
    capture local t3=_b[highitm1980]/_se[highitm1980]
	capture quietly replace pvd3=2*ttail(e(df_r),abs(`t3')) if nid==`i'
	capture local t4=_b[_cons]/_se[_cons]
	capture quietly replace pvd4=2*ttail(e(df_r),abs(`t4')) if nid==`i' 
	*******four equations*******
	capture quietly reg dlwage_hourly lowitm1980 $adaoX if nid==`i'
	capture quietly replace c1=_b[_cons] if nid==`i'
	capture quietly replace b1=_b[lowitm1980] if nid==`i'
	capture local t1=_b[lowitm1980]/_se[lowitm1980]
	capture quietly replace pvb1=2*ttail(e(df_r),abs(`t1')) if nid==`i' 
	capture local t2=_b[_cons]/_se[_cons]
	capture quietly replace pvc1=2*ttail(e(df_r),abs(`t2')) if nid==`i' 
	*
	capture quietly reg dlwage_hourly lowits1980 $adaoX if nid==`i'
	capture quietly replace c2=_b[_cons] if nid==`i'
	capture quietly replace b2=_b[lowits1980] if nid==`i'
	capture local t1=_b[lowits1980]/_se[lowits1980]
	capture quietly replace pvb2=2*ttail(e(df_r),abs(`t1')) if nid==`i' 
	capture local t2=_b[_cons]/_se[_cons]
	capture quietly replace pvc2=2*ttail(e(df_r),abs(`t2')) if nid==`i' 
	*
	capture quietly reg dlwage_hourly highitm1980 $adaoX if nid==`i'
	capture quietly replace c3=_b[_cons] if nid==`i'
	capture quietly replace b3=_b[highitm1980] if nid==`i'
	capture local t1=_b[highitm1980]/_se[highitm1980]
	capture quietly replace pvb3=2*ttail(e(df_r),abs(`t1')) if nid==`i' 
    capture local t2=_b[_cons]/_se[_cons]
	capture quietly replace pvc3=2*ttail(e(df_r),abs(`t2')) if nid==`i'
	*
	capture quietly reg dlwage_hourly highits1980 $adaoX if nid==`i'
	capture quietly replace c4=_b[_cons] if nid==`i'
	capture quietly replace b4=_b[highits1980] if nid==`i'
	capture local t1=_b[highits1980]/_se[highits1980]
	capture quietly replace pvb4=2*ttail(e(df_r),abs(`t1')) if nid==`i' 
	capture local t2=_b[_cons]/_se[_cons]
	capture quietly replace pvc4=2*ttail(e(df_r),abs(`t2')) if nid==`i' 
}

*one equation
gen dlomegaNITM1=d2-d1
gen dlomegaITM1=d4-d1
gen dlomegaNITS1=d3-d1
gen dlomegaITS1=d1
*four equations
gen dlomegaNITM=b1+c1
gen dlomegaNITS=b2+c2
gen dlomegaITM=b3+c3
gen dlomegaITS=b4+c4
sum dlomega* pv* [aw=nobs]


gen dlcompITM= [(1 + dlwage_hourly_itm)/exp(dlomegaITM)] - 1 // dlwage_hourly_itm - dlomegaITM
gen dlcompITS= [(1 + dlwage_hourly_its)/exp(dlomegaITS)] - 1 // dlwage_hourly_its - dlomegaITS
gen dlcompNITM= [(1 + dlwage_hourly_its)/exp(dlomegaNITM)] - 1 // dlwage_hourly_nitm - dlomegaNITM
gen dlcompNITS= [(1 + dlwage_hourly_nits)/exp(dlomegaNITS)] - 1 // dlwage_hourly_nits - dlomegaNITS
drop d1-pvd4

winsor2 dlomega* dlcomp*,replace cuts(1 99) trim

gen state=""
replace state="AL" if st==1
replace state="AK" if st==2
replace state="AZ" if st==4
replace state="AR" if st==5
replace state="CA" if st==6
replace state="CO" if st==8
replace state="CT" if st==9
replace state="DE" if st==10
replace state="DC" if st==11
replace state="FL" if st==12
replace state="GA" if st==13
replace state="HI" if st==15
replace state="ID" if st==16
replace state="IL" if st==17
replace state="IN" if st==18
replace state="IA" if st==19
replace state="KS" if st==20
replace state="KY" if st==21
replace state="LA" if st==22
replace state="ME" if st==23
replace state="MD" if st==24
replace state="MA" if st==25
replace state="MI" if st==26
replace state="MN" if st==27
replace state="MS" if st==28
replace state="MO" if st==29
replace state="MT" if st==30
replace state="NE" if st==31
replace state="NV" if st==32
replace state="NH" if st==33
replace state="NJ" if st==34
replace state="NM" if st==35
replace state="NY" if st==36
replace state="NC" if st==37
replace state="ND" if st==38
replace state="OH" if st==39
replace state="OK" if st==40
replace state="OR" if st==41
replace state="PA" if st==42
replace state="RI" if st==44
replace state="SC" if st==45
replace state="SD" if st==46
replace state="TN" if st==47
replace state="TX" if st==48
replace state="UT" if st==49
replace state="VT" if st==50
replace state="VA" if st==51
replace state="WA" if st==53
replace state="WV" if st==54
replace state="WI" if st==55
replace state="WY" if st==56

saveold "$empIT\data\ipums\ipums_census_clean_pctiles_adao.dta",replace version(12)


****************** table 4: comparison of elasticity estimates

*see "replicate_elasticities" file


****************** figure 9: comparison of physical computer investment

*put CPS measure in year groups
use "$empIT\data\ipums\ipums_cps_annual_clean.dta",clear
bysort ind1990: gen nobs_ind=_N
global cpsX nchild age male race_white married lincwage yrschool college
gen yrgrp=.
replace yrgrp=1977 if year>=1975 & year<1980
replace yrgrp=1982 if year>=1980 & year<1985
replace yrgrp=1987 if year>=1985 & year<1990
replace yrgrp=1992 if year>=1990 & year<1995
replace yrgrp=2002 if year>=1998 & year<2004
replace yrgrp=2007 if year>=2005 & year<=2007
drop if yrgrp==.
collapse z_itscore highit_mu highit_med $cpsX nobs [aw=wtsupp],by(ind1990 yrgrp)
ren yrgrp year
save "$empIT\data\ipums\ipums_cps_annual_clean_aadhp_compare.dta",replace

*put output data in year groups
use "$empIT\data\AADHP data\nberces90_clean.dta",clear
gen yrgrp=.
replace yrgrp=1977 if year>=1975 & year<1980
replace yrgrp=1982 if year>=1980 & year<1985
replace yrgrp=1987 if year>=1985 & year<1990
replace yrgrp=1992 if year>=1990 & year<1995
replace yrgrp=2002 if year>=1998 & year<2004
replace yrgrp=2007 if year>=2005 & year<=2007
drop if yrgrp==.
collapse real_pay real_vship,by(ind1990 yrgrp)
ren yrgrp year
gen lreal_vship=log(real_vship)
gen lreal_pay=log(real_pay)
save "$empIT\data\AADHP data\nberces90_clean_yrgrp.dta",replace

**now put together
use "$empIT\data\AADHP data\ci_measures_90_mds_ind1990.dta",clear
keep ci1977_s ci1982_s ci1987_s ci1992_s ci2002_s ci2007_s ind1990
renvars ci1977_s ci1982_s ci1987_s ci1992_s ci2002_s ci2007_s \ ci1977 ci1982 ci1987 ci1992 ci2002 ci2007
reshape long ci, i(ind1990) j(year)
merge 1:1 ind1990 year using "$empIT\data\ipums\ipums_cps_annual_clean_aadhp_compare.dta"
keep if _merge==3
drop _merge
merge 1:1 ind1990 year using "$empIT\data\AADHP data\nberces90_clean_yrgrp.dta"
keep if _merge==3
drop _merge

gen highit=highit_mu

*correlate
corr ci highit_mu [aw=nobs]
corr ci highit_med [aw=nobs]

*compare
reg ci highit_mu [aw=nobs],cluster(ind1990)
reg ci highit_med [aw=nobs],cluster(ind1990)

reg ci highit_mu [aw=nobs],cluster(ind1990)
local temp1: di %3.2f _b[highit]
corr ci highit_mu [aw=nobs]
local temp2: di %3.2f `r(rho)'
twoway (lfitci ci highit  [aw=nobs]) (scatter ci highit  [aw=nobs],msymbol(oh))  ///
	, xtitle("employment share in IT") ytitle("computer investment, z-score") legend(off) ///
	note(gradient on IT employment share = `temp1' and correlation = `temp2')
graph export "$empIT\drafts\figs\aadhp_ITmeasure_compare.pdf", as(pdf) replace


****************** figure 10: IT intensity and real value of shipments

use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
gen z_itscore80=z_itscore if year==1980
ren z_itscore z_itscoreall
bysort ind1990: gen nobs_ind=_N
global cpsX nchild age male race_white married lincwage yrschool college
collapse z_itscore* highit_mu highit_med $cpsX nobs [aw=perwt],by(ind1990)
merge 1:m ind1990 using "$empIT\data\AADHP data\nberces90_clean.dta"
keep if _merge==3
drop _merge
merge m:1 ind1990 using "$empIT\data\AADHP data\ci_measures_90_mds_ind1990.dta"
keep if _merge==3
drop _merge
save "$empIT\data\AADHP data\ci_onet_clean.dta",replace


use "$empIT\data\AADHP data\ci_onet_clean.dta",clear
keep if year>=1980
drop if comp_medium==1
ren cimean_s z_cimeanall
replace z_itscoreall=z_itscoreall/100
replace z_itscore80=z_itscore80/100
gen lreal_vship=log(real_vship)
gen lreal_pay=log(real_pay)
tab year, gen(ydum)
center cimean,prefix(z_)
replace z_itscoreall=highit_mu
*replace z_cimeanall=z_cimean
*replace z_cimeanall=ci_per_invest_1977
quietly forval t=2/30{
	gen z_cimeanall_ydum`t'=z_cimeanall*ydum`t'
	gen z_itscoreall_ydum`t'=z_itscoreall*ydum`t'
}

global cpsX nchild age male race_white married college

*ci_per_emp_1977 ci_per_emp_1982 ci_per_emp_1987 ci_per_emp_1992
gen coef_ci_ship=.
gen coef_ci_pay=.
gen coef_onet_ship=.
gen coef_onet_pay=.
gen se_ci_ship=.
gen se_ci_pay=.
gen se_onet_ship=.
gen se_onet_pay=.

set more off
reg lreal_vship i.ind1990  ydum2-ydum30 z_cimeanall_ydum* [aw=wt], cluster(ind1990)
quietly forval t=2/30{
	replace coef_ci_ship=_b[z_cimeanall_ydum`t'] if ydum`t'==1
	replace se_ci_ship=_se[z_cimeanall_ydum`t'] if ydum`t'==1
}
set more off
reg lreal_pay i.ind1990  ydum2-ydum30 z_cimeanall_ydum* [aw=wt], cluster(ind1990)
quietly forval t=2/30{
	replace coef_ci_pay=_b[z_cimeanall_ydum`t'] if ydum`t'==1
	replace se_ci_pay=_se[z_cimeanall_ydum`t'] if ydum`t'==1
}
set more off
reg lreal_vship i.ind1990  ydum2-ydum30 z_itscoreall_ydum* [aw=wt], cluster(ind1990)
quietly forval t=2/30{
	replace coef_onet_ship=_b[z_itscoreall_ydum`t'] if ydum`t'==1
	replace se_onet_ship=_se[z_itscoreall_ydum`t'] if ydum`t'==1
}
set more off
reg lreal_pay i.ind1990  ydum2-ydum30 z_itscoreall_ydum* [aw=wt], cluster(ind1990)
quietly forval t=2/30{
	replace coef_onet_pay=_b[z_itscoreall_ydum`t'] if ydum`t'==1
	replace se_onet_pay=_se[z_itscoreall_ydum`t'] if ydum`t'==1
}
collapse coef_* se_*,by(year)
gen ub_ci_ship=coef_ci_ship+1.96*se_ci_ship
gen lb_ci_ship=coef_ci_ship-1.96*se_ci_ship
gen ub_onet_ship=coef_onet_ship+1.96*se_onet_ship
gen lb_onet_ship=coef_onet_ship-1.96*se_onet_ship
gen ub_ci_pay=coef_ci_pay+1.96*se_ci_pay
gen lb_ci_pay=coef_ci_pay-1.96*se_ci_pay
gen ub_onet_pay=coef_onet_pay+1.96*se_onet_pay
gen lb_onet_pay=coef_onet_pay-1.96*se_onet_pay

twoway (line coef_ci_ship year, lc(dknavy) clpattern(dash_dot) yaxis(1) ytitle("AADHP measure", axis(1)) clwidth(thick) ) ///
	(line ub_ci_ship year, lc(dknavy) clpattern(shortdash) yaxis(1) ytitle("AADHP measure", axis(1)) clwidth(medthin) ) ///
	(line lb_ci_ship year, lc(dknavy) clpattern(shortdash) yaxis(1) ytitle("AADHP measure", axis(1)) clwidth(medthin) ) ///
	(line ub_onet_ship year, lc(red*1.2) clpattern(shortdash) yaxis(2) ytitle("ONET measure", axis(2)) clwidth(medthin) ) ///
	(line lb_onet_ship year, lc(red*1.2) clpattern(shortdash) yaxis(2) ytitle("ONET measure", axis(2)) clwidth(medthin) ) ///
	(line coef_onet_ship year, lc(red*1.2) clpattern(solid) yaxis(2) ytitle("ONET measure", axis(2)) clwidth(thick) ) ///
	, xtitle("year") legend(order(1 "AADHP measure" 6 "ONET measure"))
graph export "$empIT\drafts\figs\aadhp_shipment_compare.pdf", as(pdf) replace


****************** figure 11: IT intensity and real output


use "$empIT\data\ipums\ipums_cps_annual_clean.dta",clear
keep if year>=1970
drop if naics3==.
bysort naics3 year: gen nobs_ind=_N
global cpsX nchild age male race_white married lincwage yrschool college
collapse z_itscore highit_med highit_mu $cpsX nobs [aw=wtsupp],by(naics3)
merge 1:m naics3  using "$empIT\data\bea and other\bea_all_1947_2016.dta"
keep if _merge==3
drop _merge
merge m:1 naics3 using "$empIT\data\bea and other\bea_emp_post1998_yravg.dta"
keep if _merge==3
drop _merge
keep if year>=1970
gen lvalueadd=log(valueadd)
gen loutput=log(output)

*set baseline IT measure
replace highit_med=highit_mu

tab year,gen(ydum)
quietly forval t=2/47{
	gen highit_med_ydum`t'=highit_med*ydum`t'
}
tostring naics3,replace
gen naics2=substr(naics3,1,2)
destring naics3 naics2,replace
gen ind_manuf=0
replace ind_manuf=1 if naics3>=321 & naics3<=326
replace ind_manuf=1 if naics3==23
gen ind_serv=0
replace ind_serv=1 if naics3==22 // utilities
replace ind_serv=1 if naics3==42 | naics3==441 | naics3==445 | naics3==452 // trade
replace ind_serv=1 if naics3>=481 & naics3<=722
replace ind_serv=1 if naics3==81 // other services
gen highskill=0
replace highskill=1 if naics2==51 | naics2==52 | naics2==54

global cpsX nchild age male race_white married college


gen coef_its_m_va=.
gen se_its_m_va=.
gen coef_its_hs_va=.
gen se_its_hs_va=.
gen coef_its_ls_va=.
gen se_its_ls_va=.
gen coef_its_s_va=.
gen se_its_s_va=.


*+_b[highit_med]
set more off
reg loutput i.naics3 $cpsX  ydum2-ydum47 highit_med_ydum* if ind_manuf==1 [aw=emp], cluster(naics3)
quietly forval t=2/47{
	replace coef_its_m_va=_b[highit_med_ydum`t'] if ydum`t'==1
	replace se_its_m_va=_se[highit_med_ydum`t'] if ydum`t'==1
}
set more off
reg loutput i.naics3 $cpsX  ydum2-ydum47 highit_med_ydum* if ind_serv==1 [aw=emp], cluster(naics3)
quietly forval t=2/47{
	replace coef_its_s_va=_b[highit_med_ydum`t'] if ydum`t'==1
	replace se_its_s_va=_se[highit_med_ydum`t'] if ydum`t'==1
}
set more off
reg loutput $cpsX i.naics3 ydum2-ydum47 highit_med_ydum* if ind_serv==1 & highskill==1 [aw=emp], cluster(naics3)
quietly forval t=2/47{
	replace coef_its_hs_va=_b[highit_med_ydum`t'] if ydum`t'==1
	replace se_its_hs_va=_se[highit_med_ydum`t'] if ydum`t'==1
}
set more off
reg loutput $cpsX i.naics3 ydum2-ydum47 highit_med_ydum* if ind_serv==1 & highskill==0 [aw=emp], cluster(naics3)
quietly forval t=2/47{
	replace coef_its_ls_va=_b[highit_med_ydum`t'] if ydum`t'==1
	replace se_its_ls_va=_se[highit_med_ydum`t'] if ydum`t'==1
}


collapse coef_* se_*,by(year ind_manuf ind_serv)
gen ub_its_m_va=coef_its_m_va+1.96*se_its_m_va
gen lb_its_m_va=coef_its_m_va-1.96*se_its_m_va
gen ub_its_s_va=coef_its_s_va+1.96*se_its_s_va
gen lb_its_s_va=coef_its_s_va-1.96*se_its_s_va
gen ub_its_hs_va=coef_its_hs_va+1.96*se_its_hs_va
gen lb_its_hs_va=coef_its_hs_va-1.96*se_its_hs_va
gen ub_its_ls_va=coef_its_ls_va+1.96*se_its_ls_va
gen lb_its_ls_va=coef_its_ls_va-1.96*se_its_ls_va

twoway (line coef_its_m_va year if ind_manuf==1, lc(dknavy) clpattern(dash_dot) yaxis(1) ytitle("manufacturing", axis(1)) clwidth(thick) ) ///
	(line ub_its_m_va year if ind_manuf==1, lc(dknavy) clpattern(shortdash) yaxis(1) ytitle("manufacturing", axis(1)) clwidth(medthin) ) ///
	(line lb_its_m_va year if ind_manuf==1, lc(dknavy) clpattern(shortdash) yaxis(1) ytitle("manufacturing", axis(1)) clwidth(medthin) ) ///
	(line ub_its_s_va year if ind_serv==1, lc(red*1.2) clpattern(shortdash) yaxis(2) ytitle("services", axis(2)) clwidth(medthin) ) ///
	(line lb_its_s_va year if ind_serv==1, lc(red*1.2) clpattern(shortdash) yaxis(2) ytitle("services", axis(2)) clwidth(medthin) ) ///
	(line coef_its_s_va year if ind_serv==1, lc(red*1.2) clpattern(solid) yaxis(2) ytitle("services", axis(2)) clwidth(thick) ) ///
	, xtitle("year") legend(order(1 "manufacturing" 6 "services")) xscale(range(1970 2016)) xlabel(1970(5)2016)
graph export "$empIT\drafts\figs\solow_manuf_serv_productivity.pdf", as(pdf) replace


