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
	clear
	local csvfiles: dir "$fy24c1prdqr/SF Report" files "*.csv"
	foreach file of local csvfiles {
		preserve
		quietly import delimited using "$fy24c1prdqr/SF Report/`file'" ,clear
		//quietly tostring livestock_land_size other_resources_used other_resource diversify_types diversify why_deviate businesstype_actual businesstype_pr_not_started businesstype_pr_started businesstype_pr records_noview_reason gps_coordinateslatitudeandlongit other_disposal drops records_upcreated_dated records nosurvey_reason failed_reason, replace //Note: convert vars to string for clean appends
		tempfile temp
		quietly save `temp',replace
		restore
		quietly append using `temp'
	} //Note: raw data imported should be from the TaroWorks form directly, checking for different versions of the form 
	
	des,short

	rename (surveystarttime surveyendtime createddate createdbyfullname bmcyclename businessgroupid businessgroupname bizexpensesbusinessexit bizrevenuebusinessexit bizinventorybusinessexit bizcashbusinessexit bizinputbusinessexit prbusinesstype sbplannedbiztype sbplannedbiztypenotstarted sbplannedbiztypestarted whydeviatedfromsbplan biztypegroupcurrentlyoperating additionalbiztypesdetail ofbosdroppedbusinessexit bosdroppedbusinessexit groupsizeatpr prgrantvaluebusinessexit prgrantusedbusinessexit businessparticipationstatus reasonunabletoviewrecords visitnumber recordskept recordsuptodate datacollectionmethod whysurveynotcompleted whysurveynotconducteddetail)(surveystarttime surveyendtime created_date mobileuser bm_cycle bg_id bg_name biz_expenses biz_revenue biz_inventory biz_cash biz_input pr_biz_type sb_planned_biz_type sbplannedbiztypenotstarted sbplannedbiztypestarted whydeviatedfromsbplan biztypegroupcurrentlyoperating additionalbiztypesdetail of_bos_dropped bos_dropped groupsizeatpr pr_value pr_invested businessparticipationstatus reason_unabletoview_records visit_number records_kept records_uptodate data_collection_method whysurvey_not_completed why_surveynotconducted_detail)
		
**check survey completion 
	ta mobileuser, mi
	
	ta bm_cycle ,mi
	
	ta visit_number, mi //Note: confirm that all surveys were Post SB 2, if not then follow up with enum and insert feedback
	/* 
	
	 Visit Number |      Freq.     Percent        Cum.
	--------------+-----------------------------------
	Business Exit |          9      100.00      100.00
	--------------+-----------------------------------
			Total |          9      100.00

	*/
	
	ta whysurvey_not_completed	
	/*		
				   Why Survey Not Completed |      Freq.     Percent        Cum.
	----------------------------------------+-----------------------------------
	NOT APPLICABLE - THE SPOT CHECK IS BE.. |          9      100.00      100.00
	----------------------------------------+-----------------------------------
									  Total |          9      100.00

	*/
	ta why_surveynotconducted_detail if whysurvey_not_completed == "Other"
	//None
	
	ta bm_cycle if visit_number == "Business Exit"
	/*

	  BM Cycle Name |      Freq.     Percent        Cum.
	-------------------+-----------------------------------
	FY24C1 Hellen Muna |          9      100.00      100.00
	-------------------+-----------------------------------
				 Total |          9      100.00


	*/


keep if visit_number == "Business Exit"	
**confirm no business groups were surveyed more than once 
	duplicates report bg_id
	//None

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
	ta records_uptodate, mi //Note: confirm that all who said yes to having business records, answered this question 
	ta reason_unabletoview_records, mi //Note: flag any unusual reasons and send to BMs
	 
	*group memberships
	ta bos_dropped, mi
	ta of_bos_dropped, mi //Note: confirm that all who said yes to members dropping, answered this question 

	preserve
		keep if !missing(of_bos_dropped)
		keep bg_id bg_name groupsizeatpr bos_dropped of_bos_dropped
		order bg_id bg_name groupsizeatpr bos_dropped of_bos_dropped
		save "$fy24c1prdqr/Dta/FY24C1 BPS BOs dropped.dta", replace
	restore
	
	*pr grant use
	ta pr_value, mi //Note: confirm these are all typical amounts given for PR
	
	ta pr_invested, mi 

	gen proportionprused = pr_invested / pr_value //Note: create var for proportion of PR used to confirm no errors
	li mobileuser bm_cycle bg_id bg_name  pr_invested biz_expenses biz_revenue if proportionprused > 1, abb(20)
		
	/*
		

	*/ // These two Business groups can not be located during and after the survey 

		
// 	Note: insert any feedback and make upcreated_dates in SF once manager has reviewed
	
	*business value    
	summ biz_input 
		ta biz_input //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	
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

