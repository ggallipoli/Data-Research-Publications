

/**************

this file replicates the elasticity of substitution for the two sectors

0. form the instruments
1. this part uses reg3
2. this part uses ivregress


**************/

*------------------------------------ form the instruments at state x college


use "$empIT\data\ipums\ipums_census_clean_pctiles.dta",clear
keep if year==1980 | year==1990
collapse (sum) nobs,by(college st year)
egen uid=group(college st)
egen tid=group(year)
tsset uid tid
gen dlnobsIV=(nobs-L.nobs)/L.nobs
drop if dlnobsIV==.
keep college st dlnobsIV
save "$empIT\data\ipums\iv_adao1.dta",replace

use "$empIT\data\ipums\ipums_census_decadal_clean.dta",clear
keep if year==1970 | year==1980 | year==1990
gen itshare1980=highit_med if year==1980
gen itshare1970=highit_med if year==1970
gen nobs=1
collapse (mean) highit_med itshare1970 itshare1980 (sum) tothours nobs,by(college st year)
egen uid=group(college st)
egen tid=group(year)
tsset uid tid
gen dlnobsIV7080=(nobs-L.nobs)/L.nobs if year<1990
gen dlnobsIV8090=(nobs-L.nobs)/L.nobs if year>1970
gen dltothours8090=(tothours-L.tothours)/L.tothours
gen dlhighitIV7080=(highit_med-L.highit_med)/L.highit_med if year<1990
gen dlhighitIV8090=(highit_med-L.highit_med)/L.highit_med if year>1970
collapse dlhighitIV* itshare1980 itshare1970 dltothours8090 dlnobsIV*,by(college st)
save "$empIT\data\ipums\iv_adao2.dta",replace

*get 1980 weights
use "$empIT\data\ipums\ipums_census_clean_pctiles.dta",clear
keep if year==1980
ren nobs nobs1980
collapse nobs1980,by(college st)
save "$empIT\data\ipums\weights1980.dta",replace


*------------------------------------ use reg3 to estimate



use "$empIT\data\ipums\ipums_census_clean_pctiles_adao.dta",clear
global adaoX male married race_white age_30_40 age_40_50 age_50pl waged2 waged3
gen dlomegaITMprem=dlomegaITM-dlomegaNITM
gen dlomegaITSprem=dlomegaITS-dlomegaNITS
gen dlH_Mprem=(dltothours_itm+dlcompITM)-(dltothours_nitm+dlcompNITM)
gen dlH_Sprem=(dltothours_its+dlcompITS)-(dltothours_nits+dlcompNITS)
collapse (mean) dlomegaITMprem dlomegaITSprem dlH_Mprem dlH_Sprem dlcompITM dlcompNITM dlcompITS dlcompNITS ///
	dltothours_itm dltothours_nitm dltothours_its dltothours_nits $adaoX (sum) nobs [aw=nobs],by(college st year)
egen uid=group(college st)
reshape wide dlomegaITMprem dlomegaITSprem dlH_Mprem dlH_Sprem dlcompITM dlcompNITM dlcompITS dlcompNITS ///
	dltothours_itm dltothours_nitm dltothours_its dltothours_nits nobs $adaoX, i(uid college st) j(year)
merge m:1 st using "$empIT\data\social explorer\state1980.dta"
keep if _merge==3
drop _merge
merge 1:1 st college using "$empIT\data\ipums\weights1980.dta"
keep if _merge==3
drop _merge
merge m:1 st college using "$empIT\data\ipums\iv_adao2.dta"
keep if _merge==3
drop _merge
gen dlH_Sprem1990_coll=dlH_Sprem1990*college
gen dlH_Sprem2000_coll=dlH_Sprem2000*college
gen dlH_Sprem2013_coll=dlH_Sprem2013*college
gen dlH_Mprem1990_coll=dlH_Mprem1990*college
gen dlH_Mprem2000_coll=dlH_Mprem2000*college
gen dlH_Mprem2013_coll=dlH_Mprem2013*college

global adaoX1 male1990 married1990 race_white1990 age_30_401990 age_40_501990 age_50pl1990 waged21990 waged31990
global adaoX2 male2000 married2000 race_white2000 age_30_402000 age_40_502000 age_50pl2000 waged22000 waged32000
global adaoX3 male2013 married2013 race_white2013 age_30_402013 age_40_502013 age_50pl2013 waged22013 waged32013

*choose IV to be historical
global IVs itshare1970 dlhighitIV7080 

*pooled estimates
*coef = nu - 1, so nu = coef+1, thus elasticity = 1/(1-nu) = 1/-coef

************ MANUFACTURING
constr def 1 [first]dlH_Mprem1990=[second]dlH_Mprem2000
constr def 2 [first]dlH_Mprem1990=[third]dlH_Mprem2013
constr def 3 [first]_cons=[second]_cons
constr def 4 [first]_cons=[third]_cons

*IV
global stage1 "(first: dlomegaITMprem1990 dlH_Mprem1990 $adaoX1)"
global stage2 "(second: dlomegaITMprem2000 dlH_Mprem2000 $adaoX2)"
global stage3 "(third: dlomegaITMprem2013 dlH_Mprem2013 $adaoX3)"
global stage4 "(fourth: dlomegaITMprem1990 $IVs $adaoX1)"
global stage5 "(fifth: dlomegaITMprem2000 $IVs $adaoX2)"
global stage6 "(sixth: dlH_Mprem2013 $IVs $adaoX3)"
reg3 $stage1 $stage2 $stage3 $stage4 $stage5 $stage6 [aw=nobs1980],constr(1 2 3 4) 2sls endog(dlomegaITMprem1990 dlomegaITMprem2000 dlomegaITMprem2013)
nlcom 1/(-_b[dlH_Mprem1990])

*OLS (baseline)
global stage1 "(first: dlomegaITMprem1990 dlH_Mprem1990 $adaoX1)"
global stage2 "(second: dlomegaITMprem2000 dlH_Mprem2000 $adaoX2)"
global stage3 "(third: dlomegaITMprem2013 dlH_Mprem2013 $adaoX3)"
reg3 $stage1 $stage2 $stage3 [aw=nobs1980],constr(1 2 3 4) 3sls
nlcom 1/(-_b[dlH_Mprem1990])


************ SERVICES
constr def 1 [first]dlH_Sprem1990=[second]dlH_Sprem2000
constr def 2 [first]dlH_Sprem1990=[third]dlH_Sprem2013
constr def 3 [first]_cons=[second]_cons
constr def 4 [first]_cons=[third]_cons

*IV
global stage1 "(first: dlomegaITSprem1990 dlH_Sprem1990 $adaoX1)"
global stage2 "(second: dlomegaITSprem2000 dlH_Sprem2000 $adaoX2)"
global stage3 "(third: dlomegaITSprem2013 dlH_Sprem2013 $adaoX3)"
global stage4 "(fourth: dlomegaITSprem1990 $IVs $adaoX1)"
global stage5 "(fifth: dlomegaITSprem2000 $IVs $adaoX2)"
global stage6 "(sixth: dlomegaITSprem2013 $IVs $adaoX3)"
reg3 $stage1 $stage2 $stage3 $stage4 $stage5 $stage6 [aw=nobs1980],constr(1 2 3 4) 2sls endog(dlomegaITMprem1990 dlomegaITMprem2000 dlomegaITMprem2013)
nlcom 1/(-_b[dlH_Sprem1990])


*OLS (baseline)
global stage1 "(first: dlomegaITSprem1990 dlH_Sprem1990 $adaoX1)"
global stage2 "(second: dlomegaITSprem2000 dlH_Sprem2000 $adaoX2)"
global stage3 "(third: dlomegaITSprem2013 dlH_Sprem2013 $adaoX3)"
reg3 $stage1 $stage2 $stage3 [aw=nobs1980],constr(1 2 3 4) 3sls
nlcom 1/(-_b[dlH_Sprem1990])

*------------------------------------ use ivregress gmm to estimate


*get 1980 weights
use "$empIT\data\ipums\ipums_census_clean_pctiles.dta",clear
keep if year==1980
ren nobs nobs1980
collapse nobs1980,by(college st)
save "$empIT\data\ipums\temp.dta",replace

use "$empIT\data\ipums\ipums_census_clean_pctiles_adao.dta",clear
drop if dltothours_itm==-1 | dltothours_its==-1
drop if dltothours_nitm==-1 | dltothours_nits==-1
winsor2 dltothours*,trim cuts(1 99) replace
global adaoX male married race_white age_30_40 age_40_50 age_50pl waged2 waged3
gen dlomegaITMprem=dlomegaITM-dlomegaNITM
gen dlomegaITSprem=dlomegaITS-dlomegaNITS
gen dlH_Mprem=(dltothours_itm+dlcompITM)-(dltothours_nitm+dlcompNITM)
gen dlH_Sprem=(dltothours_its+dlcompITS)-(dltothours_nits+dlcompNITS)
collapse (mean) dlomegaITMprem dlomegaITSprem dlH_Mprem dlH_Sprem dlcompITM dlcompNITM dlcompITS dlcompNITS ///
	dltothours_itm dltothours_nitm dltothours_its dltothours_nits $adaoX (sum) nobs [aw=nobs],by(college st year)
egen uid=group(college st)
merge m:1 st college using "$empIT\data\ipums\weights1980.dta"
keep if _merge==3
drop _merge
merge m:1 st college using "$empIT\data\ipums\iv_adao2.dta"
keep if _merge==3
drop _merge

global adaoX married race_white age_30_40 age_40_50 age_50pl waged2 waged3
global IVs itshare1970  dlhighitIV7080 // dlnobsIV dltothours8090 

*first stage
reg dlH_Mprem $IVs $adaoX [aw=nobs1980],cluster(uid)
reg dlH_Sprem $IVs $adaoX [aw=nobs1980],cluster(uid)

*manufacturing
reg dlomegaITM dlH_Mprem $adaoX [aw=nobs1980],cluster(uid)
nlcom 1/(-_b[dlH_Mprem])
ivregress gmm dlomegaITM $adaoX (dlH_Mprem=$IVs) [aw=nobs1980],cluster(uid)
nlcom 1/(-_b[dlH_Mprem])

reg3 dlomegaITM dlH_Mprem $adaoX [aw=nobs1980],inst($adaoX $IVs)
nlcom 1/(-_b[dlH_Mprem])

*services
reg dlomegaITS dlH_Sprem $adaoX [aw=nobs1980],cluster(uid)
nlcom 1/(-_b[dlH_Sprem])
ivregress gmm dlomegaITS $adaoX (dlH_Sprem=$IVs) [aw=nobs1980],cluster(uid)
nlcom 1/(-_b[dlH_Sprem])




