/*******************************************************************************
 * Accountability System School Profiles                                       *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_PROFILE, sheets(`"`"Accountability Profile Data"' `"ACCOUNTABILITY PROFILE"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015 2016)

// Standardize variable names and value labels
kdestandardize, dropv(category next_yr_score *_py sch_type state_sch_id		 ///   
trend_display) schyrl(2) primaryk(schyr schid level grade)

// Sets the display order (e.g., column order) of the variables
order schyr schid distid schnum cntyid cntynm ncesid coop coopid distnm schnm ///   
overall rank classification reward baseline amogain amogoal amomet nextpartic ///   
gradgoal

// Saves the cleaned file
qui: save clean/acctProfile.dta, replace

/*******************************************************************************
 * Accountability System Summary                                               *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_SUMMARY, sheets(`"`"Accountability Summary Data"' `"ACCOUNTABILITY SUMMARY"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
qui: save clean/acctSummary.dta, replace


/*******************************************************************************
 * Accountability System ACT data											   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_ACT.xlsx, first case(lower) clear sheet(`"Public Schools"') allstring
tempfile act1
qui: save `act1'.dta, replace
kdecombo ASSESSMENT_ACT, sheets(`"`"Public Alternative Programs"' `"ACT Data"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
append using `act1'.dta
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)
qui: replace sch_year = substr(sch_year, 5, 8)

amogroup disagg_order, la(disagg_label) lan(amogroup)
destring schyr

qui: save clean/assessACT.dta, replace

/*******************************************************************************
 * Accountability System Explore data										   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_EXPLORE.xlsx, first case(lower) clear sheet(`"Public Alternate Programs"') allstring
tempfile explore
qui: save `explore'.dta, replace
kdecombo ASSESSMENT_EXPLORE, sheets(`"`"Public Schools"' `"EXPLORE Data"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `explore'.dta
qui: save clean/assessExplore.dta, replace

/*******************************************************************************
 * Accountability System Plan data	   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_PLAN.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
tempfile plan
qui: save `plan'.dta, replace
kdecombo ASSESSMENT_PLAN, sheets(`"`"Public Schools"' `"PLAN Data"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `plan'.dta
qui: save clean/assessPlan.dta, replace

/*******************************************************************************
 * Accountability System KPREP End of Course Assessment Data				   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_EOC.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
tempfile keoc
qui: save `keoc'.dta, replace

kdecombo ASSESSMENT_KPREP_EOC, y(2012 2012 2013 2014 2015 2016)				 ///    
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "'				 ///   
`"`"Assessment KPREP-EOC"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(schyr schid content grade amogroup) grade(100) 	 ///   
m(tested membership partic novice apprentice proficient distinguished) 


qui: save clean/assessEOC.dta, replace

/*******************************************************************************
 * Accountability System KPREP Grade Level Assessment Data					   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_GRADE.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
tempfile kgr
qui: save `kgr'.dta, replace
kdecombo ASSESSMENT_KPREP_GRADE, sheets(`"`"Public Schools"' `"Assessment KPREP Grades"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `kgr'.dta

kdecombo ASSESSMENT_KPREP_GRADE, y(2012 2012 2013 2014 2015 2016)			 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "' 				 ///   
`"`"Assessment KPREP Grades"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(schyr schid level content grade amogroup)		 ///   
m(tested membership partic novice apprentice proficient distinguished)


qui: save clean/assessKPREPgr.dta, replace

/*******************************************************************************
 * Accountability System KPREP Educational Level Assessment Data			   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_LEVEL.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
tempfile klev
qui: save `klev'.dta, replace
kdecombo ASSESSMENT_KPREP_LEVEL, sheets(`"`"Public Schools"' `"Assessment KPREP Level"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `klev'.dta

kdecombo ASSESSMENT_KPREP_LEVEL, y(2012 2012 2013 2014 2015 2016)			 ///    
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "'				 ///   
`"`"Assessment KPREP Level"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(schyr schid level content amogroup)				 ///   
m(tested membership partic novice apprentice proficient distinguished)

qui: save clean/assessKPREPlevel.dta, replace

qui: append using clean/assessEOC.dta
qui: append using clean/assessKPREPgr.dta
sort distid schid schlev content grade amogroup schyr
qui: egen x = rowmiss(novice apprentice proficient distinguished tested)
qui: drop if x == 5
qui: drop x
qui: save clean/kprep.dta, replace

/*******************************************************************************
 * Accountability System NRT Assessment Data	   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_NRT.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
tempfile nrt
qui: save `nrt'.dta, replace
kdecombo ASSESSMENT_NRT, sheets(`"`"Public Schools"' `"SAT-NRT"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `nrt'.dta

qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 1, 3) if mi(sch_number)
drop category sch_cd dist_name sch_name cntyno cntyname state_sch_id 		 ///   
ncesid coop coop_code sch_type
qui: replace sch_year = substr(sch_year, 5, 8)
rename (reading_percentile mathematics_percentile science_percentile social_percentile language_mechanics_percentile sch_year test_type dist_number sch_number)(pctile3 pctile2 pctile4 pctile5 pctile1 schyr testnm distid schid)
qui: replace testnm = "6"
foreach v of var pctile* {
	qui: replace `v' = ".s" if `v' == "***"
}
destring pctile* grade* testnm schyr, replace
reshape long pctile, i(distid schid schyr grade) j(content)
la def content 1 "Language Mechanics" 2 "Mathematics" 3 "Reading" 4 "Science" 5 "Social Studies" 6 "Writing" 7 "Algebra II" 8 "Biology" 9 "English II" 10 "U.S. History", modify

qui: save clean/assessNRT.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - College/Career Readiness Data   *
 ******************************************************************************/
kdecombo CTE_CAREER_CCR, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/cteCCR.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - Career Pathways Data	   *
 ******************************************************************************/
kdecombo CTE_CAREER_PATHWAYS, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/ctePathway.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - Perkins Program Data			   *
 ******************************************************************************/
kdecombo CTE_CAREER_PERKINS, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/ctePerkins.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - College & Career Readiness	 	   *
 ******************************************************************************/
import excel using raw/2012/DELIVERY_TARGET_CCR.xlsx, first case(lower) clear sheet(`"Delivery Target CCR"') allstring
tempfile `tgt'.dta, replace
kdecombo DELIVERY_TARGET_CCR, sheets(`"`"Delivery Target CCR"' `"Delivery Target CCR"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015 2016)
append using `tgt'.dta
kdestandardize, primarykey(schyr schid target)								 ///
m(ccr2010 ccr2011 ccr2012 ccr2013 ccr2014 ccr2015 ccr2016 ccr2017)
qui: save clean/targetCCR.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Graduation Rate Data	  		   *
 ******************************************************************************/
import excel using raw/2013/Delivery_TARGET_GRADUATION_RATE_COHORT.xlsx, first case(lower) clear sheet(`"Delivery Target Cohort Data"') allstring
tempfile `cohort'.dta, replace
kdecombo DELIVERY_TARGET_GRADUATION_RATE_COHORT, sheets(`"`"Delivery Target Cohort Data"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2013 2014 2015 2016)
append using `cohort'.dta
kdestandardize, primarykey(schyr schid cohort target amogroup)				 ///
m(cohort2013 cohort2014 cohort2015 reportyear2014 reportyear2016 reportyear2017 reportyear2018 reportyear2019 reportyear2020)
qui: save clean/targetGradRate.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Proficiency Gap Data		 	   *
 ******************************************************************************/
import excel using raw/2012/DELIVERY_TARGET_PROFICIENCY_GAP.xlsx, first case(lower) clear sheet(`"Delivery Target ProficiencyGap"') allstring
tempfile `gap'.dta, replace
kdecombo DELIVERY_TARGET_PROFICIENCY_GAP, sheets(`"`"Delivery Target ProficiencyGap"' `"Delivery Target Proficiency Gap"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015 2016)
append using `gap'.dta
kdestandardize, primarykey(schyr schid content amogroup target)				 ///
m(yr2014 yr2015 yr2016 yr2017 yr2018 yr2019)
qui: save clean/targetProfGap.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Kindergarten Readiness Screening   *
 ******************************************************************************/
import excel using raw/2014/DELIVERY_TARGET_KSCREEN.xlsx, first case(lower) clear sheet(`"Sheet 1"') allstring
tempfile `kscrn'.dta, replace
kdecombo DELIVERY_TARGET_KSCREEN, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2014 2015 2016)
append using `kscrn'.dta
kdestandardize, primarykey(schyr schid kstype target amogroup)				 ///
m(kscreen2013 kscreen2014 kscreen2015 kscreen2016 kscreen2017 kscreen2018)
qui: save clean/targetKScreen.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Program Review					   *
 ******************************************************************************/
import excel using raw/2014/DELIVERY_TARGET_PROGRAM_REVIEW.xlsx, first case(lower) clear sheet(`"Sheet 1"') allstring
tempfile `pr'.dta, replace
kdecombo DELIVERY_TARGET_PROGRAM_REVIEW, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2014 2015 2016)
append using `pr'.dta
kdestandardize, primarykey(schyr schid target ptargettype)					 ///
m(pr2013 pr2014 pr2015 pr2016 pr2017 pr2018
qui: save clean/targetProgramReview.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Student-Teacher Data	   *
 ******************************************************************************/
import excel using raw/2012/LEARNING_ENVIRONMENT_STUDENT-TEACHERS.xlsx, first case(lower) clear sheet(`"Sheet1"') allstring
tempfile `stdtch'.dta, replace
kdecombo LEARNING_ENVIRONMENT_STUDENTS-TEACHERS, sheets(`"`"Sheet1"' `"Sheet1"' `"Student-Teacher Detail"' `"Student-Teacher Detail"' `"Student - Teacher Detail"'"') y(2012 2013 2014 2015 2016)
append using `stdtch'.dta
kdestandardize, primarykey(schyr schid grade)								 ///
m(membershiptotal maletotal femaletotal whitemalecnt whitefemalecnt whitetotal blackmalecnt blackfemalecnt blacktotal hisapnicmalecnt hispanicfemalecnt hispanictotal asianmalecnt asianfemalecnt asiantotal ///
	aianmalecnt aianfemalecnt aiantotal hawaiianmalecnt hawaiianfemalecnt hawaiiantotal twoormoreracemalecnt twoormoreracefemalecnt twoormoreracetotal)
qui: save clean/envStudentTeacher.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Teaching Methods Data			   *
 ******************************************************************************/
import excel using raw/2013/LEARNING_ENVIRONMENT_TEACHING_METHODS.xlsx, first case(lower) clear sheet(`"TEACHING METHODS"') allstring
tempfile `mthd'.dta, replace
kdecombo LEARNING_ENVIRONMENT_TEACHING_METHODS, sheets(`"`"TEACHING METHODS"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2013 2014 2015 2016)
append using `mthd'.dta
kdestandardize, primarykey(schyr schid pedagogy)							 ///
m(onsiteclassroomcnt offsitectecnt offsitecollegecnt homehospitalcnt onlinecnt)
qui: save clean/envTeachingMethods.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Safety Data					   *
 ******************************************************************************/
import excel using raw/2012/LEARNING_ENVIRONMENT_SAFETY.xlsx, first case(lower) clear sheet(`"Safety Data"') allstring
tempfile `safe'.dta, replace
kdecombo LEARNING_ENVIRONMENT_SAFETY, sheets(`"`"Safety Data"' `"Safety Data"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015 2016)
append using `safe'.dta
kdestandardize, primarykey(schyr schid rpthdr rptln)						 ///
m(nwhite nblack nishp nasian naian npacisl nmulti nmale nfemale membership totevents)
qui: save clean/safety.dta, replace

/*******************************************************************************
 * Accountability System Program Review	Data								   *
 ******************************************************************************/
import excel using raw/2014/PROGRAM_REVIEW.xlsx, first case(lower) clear sheet(`"Sheet 1"') allstring
tempfile `pr'.dta, replace
kdecombo PROGRAM_REVIEW, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2014 2015 2016)
append using `pr'.dta
kdestandardize, primarykey(schyr schid level)								 ///
m(totpts totscore ahcurrandinst ahformandsumm ahprofdevandsup ahadminandsup ahtotalpoints ahclassification plcurrandinst plformandsumm plprofdevandsup pladminandsup pltotalpoints plclassification ///
wrcurrandinst wrformandsumm wrprofdevandsup wradminandsup wrtotalpoints wrclassification k3currandinst k3formandsumm k3profdevandsup k3adminandsup k3totalpoints k3classification ///
wlcurrandinst wlformandsumm wlprofdevandsup wladminandsup wltotalpoints wlclassification)
qui: save clean/programReview.dta, replace

/*******************************************************************************
 * Accountability System Participation Rates								   *
 ******************************************************************************/
tempfile part12 part13
import excel using raw/2012/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Participation Rate"') allstring
qui: save `part12'.dta, replace
import excel using raw/2013/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Participation Rate"') allstring
qui: save `part13'.dta, replace
kdecombo ACCOUNTABILITY_FEDERAL_DATA_PARTICIPATION_RATE, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
append using `part12'.dta
append using `part13'.dta
save clean/participationRates.dta, replace

/*******************************************************************************
 * Accountability System Daily Attendance Rates								   *
 ******************************************************************************/
tempfile oth12 oth13
import excel using raw/2012/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Other Indicators"') allstring
qui: save `oth12'.dta, replace
import excel using raw/2013/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Other Indicators"') allstring
qui: save `oth13'.dta, replace
kdecombo ACCOUNTABILITY_FEDERAL_DATA_ATTENDANCE, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
append using `oth12'.dta
append using `oth13'.dta
save clean/amoOtherIndicators.dta, replace

