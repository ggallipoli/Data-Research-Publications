
set more off 

cd "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\Programs for JHR"

use "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\May 2011 Programs\Data\ANALYSIS DATA NOVEMBER 19 2007.dta", clear

drop if p1sfemale == 1


sort schoolid


joinby schoolid using "P:\12-SSH-BCI-1529-R003\imported from bci-rdc\Green_1529 researcher files\Dropouts\May 2011 Programs\Data\youth_unemp.dta", unmat(both)

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

gen ppt = 1 if pt1 == 1
replace ppt = 2 if pt2 == 1
replace ppt = 3 if pt3 == 1
replace ppt = 4 if pt4 == 1
egen parpptx = group(parpref ppt)

ta parpptx, gen(parpp)

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
gen lonepar = lonemom+lonedad
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
 






 drop if female == .



quietly sum wght
scalar mwght =r(mean)
gen newpw = wght/(mwght * 20800/29687)


destring sc11q03, replace force
gen lowmat = sc11q03 == 3 | sc11q03 == 4 if sc11q03 ~= .
destring stratio, force replace
destring ratcomp, force replace
destring sc13q01, replace force
destring schlsize, replace force
destring sc14q01, replace force 
destring sc14q02, replace force 


gen comprat = schlsize/sc13q01
gen tearat = schlsize/(sc14q01+.5*sc14q01)


local a1 lnfi
local a2 pedn2
local a3 pedn3
local a4 pedn4
local a5 pedn5
local a6 pedn6
local a7 nfld
local a8 pei
local a9 ns
local a10 nb
local a11 pq
local a12 sk
local a13 mb
local a14 ab
local a15 bc
local a16 native
local a17 rural
local a18 imm
local a19 moves
local a20 otpar
local a21 lonepar
local a22 parpp1
local a23 parpp2
local a24 parpp3
local a25 parpp4
local a26 parpp5
local a27 parpp6
local a28 parpp7
local a29 tryhard
local a30 neverlate
local a31 hwkonetime
local a32 frhsimp
local a33 frskip
local a34 frdrop
local a35 frmoreed
local a36 frtroub
local a37 frsmoke
local a38 frswkhrd
local a39 depchild
local a40 y1smokewkl
local a41 comprat  
local a42 tearat
local a43 lowmat
local a44 numsib
local a45 monthb 
local a46 yunemp 


forval i = 1(1)46 {

quietly sum `a`i'' 
scalar m`a`i'' = r(mean)
}

#delim ;

probit dp  lnfi  i.pedxx native rural imm moves otpar lonepar numsib monthb 
ib(last).parpptx tryhard hwkonetime 
i.schoolid  [pw =newpw ];



#delim ;
gen samp = e(sample) ;

egen newschool = group(schoolid) if samp == 1 ;
ta newschool ;



/**************JHR TABLE 1 COL 5 with school fixed effects ******************/ ;
capture log close ;
log using Output/Tab1schoolfixed.txt, text replace ;
#delim ;

probit dp  lnfi  i.pedxx  native rural imm moves otpar lonepar numsib monthb 
ib(last).parpptx tryhard hwkonetime 
 yunemp ib(freq).newschool if samp == 1
 [pw =newpw ], cluster(schoolid) ;
#delim ;
testparm  i(2/295).newschool ;
predictnl bcol3 = normal(_b[lnfi]*+ 
_b[4.pedxx] + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[1.parpptx]* mparpp1 + 
_b[1.parpptx]* mparpp2 + 
_b[1.parpptx]* mparpp3 + 
_b[1.parpptx]* mparpp4 + 
_b[1.parpptx]* mparpp5 + 
_b[1.parpptx]* mparpp6 + 
_b[1.parpptx]* mparpp7 + 
_b[tryhard]* mtryhard + 
_b[hwkonetime]* mhwkonetime + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[yunemp]*myunemp +
_b[_cons]) - 
normal(_b[lnfi]* + 
_b[4.pedxx] + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[1.parpptx]* mparpp1 + 
_b[1.parpptx]* mparpp2 + 
_b[1.parpptx]* mparpp3 + 
_b[1.parpptx]* mparpp4 + 
_b[1.parpptx]* mparpp5 + 
_b[1.parpptx]* mparpp6 + 
_b[1.parpptx]* mparpp7 + 
_b[tryhard]* mtryhard + 
_b[hwkonetime]* mhwkonetime + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[yunemp]*myunemp +
_b[_cons]) in 1, se(bcol3se) ;


/*income marginal*/ ;

sum bcol3 bcol3se ;
#delim ;
margins, dydx(yunemp tryhard hwkonetime  native rural imm moves otpar lonepar numsib monthb) at(4.pedxx =1 ) ;


margins i.pedxx, at(8b.parpptx = 1)  ;

margins i.parpptx, at(4.pedxx =1 8b.parpptx = 1)  ;

margins, dydx(2.pedxx 3.pedxx 4.pedxx 5.pedxx 6.pedxx) at(8b.parpptx = 1)  ;
margins, dydx(1.parpptx 2.parpptx 3.parpptx 4.parpptx 5.parpptx 6.parpptx 7.parpptx) at(4.pedxx =1 )  ;

#delim ;
/*same sample without fixed effects*/
probit dp  lnfi  i.pedxx  native rural imm moves otpar lonepar numsib monthb 
ib(last).parpptx tryhard hwkonetime 
 yunemp  if samp == 1
 [pw =newpw ], cluster(schoolid) ;
#delim ;

predictnl bcol4 = normal(_b[lnfi]* + 
_b[4.pedxx] + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[1.parpptx]* mparpp1 + 
_b[1.parpptx]* mparpp2 + 
_b[1.parpptx]* mparpp3 + 
_b[1.parpptx]* mparpp4 + 
_b[1.parpptx]* mparpp5 + 
_b[1.parpptx]* mparpp6 + 
_b[1.parpptx]* mparpp7 + 
_b[tryhard]* mtryhard + 
_b[hwkonetime]* mhwkonetime + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[yunemp]*myunemp +
_b[_cons]) - 
normal(_b[lnfi]*+ 
_b[4.pedxx] + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[1.parpptx]* mparpp1 + 
_b[1.parpptx]* mparpp2 + 
_b[1.parpptx]* mparpp3 + 
_b[1.parpptx]* mparpp4 + 
_b[1.parpptx]* mparpp5 + 
_b[1.parpptx]* mparpp6 + 
_b[1.parpptx]* mparpp7 + 
_b[tryhard]* mtryhard + 
_b[hwkonetime]* mhwkonetime + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[yunemp]*myunemp +
_b[_cons]) in 1, se(bcol4se) ;


/*income marginal*/ ;

sum bcol4 bcol4se ;
#delim ;
margins, dydx(yunemp tryhard hwkonetime  native rural imm moves otpar lonepar numsib monthb) at(4.pedxx =1 ) ;


margins i.pedxx, at(8b.parpptx = 1)  ;

margins i.parpptx, at(4.pedxx =1 8b.parpptx = 1)  ;

margins, dydx(2.pedxx 3.pedxx 4.pedxx 5.pedxx 6.pedxx) at(8b.parpptx = 1)  ;
margins, dydx(1.parpptx 2.parpptx 3.parpptx 4.parpptx 5.parpptx 6.parpptx 7.parpptx) at(4.pedxx =1 )  ;


 


log close


