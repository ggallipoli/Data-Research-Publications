clear all


/************************************************************************
Canada Covid 2021 - data clean and indices computing

Xianya 06/04/2021 updated
************************************************************************/


// Xianya's laptop
if strpos("`c(hostname)'","XIANYAs-MacBook-Pro.local")!=0 {
	cd "/Users/xianya/Dropbox/2020 - Canada COVID"
	}

// Xianya's desktop
if strpos("`c(hostname)'","ARTS-ECON-053B")!=0 {
	cd "C:\Users\User\Dropbox\2020 - Canada COVID"
	}
	
global data "../2020 - Canada COVID/data" 
global analysis "../2020 - Canada COVID/analysis"
global wfh "../2020 - Canada COVID/work_from_home"
set scheme s1color




/**************************

- clean ipums data and compute IT index, by industry

**********************/


use "$data/canada_ipums2011.dta", clear

// keep employed workers and those ages 25-65
keep if empstat==1
keep if age>=25 & age<=65

// recode occupation to SOC and industry codes: https://international.ipums.org/international-action/variables/CA2011A_0404#codes_section
run "$analysis/crosswalk_ind_occ.do"

// Link with occupation O*NET data to get IT intensity

* There are soc2010 3 digit codes, so I use the onet_avg_2002_2016_3dig file for merging
merge m:1 soc2010 using "$data/onet_avg_2002_2016_3dig.dta"
tab _merge
* 395012 match. All merge from master file as it should
* Few- 34 do not match from using because there are fewer Canada occ (ipums) codes than soc 2010 codes at 3 digit level and few have the same soc2010 codes.
keep if _merge==3
drop _merge


// Make industry level IT intensity estimates by collapsing different occupations to industry
sort ind_codes soc2010
collapse highit_occ, by (ind_codes)
* collapse z_itscore, by (ind_codes)
* egen z_itscore_mean = mean(z_itscore) , by(ind_codes)
save "$data/it_intensity_industry.dta", replace


// all industries
collapse highit_occ
append using "$data/it_intensity_industry.dta"
replace ind_codes=99 if ind==.
label define ind_codes_lbl 99 `"All industries"', add
label values ind_codes ind_codes_lbl
save "$data/it_intensity_industry.dta", replace


** collapse to the new defined indutries category 
keep if ind_codes == 6 | ind_codes == 7
collapse highit_occ
append using "$data/it_intensity_industry.dta"
replace ind_codes=199 if ind==.
label define ind_codes_lbl 199 `"Wholesale & retail trade"', add
label values ind_codes ind_codes_lbl
//drop if ind_codes == 6 | ind_codes == 7
save "$data/it_intensity_industry.dta", replace

 
keep if ind_codes == 10 | ind_codes == 11
collapse highit_occ
append using "$data/it_intensity_industry.dta"
replace ind_codes=299 if ind==.
label define ind_codes_lbl 299 `"Professional, scientific & tech. services"', add
label values ind_codes ind_codes_lbl
//drop if ind_codes == 10 | ind_codes == 11
save "$data/it_intensity_industry.dta", replace

keep if ind_codes == 9 | ind_codes == 16
collapse highit_occ
append using "$data/it_intensity_industry.dta"
replace ind_codes=399 if ind==.
label define ind_codes_lbl 399 `"Information, culture & recreation"', add
label values ind_codes ind_codes_lbl
//drop if ind_codes == 9 | ind_codes == 16
save "$data/it_intensity_industry.dta", replace





/**************************

- compute Dingel index, by industry

**********************/

use "$data/canada_ipums2011.dta", clear

// keep employed workers and those ages 25-65
keep if empstat==1
keep if age>=25 & age<=65

// recode occupation to SOC and industry codes: https://international.ipums.org/international-action/variables/CA2011A_0404#codes_section
run "$analysis/crosswalk_ind_occ.do"

// Link with occupation O*NET data from Dingel and Nieman 

* There are soc2010 3 digit codes, so I use the onet_avg_2002_2016_3dig file for merging
merge m:1 soc2010 using "$data/DN_index2.dta"
tab _merge
* All merge from master, some (38) do not match from using as it has more occupations.
keep if _merge==3
drop _merge


* Main Regressions
gen age_groups=.
replace age_groups=1 if age>=25 & age<=35
replace age_group=2 if age>35 & age<=50
replace age_group=3 if age>50

reg d_n_index i.sex, beta
reg d_n_index i.edattaind , beta
reg d_n_index i.age_groups , beta

// Make industry level IT intensity estimates by collapsing different occupations to industry

sort ind_codes soc2010
collapse d_n_index, by (ind_codes)

save "$data/dingel_index_industry.dta", replace

// all industries
collapse d_n_index
append using "$data/dingel_index_industry.dta"
replace ind_codes=99 if ind==.
label define ind_codes_lbl 99 `"All industries"', add
label values ind_codes ind_codes_lbl

save "$data/dingel_index_industry.dta", replace


** collapse to the new defined indutries category 
keep if ind_codes == 6 | ind_codes == 7
collapse d_n_index
append using "$data/dingel_index_industry.dta"
replace ind_codes=199 if ind==.
label define ind_codes_lbl 199 `"Wholesale & retail trade"', add
label values ind_codes ind_codes_lbl
* drop if ind_codes == 6 | ind_codes == 7
save "$data/dingel_index_industry.dta", replace

 
keep if ind_codes == 10 | ind_codes == 11
collapse d_n_index
append using "$data/dingel_index_industry.dta"
replace ind_codes=299 if ind==.
label define ind_codes_lbl 299 `"Professional, scientific & tech. services"', add
label values ind_codes ind_codes_lbl
* drop if ind_codes == 10 | ind_codes == 11
save "$data/dingel_index_industry.dta", replace


keep if ind_codes == 9 | ind_codes == 16
collapse d_n_index
append using "$data/dingel_index_industry.dta"
replace ind_codes=399 if ind==.
label define ind_codes_lbl 399 `"Information, culture & recreation"', add
label values ind_codes ind_codes_lbl
* drop if ind_codes == 9 | ind_codes == 16
save "$data/dingel_index_industry.dta", replace





/**************************

- compute IT index by province

**********************/


use "${data}/gdp_indus_prov_canada_growthrates_2019.dta", clear
merge m:1 ind_codes using "$data/it_intensity_industry.dta"

rename Province_code province_code


// Link to employment * province * industry data
* use statscan data- https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=1410002301


merge 1:1 province_code ind_codes using "${data}/employ_industry.dta", nogen keep(3)

egen sum_person=sum(persons), by(province_code)

gen ind_prov_highit_occ=highit_occ*persons
egen ind_prov_highit_occ_sum=sum(ind_prov_highit_occ), by (province_code)
gen ind_prov_highit_occ_final=(ind_prov_highit_occ_sum/sum_person)
collapse ind_prov_highit_occ_final, by(province_code)

replace province_code = 1 if province_code == 10
replace province_code = 2 if province_code == 11
replace province_code = 3 if province_code == 12
replace province_code = 4 if province_code == 13
replace province_code = 5 if province_code == 24
replace province_code = 6 if province_code == 35
replace province_code = 7 if province_code == 46
replace province_code = 8 if province_code == 47
replace province_code = 9 if province_code == 48
replace province_code = 10 if province_code == 59

save "${data}/it_index_province.dta", replace



** compute the country-level index by avraging all provinces 
collapse ind_prov_highit_occ_final
append using "${data}/it_index_province.dta"
replace province_code = 11 if province_code ==.

gen province=""
replace province = "Newfoundland and Labrador" if province_code == 1
replace province = "Prince Edward Island" if province_code == 2
replace province = "Nova Scotia" if province_code == 3
replace province = "New Brunswick" if province_code == 4
replace province = "Quebec" if province_code == 5
replace province = "Ontario" if province_code == 6
replace province = "Manitoba" if province_code == 7
replace province = "Saskatchewan" if province_code == 8
replace province = "Alberta" if province_code == 9
replace province = "British Columbia" if province_code == 10
replace province = "Canada" if province_code == 11



save "${data}/it_index_province.dta", replace






/**************************

- compute Dingel index by province

**********************/

use "${data}/gdp_indus_prov_canada_growthrates_2019.dta", clear
merge m:1 ind_codes using "$data/dingel_index_industry.dta", nogen keep(3)

rename Province_code province_code


// Link to employment * province * industry data
* use statscan data- https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=1410002301

merge 1:1 province_code ind_codes using "${data}/employ_industry.dta", nogen keep(3)

egen sum_person=sum(persons), by(province_code)

gen ind_prov_dn_index=d_n_index*persons
egen ind_prov_dn_index_sum=sum(ind_prov_dn_index), by (province_code)
gen ind_prov_dn_index_final=(ind_prov_dn_index_sum/sum_person)
collapse ind_prov_dn_index_final, by(province_code)

replace province_code = 1 if province_code == 10
replace province_code = 2 if province_code == 11
replace province_code = 3 if province_code == 12
replace province_code = 4 if province_code == 13
replace province_code = 5 if province_code == 24
replace province_code = 6 if province_code == 35
replace province_code = 7 if province_code == 46
replace province_code = 8 if province_code == 47
replace province_code = 9 if province_code == 48
replace province_code = 10 if province_code == 59


save "${data}/dingel_index_province.dta", replace


** compute the country-level index by avraging all provinces 
collapse ind_prov_dn_index_final
append using "${data}/dingel_index_province.dta"
replace province_code = 11 if province_code ==.


gen province=""
replace province = "Newfoundland and Labrador" if province_code == 1
replace province = "Prince Edward Island" if province_code == 2
replace province = "Nova Scotia" if province_code == 3
replace province = "New Brunswick" if province_code == 4
replace province = "Quebec" if province_code == 5
replace province = "Ontario" if province_code == 6
replace province = "Manitoba" if province_code == 7
replace province = "Saskatchewan" if province_code == 8
replace province = "Alberta" if province_code == 9
replace province = "British Columbia" if province_code == 10
replace province = "Canada" if province_code == 11


save "${data}/dingel_index_province.dta", replace





/**************************

- compute VSE index by province

**********************/


* Creating a work from home index by province - this can be repeated for each province but with different n_workers_ind*
clear
local k = 1
foreach province in "AB" "BC" "CA" "MB" "NBPE" "NL" "NS" "ON" "QC" "SK"{

import excel "${wfh}/`province'/work_from_home_score.xlsx", sheet("score") firstrow clear
preserve
collapse (sum) n_workers, by (ind_2_digit)
rename n_workers n_workers_total
tempfile workers
save `workers', replace
restore

*creating a share of occupation in each industry
merge m:1 ind_2_digit using `workers', nogen

gen share_occ_ind= n_workers/n_workers_total

gen score_share_ind = work_from_home*share_occ_ind

*a score for each industry in the province*

collapse (sum) score_share_ind share_occ_ind, by (ind_2_digit ind_2_digit_description)
merge m:1 ind_2_digit using `workers', nogen
egen sum_n_workers= sum(n_workers_total)

gen share_ind_prov = n_workers_total/sum_n_workers
gen score_share_prov = share_ind_prov* score_share_ind

*this is only to see what effect we have if we exclude agriculture at this step- when finding scores with all industries, this is commented out*
*drop if ind_2_digit==11

*share of work from home by province*
collapse (sum) score_share_prov
gen province = "`province'"

if `k' == 1{
save "${wfh}/vse_index_province.dta", replace
}
if `k' != 1{
tempfile final
save `final', replace
append using "${wfh}/vse_index_province.dta"
save "${wfh}/vse_index_province.dta", replace
}
local k = `k' + 1
}

use "${wfh}/vse_index_province.dta", clear
collapse (mean) score_share_prov
gen province = "Territories"
append using "${wfh}/vse_index_province.dta"
replace province = "NB" if province == "NBPE"
save "${wfh}/vse_index_province.dta", replace


keep if province == "NB"
replace province = "PE" if province == "NB"
append using "${wfh}/vse_index_province.dta"

gen province_code =.
replace province_code = 1 if province == "NL"
replace province_code = 2 if province == "PE"
replace province_code = 3 if province == "NS"
replace province_code = 4 if province == "NB"
replace province_code = 5 if province == "QC"
replace province_code = 6 if province == "ON"
replace province_code = 7 if province == "MB"
replace province_code = 8 if province == "SK"
replace province_code = 9 if province == "AB"
replace province_code = 10 if province == "BC"
replace province_code = 11 if province == "CA"
replace province_code = 12 if province == "Territories"

drop province
gen province=""
replace province = "Newfoundland and Labrador" if province_code == 1
replace province = "Prince Edward Island" if province_code == 2
replace province = "Nova Scotia" if province_code == 3
replace province = "New Brunswick" if province_code == 4
replace province = "Quebec" if province_code == 5
replace province = "Ontario" if province_code == 6
replace province = "Manitoba" if province_code == 7
replace province = "Saskatchewan" if province_code == 8
replace province = "Alberta" if province_code == 9
replace province = "British Columbia" if province_code == 10
replace province = "Canada" if province_code == 11
replace province = "Territories" if province_code == 12


save "${wfh}/vse_index_province.dta", replace





/**************************

- compute VSE index by industry

**********************/

import excel "${wfh}/CA/work_from_home_score.xlsx", sheet("score") firstrow clear

preserve
collapse (sum) n_workers, by (ind_2_digit)
rename n_workers n_workers_total
tempfile n_workers
save `n_workers'
restore
*creating a share of occupation in each industry

merge m:1 ind_2_digit using `n_workers', nogen


gen share_occ_ind= n_workers/n_workers_total

gen score_share_ind = work_from_home*share_occ_ind

*a score for each industry in the province*

collapse (sum) score_share_ind, by (ind_2_digit ind_2_digit_description)


save "${wfh}/vse_index_industry.dta", replace


