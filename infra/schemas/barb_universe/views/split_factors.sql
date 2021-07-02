with factors as (
    SELECT p.Panel_Code, p.Panel_Name, ss.Split_Transmission_Indicator, ss.Split_Station_Name, IFNULL(ss.Split_Area_Factor,1) as Split_Area_Factor, ss.Reporting_Start_Date, ss.Reporting_End_Date
    FROM barb_master.Panel_Reporting as p
      LEFT OUTER JOIN barb_master.Split_Stations_Reporting as ss 
          ON p.Panel_Code=ss.Panel_Code AND p.Panel_Start_Date BETWEEN ss.Reporting_Start_Date AND ss.Reporting_End_Date
  )
  SELECT f.*, rs.sare_no, s.name as sare_name
  FROM factors as f
    --LEFT OUTER 
    JOIN landmark.Lmrssa AS rs ON f.panel_code=rs.rptng_panel_code
    JOIN landmark.Lmsare as s  ON rs.sare_no=s.sare_no
