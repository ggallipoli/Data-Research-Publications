*********************** INTENSITY INDEX (ONET) **********************************
clear
cd "/Users/elbagomeznavas/Desktop/raw_data"

*========================================================== ONET(WORK ACTIVITIES)

import delimited /Users/elbagomeznavas/Desktop/raw_data/Work_Activities.txt
keep onetsoccode elementname datavalue scaleid

//Keep Relevant Variables
replace elementname = subinstr(elementname," ","",.) 
replace elementname="ANALYZE" if elementname=="AnalyzingDataorInformation" 
replace elementname="THINK" if elementname=="ThinkingCreatively" 
replace elementname="INTERPRET" if elementname=="InterpretingtheMeaningofInformationforOthers" 
replace elementname="RELATIONSHIPS" if elementname=="EstablishingandMaintainingInterpersonalRelationships" 
replace elementname="GUIDE" if elementname=="Guiding,Directing,andMotivatingSubordinates" 
replace elementname="COACH" if elementname=="CoachingandDevelopingOthers" 
replace elementname="OPERATE" if elementname=="OperatingVehicles,MechanizedDevices,orEquipment" 
replace elementname="CONTROL" if elementname=="ControllingMachinesandProcesses" 
keep if elementname == "ANALYZE" | elementname == "THINK" | elementname == "INTERPRET" | elementname =="RELATIONSHIPS" | elementname =="GUIDE" | elementname =="COACH" | elementname =="OPERATE" | elementname =="CONTROL"

// Reshape Data (from long to wide) 
gen unique_id = elementname + scaleid
drop scaleid elementname
reshape wide datavalue, i(onetsoccode) j(unique_id) string

//Multiply Level*Importance
generate ANALYZE= datavalueANALYZEIM*datavalueANALYZELV
generate THINK = datavalueTHINKIM*datavalueTHINKLV
generate INTERPRET = datavalueINTERPRETIM*datavalueINTERPRETLV
generate RELATIONSHIPS = datavalueRELATIONSHIPSIM*datavalueRELATIONSHIPSLV
generate GUIDE = datavalueGUIDEIM*datavalueGUIDELV 
generate COACH = datavalueCOACHIM*datavalueCOACHLV
generate OPERATE = datavalueOPERATEIM*datavalueOPERATELV 
generate CONTROL = datavalueCONTROLIM*datavalueCONTROLLV
keep ANALYZE THINK INTERPRET RELATIONSHIPS GUIDE COACH OPERATE CONTROL onetsoccode

save "/Users/elbagomeznavas/Desktop/raw_data/WorkActivities.dta", replace

*============================================================ ONET(WORK CONTEXT)

import delimited /Users/elbagomeznavas/Desktop/raw_data/Work_Context.txt
keep onetsoccode elementname datavalue scaleid category

//Keep Relevant Variables
replace elementname = subinstr(elementname," ","",.) 
replace elementname="ACCURATE" if elementname=="ImportanceofBeingExactorAccurate" 
replace elementname="REPEAT" if elementname=="ImportanceofRepeatingSameTasks" 
replace elementname="STRUCTURED" if elementname=="StructuredversusUnstructuredWork" 
replace elementname="HANDLE" if elementname=="SpendTimeUsingYourHandstoHandle,Control,orFeelObjects,Tools,orControls" 
replace elementname="SPEED" if elementname=="PaceDeterminedbySpeedofEquipment" 
replace elementname="REPETITIVE" if elementname=="SpendTimeMakingRepetitiveMotions" 
keep if elementname == "ACCURATE" | elementname == "REPEAT" | elementname == "STRUCTURED" | elementname =="HANDLE" | elementname =="SPEED" | elementname =="REPETITIVE"


//Scaling the Data
drop if  scaleid=="CX"
destring ( category), replace
gen index=.
replace index=0 if category==1 
replace index=0.2 if category==2
replace index=0.5 if category==3 
replace index=0.7 if category==4
replace index=1 if category==5 
gen datavalue_scaled = datavalue*index
ren datavalue_scaled dv_s

// Reshape Data (from long to wide) 

tostring (category), replace
gen unique_id = elementname + scaleid +category
drop scaleid elementname category index datavalue
reshape wide dv_s, i(onetsoccode) j(unique_id) string


//Adding the percentages above 

generate ACCURATE=dv_sACCURATECXP1 + dv_sACCURATECXP2 + dv_sACCURATECXP3 +dv_sACCURATECXP4 + dv_sACCURATECXP5
generate REPEAT= dv_sHANDLECXP1  + dv_sHANDLECXP2   + dv_sHANDLECXP3 + dv_sHANDLECXP4  + dv_sHANDLECXP5
generate STRUCTURED= dv_sREPEATCXP1 + dv_sREPEATCXP2  + dv_sREPEATCXP3 + dv_sREPEATCXP4 + dv_sREPEATCXP5
generate HANDLE = dv_sREPETITIVECXP1  + dv_sREPETITIVECXP2 + dv_sREPETITIVECXP3 + dv_sREPETITIVECXP4 + dv_sREPETITIVECXP5 
generate SPEED = dv_sSPEEDCXP1 +  dv_sSPEEDCXP2 +  dv_sSPEEDCXP3 + dv_sSPEEDCXP4 + dv_sSPEEDCXP5
ren dv_sSTRUCTUREDCXP4 dv4
generate REPETITIVE = dv_sSTRUCTUREDCXP1  + dv_sSTRUCTUREDCXP2  + dv_sSTRUCTUREDCXP3 + dv4 + dv_sSTRUCTUREDCXP5
keep ACCURATE REPEAT  STRUCTURED  HANDLE SPEED  REPETITIVE onetsoccode

save "/Users/elbagomeznavas/Desktop/raw_data/WorkContext.dta", replace

*=============================================================== ONET(ABILITIES)
import delimited /Users/elbagomeznavas/Desktop/raw_data/Abilities.txt
keep onetsoccode elementname datavalue scaleid

//Keep Relevant Variables
replace elementname = subinstr(elementname," ","",.) 
replace elementname="MANUAL" if elementname=="ManualDexterity" 
replace elementname="SPATIAL" if elementname=="SpatialOrientation" 
keep if elementname == "MANUAL" | elementname == "SPATIAL" 

// Reshape Data (from long to wide) 
gen unique_id = elementname + scaleid
drop scaleid elementname
reshape wide datavalue, i(onetsoccode) j(unique_id) string

//Multiply Level*Importance

generate MANUAL=datavalueMANUALIM *datavalueMANUALLV
generate SPATIAL=datavalueSPATIALIM *datavalueSPATIALLV
keep MANUAL SPATIAL onetsoccode
save "/Users/elbagomeznavas/Desktop/raw_data/Abilities.dta", replace

*====================================================================
//Now we group each variable to create five aggregate skill intensity measures

use "/Users/elbagomeznavas/Desktop/raw_data/WorkActivities.dta"
merge 1:1 onetsoccode  using "/Users/elbagomeznavas/Desktop/raw_data/Abilities.dta"
drop _merge
merge 1:1 onetsoccode using "/Users/elbagomeznavas/Desktop/raw_data/WorkContext.dta"
keep if _merge==3
drop _merge

generate NON_ROUT_COG_ANALYT = ANALYZE + THINK + INTERPRET

generate NON_ROUT_COGN_INTERP = RELATIONSHIPS + GUIDE + COACH

generate ROUT_COGNITIVE = REPEAT + ACCURATE + STRUCTURED 

generate ROUT_MANUAL = SPEED + CONTROL + REPETITIVE

generate NON_ROUT_MANUAL_PHYS = OPERATE + HANDLE + MANUAL + SPATIAL

//Finally we create a consolidated Z-score 

quietly center  NON_ROUT_COG_ANALYT,standardize prefix(z_)
quietly center  NON_ROUT_COGN_INTERP,standardize prefix(z_)
quietly center  ROUT_COGNITIVE,standardize prefix(z_)
quietly center  ROUT_MANUAL,standardize prefix(z_)
quietly center  NON_ROUT_MANUAL_PHYS,standardize prefix(z_)
save "/Users/elbagomeznavas/Desktop/raw_data/Intensity_Measure_ONet.dta", replace


//Now we get the SOC 2010 occupation codes 

import excel "/Users/elbagomeznavas/Desktop/2010_to_SOC_Crosswalk.xls", sheet("O-NET-SOC 2010 Occupation Listi") firstrow
ren  ONETSOC2010Code onetsoccode
merge 1:m  onetsoccode using "/Users/elbagomeznavas/Desktop/raw_data/Intensity_Measure_ONet.dta"
keep if _merge==3
drop _merge
collapse 
collapse (mean) z_NON_ROUT_COG_ANALYT z_NON_ROUT_COGN_INTERP z_ROUT_COGNITIVE z_ROUT_MANUAL z_NON_ROUT_MANUAL_PHYS, by(SOC2010Code)

quietly center  z_NON_ROUT_COG_ANALYT,standardize prefix(z_)
quietly center  z_NON_ROUT_COGN_INTERP,standardize prefix(z_)
quietly center  z_ROUT_COGNITIVE,standardize prefix(z_)
quietly center  z_ROUT_MANUAL,standardize prefix(z_)
quietly center  z_NON_ROUT_MANUAL_PHYS,standardize prefix(z_)

drop z_NON_ROUT_COG_ANALYT z_NON_ROUT_COGN_INTERP z_ROUT_COGNITIVE z_ROUT_MANUAL z_NON_ROUT_MANUAL_PHYS

ren z_z_NON_ROUT_COG_ANALYT		 Z_NON_ROUT_COG_ANALYT
ren z_z_NON_ROUT_COGN_INTERP 	 Z_NON_ROUT_COGN_INTERP
ren z_z_ROUT_COGNITIVE           Z_ROUT_COGNITIVE
ren z_z_ROUT_MANUAL              Z_ROUT_MANUAL
ren z_z_NON_ROUT_MANUAL_PHYS     Z_NON_ROUT_MANUAL_PHYS

label variable  Z_NON_ROUT_COG_ANALYT	"Non-Routine Cognitive Analytical" 
label variable  Z_NON_ROUT_COGN_INTERP  "Non-Routine Cognitive Interpersonal" 
label variable  Z_ROUT_COGNITIVE 		"Routine Cognitive" 
label variable  Z_ROUT_MANUAL   		"Routine Manual" 
label variable  Z_NON_ROUT_MANUAL_PHYS  "Non-Routine Manual Physical" 
label variable  SOC2010Code  			"Standard Occupation Code (2010)" 

save "/Users/elbagomeznavas/Desktop/raw_data/Intensity_Measure_ONet.dta", replace
