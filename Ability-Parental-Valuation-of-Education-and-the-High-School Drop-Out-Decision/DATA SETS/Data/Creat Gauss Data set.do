



set more off
clear

use "K:\Dropouts\readonlydata\ANALYSIS DATA NOVEMBER 19 2007.dta", clear



drop if p1sfemale == 1


sort schoolid


joinby schoolid using "K:\Dropouts\readonlydata\wagedat.dta", unmat(both)

drop if _merge == 2

drop _merge

destring st19q01, replace force
destring st19q02, replace force
destring st19q03, replace force
destring st19q04, replace force
destring st19q05, replace force
destring st19q06, replace force
destring st20q01, replace force
destring st20q02, replace force

destring st21q09, replace force
destring st21q10, replace force 
destring st21q11, replace force
destring st21q05, replace force
destring st21q01, replace force
destring st21q02, replace force
destring st21q03, replace force
destring st21q04, replace force
destring st21q06, replace force
destring st21q07, replace force
destring st21q08, replace force


gen dp = c3dropout
gen lnfi =   ln(aeqivinc)

drop if aeqivinc >= 350

gen pedxx = 6 if a2 == 1 | a2 == 5 | a2 == 21
replace pedxx= 5 if a2 == 2 | a2 == 6 |  a2 == 10 | a2 == 22
replace pedxx= 4 if a2 == 7 
replace pedxx= 3 if a2 == 3 | a2 == 8  | a2 == 11  | a2 == 12 | a2 == 13  | a2 == 15  | a2 == 23
replace pedxx= 2 if a2 == 4  | a2 == 9 | a2 == 14 | a2 == 16 | a2 == 17 | a2 == 18 | a2 == 20 | a2 == 24
replace pedxx = 1 if a2 == 19 


ta pedxx, gen(pedn)


label var  pedn6 "LTSH"
label var  pedn5 " one HS"
label var  pedn4 "Both HS"
label var  pedn3 "PSE < BA"
label var  pedn2 "BA mixture"
label var  pedn1 "BA"



gen grd1 = y1sovgr50t54  == 1 | y1sovgrlt50 == 1 | y1sovgr55t59  == 1 if y1sovgrlt50 ~= .
gen grd2 = y1sovgr60t69 == 1 if y1sovgr60t69 ~= .
gen grd3 = y1sovgr70t79  ==1 if y1sovgr70t79 ~= .
gen grd4 = y1sovgr80t89  == 1 | y1sovgr9t100 ==1 if y1sovgr80t89  ~= .



gen grds = 95  if ysdv_l2 == 1
replace grds = 85 if ysdv_l2== 2
replace grds = 75 if ysdv_l2== 3
replace grds = 65 if ysdv_l2== 4
replace grds = 57 if ysdv_l2== 5
replace grds = 52 if ysdv_l2== 6
replace grds = 49 if ysdv_l2== 7


/*
gen minw1 = 6 if province == 0
replace minw1 = 6.5 if province == 1
replace minw1 = 6.5 if province == 2
replace minw1 = 6.2 if province == 3
replace minw1 = 7.45 if province == 4
replace minw1 = 7.15 if province == 5
replace minw1 = 7 if province == 6
replace minw1 = 6.65 if province == 7
replace minw1 = 7 if province == 8
replace minw1 = 8 if province == 9

gen minw = ln(minw1)

destring st37q01, replace force

gen nb1 = st37q01 == 1 | st37q01 == 2  | st37q01 == 3 if st37q01 ~= .
gen nb2 = st37q01 == 4 if st37q01 ~= .
gen nb3 = st37q01 == 5 | st37q01 == 6 if st37q01 ~= .
gen nb4 = st37q01 == 7 if st37q01 ~= .

*/
gen parpref = parexpsm == 4 if parexpsm ~= .


gen pt1 = readtile1 == 1
gen pt2 = readtile1 == 2
gen pt3 = readtile1 == 3
gen pt4 = readtile1 == 4

egen avgread = rowmean(pv1read pv2read pv3read pv4read pv5read)

/*
label var nb1	"0-50 books	"
label var nb2	"51-100 books"		
label var nb3	"101-500 books"			
label var nb4 	"More than 500 books"

gen selfeff = y1sselfeff 

gen effx = ysk1a < 4 if ysk1a < 5

gen effortpay = 1 - effx
*/
gen nfld = y1sprov1
gen pei = y1sprov2
gen ns  = y1sprov3
gen nb = y1sprov4
gen pq = y1sprov5
gen sk = y1sprov7
gen mb = y1sprov8
gen ab = y1sprov9
gen bc = y1sprov10

gen native = childnative 


rename rural urban
gen rural = 1-urban

gen imm =  p1simm 
/*gen sec =  p1ssecgen */
gen moves = p1pnummoves 

gen otpar = p1potwopar == 1 | p1potonepar == 1 
gen lonemom = p1pmomonly 
gen lonedad = p1pdadonly 
gen female = p1sfemale

gen saved = pb2701 == 1 | pb2702 == 1 | pb2703 == 1 | pb2704 == 1 if pb26 < 3


gen wght = w3_ypr







gen school = schoolid


destring st29q01, replace force
destring st29q03, replace force 
destring st32q01, replace force


gen hwkonetime = st32q01 == 4 if st32q01 ~= .
gen tryhard = ysa8g == 1 if ysa8g < 6
gen neverlate = st29q03 ==1 if st29q03 ~= .

drop if hwkonetime == .

drop if tryhard == . 

drop if neverlate == .

destring sc13q01, replace force
destring schlsize, replace force
destring sc14q01, replace force
destring sc14q02, replace force


gen page = pa6p2 if pa6p2 < 90 

gen numsib = 0 

forval i = 4(1)8 {

replace numsib = numsib + 1 if pa4p`i' >= 5 & pa4p`i' <= 8

}

gen monthb = 0 

forval i = 2(1)12 {
local k = `i' - 1
replace monthb = `k' if  birthm`i' == 1
}


reg dp lnfi yunemp parpref grd1 pedn1 pt1 lonedad imm saved rural moves native nfld monthb numsib page  [aw = w3_ypr]

gen dpoutsamp1 = e(sample)

keep if dpoutsamp == 1
 

keep yunemp -monthb




 drop if female == .

drop pedxx



	
outsheet using "K:\Dropouts\Factor Analysis\July2009\dat\JUL20DATB.raw", nonames replace


