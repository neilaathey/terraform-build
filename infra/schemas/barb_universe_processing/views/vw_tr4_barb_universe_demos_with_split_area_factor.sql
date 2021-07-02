SELECT u.Date_Loaded, u.Full_File_Name, u.Reporting_Panel_code, p.Panel_Name
, uf.Split_Transmission_Indicator, uf.Split_Area_Name, IFNULL(uf.Split_Area_Factor,1) as Split_Area_Factor, u.Effective_from_date, u.Effective_to_date
, CAST(CONCAT(EXTRACT(YEAR FROM Effective_from_date ), SUBSTR(CONCAT('0', CAST(EXTRACT(MONTH FROM Effective_from_date ) as STRING)),-2)) as INT64) as YearMonth
--, demo
,u.Category_No, u.value, u.Audience_Short_Description, u.BARB_Audience_Category_Code, u.Audience_Description, u.Source
FROM barb_universe_processing.vw_tr3_barb_universe_demos as u
  --LEFT OUTER 
  JOIN barb_master.Panel_Reporting as p 
    ON u.Reporting_Panel_code = p.Panel_Code
      AND u.Effective_from_date BETWEEN p.Panel_Start_Date AND IFNULL(p.Panel_End_Date,'2037-12-31')
  LEFT OUTER JOIN barb_master.Universe_Factor as uf
    ON u.Reporting_Panel_code = uf.Panel_Code 
      and u.Effective_from_date BETWEEN uf.Reporting_Start_Date AND IFNULL(uf.Reporting_End_Date,'2037-12-31')