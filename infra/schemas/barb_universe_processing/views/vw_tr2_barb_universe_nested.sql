WITH audiences as (
  SELECT Effective_from_date, Reporting_Panel_code, Effective_to_date,Full_File_Name, Date_Loaded,
  unpivotted.*
  FROM `barb_universe_processing.vw_tr1_Daily_Universe_File_Data_Record_PlusDerivedAudiences` a
    , UNNEST(tools.unpivot(a, 'Audience_Category_[0-9]')) unpivotted
)
SELECT Full_File_Name, Date_Loaded, Effective_from_date, Reporting_Panel_code,Effective_to_date
  ,array_agg(STRUCT(CAST(REPLACE(key,'Audience_Category_','') as INT64) as Category_No,value) ORDER BY CAST(REPLACE(key,'Audience_Category_','') as INT64)) as Audience
FROM audiences
GROUP BY Full_File_Name ,Date_Loaded, Effective_from_date, Reporting_Panel_code, Effective_to_date