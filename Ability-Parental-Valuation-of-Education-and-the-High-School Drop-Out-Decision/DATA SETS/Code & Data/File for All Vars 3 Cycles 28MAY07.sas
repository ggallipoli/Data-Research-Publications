
options NOFMTERR;
libname indat1 "I:\YITS\YITS_Data\Cycle1\Cohort_A\Data_Donnees" ;
libname indat1a "I:\YITS\YITS_Data\Cycle1\Cohort_A\Data_Donnees\English" ;
libname indat2 "I:\YITS\YITS_Data\Cycle2\Cohort_A\Data_Donnees" ;
libname indat2a "I:\YITS\YITS_Data\Cycle2\Cohort_A\Data_Donnees\English" ;
libname indat3 "I:\YITS\YITS_Data\Cycle3\Cohort_A\Data_Donnees" ;
libname indat3a "I:\YITS\YITS_Data\Cycle3\Cohort_A\Data_Donnees\English" ;
libname outdat "K:\Green_YITS\Dropouts\readonlydata\May 28 2007" ;
libname outdat1 "K:\Green_YITS\Dropouts\readonlydata\May 28 2007" ;

/*
%inc "K:\Green_YITS\Dropouts\dataprep\prog\macro covars.sas" ; run;
data _null_ ;
file &listfile;
PUT

"IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"/


"							YITS HIGHSCHOOL DROPSOUT STATCAN PROJECT				"/


"______________________________________________________________________________________"/


"		DATE: &sysdate																	"/


"		PROGRAMER: KELLY FOLEY															"/


"		PROGRAM PURPOSE:  	CREATES A FILE TO USE FOR SELECTION ANALYSIS USING ALL 3 CYCLES		"/
"						        "/

						CREATES DATA USING NEWLY RELEASED FILES


"IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"/

;
/*
filename list &listfile;
proc printto print = list;
*/


/*DATA TEMP THREE A CYCLE 3 YITS STUDENT RESPONSES*/
data temp3 (index=(rec)) ;
set indat3a.c3ca_main;

rec = recordid ;
drop recordid ;
run;



/*DATA TEMP ONE A CYCLE 1 PISA STUDENT RESPONSES*/

data temp1a (index=(rec)) ;
set indat1a.c1CA_pisa_student; 

rec =input(recordid,10.0);
drop recordid;
run;


/*DATA TEMP ONE B CYCLE 1 YITS STUDENT RESPONSES*/
data temp1b (index=(rec)) ;
set indat1a.c1CA_yits_student; 
rec =input(recordid,10.0);
drop recordid;
/*DATA TEMP ONE C CYCLE 1 YITS PARENT RESPONSES*/
data temp1c (index=(rec)) ;
set indat1a.c1CA_yits_parent; 
rec =input(recordid,10.0);
drop recordid;
/*DATA TEMP TWO A CYCLE 2 YITS STUDENT RESPONSES*/
data temp2a (index=(rec)) ;
set indat2a.c2CA_main; 
rec = recordid ;
drop recordid weight;


data temp1ar (index=(rec)) ;
set indat1a.c1CA_pisa_read_results; 

rec =input(recordid,10.0);
drop recordid;
run;


data temp1am (index=(rec)) ;
set indat1a.c1CA_pisa_math_results; 

rec =input(recordid,10.0);
drop recordid;
run;

data  studenttemp (index =(schid));
merge temp1a (in=in1a) temp1a (in=in1b) temp1c (in=in1c) temp2a (in=in2) temp3 (in=in3)  temp1ar (in =inr) ;
by rec ;
sch1 = put(rec,9.) ;
schid = input(substr(sch1,1,4),4.0) ;
inpisa1 = in1a ;
inyits1 = in1b ;
inpar1 = in1c ;
incycle2 = in2;
incycle3 = in3;
insamp =   B2Q06 = 1 & B2Q32 = 96 ;
insamp3 = B3Q06 in (1,6) & B3Q32 = 96 ;
inmath = inm ;
inread  = inr ;
run;

data schooltemp (index=(schid));
set indat1a.c1ca_pisa_school;
 schid = input(schoolid,10.0) ;

run;

data outdat.Allvarsfile28MAY07 ;
merge studenttemp (in=inst) schooltemp (in=insc) ;
by schid ;

inschool = insc ;
instudent = inst ;


****startDEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS* ;

label inpisa1 = "On Cycle One PISA File"
incycle2 = "On Cycle Two  File"
incycle3 = "On Cycle Three  File"
inpar1 = "On Cycle One Parents YITS File"
inyits1 = "On Cycle One Student YITS File"
insamp = "Valid for sample restrictions" 
insamp3 = "Valid for sample restrictions cycle3" 
inschool = "Record from the School file Merge"
instudent = "Record from the (student) School file Merge"
inmath = "On Math Results file"
inread = "On Reading Results file"
;
RECORDID = rec ;
drop rec;


if YSLANGUE = 1 then y1sqenglish = 1 ;
if YSLANGUE = 2 then y1sqenglish = 0 ;

if YSDVProv = 10 then y1sprov = 1 ;
if YSDVProv = 11 then y1sprov = 2 ;
if YSDVProv = 12 then y1sprov = 3 ;
if YSDVProv = 13 then y1sprov = 4 ;
if YSDVProv = 24 then y1sprov = 5 ;
if YSDVProv = 35 then y1sprov = 6 ;
if YSDVProv = 46 then y1sprov = 7 ;
if YSDVProv = 47 then y1sprov = 8 ;
if YSDVProv = 48 then y1sprov = 9 ;
if YSDVProv = 59 then y1sprov = 10 ;

if YSDVProv = 10 then y1sprovnnb = 1 ;
if YSDVProv = 11 then y1sprovnnb = 2 ;
if YSDVProv = 12 then y1sprovnnb = 3 ;
if YSDVProv = 24 then y1sprovnnb = 4 ;
if YSDVProv = 35 then y1sprovnnb = 5 ;
if YSDVProv = 46 then y1sprovnnb = 6 ;
if YSDVProv = 47 then y1sprovnnb = 7 ;
if YSDVProv = 48 then y1sprovnnb = 8 ;
if YSDVProv = 59 then y1sprovnnb = 9 ;

      y1sprov1 = y1sprov = 1;
	y1sprov2 = y1sprov = 2;
	y1sprov3 = y1sprov = 3;
	y1sprov4 = y1sprov = 4;
	y1sprov5 = y1sprov = 5;
	y1sprov6 = y1sprov = 6;
	y1sprov7 = y1sprov = 7;
	y1sprov8 = y1sprov = 8;
	y1sprov9 = y1sprov = 9;
	y1sprov10 = y1sprov = 10;

if YSHACPS1 < 9 then y1sacadpart = YSHACPS1 ;
if YSHACIS1 < 9 then y1sacadidnt = YSHACIS1;
if YSHSOES1  < 9 then y1ssoceng = YSHSOES1;
if YSHACES1  < 9 then y1sacaeng = YSHACES1;
if YSHSCES1  < 9 then y1sovreng = YSHSCES1;
if YSHSFES1  < 9 then y1sselfest = YSHSFES1;
if YSHSFFS1  < 9 then y1sselfeff = YSHSFFS1;
if YSHSUPS1  < 9 then y1ssocsupp = YSHSUPS1;
if YSHMASS1  < 9 then y1smastery = YSHMASS1;


if YSA3 < 7 then y1strschwkbk = (ysa3 = 1  | ysa3 = 5);
if YSA3 < 7 then y1strschpubtr = ysa3 = 3 ;
if YSA3 < 7 then y1strschdrive = ysa3 = 4 ;
if YSA3 < 7 then y1strschscbus = ysa3 = 2 ;
if YSA3 < 7 then y1strschscres = ysa3 = 6 ;

if YSA4 < 7 then y1strtml15m = ysa4 = 1 ;
if YSA4 < 7 then y1strtm15t1h = (ysa4 > 1 & ysa4 < 5) ;
if YSA4 < 7 then y1strtmgt1h = (ysa4 > 4 & ysa4 < 7) ;
if YSA10 ne 9 then y1sexphsgrad = ysa10 = 1 ;


if YSDV_A11 < 97 then do ;

y1sexplths = ysdv_a11 = 1 ;
y1sexphs = ysdv_a11 = 2 ;
y1sexptrade = ysdv_a11 = 3 ;
y1sexpcollge = ysdv_a11 = 4 ;
y1sexpbadeg = ysdv_a11 = 5 ;
y1sexpgrad = ysdv_a11 = 6 ;

end;


if YSB3A < 9 then y1sawaysick = YSB3A = 1 ;

if YSE3A ne 9 then y1shospstay = YSE3A = 1 ;
if YSE3B ne 9 then y1sschkout =YSE3B = 1 ;
if YSE5 ne 9 then y1strdsmoke =YSE5 = 1 ;

if YSE7 ne 99 then y1smokewkl = yse7 = 4 | yse7 = 5 | yse7 = 6;

if YSVOLAD ne 9 then y1svolunt = YSVOLAD = 1 ;
if YSG2A ne 9 then y1swrkemp = YSG2A = 1 ;
if YSG2B ne 9 then y1swrkodd = YSG2A = 1 ;
if YSG2C ne 9 then y1swrkfam = YSG2A = 1 ;
 if y1swrkemp = 1 | y1swrkodd = 1 | y1swrkfam= 1 then y1severwrk = 1;
if y1swrkemp = 0 & y1swrkodd = 0 & y1swrkfam= 0 then y1severwrk = 0 ;

if YSG11A ne 9 then y1swschemp = YSG11A = 1 ;
if YSG11B ne 9 then y1swschodd = YSG11A = 1 ;
if YSG11C ne 9 then y1swschfam = YSG11A = 1 ;
 if y1swschemp = 1 | y1swschodd = 1 | y1swschfam= 1 then y1sschwrk = 1;
if y1swschemp = 0 & y1swschodd = 0 & y1swschfam= 0 then y1sschwrk = 0 ;

if YSH3 ne 9 then y1ssvowned = YSH3 = 1 ;

if YSK8A = 4 | YSK8B = 4 then y1shsvimppar = 1 ;
else y1shsvimppar = 0 ;
if (YSK8A = 99 & YSK8B = 99) | (YSK8A = 6 & YSK8B = 6) then y1shsvimppar = . ;

if YSK9A = 4 | YSK9B = 4 then y1sgthsvimppar = 1 ;
else y1sgthsvimppar = 0 ;
if (YSK9A = 99 & YSK9B = 99) | (YSK9A = 6 & YSK9B = 6) then y1sgthsvimppar = . ;


if YSDV_L2 ne 99 then do;

y1sovgr9t100 = YSDV_L2 = 1;
y1sovgr80t89 = YSDV_L2 = 2;
y1sovgr70t79 = YSDV_L2 = 3;
y1sovgr60t69 = YSDV_L2 =4;
y1sovgr55t59 = YSDV_L2 = 5;
y1sovgr50t54 = YSDV_L2 = 6;
y1sovgrlt50 = YSDV_L2 = 7;
end;


label y1sqenglish = "YITS S1: Questionaire in English" 
y1sprov = "YITS S1: Province"
y1sprov1 = "YITS S1: Newfoundland"
y1sprov2 = "YITS S1: Prince Edward Island"
y1sprov3 = "YITS S1: Nova Scotia"
y1sprov4 = "YITS S1: New Brunswick"
y1sprov5 = "YITS S1: Quebec"
y1sprov6 = "YITS S1: Ontario"
y1sprov7 = "YITS S1: Manitoba"
y1sprov8 = "YITS S1: Saskatchewan"
y1sprov9 = "YITS S1: Alberta"
y1sprov10 = "YITS S1: British Columbia"
y1sprovnnb= "YITS S1: Province (not including New Brunswick"
y1sacadpart = "YITS S1: Academic Participation Scale" 
y1sacadidnt = "YITS S1: Academic Identification Scale"
y1ssoceng = "YITS S1: Social Engagement Scale"
y1sacaeng = "YITS S1: Academic Engagement Scale"
y1sovreng = "YITS S1: Overall Engagement Scale"
y1sselfest ="YITS S1: Self-Esteem Scale"
y1sselfeff = "YITS S1: Self-Efficacy Scale"
y1ssocsupp = "YITS S1: Support Scale"
y1smastery = "YITS S1: Mastery Scale"
y1strschwkbk = "YITS S1: Walk or Bike to school"
y1strschpubtr = "YITS S1: Take public transport to school"
y1strschdrive = "YITS S1: Drive to school"
y1strschscbus = "YITS S1: Take School Bus to school"
y1strschscres = "YITS S1: Live in residence at school"
y1strtml15m = "YITS S1: Less than 15 min travel time to school"
y1strtm15t1h = "YITS S1:  Btwn 15 min and 1 hr travel time to school"
y1strtmgt1h = "YITS S1: Over 1 hr travel time to school"
y1sexphsgrad = "YITS S1: Expect to graduate from H.S."
y1sexplths = "YITS S1: Highest Ed. want to obtain- less than H.S."
y1sexphs = "YITS S1: Highest Ed. want to obtain-  H.S."
y1sexptrade = "YITS S1: Highest Ed. want to obtain- Trade/Appr"
y1sexpcollge = "YITS S1: Highest Ed. want to obtain- College/CEGEP"
y1sexpbadeg = "YITS S1: Highest Ed. want to obtain- One Uni. Degree"
y1sexpgrad = "YITS S1: Highest Ed. want to obtain- > 1 Uni Degree"
y1sawaysick = "YITS S1: Away from school >2wks for sickness"
y1shospstay = "YITS S1: Ever been in hospital for > 2wks"
y1sschkout= "YITS S1: Ever been kicked out of school"
y1strdsmoke = "YITS S1: Ever tried smoking"
y1smokewkl =  "YITS S1: Smoke at least weekly"
y1svolunt =  "YITS S1: Volunteered in the last 12 months"
y1swrkemp=  "YITS S1: Ever worked for an employer"
y1swrkodd=  "YITS S1: Ever worked at odd jobs"
y1swrkfam=  "YITS S1: Ever worked for family"
y1severwrk=  "YITS S1: Ever worked for any job"
y1swschemp=  "YITS S1: Worked during school year for an employer"
y1swschodd=  "YITS S1: Worked during school year at odd jobs"
y1swschfam=  "YITS S1: Worked during school year for family"
y1sschwrk=  "YITS S1: Worked during school year for any job"
y1ssvowned=  "YITS S1: Saves for own education"
y1shsvimppar=  "YITS S1: H.S. grad very imp. to at least one parent"
y1sgthsvimppar =  "YITS S1: More than H.S. very imp. to at least one parent"
y1sovgr9t100 =  "YITS S1: Overall grades 90 to 100 %"
y1sovgr80t89 =  "YITS S1: Overall grades 80 to 89 %"
y1sovgr70t79 =  "YITS S1: Overall grades 70 to 79 %"
y1sovgr60t69 =  "YITS S1: Overall grades 60 to 69 %"
y1sovgr55t59 =  "YITS S1: Overall grades 55 to 59 %"
y1sovgr50t54 =  "YITS S1: Overall grades 50 to 54 %"
y1sovgrlt50 =  "YITS S1: Overall grades lt 50 %"




;


****endDEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS*DEMOGRAPHICVARS* ;



****start DEPENDENT VARIABLE DEPENDENT VARIABLE DEPENDENT VARIABLE DEPENDENT VARIABLE DEPENDENT VARIABLE *;

if BMONTHD2 ne 99 and BYEARD2 ne 9999 then sasbday2 = mdy(BMONTHD2,15,BYEARD2);
if ST01Q01 < 32 and ST01Q02 le 12 and ST01Q03 < 2000 then sasbday1 = mdy(ST01Q02,15,ST01Q03) ;
sasbday = sasbday1 ;
if sasbday1 = . and sasbday2 ne . then sasbday = sasbday2 ;

if B2Q06 = 1 then inschool15 = 1 ;

agedec2001 = intck('month',sasbday,MDY(12, 15, 2001)) ;

if LESMTD2 ne 99 and LESYRD2 ne 9999 then dtlstinsch = mdy(LESMTD2,15,LESYRD2);


if LFTESMD2 ne 99 and LFTESYD2 ne 9999 then dtlstftsch = mdy(LFTESMD2,15,LFTESYD2);

if HSDIPMD2 not in (99,96) and HSDIPYD2 not in (9996,9999) then dtgrdhsch = mdy(HSDIPMD2,15,HSDIPYD2);

bday16 = intnx('month',sasbday,192);

monthstograd =intck('month',bday16,dtgrdhsch);
 monthstodrop =intck('month',bday16,dtlstinsch);
 monthstodrft =intck('month',bday16,dtlstftsch);
 

 format dtlstinsch dtlstftsch dtgrdhsch sasbday sasbday1 sasbday2 yymmdd10.; 


if DNOD2 ne 99 then do ;
d2nevdropout = DNOD2 = 0 ;
d2dropoutonc = DNOD2 = 1;
d2dropoutgeon = DNOD2 > 1;
end;

if DRPD2 in (1,2) & HSSTATD2 in (1,2,3) then do ;

d2drophsgrd = DRPD2 = 1 & HSSTATD2 = 1 ;
d2dropleav  = DRPD2 = 1 & HSSTATD2 = 3 ;
d2dropcont  = DRPD2 = 1 & HSSTATD2 = 2 ;
d2nodrhsgrd = DRPD2 = 2 & HSSTATD2 = 1 ;
d2nodrcont= DRPD2 = 2 & HSSTATD2 = 2 ;

end;

if d2dropleav ne . then d2monthdrop = 0 ;
if d2dropleav = 1 then d2monthdrop = monthstodrop ;

if d2dropcont = 1 | d2nodrcont = 1 then censorm = 23; ;
if d2drophsgrd = 1 | d2nodrhsgrd = 1 and (monthstograd) then censorm = monthstograd  ;
if d2drophsgrd = 1 | d2nodrhsgrd = 1 and monthstograd ne . and monthstograd < 1 then censorm = 0 ;
if d2dropleav = 1 then censorm = monthstodrop;




label dtlstinsch = "Date last in school" 
dtlstftsch = "Date last in school full-time" 
dtgrdhsch = "Date graduated highschool" 
 
 d2nevdropout = "DEPVAR S2: Never Dropped Out"
d2dropoutonc = "DEPVAR S2: Dropped Out Once"
d2dropoutgeon = "DEPVAR S2: Dropped OUt more than Once"
d2drophsgrd = "DEPVAR S2: Dropped out and HS Grad"
d2dropleav  = "DEPVAR S2: Dropped out and HS Leaver"
d2dropcont  = "DEPVAR S2: Dropped out and HS Continuer"
d2nodrhsgrd = "DEPVAR S2: No Drop out and HS Grad"
d2nodrcont= "DEPVAR S2: No Drop out and HS Grad"
d2monthdrop="DEPVAR S2: Month until dropped out" ;



****end DEPENDENT VARIABLE DEPENDENT VARIABLE DEPENDENT VARIABLE DEPENDENT VARIABLE DEPENDENT VARIABLE *;

****start PISA COVARS PISA COVARS PISA COVARS PISA COVARS PISA COVARS PISA COVARS PISA COVARS PISA COVARS *;

 
if (ST02Q01) then p1sgrade67 =  (ST02Q01 = 6 |ST02Q01 = 7) ;
if (ST02Q01) then p1sgrade8 =  ST02Q01 = 8;
if (ST02Q01) then p1sgrade9 =  ST02Q01 = 9;
if (ST02Q01) then p1sgrade10 =  ST02Q01 = 10;
if (ST02Q01) then p1sgradeg11 =  ST02Q01 ge 11;
if (ST03Q01)  then p1sfemale = ST03Q01 = 1;




if ST04Q01=2 and ST04Q02=2 and ST04Q03=2 and ST04Q04=1 then  p1smalguard = 1;
if ST04Q01=2 and ST04Q02=2 and ST04Q03=1 and ST04Q04=2 then p1slvdad = 1;
if ST04Q01=2 and ST04Q02=2 and ST04Q03=1 and ST04Q04=.m then p1slvdad = 1;
if ST04Q01=2 and ST04Q02=2 and ST04Q03=1 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=2 and ST04Q04=2 then  p1sfemguard = 1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=2 and ST04Q04=1 then p1stwoguard = 1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=1 and ST04Q04=2 then p1slvdadfem=1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=1 and ST04Q04=.m then p1slvdadfem=1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=1 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=.m and ST04Q04=1 then p1stwoguard=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=2 and ST04Q04=2 then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=2 and ST04Q04=.m then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=2 and ST04Q04=.m then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=2 and ST04Q04=1 then p1slvmommal=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=1 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=1 and ST04Q04=2 then p1stwopar = 1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=1 and ST04Q04=.m then p1stwopar = 1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=2 then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=2 then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=.m then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=.m then p1slvmom=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=1 then p1slvmommal=1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=1 then p1slvmommal=1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=2 and ST04Q04=2 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=2 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=1 and ST04Q04=2 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=1 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=1 and ST04Q04=.m then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=.m and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=1 and ST04Q03=.m and ST04Q04=.m then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=2 and ST04Q04=2 then p1slvmom=1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=2 and ST04Q04=1 then p1slvmommal=1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=1 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=1 and ST04Q04=2 then p1stwopar = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=1 and ST04Q04=2 then p1stwopar = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=1 and ST04Q04=.m then p1stwopar = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=.m and ST04Q04=2 then p1slvmom=1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=.m and ST04Q04=.m then p1slvmom=1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=.m and ST04Q04=1 then p1slvmommal=1;
if ST04Q01=.m and ST04Q02=2 and ST04Q03=1 and ST04Q04=2 then p1slvdad = 1;
if ST04Q01=.m and ST04Q02=1 and ST04Q03=1 and ST04Q04=.m then p1slvdadfem=1;
if ST04Q01=.m and ST04Q02=1 and ST04Q03=.m and ST04Q04=1 then p1stwoguard = 1;
if ST04Q01=.m and ST04Q02=.m and ST04Q03=1 and ST04Q04=2 then p1slvdad = 1;
if ST04Q01=.m and ST04Q02=.m and ST04Q03=1 and ST04Q04=.m then p1slvdad = 1;
if ST04Q01=.m and ST04Q02=.m and ST04Q03=1 and ST04Q04=1 then p1slvnotrad = 1;
if ST04Q01=.m and ST04Q02=.m and ST04Q03=.m and ST04Q04=1 then  p1smalguard = 1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=1 and ST04Q04=.m then  p1stwopar = 1;
if ST04Q01=1 and ST04Q02=2 and ST04Q03=.m and ST04Q04=1 then  p1slvmommal = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=1 and ST04Q04=2 then  p1stwopar = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=1 and ST04Q04=1 then  p1slvnotrad = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=2 and ST04Q04=1 then  p1slvmommal = 1;
if ST04Q01=1 and ST04Q02=.m and ST04Q03=2 and ST04Q04=.m then  p1slvmom = 1;
if ST04Q01=2 and ST04Q02=1 and ST04Q03=2 and ST04Q04=.m then  p1sfemguard = 1;
if ST04Q01=2 and ST04Q02=2 and ST04Q03=.m and ST04Q04=1 then  p1smalguard = 1;
if ST04Q01=2 and ST04Q02=.m and ST04Q03=1 and ST04Q04=2 then  p1slvdad = 1;
if ST04Q01=2 and ST04Q02=.m and ST04Q03=1 and ST04Q04=.m then  p1slvdad = 1;
if ST04Q01=2 and ST04Q02=.m and ST04Q03=2 and ST04Q04=1 then  p1smalguard = 1;
if ST04Q01=.m and ST04Q02=1 and ST04Q03=2 and ST04Q04=.m then  p1sfemguard = 1;
if ST04Q01=.m and ST04Q02=1 and ST04Q03=.m and ST04Q04=.m then  p1sfemguard = 1;
if ST04Q01 in (.m,2) and ST04Q02  in (.m,2) and ST04Q03  in (.m,2) and ST04Q04 in (.m,2) & ST04Q07
= 1 then  p1sgranguard = 1;

valid = (p1smalguard) |
(p1sfemguard) |
(p1slvdad) |
(p1slvmom) |
(p1sgranguard) |
(p1stwopar) |
(p1slvnotrad) |
(p1slvmommal) |
(p1slvdadfem) |
(p1stwoguard) ;

if valid = 1 then do ;
if p1smalguard ne 1 then p1smalguard = 0;
if p1sfemguard ne 1 then p1sfemguard  = 0;
if p1slvdad ne 1 then  p1slvdad  = 0;
if p1slvmom ne 1 then  p1slvmom  = 0;
if p1sgranguard ne 1 then  p1sgranguard  = 0;
if p1stwopar ne 1 then  p1stwopar = 0;
if p1slvnotrad ne 1 then p1slvnotrad  = 0;
if p1slvmommal ne 1 then p1slvmommal  = 0;
if p1slvdadfem ne 1 then p1slvdadfem  = 0;
if p1stwoguard ne 1 then p1stwoguard = 0;
end;



if valid = 1 then do;
p1sprgrp1 = p1stwopar = 1 ;
p1sprgrp2 = p1slvmom = 1;
p1sprgrp3 = p1slvdad = 1;
p1sprgrp4 = p1slvdadfem = 1 |  p1slvmommal = 1;
p1sprgrp5 = p1stwopar ne 1 & p1slvmom ne 1 & p1slvdad ne 1 & p1slvdadfem ne 1 & p1slvmommal ne 1;
end;
drop valid;


older = ST05Q01-1;
if ST05Q01= .m then older = 0;
younger = ST05Q02-1;
if ST05Q02 = .m then younger = 0 ;
sameage = ST05Q03 -1;
if ST05Q03 = .m then sameage = 0 ;

p1snumsib = older + younger + sameage ;
if p1snumsib >= 0 then do ;
p1sonlych = p1snumsib = 0 ;
p1soldest = older = 0 & younger > 0 ;
p1syoungest = older > 0 & younger = 0 ;
p1smiddle = older > 0 & younger > 0 ;
p1ssameage= p1soldest = 0 & p1syoungest = 0 & p1smiddle = 0 & sameage > 0;
end;

p1smomjbnoinfo = (ST06Q01 < 1) ;
p1smomjobft = (ST06Q01= 1) ;
p1smomjobpt =(ST06Q01= 2) ;
p1smomjobun = (ST06Q01= 3) ;
p1smomjobhm =(ST06Q01= 4) ;

p1sdadjbnoinfo = (ST07Q01 < 1) ;
p1sdadjobft = (ST07Q01= 1) ;
p1sdadjobpt =(ST07Q01= 2) ;
p1sdadjobun = (ST07Q01= 3) ;
p1sdadjobhm =(ST07Q01= 4) ;
if (ST14Q01) & (ST12Q01) then do ;
p1smomhed5 = ST14Q01 = 1 ;

p1smomhed4 = ST12Q01 = 5 & p1smomhed5 = 0;
 p1smomhed3 = ST12Q01 = 3 & p1smomhed5 = 0;
 p1smomhed2 = ST12Q01 = 2 & p1smomhed5 = 0;
 p1smomhed1 = ST12Q01 = 1 & p1smomhed5 = 0;
 end;

if (ST13Q01) & (ST15Q01) then do ;
p1sdadhed5 = ST15Q01 = 1 ;
p1sdadhed4 = ST13Q01 = 5 & p1sdadhed5 = 0 ;
 p1sdadhed3 = ST13Q01 = 3 & p1sdadhed5 = 0 ;
 p1sdadhed2 = ST13Q01 = 2 & p1sdadhed5 = 0 ;
 p1sdadhed1 = ST13Q01 = 1 & p1sdadhed5 = 0 ;

end;


p1smomnoed = p1smomhed5 = . ;

p1smomhson = p1smomhed4 = 1 & p1smomnoed = 0 ;
p1smomunhs = ST12Q01 = 5 & ST14Q01 = 1 & p1smomnoed = 0 ;
p1smomunns = ST12Q01 in (1,2,3) & ST14Q01 = 1 & p1smomnoed = 0 ;
p1smomlths = ST12Q01 in (1,2,3) & ST14Q01 = 2 & p1smomnoed = 0 ;


p1sdadnoed = p1sdadhed5 = . ;

p1sdadhson = p1sdadhed4 = 1 & p1sdadnoed = 0 ;
p1sdadunhs = ST13Q01 = 5 & ST15Q01 = 1 & p1sdadnoed = 0 ;
p1sdadunns = ST13Q01 in (1,2,3) & ST15Q01 = 1 & p1sdadnoed = 0 ;
p1sdadlths = ST13Q01 in (1,2,3) & ST15Q01 = 2 & p1sdadnoed = 0 ;

if (ST16Q01) then p1simm = ST16Q01 = 2;
if (ST16Q02) then p1simmmom = ST16Q02 = 2;
if (ST16Q03) then p1simmdad = ST16Q03 = 2;

p1ssecgen = p1simm = 0 & (p1simmmom =1 | p1simmdad= 1) ;
if p1simm = . | (p1simmmom= . & p1simmdad = .)  | (p1simmmom= . & p1simmdad = 0)  | (p1simmmom= 0 & p1simmdad = .)  then p1ssecgen = . ;
if p1simm = 1 then p1ssecgen = 0 ;


if (ST17Q01) then do;

p1senglish = ST17Q01 = 1;
p1sfrench = ST17Q01 = 2;
p1sothlang = ST17Q01 = 4;

end;


if (ST23Q01) then p1senrisch = st23q01 in (2,3) ;
if (ST23Q02)  or  (ST23Q03) then p1sremedsch = st23q02 in (2,3) |  st23q03 in (2,3) ;
if p1sremedsch = 0 and (st23q02 < 0 | st23q03 < 0) then p1sremedsch = . ;
if (ST24Q07) then p1sprtutor = ST24Q07 in (2,3) ;

if (ST29Q03) then do;
p1snvlate = ST29Q03 = 1 ;
p1ssmtlate = ST29Q03 = 2 ;
p1softlate = ST29Q03 => 3 ;
end;



if (ST29Q01) then do;
p1snvmiss = ST29Q01 = 1 ;
p1ssmtmiss = ST29Q01 = 2 ;
p1softmiss = ST29Q01 => 3 ;
end;


if (ST29Q02) then do;
p1snvskip = ST29Q02 = 1 ;
p1ssmtskip = ST29Q02 = 2 ;
p1softskip = ST29Q02 => 3 ;
end;

if (ST37Q01) then do;
p1snobooks = ST37Q01 = 1;
p1s1t100books = ST37Q01 = 2 | ST37Q01 = 3 | ST37Q01 = 4;
p1s100t500bks = ST37Q01 = 5 | ST37Q01 = 6;
p1sgt500books = ST37Q01 = 7;
end;

if (IT01Q01) then p1scomphome = IT01Q01 = 1 ;

label p1sgrade67 = "PISA S1: Grade 6 or 7"
p1sgrade8 = "PISA S1: Grade 8"
p1sgrade9 = "PISA S1: Grade 9"
p1sgrade10 = "PISA S1: Grade 10"
p1sgradeg11 = "PISA S1: Grade 11 or over"
p1sfemale= "PISA S1: Female"
p1smalguard = "PISA S1: Live with male gaurdian "
p1sfemguard= "PISA S1: Live with female graurdian"
p1slvdad = "PISA S1: live with dad"
p1slvmom= "PISA S1: Live with mom"
p1sgranguard= "PISA S1: Live with grandmother as head"
p1stwopar= "PISA S1: Live with both parents"
p1slvnotrad = "PISA S1: Live in non-traditional house"
p1slvmommal= "PISA S1: Live with mom and male guardian"
p1slvdadfem= "PISA S1: Live with dad and female guardian"
p1stwoguard = "PISA S1:  Live with male and female guardians"
p1sprgrp1= "PISA S1: Family Type, Two parents" 
p1sprgrp2= "PISA S1: Family Type, Single mom" 
p1sprgrp3= "PISA S1: Family Type, Single dad"
p1sprgrp4= "PISA S1: Family Type, parent and step parent" 
p1sprgrp5= "PISA S1: Family Type, other" 
p1snumsib = "PISA S1: Number of siblings"
p1sonlych= "PISA S1: Only Child"
p1soldest= "PISA S1: Oldest Child"
p1syoungest= "PISA S1: Youngest Child"
p1smiddle= "PISA S1: Middle Child"
p1ssameage= "PISA S1: Siblings all same age"
p1smomjbnoinfo  ="PISA S1: No info mom's activity"
p1smomjobft  ="PISA S1: Mom works FT"
p1smomjobpt  ="PISA S1: Mom works PT"
p1smomjobun  ="PISA S1: Mom unemployed"
p1smomjobhm ="PISA S1:  Mom not in lab. market"
p1sdadjbnoinfo  ="PISA S1: No info dad's activity"
p1sdadjobft  ="PISA S1: Dad works FT"
p1sdadjobpt  ="PISA S1: Dad works PT"
p1sdadjobun  ="PISA S1: Dad unemployed"
p1sdadjobhm ="PISA S1:  Dad not in lab. market"
p1smomhed1 ="PISA S1: Mom's highest ed. < grd 6"
p1smomhed2 ="PISA S1: Mom's highest ed. > grd 6 < grd 9"
p1smomhed3 ="PISA S1: Mom's highest ed. > grd 9 no h.s."
p1smomhed4 ="PISA S1: Mom's highest ed. Highschool"
p1smomhed5 ="PISA S1: Mom's highest ed. PSE"
p1sdadhed1 ="PISA S1: Dad's highest ed. < grd 6"
p1sdadhed2 ="PISA S1: Dad's highest ed. > grd 6 < grd 9"
p1sdadhed3 ="PISA S1: Dad's highest ed. > grd 9 no h.s."
p1sdadhed4 ="PISA S1: Dad's highest ed. Highschool"
p1sdadhed5 ="PISA S1: Dad's highest ed. PSE"
p1smomnoed  ="PISA S1: No Mom's Ed data"
p1smomhson ="PISA S1: Mom high school only"
p1smomunhs ="PISA S1: Mom high school and PSE"
p1smomunns ="PISA S1: Mom PSE and no h.s."
p1smomlths ="PISA S1: Mom PSE and less than h.s."
p1sdadnoed  ="PISA S1: No Dad's Ed data"
p1sdadhson ="PISA S1: Dad high school only"
p1sdadunhs ="PISA S1: Dad high school and PSE"
p1sdadunns ="PISA S1: Dad PSE and no h.s."
p1sdadlths ="PISA S1: Dad PSE and less than h.s."
p1simm ="PISA S1: Child is not born in Canada"
p1simmmom ="PISA S1: Mother not born in Canada"
p1simmdad ="PISA S1: Father not born in Canada"
p1ssecgen = "PISA S1: Second generation Canadian"
p1senglish ="PISA S1: Speak English at Home"
p1sfrench ="PISA S1: Speak French at Home"
p1sothlang="PISA S1: Speak Other Language at Home"
p1sremedsch="PISA S1: Took remedial courses at school"
p1senrisch="PISA S1: Took enriched courses at school"
p1sprtutor="PISA S1: Go to private tutor"
p1snvlate="PISA S1: Never late for school"
p1ssmtlate ="PISA S1: Sometimes late for school"
p1softlate="PISA S1: Often late for school"
p1snvmiss="PISA S1: Never miss school"
p1ssmtmiss ="PISA S1: Sometimes miss school"
p1softmiss="PISA S1: Often miss school"
p1snvskip ="PISA S1: Never skip school"
p1ssmtskip ="PISA S1: Sometimes skip school"
p1softskip="PISA S1: Often skip school"
p1snobooks ="PISA S1: No books in the home"
p1s1t100books ="PISA S1: 1 to 100 books in the home"
p1s100t500bks ="PISA S1: 100 to 500 books in the home"
p1sgt500books ="PISA S1: more than 500 books in the home"
p1scomphome="PISA S1: Access to computer at home"

;

/* START PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE */

if  URRURMZP not in (6,9) then p1purban = URRURMZP = 0 ;

if IMMRD in (1,2,3) then p1pfrchimm = immrd = 1 ;

if pmons1 < 90 then p1pmonitor = pmons1;
if pnurs1 < 90 then p1pnuture = pnurs1;
if prejs1 < 90 then p1pincons = prejs1;



if actdd in (1,2,3) then do ;
p1pchdadifs = actdd = 1;
p1pchdadifo = actdd = 2;
p1pchdadifn = actdd = 3;
end;

p1pfamincom = ctid;

IF PB8 IN (1,2) THEN p1penrisch = PB8 = 1 ;
IF PB9 IN (1,2) THEN p1premedsch = PB9 = 1 ;
IF PB10A IN (1,2) THEN p1prptgrd = PB10A = 1 ;
if PB13A1 in (1,2) then p1pprbsch = PB13A1 = 1 ;
if PB14A1 in (1,2) then p1ppolice = PB14A1 = 1 ;

if PB20 in (1,2,3) then p1psibdrpout = PB20 = 1 ;
if PB21A in (1,2,3,4) then p1phsvimppar = PB21A = 4 ;
if PB21b in (1,2,3,4) then p1pgthsvimppar = PB21b = 4 ;


if PB25B1 in (1,2,6) then p1pfinobst = PB25B1 = 1 ;
if PB25B2 in (1,2,6) then p1pdistobst = PB25B2 = 1 ;
if PB25B3 in (1,2,6) then p1pgrdobst = PB25B3 = 1 ;
if PB25B4 in (1,2,6) then p1phlthobst = PB25B4 = 1 ;

if PB26 in (1,2) then p1pplaned = PB26 ;

if FAMSD ne 99 then do ;

p1ptwoparents = FAMSD <= 16 ;
p1poneparent = FAMSD > 16 ;

p1pmomdad =  FAMSD = 1 ;
p1potwopar =  FAMSD > 1 & famsd < 17 ;
p1pmomonly = FAMSD = 21;
p1pdadonly = FAMSD = 22;
p1potonepar = famsd > 22 ;
end;

if PD1 < 996 then p1pnummoves = input(pd1,3.);

if PD2P1 < 995 then p1pchildimm = PD2P1 ~= 136;
if PD2P2 < 995 or PD2P3 < 995 then p1psecgen =  PD2P2 ne 136 | PD2P3 ne 136 ;

if PD3P11 in (1,2) then p1pchcancit = (PD3P11 = 1 | PD3P12 = 1) ;

if RESPD in (1,2,3,4) then do ;
mother = PA5P2 = 2;
 father = PA5P2 = 1;
end;

if mother = 1 then do ; 
if    PE1C < 90 then do ;

p1pmomhed4   = PE1C in (2,3) ;
p1pmomhed5  = PE1C > 3 ;
if PE1B < 9 |  p1pmomhed4 = 1 | p1pmomhed5 = 1 then do ;
p1pmomhed1 = 0 ;
p1pmomhed3 = 0 ;
p1pmomhed2 = 0 ;
if PE1C = 1 then do ;
p1pmomhed1  = PE1B = 1;
p1pmomhed3 = PE1B in (2,3,4,5);
p1pmomhed2  = PE1B in (6,7,8,9);
end;
end;
end;

if    PE2C < 90 then do ;

p1pdadhed4   = PE2C in (2,3) ;
p1pdadhed5  = PE2C > 3 ;
if PE2B < 9 |  p1pdadhed4 = 1 | p1pdadhed5 = 1 then do ;
p1pdadhed1 = 0 ;
p1pdadhed3 = 0 ;
p1pdadhed2 = 0 ;
if PE2C = 1 then do ;
p1pdadhed1  = PE2B = 1;
p1pdadhed3 = PE2B in (2,3,4,5);
p1pdadhed2  = PE2B in (6,7,8,9);
end;
end;
end;

end;



if father = 1 then do ; 
if    PE1C < 90 then do ;

p1pdadhed4   = PE1C in (2,3) ;
p1pdadhed5  = PE1C > 3 ;
if PE1B < 9 |  p1pdadhed4 = 1 | p1pdadhed5 = 1 then do ;
p1pdadhed1 = 0 ;
p1pdadhed3 = 0 ;
p1pdadhed2 = 0 ;
if PE1C = 1 then do ;
p1pdadhed1  = PE1B = 1;
p1pdadhed3 = PE1B in (2,3,4,5);
p1pdadhed2  = PE1B in (6,7,8,9);
end;
end;
end;

if    PE2C < 90 then do ;

p1pmomhed4   = PE2C in (2,3) ;
p1pmomhed5  = PE2C > 3 ;
if PE2B < 9 |  p1pmomhed4 = 1 | p1pmomhed5 = 1 then do ;
p1pmomhed1 = 0 ;
p1pmomhed3 = 0 ;
p1pmomhed2 = 0 ;
if PE2C = 1 then do ;
p1pmomhed1  = PE2B = 1;
p1pmomhed3 = PE2B in (2,3,4,5);
p1pmomhed2  = PE2B in (6,7,8,9);
end;
end;
end;

end;

if p1pmomhed1 = . then do ;
p1pmomhed4 = . ;
p1pmomhed5 = . ;
end;

if p1pdadhed1 = . then do ;
p1pdadhed4 = . ;
p1pdadhed5 = . ;
end;

if mother = 1  then do ;
if PF1 > 8 then do ; 
p1pmomjbnoinfo  =1 ;
p1pmomjob  =0;
p1pmomjobun   =0;
p1pmomjobhm  =0;
end;
if PF1 <= 8 then do;
p1pmomjbnoinfo  =0 ;
p1pmomjob  = PF1 in (1,2) ;
p1pmomjobun  = PF1 = 5;
p1pmomjobhm = PF1 in (3,4,6,7,8) ;
end;

if PF31 > 8 then do ; 
p1pdadjbnoinfo  =1 ;
p1pdadjob  =0;
p1pdadjobun   =0;
p1pdadjobhm  =0;
end;
if PF31 <= 8 then do;
p1pdadjbnoinfo  =0 ;
p1pdadjob  = PF31 in (1,2) ;
p1pdadjobun  =PF31= 5;
p1pdadjobhm = PF31 in (3,4,6,7,8) ;
end;

end;


if father = 1  then do ;
if PF31 > 8 then do ; 
p1pmomjbnoinfo  =1 ;
p1pmomjob  =0;
p1pmomjobun   =0;
p1pmomjobhm  =0;
end;
if PF31 <= 8 then do;
p1pmomjbnoinfo  =0 ;
p1pmomjob  = PF31 in (1,2) ;
p1pmomjobun  = PF31 = 5;
p1pmomjobhm = PF31 in (3,4,6,7,8) ;
end;

if PF1 > 8 then do ; 
p1pdadjbnoinfo  =1 ;
p1pdadjob  =0;
p1pdadjobun =0;
p1pdadjobhm  =0;
end;
if PF1 <= 8 then do;
p1pdadjbnoinfo  =0 ;
p1pdadjob  = PF1 in (1,2) ;
p1pdadjobun  =PF1= 5;
p1pdadjobhm = PF1 in (3,4,6,7,8) ;
end;

end;


LABEL
p1purban = "PISA P1: Urban"
p1pfamincom="PISA P1: Family Income"
p1pfrchimm="PISA P1: Child in french immersion"
p1pmonitor="PISA P1: Parent monitoring scale"
p1pnuture="PISA P1: Parent nuturing scale"
p1pincons="PISA P1: Parent inconsistent discipline scale"
p1pchdadifs="PISA P1: Child Activity difficult sometimes"
p1pchdadifo="PISA P1: Child Activity difficult often"
p1pchdadifn="PISA P1: Child Activity difficult never"
p1premedsch="PISA P1: Child taken remedial classes"
p1penrisch="PISA P1: Child taken enrichment classes"
p1prptgrd="PISA P1: Child repeated grade"
p1pprbsch="PISA P1: Contacted by the school for problem"
p1ppolice="PISA P1: Child intervied by police"
p1psibdrpout="PISA P1: Sibling has dropped out of Highschool"
p1phsvimppar="PISA P1: Important child finished High school"
p1pgthsvimppar="PISA P1: Important child goes beyond H.S."
p1pfinobst ="PISA P1: Financial obstacle to parent's ed. expectation"
p1pdistobst ="PISA P1: Distance obstacle to parent's ed. expectation"
p1pgrdobst ="PISA P1: Grades obstacle to parent's ed. expectation"
p1phlthobst ="PISA P1: Health obstacle to parent's ed. expectation"
p1pplaned ="PISA P1: Parents' plan for child's education"
p1ptwoparents ="PISA P1: Lives with two parents"
p1poneparent ="PISA P1: Lives with one parent"
p1pmomdad ="PISA P1:  Lives with mother and father"
p1potwopar ="PISA P1: Lives with other two parents"
p1pmomonly ="PISA P1:  Lives with single mother"
p1pdadonly ="PISA P1:  Lives with single father"
p1potonepar ="PISA P1:   Lives with other one parent"
p1pnummoves="PISA P1: Number of child home moves"
p1pchcancit="PISA P1: Child canadian citizen"
p1pchildimm ="PISA P1: Child not born in Canada"
p1psecgen="PISA P1: At least one parent not born in Canada"
p1pmomhed1 ="PISA P1: Mom's highest ed. < grd 6"
p1pmomhed2 ="PISA P1: Mom's highest ed. > grd 6 < grd 9"
p1pmomhed3 ="PISA P1: Mom's highest ed. > grd 9 no h.s."
p1pmomhed4 ="PISA P1: Mom's highest ed. Highschool"
p1pmomhed5 ="PISA P1: Mom's highest ed. PSE"
p1pdadhed1 ="PISA P1: Dad's highest ed. < grd 6"
p1pdadhed2 ="PISA P1: Dad's highest ed. > grd 6 < grd 9"
p1pdadhed3 ="PISA P1: Dad's highest ed. > grd 9 no h.s."
p1pdadhed4 ="PISA P1: Dad's highest ed. Highschool"
p1pdadhed5 ="PISA P1: Dad's highest ed. PSE"
p1pmomjbnoinfo  ="PISA P1: No info mom's activity"
p1pmomjob  ="PISA P1: Mom works "
p1pmomjobun  ="PISA P1: Mom unemployed"
p1pmomjobhm ="PISA P1:  Mom not in lab. market"
p1pdadjbnoinfo  ="PISA P1: No info dad's activity"
p1pdadjob  ="PISA P1: Dad works "
p1pdadjobun  ="PISA P1: Dad unemployed"
p1pdadjobhm ="PISA P1:  Dad not in lab. market"

;
drop older younger sameage;





/*="PISA P1: 
="PISA P1: 
="PISA P1: 
="PISA P1: 
="PISA P1: 
="PISA P1: */


/* END PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE PARENT FILE */
/*
="PISA P1:
="PISA P1:
="PISA P1:
="PISA P1:*/
/*
data temp ;
set outdat.Allvarsfile28MAY07 ;
*/
array mod99a{21} 
YSA1 YSA7 YSA8D YSA8I YSA8N
YSA2 YSA10 YSA8E YSA8J 
YSA3 YSA8A YSA8F YSA8K 
YSA4 YSA8B YSA8G YSA8L 
YSA6 YSA8C YSA8H YSA8M  ;

array mod9a{22}
YSA5A	YSA5F	YSA9E	YSA9J	YSA9O
YSA5B	YSA9A	YSA9F	YSA9K	YSA9P
YSA5C	YSA9B	YSA9G	YSA9L	
YSA5D	YSA9C	YSA9H	YSA9M	
YSA5E	YSA9D	YSA9I	YSA9N	;




array mod9c{8}
YSC1			YSC2A	YSC2B
YSC2C	YSC2D	YSC4A	YSC4B	YSC4C ;

array mod99c{2}
YSC3 YSC5 ;

array mod9d{16}
YSD1A YSD1E YSD2C YSD2G
YSD1B YSD1F YSD2D YSD2H
YSD1C YSD2A YSD2E YSD2I
YSD1D YSD2B YSD2F YSD2J ;



array mod99e{4}
YSE1A YSE1B YSE1C YSE1D 	;
array mod9e{3}
YSE3A YSE3B YSE5 ;


array mod99f{7} YSF1A YSF1B YSF1C YSF1D YSF1E YSF1F YSF1G ;

array mod9g{10}
YSG1A YSG1C YSG1E YSG1G YSG2B
YSG1B YSG1D YSG1F YSG2A YSG2C ;

array mod99h{3} 
YSH1A YSH1B YSH2 ;
array mod9i{17}
YSI1A YSI1B YSI1C YSI1D YSI1E
YSI1F YSI1G YSI1H YSI1I YSI1J
YSI2A YSI2B YSI2C YSI2D YSI2E
YSI2F YSI2G   ;

array mod9j{61}
YSJ1A1 YSJ1B2 YSJ1C3 YSJ1D4 YSJ1I1 YSJ2B2 
YSJ1A2 YSJ1B3 YSJ1C4 YSJ1D5 YSJ1I2 YSJ2B3 
YSJ1A3 YSJ1B4 YSJ1C5 YSJ1E1 YSJ1I3 YSJ2B4 
YSJ1A4 YSJ1B5 YSJ1D1 YSJ1E2 YSJ1I4 YSJ2C1 
YSJ1A5 YSJ1C1 YSJ1D2 YSJ1E3 YSJ1I5 YSJ2C2 
YSJ1B1 YSJ1C2 YSJ1D3 YSJ1E4 YSJ2A1 YSJ2C3 
YSJ1E5 YSJ1F4 YSJ1G3 YSJ1H2 YSJ2A2 YSJ2C4 
YSJ1F1 YSJ1F5 YSJ1G4 YSJ1H3 YSJ2A3 YSJ2D1 
YSJ1F2 YSJ1G1 YSJ1G5 YSJ1H4 YSJ2A4 YSJ2D2 
YSJ1F3 YSJ1G2 YSJ1H1 YSJ1H5 YSJ2B1 YSJ2D3 YSJ2D4 ;


array mod9k{29}
YSK1A YSK1G YSK2A YSK2G YSK3D 
YSK1B YSK1H YSK2B YSK2H YSK3E 
YSK1C YSK1I YSK2C YSK2I YSK3F 
YSK1D YSK1J YSK2D YSK3A YSK3G 
YSK1E YSK1K YSK2E YSK3B YSK4 
YSK1F YSK1L YSK2F YSK3C ;

array mod99k{4}
YSK8B YSK9A YSK9B YSK8A  ;

counta = 0;
countc = 0;
countd = 0;
counte = 0;
countf = 0 ;
countg = 0 ;
counth = 0 ;
countj = 0;
counti = 0;
countk = 0 ;

do i = 1 to dim(mod99a);
if mod99a{i} = 99 then counta +1 ;
end;

do i = 1 to dim(mod9a);
if mod9a{i} = 9 then counta +1 ;
end;


do i = 1 to dim(mod99c);
if mod99c{i} = 99 then countc +1 ;
end;

do i = 1 to dim(mod9c);
if mod9c{i} = 9 then countc +1 ;
end;



do i = 1 to dim(mod9d);
if mod9d{i} = 9 then countd +1 ;
end;


do i = 1 to dim(mod99e);
if mod99e{i} = 99 then counte +1 ;
end;

do i = 1 to dim(mod9e);
if mod9e{i} = 9 then counte +1 ;
end;

do i = 1 to dim(mod99f);
if mod99f{i} = 99 then countf +1 ;
end;


do i = 1 to dim(mod9g);
if mod9g{i} = 9 then countg +1 ;
end;


do i = 1 to dim(mod99h);
if mod99h{i} = 99 then counth +1 ;
end;

do i = 1 to dim(mod9i);
if mod9i{i} = 9 then counti +1 ;
end;

do i = 1 to dim(mod9j);
if mod9j{i} = 9 then countj +1 ;
end;



do i = 1 to dim(mod99k);
if mod99k{i} = 99 then countk +1 ;
end;

do i = 1 to dim(mod9k);
if mod9k{i} = 9 then countk +1 ;
end;


run;




PROC EXPORT DATA= outdat.Allvarsfile28MAY07
            OUTFILE= "K:\Green_YITS\Dropouts\readonlydata\May 28 2007\allvars file 3 cycles 28MAY07.csv" 
            DBMS=CSV REPLACE;
RUN;
