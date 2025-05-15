***********Post SB2 DQR Template*************
***********Last updated: November 2024
	
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
**import raw data 
	 
	import delimited "C:\Users\RamandhanMasudi\Desktop\FY24C3 Post SB 2 DQR\FY24C3 BPS 2.csv", varnames(1)
	des,short
    br
	rename (surveystarttime surveyendtime createddate createdbyfullname bmcyclename businessgroupid businessgroupname bizexpenses bizrevenue bizinventory bizcash bizinputs sbbusinesstype sbplannedbiztype sbplannedbiztypenotstarted sbplannedbiztypestarted whydeviatedfromsbplan biztypegroupcurrentlyoperating additionalbiztypesdetail ofbosdropped bosdropped groupsizeat sbgrantvalue sbgrantused businessparticipationstatus reasonunabletoviewrecords visitnumber recordskept recordsuptodate datacollectionmethod whysurveynotcompleted whysurveynotconducteddetail)(surveystarttime surveyendtime created_date mobileuser bm_cycle bg_id bg_name biz_expenses biz_revenue biz_inventory biz_cash biz_input sb_biz_type sb_planned_biz_type sbplannedbiztypenotstarted sbplannedbiztypestarted whydeviatedfromsbplan biztypegroupcurrentlyoperating additionalbiztypesdetail of_bos_dropped bos_dropped groupsizeatsb sb_value sb_invested businessparticipationstatus reason_unabletoview_records visit_number records_kept records_uptodate data_collection_method whysurvey_not_completed why_surveynotconducted_detail)
		
**check survey completion 
	ta mobileuser, mi
	/*
Created By: Full Name |      Freq.     Percent        Cum.
----------------------+-----------------------------------
        Amina Drateru |         40       10.00       10.00
Caroline Dawa Godfrey |         20        5.00       15.00
     Esther Angunduru |         40       10.00       25.00
       Hidaya Driciru |         40       10.00       35.00
        Justine Ndugu |         40       10.00       45.00
       Kenedy Munguci |         20        5.00       50.00
        Nadia Manzubo |         40       10.00       60.00
          Nenisa Gire |         20        5.00       65.00
       Phillimon Waka |         40       10.00       75.00
   Sadam Khamis Banya |         20        5.00       80.00
         Swaibu Akimu |         40       10.00       90.00
      William Aluonzi |         20        5.00       95.00
       Zulaika Majuma |         20        5.00      100.00
----------------------+-----------------------------------
                Total |        400      100.00
*/

	ta bm_cycle ,mi
	
/*
     BM Cycle Name |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
         FY24C3 Annet Eyotaru |         20        5.00        5.00
         FY24C3 Charles Baker |         20        5.00       10.00
            FY24C3 David Bida |         20        5.00       15.00
          FY24C3 Edward Amono |         20        5.00       20.00
          FY24C3 Fauzu Ajidra |         20        5.00       25.00
      FY24C3 Glorious Ayikoru |         20        5.00       30.00
  FY24C3 Harmony Irene Faidah |         20        5.00       35.00
           FY24C3 Hellen Muna |         20        5.00       40.00
          FY24C3 Isaac Candia |         20        5.00       45.00
FY24C3 Jackline Julius Jokudu |         20        5.00       50.00
  FY24C3 Josline Peace Onyiru |         20        5.00       55.00
          FY24C3 Leila Zalika |         20        5.00       60.00
            FY24C3 Luke Avibo |         20        5.00       65.00
           FY24C3 Majid Taban |         20        5.00       70.00
        FY24C3 Modnes Akandru |         20        5.00       75.00
          FY24C3 Nassa Hindum |         20        5.00       80.00
          FY24C3 Nelson Adaku |         20        5.00       85.00
     FY24C3 Santino Ojas Ware |         20        5.00       90.00
            FY24C3 Umar Jurua |         20        5.00       95.00
     FY24C3 Yesua Aliki Uriah |         20        5.00      100.00
------------------------------+-----------------------------------
                        Total |        400      100.00
*/
	
ta visit_number, mi //Note: confirm that all surveys were Post SB 2, if not then follow up with enum and insert feedback
	/* 
	 Visit |
     Number |      Freq.     Percent        Cum.
------------+-----------------------------------
  Post SB 2 |        400      100.00      100.00
------------+-----------------------------------
      Total |        400      100.00
	*/
	
	ta whysurvey_not_completed	
	/*		
               why Survey Not Completed |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                    Business has failed |          1        0.25        0.25
NOT APPLICABLE - THE SPOT CHECK IS BE.. |        399       99.75      100.00
----------------------------------------+-----------------------------------
                                  Total |        400      100.00	
	*/
	drop if whysurvey_not_completed=="Business has failed"
	ta why_surveynotconducted_detail if whysurvey_not_completed == "Other"
	//None

**confirm no business groups were surveyed more than once 
	duplicates report bg_id
/*
    --------------------------------------
    copies    | observations       surplus
    ----------+---------------------------
        1     |          399             0
    --------------------------------------

*/
	
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
	li bm_cycle mobileuser bg_id bg_name if records_kept=="No"
	ta records_uptodate, mi //Note: confirm that all who said yes to having business records, answered this question 
	ta reason_unabletoview_records, mi //Note: flag any unusual reasons and send to BMs
	 
	*group memberships
	ta bos_dropped, mi
	ta of_bos_dropped, mi //Note: confirm that all who said yes to members dropping, answered this question 
    li bm_cycle bg_id bg_name records_kept bos_dropped of_bos_dropped if bos_dropped=="Yes"
	/*
	+------------------------------------------------------------------------------------------+
     |            bm_cycle    bg_id                    bg_name   record~t   bos_dr~d   of_bos~d |
     |------------------------------------------------------------------------------------------|
159. |  FY24C3 Hellen Muna    99705               Ngen ku Ngun        Yes        Yes          2 |
203. |  FY24C3 Majid Taban   100031   Ocemacen business groups        Yes        Yes          1 |
321. | FY24C3 Leila Zalika   100176                   PEACE BG        Yes        Yes          1 |
350. | FY24C3 Leila Zalika   100178                EMMANUEL BG        Yes        Yes          1 |
     +------------------------------------------------------------------------------------------+
     /// confirmed the members have dropped but follow-ups need to be done with BMs
   */
	*SB grant use
	ta sb_value, mi //Note: confirm these are all typical amounts given for sb
	replace sb_value=500000 if sb_value<500000
	ta sb_invested, mi 
	li mobileuser bm_cycle bg_id bg_name sb_invested if sb_invested<=300000 //  Confirmed the amount spend from enumerators
    /*
	+---------------------------------------------------------------------------------------------+
     |            mobileuser                   bm_cycle    bg_id                bg_name   sb_inv~d |
     |---------------------------------------------------------------------------------------------|
 40. |         Amina Drateru        FY24C3 Isaac Candia    99991             Stand Firm     300000 |
 41. | Caroline Dawa Godfrey   FY24C3 Santino Ojas Ware   100259      RIT-KU-WOPIOTH BG     300000 |
159. |         Justine Ndugu         FY24C3 Hellen Muna    99705           Ngen ku Ngun     160000 |
160. |         Justine Ndugu        FY24C3 Fauzu Ajidra    99667              Moribongo     280000 |
164. |         Justine Ndugu        FY24C3 Fauzu Ajidra    99660             Fanya Kazi     284000 |
     |---------------------------------------------------------------------------------------------|
202. |         Nadia Manzubo         FY24C3 Majid Taban   100037   Avaru Business Group     300000 |
251. |           Nenisa Gire        FY24C3 Edward Amono   100383              NOM DIANG     200000 |
291. |        Phillimon Waka       FY24C3 Charles Baker    99805               Ochogoru     216000 |
337. |          Swaibu Akimu        FY24C3 Leila Zalika   100173              LOKETA BG     151000 |
359. |          Swaibu Akimu        FY24C3 Leila Zalika   100174         GOD WITH US BG     250000 |
     +---------------------------------------------------------------------------------------------+

    */
	
	gen proportionsbused = sb_invested / sb_value     //Note: create var for proportion of sb used to confirm no errors
	ta proportionsbused,mi	//Confirmed from the Enumerators about the less sb invested
	br bm_cycle mobileuser bg_id bg_name sb_invested proportionsbused if proportionsbused<1
	
	*business value    
	summ biz_input 
		ta biz_input //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	    br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_input==0
	    li bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_input>1000000
        replace biz_input=20000 if bg_id==99671
		replace biz_input=40000 if bg_id==99661
		replace biz_input=65000 if bg_id==100402

	summ biz_inventory 
		ta biz_inventory //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	    br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_inventory<=100000
		br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_inventory>2000000
        br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_inventory==0
		replace biz_inventory=150000 if bg_id==99673
		replace biz_inventory=1190000 if bg_id==101084
        replace biz_inventory=360000 if bg_id==100163
		// Groups with zero inventory are mostly crops businesses with crops yet to be harvested
	summ biz_cash
		ta biz_cash //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	  	li bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_cash<=100000
        br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name sb_invested proportionsbused if biz_cash>=2000000
        // biz_input seem to match with the business types & the business inputs & inventories
	gen bizvalue = biz_input + biz_inventory + biz_cash
	summ bizvalue, detail
		ta bizvalue	//Note: flag any outliters that require follow up
	    br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name bizvalue sb_invested proportionsbused if bizvalue<=500000
	    br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name bizvalue sb_invested proportionsbused if bizvalue>=2000000
		// bizvalue matches with the business types 
	*business profit   
	summ biz_revenue 
		ta biz_revenue, mi //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	    br bm_cycle mobileuser biz_input sb_biz_type biz_inventory biz_cash records_uptodate bg_id bg_name bizvalue biz_revenue sb_invested proportionsbused if biz_revenue<=1000000
	    replace biz_revenue=2450000 if bg_id==100163
		replace biz_revenue=695000 if bg_id==100394
		replace biz_revenue=832400 if bg_id==100400
		replace biz_revenue=565000 if bg_id==100350
		//Biz_Value matches with the biz_revenues
		//Enumerators got all the information from the record books
		
	summ biz_expenses
		ta biz_expenses, mi //Note: look for any values like 99 or 999 which need to upcreated_dated to 0
	    replace biz_expenses=820000 if bg_id==100163
	    replace biz_expenses=207500 if bg_id==100394
	    replace biz_expenses=2840500 if bg_id==100400
	    replace biz_expenses=137000 if bg_id==100350
	gen bizprofits = biz_revenue - biz_expenses
		summ bizprofits
		ta bizprofits //Note: flag any outliters for BMs i.e. 0 or negative profits 
		li mobileuser bm_cycle bg_id bg_name  sb_invested biz_expenses biz_revenue if bizprofits==-398000
		li mobileuser bm_cycle bg_id bg_name  sb_invested biz_expenses biz_revenue if bizprofits==-244000
		li mobileuser bm_cycle bg_id bg_name  sb_invested biz_expenses biz_revenue if bizprofits > 10000000, abb(20)

	save "C:\Users\RamandhanMasudi\Desktop\FY24C3 Post SB 2 DQR\FY24C3 BPS 2 cleaned.dta", replace //Note save clean dta 


