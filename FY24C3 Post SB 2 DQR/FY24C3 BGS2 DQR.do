***********FY24C3 BSG 2 DQR November 2024*******
/////////Key Areas for Data Quality Review/////////
    *

import delimited "C:\Users\RamandhanMasudi\Desktop\FY24C3 Post SB 2 DQR\FY24C3 BSG 2.csv"
des,short
br
rename (surveystarttime surveyendtime bmcyclename bsgprogresssurveyname bsgname bsgid bsgprogresssurveyid bsgmembers savingsmonthrecorded savingstotaltodate savinglastmonth attendancethismeeting attendancelastmeeting attendance2meetingsago bsgexecsfemale bsgexecsmale createddate createdbyfullname currentmembers newmembers originalbosdropped originalbosinbsg)(survey_start_time survey_end_time bm_cycle bsgprogresssurveyname bsg_name bsg_id bsgprogresssurveyid bsg_members savings_month_recorded savings_total_todate saving_last_month attendance_this_meeting attendance_last_meeting attendance_2_meetings_ago bsg_execs_female bsg_execs_male created_date mobileuser current_members new_members original_bos_dropped original_bos_in_bsg)
ta bm_cycle,mi

/*


                BM Cycle Name |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
         FY24C3 Annet Eyotaru |          2        5.00        5.00
         FY24C3 Charles Baker |          2        5.00       10.00
            FY24C3 David Bida |          2        5.00       15.00
          FY24C3 Edward Amono |          2        5.00       20.00
          FY24C3 Fauzu Ajidra |          2        5.00       25.00
      FY24C3 Glorious Ayikoru |          2        5.00       30.00
  FY24C3 Harmony Irene Faidah |          2        5.00       35.00
           FY24C3 Hellen Muna |          2        5.00       40.00
          FY24C3 Isaac Candia |          2        5.00       45.00
FY24C3 Jackline Julius Jokudu |          2        5.00       50.00
  FY24C3 Josline Peace Onyiru |          2        5.00       55.00
          FY24C3 Leila Zalika |          2        5.00       60.00
            FY24C3 Luke Avibo |          2        5.00       65.00
           FY24C3 Majid Taban |          2        5.00       70.00
        FY24C3 Modnes Akandru |          2        5.00       75.00
          FY24C3 Nassa Hindum |          2        5.00       80.00
          FY24C3 Nelson Adaku |          2        5.00       85.00
     FY24C3 Santino Ojas Ware |          2        5.00       90.00
            FY24C3 Umar Jurua |          2        5.00       95.00
     FY24C3 Yesua Aliki Uriah |          2        5.00      100.00
------------------------------+-----------------------------------
                        Total |         40      100.00
*/
ta mobileuser,mi
/*
Created By: Full Name |      Freq.     Percent        Cum.
----------------------+-----------------------------------
        Amina Drateru |          4       10.00       10.00
Caroline Dawa Godfrey |          2        5.00       15.00
     Esther Angunduru |          4       10.00       25.00
       Hidaya Driciru |          4       10.00       35.00
        Justine Ndugu |          4       10.00       45.00
       Kenedy Munguci |          2        5.00       50.00
        Nadia Manzubo |          4       10.00       60.00
          Nenisa Gire |          2        5.00       65.00
       Phillimon Waka |          4       10.00       75.00
   Sadam Khamis Banya |          2        5.00       80.00
         Swaibu Akimu |          4       10.00       90.00
      William Aluonzi |          2        5.00       95.00
       Zulaika Majuma |          2        5.00      100.00
----------------------+-----------------------------------
                Total |         40      100.00
*/
ta whysurveynotcompleted
/*

               Why Survey Not Completed |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
NOT APPLICABLE - THE SURVEY IS BEING .. |         40      100.00      100.00
----------------------------------------+-----------------------------------
                                  Total |         40      100.00
*/
ta current_members,mi
/*
  # Current |
    Members |      Freq.     Percent        Cum.
------------+-----------------------------------
         27 |          1        2.50        2.50
         29 |          3        7.50       10.00
         30 |         36       90.00      100.00
------------+-----------------------------------
      Total |         40      100.00
*/
li mobileuser bm_cycle bsg_id bsg_name if current_members<30
/*
-------------------------------------------------------------------------------------+
     |    mobileuser              bm_cycle   bsg_id                                bsg_name |
     |--------------------------------------------------------------------------------------|
 15. | Justine Ndugu    FY24C3 Hellen Muna     7224                                   Happy |
 16. | Justine Ndugu    FY24C3 Hellen Muna     7225                                  Baraka |
 23. |  Swaibu Akimu   FY24C3 Leila Zalika     7172                              NYARET BSG |
 28. | Nadia Manzubo    FY24C3 Majid Taban     7181   Delete Poverty Business Savings Group |
     +--------------------------------------------------------------------------------------+
*/
ta new_members,mi  // no members joined
ta original_bos_dropped,mi
/*
 # Original |
BOs Dropped |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |         32       80.00       80.00
          1 |          3        7.50       87.50
          3 |          1        2.50       90.00
         30 |          4       10.00      100.00
------------+-----------------------------------
      Total |         40      100.00
*/

li mobileuser bm_cycle bsg_id bsg_name if original_bos_dropped==30
/*
+---------------------------------------------------------------------------------+
     |    mobileuser                bm_cycle   bsg_id                         bsg_name |
     |---------------------------------------------------------------------------------|
  5. | Amina Drateru       FY24C3 David Bida     7226                            HAPPY |
  6. | Amina Drateru       FY24C3 David Bida     7227                            YUPET |
 18. | Amina Drateru     FY24C3 Isaac Candia     7145                            Unity |
 30. |  Swaibu Akimu   FY24C3 Modnes Akandru     7200   Tomore  Business Savings group |
     +---------------------------------------------------------------------------------+
*/
replace original_bos_dropped=0 if original_bos_dropped==30
ta original_bos_in_bsg,mi   //looks fine     

ta savings_month_recorded,mi
/*
 Savings |
      Month |
   Recorded |      Freq.     Percent        Cum.
------------+-----------------------------------
   November |          3        7.50        7.50
    October |         36       90.00       97.50
  September |          1        2.50      100.00
------------+-----------------------------------
      Total |         40      100.00
*/
li mobileuser bm_cycle bsg_id bsg_name if savings_month_recorded=="November"
/*
     +----------------------------------------------------------+
     |   mobileuser              bm_cycle   bsg_id     bsg_name |
     |----------------------------------------------------------|
  7. |  Nenisa Gire   FY24C3 Edward Amono     7222   TAKE HEART |
  8. |  Nenisa Gire   FY24C3 Edward Amono     7223    KONY BAAI |
 23. | Swaibu Akimu   FY24C3 Leila Zalika     7172   NYARET BSG |
     +----------------------------------------------------------+
*/
replace savings_month_recorded="October" if savings_month_recorded=="November"
ta savings_total_todate,mi  //looks fine
li mobileuser bm_cycle bsg_id bsg_name if savings_total_todate>=10000000
/*
 +-----------------------------------------------------------------------------+
     |     mobileuser              bm_cycle   bsg_id                      bsg_name |
     |-----------------------------------------------------------------------------|
 27. |  Nadia Manzubo    FY24C3 Majid Taban     7180   Hope Business Savings Group |
 31. | Kenedy Munguci   FY24C3 Nassa Hindum     7135                           JOY |
     +-----------------------------------------------------------------------------+
*/
ta saving_last_month,mi  //looks good
br bm_cycle bsg_id bsg_name saving_last_month savings_total_todate  //looks fine
ta attendance_this_meeting,mi
ta attendance_last_meeting,mi
ta attendance_2_meetings_ago,mi

