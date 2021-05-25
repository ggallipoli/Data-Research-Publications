

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
local a22 parpptx1
local a23 parpptx2
local a24 parpptx3
local a25 parpptx4
local a26 parpptx5
local a27 parpptx6
local a28 parpptx7
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

set more off
capture log close
log using "K:\Dropouts\Factor Analysis\QE Programs\Reduced Form\Table 2 Girls OUT.txt", text replace


#delim  ;
.

/**************TABLE F3 COL 1******************/ ;

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

 /****************       JHR F3 COL 2  ********************************/ ;
probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar 
parpptx1 parpptx2 parpptx3 parpptx4 parpptx5 parpptx6 parpptx7 tryhard numsib monthb [pw =newpw ], cluster(schoolid) ;

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
_b[tryhard]* mtryhard + 
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
_b[tryhard]* mtryhard + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +


_b[_cons]) in 1, se(bcol1se) ;


/*income marginal*/;

sum bcol1 bcol1se  ;

mfx,  varlist(tryhard native rural imm moves otpar lonepar numsib monthb ) at(
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



. /****************       JHR F3 COL 3  ********************************/ ;
#delim ;
probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar numsib monthb 
parpptx1 parpptx2 parpptx3 parpptx4 parpptx5 parpptx6 parpptx7 tryhard hwkonetime efficacy esteem [pw =newpw ], cluster(schoolid) ;

predictnl bcol2 = normal(_b[lnfi]*10.1266311 + 
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
_b[tryhard]* mtryhard + 
_b[esteem]*mesteem +
_b[efficacy]*mefficacy +
_b[hwkonetime]* mhwkonetime + 
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
_b[esteem]*mesteem +
_b[efficacy]*mefficacy +
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
_b[tryhard]* mtryhard + 

_b[hwkonetime]* mhwkonetime + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[_cons]) in 1, se(bcol2se) ;


/*income marginal*/ ;

sum bcol2 bcol2se ;

mfx,  varlist(tryhard hwkonetime native rural imm moves otpar lonepar numsib monthb esteem efficacy ) at(
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



/**************TABLE F3 COL 4******************/ ;

probit dp  lnfi  pedn2 pedn3 pedn4 pedn5 pedn6 nfld pei ns nb pq sk mb ab bc native rural imm moves otpar lonepar numsib monthb 
parpptx1 parpptx2 parpptx3 parpptx4 parpptx5 parpptx6 parpptx7 tryhard hwkonetime 
frhsimp frskip frdrop frmoreed frtroub frsmoke frswkhrd  depchild y1smokewkl 
 [pw =newpw ], cluster(schoolid) ;

predictnl bcol2 = normal(_b[lnfi]*10.1266311 + 
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
_b[tryhard]* mtryhard + 

_b[hwkonetime]* mhwkonetime + 
_b[frhsimp]* mfrhsimp + 
_b[frskip]* mfrskip + 
_b[frdrop]* mfrdrop + 
_b[frmoreed]* mfrmoreed + 
_b[frtroub]* mfrtroub + 
_b[frsmoke]* mfrsmoke + 
_b[frswkhrd]* mfrswkhrd + 
_b[depchild]* mdepchild + 
_b[y1smokewkl]* my1smokewkl + 
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
_b[tryhard]* mtryhard + 

_b[hwkonetime]* mhwkonetime + 
_b[frhsimp]* mfrhsimp + 
_b[frskip]* mfrskip + 
_b[frdrop]* mfrdrop + 
_b[frmoreed]* mfrmoreed + 
_b[frtroub]* mfrtroub + 
_b[frsmoke]* mfrsmoke + 
_b[frswkhrd]* mfrswkhrd + 
_b[depchild]* mdepchild + 
_b[y1smokewkl]* my1smokewkl + 
_b[numsib]* mnumsib  +
_b[monthb]* monthb +
_b[_cons]) in 1, se(bcol2se) ;


/*income marginal*/ ;

sum bcol2 bcol2se ;

mfx,  varlist(tryhard hwkonetime frhsimp frskip frdrop frmoreed frtroub frsmoke frswkhrd  depchild y1smokewkl  native rural imm moves otpar lonepar numsib monthb ) at(
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



 


log close


