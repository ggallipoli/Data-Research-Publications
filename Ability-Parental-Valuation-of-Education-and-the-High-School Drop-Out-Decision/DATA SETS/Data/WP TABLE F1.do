



/*Rescale weight so it returns aweights in the pweight command, because stata probit does not allow aweights*/
quietly sum w3_ypr
scalar mwght =r(mean)
gen newpw = w3_ypr/(mwght * 20800/29687)

gen ppt = 1 if pt1 == 1
replace ppt = 2 if pt2 == 1
replace ppt = 3 if pt3 == 1
replace ppt = 4 if pt4 == 1
egen parpptx = group(parpref ppt)

ta parpptx, gen(parpptx)
gen lonepar = lonemom+lonedad 

set more off
capture log close
log using "K:\Dropouts\Factor Analysis\QE Programs\Reduced Form\Table 1 Boys OUT.txt", text replace


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
local a22 parpptx1
local a23 parpptx2
local a24 parpptx3
local a25 parpptx4
local a26 parpptx5
local a27 parpptx6
local a28 parpptx7
local a29 numsib
local a30 monthb 
local a31 yunemp 
local a32 pt1
local a33 pt2
local a34 pt3
local a35 parpref


forval i = 1(1)35 {

quietly sum `a`i'' 
scalar m`a`i'' = r(mean)
}

/************************COLUMN ONE***************************/

probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 [pw =newpw ], cluster(schoolid)
#delim ;

predictnl bcol1 = normal(_b[lnfi]*10.1266311 + _b[pedn4] +_b[_cons]) - normal(_b[lnfi]*8.922658 + _b[pedn4] +_b[_cons]) in 1, se(bcol1se) ;

sum bcol1 ;
sum bcol1se ;
drop bcol1 bcol1se ;
mfx,  varlist(pedn2 pedn3 pedn4 pedn5 pedn6) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  0,
pedn5 =  0,
pedn6 =  0) ;


#delim cr

/************************COLUMN TWO***************************/


forval i = 1(1)31 {

quietly sum `a`i'' 
scalar m`a`i'' = r(mean)
}

probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar numsib monthb [pw =newpw ], cluster(schoolid)
#delim  ;


predictnl bcol1 = normal(_b[lnfi]*10.1266311 + _b[pedn4] +_b[_cons] +
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar +
_b[numsib]* mnumsib  +
_b[monthb]* monthb 
) 
- normal(_b[lnfi]*8.922658 + _b[pedn4] +_b[_cons] +
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar +
_b[numsib]* mnumsib  +
_b[monthb]* monthb ) 

in 1, se(bcol1se) ;

sum bcol1 ;
sum bcol1se ;
drop bcol1 bcol1se  ;


mfx,  varlist(native rural imm moves otpar lonepar  numsib monthb) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  1,
pedn5 =  0,
pedn6 =  0) ;


mfx,  varlist(pedn2 pedn3 pedn4 pedn5 pedn6) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  0,
pedn5 =  0,
pedn6 =  0) ;

#delim cr



/************************COLUMN THREE***************************/
#delim  ;
probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar numsib monthb
parpptx1 parpptx2 parpptx3 parpptx4 parpptx5 parpptx6 parpptx7  [pw =newpw ], cluster(schoolid) ;


predictnl bcol1 = normal(_b[lnfi]*10.1266311 + 
_b[pedn4] + 
_b[nfld]* mnfld + 
_b[pei]* mpei + 
_b[ns]* mns + 
_b[nb]* mnb + 
_b[pq]* mpq + 
_b[sk]* msk + 
_b[mb]* mmb + 
_b[ab]* mab + 
_b[bc]* mbc + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[parpptx1]* mparpptx1 + 
_b[parpptx2]* mparpptx2 + 
_b[parpptx3]* mparpptx3 + 
_b[parpptx4]* mparpptx4 + 
_b[parpptx5]* mparpptx5 + 
_b[parpptx6]* mparpptx6 + 
_b[parpptx7]* mparpptx7 + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[_cons]) - 
normal(_b[lnfi]*8.922658 + 
_b[pedn4] + 
_b[nfld]* mnfld + 
_b[pei]* mpei + 
_b[ns]* mns + 
_b[nb]* mnb + 
_b[pq]* mpq + 
_b[sk]* msk + 
_b[mb]* mmb + 
_b[ab]* mab + 
_b[bc]* mbc + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[parpptx1]* mparpptx1 + 
_b[parpptx2]* mparpptx2 + 
_b[parpptx3]* mparpptx3 + 
_b[parpptx4]* mparpptx4 + 
_b[parpptx5]* mparpptx5 + 
_b[parpptx6]* mparpptx6 + 
_b[parpptx7]* mparpptx7 + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb+
_b[_cons]) in 1, se(bcol1se) ;

sum bcol1 ;
sum bcol1se ;
drop bcol1 bcol1se  ;


mfx,  varlist( native rural imm moves otpar lonepar numsib monthb ) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  1,
pedn5 =  0,
pedn6 =  0) ;


mfx,  varlist(pedn2 pedn3 pedn4 pedn5 pedn6) at(
pedn2 =0 ,
pedn3 =  0,
pedn4 =  0,
pedn5 =  0,
pedn6 =  0 ) ;

mfx,  varlist(parpptx1 parpptx2 parpptx3 parpptx4 parpptx5 parpptx6 parpptx7) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  1,
pedn5 =  0,
pedn6 =  0,
parpptx1 =0,
parpptx2 =0,
parpptx3 =0,
parpptx4 =0,
parpptx5 =0,
parpptx6 =0,
parpptx7 =0 ) ;

#delim cr

/************************COLUMN FIVE***************************/

probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar numsib monthb pt1 pt2 pt3 [pw =newpw ], cluster(schoolid)
#delim  ;


predictnl bcol1 = normal(_b[lnfi]*10.1266311 + 
_b[pedn4] + 
_b[nfld]* mnfld + 
_b[pei]* mpei + 
_b[ns]* mns + 
_b[nb]* mnb + 
_b[pq]* mpq + 
_b[sk]* msk + 
_b[mb]* mmb + 
_b[ab]* mab + 
_b[bc]* mbc + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[pt1]* mpt1 + 
_b[pt2]* mpt2 + 
_b[pt3]* mpt3 + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[_cons]) - 
normal(_b[lnfi]*8.922658 + 
_b[pedn4] + 
_b[nfld]* mnfld + 
_b[pei]* mpei + 
_b[ns]* mns + 
_b[nb]* mnb + 
_b[pq]* mpq + 
_b[sk]* msk + 
_b[mb]* mmb + 
_b[ab]* mab + 
_b[bc]* mbc + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[pt1]* mpt1 + 
_b[pt2]* mpt2 + 
_b[pt3]* mpt3 + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb+
_b[_cons]) in 1, se(bcol1se) ;

sum bcol1 ;
sum bcol1se ;
drop bcol1 bcol1se  ;

mfx,  varlist(native rural imm moves otpar lonepar numsib monthb) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  1,
pedn5 =  0,
pedn6 =  0) ;



mfx,  varlist(pedn2 pedn3 pedn4 pedn5 pedn6) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  0,
pedn5 =  0,
pedn6 =  0) ;
#delim  ;
mfx,  varlist(pt1 pt2 pt3) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  1,
pedn5 =  0,
pedn6 =  0,
pt1 = 0,
pt2 = 0,
pt3 = 0) ;


#delim cr

/************************COLUMN FOUR***************************/

probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar parpref numsib monthb [pw =newpw ], cluster(schoolid)
#delim  ;


predictnl bcol1 = normal(_b[lnfi]*10.1266311 + 
_b[pedn4] + 
_b[nfld]* mnfld + 
_b[pei]* mpei + 
_b[ns]* mns + 
_b[nb]* mnb + 
_b[pq]* mpq + 
_b[sk]* msk + 
_b[mb]* mmb + 
_b[ab]* mab + 
_b[bc]* mbc + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[parpref]* mparpref + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[_cons]) - 
normal(_b[lnfi]*8.922658 + 
_b[pedn4] + 
_b[nfld]* mnfld + 
_b[pei]* mpei + 
_b[ns]* mns + 
_b[nb]* mnb + 
_b[pq]* mpq + 
_b[sk]* msk + 
_b[mb]* mmb + 
_b[ab]* mab + 
_b[bc]* mbc + 
_b[native]* mnative + 
_b[rural]* mrural + 
_b[imm]* mimm + 
_b[moves]* mmoves + 
_b[otpar]* motpar + 
_b[lonepar]* mlonepar + 
_b[parpref]* mparpref + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb+
_b[_cons]) in 1, se(bcol1se) ;

sum bcol1 ;
sum bcol1se ;
drop bcol1 bcol1se  ;

mfx,  varlist(=native rural imm moves otpar lonepar parpref numsib monthb) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  1,
pedn5 =  0,
pedn6 =  0) ;



mfx,  varlist(pedn2 pedn3 pedn4 pedn5 pedn6) at(
pedn2 = 0,
pedn3 =  0,
pedn4 =  0,
pedn5 =  0,
pedn6 =  0) ;

#delim cr

log close


