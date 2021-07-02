WITH uni as (
  SELECT Full_File_Name, Date_Loaded, Effective_from_date, Reporting_Panel_code, Effective_to_date, a.Category_No, a.value 
  FROM barb_universe_processing.vw_tr2_barb_universe_nested as n
    CROSS JOIN UNNEST(n.Audience) as a
)
SELECT u.Full_File_Name, u.Date_Loaded, u.Effective_from_date, u.Reporting_Panel_code, u.Effective_to_date
,u.Category_No, u.value, ac.Audience_Short_Description, ac.BARB_Audience_Category_Code, ac.Audience_Description, ac.Source
FROM uni as u
  LEFT OUTER JOIN barb_master.vw_AudienceCategoryCodes as ac     
    on u.Category_No=ac.Audience_Category_No
