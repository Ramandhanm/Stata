*****Post PR DQR Template
****Last upcreated_dated: June 2024
	
	/*
	purpose of DQR: 
	-Check correct visit detail was selected and reasons for surveys not being completed
	-Create a time difference variable based on timestamps 
	-Investigate any duplicate surveys 
	-Check key variables for any data quality issues or missing data 
	-Create list of businesses that have not been surveyed yet 
	*/

	
*set up file paths
	cls
	clear
	set more off	
	local user = c(username)
	global fy24c1prdqr "/Users/`user'/Box/M&E/3- Implementation Partnerships/DREAMS/Uganda/FY24C1/Cycle Report Data/Businesses/Post PR Spot Checks"	
	//Note: please use forward slashes to accodomate both Mac and PCs
	
**import raw data 
	 
	import delimited "C:\Users\RamandhanMasudi\Downloads\FY24C1 DREAMS Business Exit.csv", varnames(1)
	des,short
    br
	rename (surveystarttime surveyendtime createddate createdbyfullname bmcyclename businessgroupid businessgroupname bizexpensesbusinessexit bizrevenuebusinessexit bizinventorybusinessexit bizcashbusinessexit bizinputbusinessexit prbusinesstype sbplannedbiztype sbplannedbiztypenotstarted sbplannedbiztypestarted whydeviatedfromsbplan biztypegroupcurrentlyoperating additionalbiztypesdetail ofbosdroppedbusinessexit bosdroppedbusinessexit groupsizeatpr prgrantvaluebusinessexit prgrantusedbusinessexit businessparticipationstatus reasonunabletoviewrecords visitnumber recordskept recordsuptodate datacollectionmethod whysurveynotcompleted whysurveynotconducteddetail)(surveystarttime surveyendtime created_date mobileuser bm_cycle bg_id bg_name biz_expenses biz_revenue biz_inventory biz_cash biz_input pr_biz_type sb_planned_biz_type sbplannedbiztypenotstarted sbplannedbiztypestarted whydeviatedfromsbplan biztypegroupcurrentlyoperating additionalbiztypesdetail of_bos_dropped bos_dropped groupsizeatpr pr_value pr_invested businessparticipationstatus reason_unabletoview_records visit_number records_kept records_uptodate data_collection_method whysurvey_not_completed why_surveynotconducted_detail)
		
**check survey completion 
	ta mobileuser, mi
	/*
	eated By: Full Name |      Freq.     Percent        Cum.
----------------------+-----------------------------------
        Amina Drateru |         40       10.05       10.05
Caroline Dawa Godfrey |         20        5.03       15.08
     Esther Angunduru |         30        7.54       22.61
       Hidaya Driciru |         41       10.30       32.91
        Justine Ndugu |         41       10.30       43.22
       Kenedy Munguci |         36        9.05       52.26
        Nadia Manzubo |         30        7.54       59.80
          Nenisa Gire |         20        5.03       64.82
       Phillimon Waka |         80       20.10       84.92
   Sadam Khamis Banya |         20        5.03       89.95
         Swaibu Akimu |         20        5.03       94.97
       Zulaika Majuma |         20        5.03      100.00
----------------------+-----------------------------------
                Total |        398      100.00
*/

	ta bm_cycle ,mi
	
/*
   BM Cycle Name |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
          FY24C1 Albert Atama |         20        5.03        5.03
         FY24C1 Annet Eyotaru |         20        5.03       10.05
         FY24C1 Charles Baker |         21        5.28       15.33
          FY24C1 Edward Amono |         20        5.03       20.35
          FY24C1 Fauzu Ajidra |         20        5.03       25.38
      FY24C1 Glorious Ayikoru |         20        5.03       30.40
  FY24C1 Harmony Irene Faidah |         20        5.03       35.43
           FY24C1 Hellen Muna |         20        5.03       40.45
          FY24C1 Isaac Candia |         20        5.03       45.48
FY24C1 Jackline Julius Jokudu |         20        5.03       50.50
  FY24C1 Josline Peace Onyiru |         20        5.03       55.53
          FY24C1 Leila Zalika |         20        5.03       60.55
            FY24C1 Luke Avibo |         17        4.27       64.82
           FY24C1 Majid Taban |         20        5.03       69.85
        FY24C1 Modnes Akandru |         21        5.28       75.13
          FY24C1 Nassa Hindum |         19        4.77       79.90
          FY24C1 Nelson Adaku |         20        5.03       84.92
     FY24C1 Santino Ojas Ware |         20        5.03       89.95
            FY24C1 Umar Jurua |         20        5.03       94.97
     FY24C1 Yesua Aliki Uriah |         20        5.03      100.00
------------------------------+-----------------------------------
                        Total |        398      100.00
*/
	
ta visit_number, mi //Note: confirm that all surveys were Post SB 2, if not then follow up with enum and insert feedback
	/* 
	
	Visit Number |      Freq.     Percent        Cum.
--------------+-----------------------------------
Business Exit |        398      100.00      100.00
--------------+-----------------------------------
        Total |        398      100.00

	*/
	
	ta whysurvey_not_completed	
	/*		
	 Why Survey Not Completed |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
NOT APPLICABLE - THE SPOT CHECK IS BE.. |        398      100.00      100.00
----------------------------------------+-----------------------------------
                                  Total |        398      100.00

	*/
	ta why_surveynotconducted_detail if whysurvey_not_completed == "Other"
	//None
	
	ta bm_cycle if visit_number == "Business Exit"
	/*

   BM Cycle Name |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
          FY24C1 Albert Atama |         20        5.03        5.03
         FY24C1 Annet Eyotaru |         20        5.03       10.05
         FY24C1 Charles Baker |         21        5.28       15.33
          FY24C1 Edward Amono |         20        5.03       20.35
          FY24C1 Fauzu Ajidra |         20        5.03       25.38
      FY24C1 Glorious Ayikoru |         20        5.03       30.40
  FY24C1 Harmony Irene Faidah |         20        5.03       35.43
           FY24C1 Hellen Muna |         20        5.03       40.45
          FY24C1 Isaac Candia |         20        5.03       45.48
FY24C1 Jackline Julius Jokudu |         20        5.03       50.50
  FY24C1 Josline Peace Onyiru |         20        5.03       55.53
          FY24C1 Leila Zalika |         20        5.03       60.55
            FY24C1 Luke Avibo |         17        4.27       64.82
           FY24C1 Majid Taban |         20        5.03       69.85
        FY24C1 Modnes Akandru |         21        5.28       75.13
          FY24C1 Nassa Hindum |         19        4.77       79.90
          FY24C1 Nelson Adaku |         20        5.03       84.92
     FY24C1 Santino Ojas Ware |         20        5.03       89.95
            FY24C1 Umar Jurua |         20        5.03       94.97
     FY24C1 Yesua Aliki Uriah |         20        5.03      100.00
------------------------------+-----------------------------------
                        Total |        398      100.00

	*/
keep if visit_number == "Business Exit"	

**confirm no business groups were surveyed more than once 
	duplicates report bg_id
/*
 --------------------------------------
   copies | observations       surplus
----------+---------------------------
        1 |          394             0
        2 |            4             2
--------------------------------------
*/
	duplicates tag bg_id, gen(Dups)
	ta Dups
	li surveystarttime mobileuser bm_cycle bg_id bg_name if Dups>=1
	
/*
     +---------------------------------------------------------------------------------+
     |   surveystarttime       mobileuser                bm_cycle   bg_id      bg_name |
     |---------------------------------------------------------------------------------|
 53. | 23/08/2024, 10:35    Justine Ndugu    FY24C1 Charles Baker   89013   Mungu Feni |
 54. | 29/08/2024, 12:28    Justine Ndugu    FY24C1 Charles Baker   89013   Mungu Feni |
284. | 26/08/2024, 15:26   Hidaya Driciru   FY24C1 Modnes Akandru   88033    Mungufeni |
285. | 26/08/2024, 16:11   Hidaya Driciru   FY24C1 Modnes Akandru   88033    Mungufeni |
     +---------------------------------------------------------------------------------+
*/
	drop if bg_name=="Mungu Feni" & surveystarttime=="23/08/2024, 10:35" // Data was mistakenly collected under the BG.
    drop if bg_name=="Mungufeni" & surveystarttime=="26/08/2024, 16:11" // Data was collected twice due confusions from the side of BOs
    drop if bg_id==88072 //The group wasn't funded for PR
**check timestamps of surveys and confirm no dubious submissions 
	gen str time_sta = substr(surveystarttime, 1,16)	 
	gen double dt_start = clock(time_sta, "DMY hm")
	format dt_start %tc
	
	gen str time_end = substr(surveyendtime, 1,16)
	gen double dt_end = clock(time_end, "DMY hm")
	format dt_end %tc
	
	gen time_diff = minutes(dt_end - dt_start)
	ta time_diff mobileuser
	sum time_diff //Note: insert the average time of the survey
		
	bysort mobileuser : sum time_diff //Note: probe further into enum's averages, min, max
	//drop if time_diff < 5 //Note: drop any surveys that are completed in an unreasonable amount of time unless double checked with the enum 
	//The enumerators who spend less than 5 minutes made editing on the job after saving that made Taroworks capture only the edit minutes.
	
**investigate key variables
	*record keeping
	ta records_kept, mi
	li bm_cycle bg_id bg_name if records_kept=="No"
	ta records_uptodate, mi //Note: confirm that all who said yes to having business records, answered this question 
	ta reason_unabletoview_records, mi //Note: flag any unusual reasons and send to BMs
	 
	*group memberships
	ta bos_dropped, mi
	ta of_bos_dropped, mi //Note: confirm that all who said yes to members dropping, answered this question 
    li bm_cycle bg_id bg_name records_kept bos_dropped of_bos_dropped if bos_dropped=="Yes"
	preserve
		keep if !missing(of_bos_dropped)
		keep bg_id bg_name groupsizeatpr bos_dropped of_bos_dropped
		order bg_id bg_name groupsizeatpr bos_dropped of_bos_dropped
		save "$fy24c1prdqr/Dta/FY24C1 BPS BOs dropped.dta", replace
	restore
	
	*pr grant use
	ta pr_value, mi //Note: confirm these are all typical amounts given for PR
	replace pr_value=240000 if pr_value==24000 // type mismatch for Enumerator
	ta pr_invested, mi 
	li bm_cycle bg_id bg_name pr_invested if pr_invested<=200000 // Most Businesses Fy24C1 Edward Amono, Tika 4 invested less PR Grand
    li bm_cycle bg_id bg_name pr_invested if pr_invested>240000 // Most Businesses Fy24C1 Edward Amono, Tika 4 invested less PR Grand
	replace pr_invested=240000 if pr_invested==2140000
	replace pr_invested=240000 if pr_invested==244000
	gen proportionprused = pr_invested / pr_value //Note: create var for proportion of PR used to confirm no errors
	ta proportionprused,mi	//Confirmed from the Enumerators about the less PR invested
	li bm_cycle mobileuser bg_id bg_name pr_invested proportionprused if proportionprused<1
	
	*business value    
	summ biz_input 
		ta biz_input //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	    br bm_cycle mobileuser biz_input pr_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name pr_invested proportionprused if biz_input<200000
	    br bm_cycle mobileuser biz_input pr_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name pr_invested proportionprused if biz_input>1000000
	    replace biz_input=185000 if bg_id==88129 // Enumerator forgot to include value for the phones worth 165000

	summ biz_inventory 
		ta biz_inventory //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	     
	summ biz_cash
		ta biz_cash //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	
	gen bizvalue = biz_input + biz_inventory + biz_cash
		summ bizvalue, detail
		ta bizvalue	//Note: flag any outliters that require follow up
	
	*business profit   
	summ biz_revenue 
		ta biz_revenue, mi //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	
	summ biz_expenses
		ta biz_expenses, mi //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	
	gen bizprofits = biz_revenue - biz_expenses
		summ bizprofits
		ta bizprofits //Note: flag any outliters for BMs i.e. 0 or negative profits 
		
		li mobileuser bm_cycle bg_id bg_name  pr_invested biz_expenses biz_revenue if bizprofits > 10000000, abb(20)
	
	save "$fy24c1prdqr/Dta/FY24C1 BPS DQR.dta", replace //Note save clean dta 
	
//Note: SF Upcreated_dates should be done manually according to the DQR issues addressed above once the DQR has been reviewed and approved by the manager 

