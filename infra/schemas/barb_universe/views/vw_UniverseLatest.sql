WITH Universe as (
  SELECT Date_Loaded, Full_File_Name, Reporting_Panel_code, Split_Transmission_Indicator, Split_Area_Factor, Effective_from_date, Effective_to_date, YearMonth, demo 
  ,ROW_NUMBER() OVER (PARTITION BY Reporting_Panel_code, Split_Transmission_Indicator, Effective_from_date, Effective_to_date, YearMonth ORDER BY Date_Loaded DESC) as RecNo
  FROM barb_universe.Universe
)
SELECT Date_Loaded, Full_File_Name, Reporting_Panel_code, Split_Transmission_Indicator, Split_Area_Factor, Effective_from_date, Effective_to_date, YearMonth, demo
FROM Universe 
WHERE RecNo=1