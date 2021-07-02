WITH Universes AS (
  SELECT rs.sare_no, rs.name as sare_name
  --, u.* EXCEPT(value)
  
,  u.Date_Loaded, u.Full_File_Name, u.Reporting_Panel_code, u.Panel_Name
, u.Split_Transmission_Indicator, u.Split_Area_Name, u.Split_Area_Factor, u.Effective_from_date, u.Effective_to_date
, u.YearMonth
, u.Category_No, u.Audience_Short_Description, u.BARB_Audience_Category_Code, u.Audience_Description, u.Source
  , CAST(ROUND((Split_Area_Factor * cast(value as FLOAT64)) * 1000,0) as INT64) as Universe_Value
  FROM barb_universe_processing.vw_tr4_barb_universe_demos_with_split_area_factor as u 
    LEFT OUTER 
    JOIN `landmark.vwRssa_Sare` as rs
      ON u.Reporting_Panel_code = rs.Panel_code 
        and u.Effective_from_date BETWEEN rs.StartDate AND IFNULL(rs.EndDate,'2037-12-31')
      WHERE 1=1
        AND (u.Split_Transmission_Indicator = rs.sti OR u.Split_Transmission_Indicator IS NULL )
)
SELECT u.Full_File_Name, u.Date_Loaded, u.sare_no, u.sare_name, u.Reporting_Panel_code, u.Panel_Name
, u.Split_Transmission_Indicator, u.Split_Area_Name, u.Split_Area_Factor, u.Effective_from_date, u.Effective_to_date, u.YearMonth
,array_agg(STRUCT(u.Category_No, u.Universe_Value, u.Audience_Short_Description, u.BARB_Audience_Category_Code, u.Audience_Description, u.Source)) as demo
FROM Universes as u
GROUP BY u.sare_no, u.sare_name, u.Date_Loaded, u.Full_File_Name, u.Reporting_Panel_code, u.Panel_Name
, u.Split_Transmission_Indicator, u.Split_Area_Name, u.Split_Area_Factor, u.Effective_from_date, u.Effective_to_date, u.YearMonth