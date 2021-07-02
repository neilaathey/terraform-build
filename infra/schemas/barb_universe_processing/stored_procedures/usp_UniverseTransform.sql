BEGIN
    DECLARE varRow_count INT64;
    DECLARE result STRING;
    DECLARE data_rows INT64;
    DECLARE message STRING;
    
/*
EXAMPLE:

CALL `barb_universe_processing.usp_UniverseTransform`('B20200801.UNI.20200731173315.gz');

Versions
20210510 Neil - Deployed through terraform
20210525 Neil - Added ; to very end - to sync with deployed version

*/

    CREATE OR REPLACE TEMP TABLE tmpProcess_Log_Raw_Detail
      (
        ProcessName         STRING NOT NULL
        , ProcessType       STRING NOT NULL
        , ProcessMessage    STRING NOT NULL
        , ProcessDatetime   TIMESTAMP NOT NULL
        , DestinationTable  STRING
        , RowsProcessed     INT64
        , BARB_File_Name    STRING
        , Full_File_Name    STRING
      );

    --log results to temp table
    INSERT INTO tmpProcess_Log_Raw_Detail 
                (ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name)
        VALUES  ('usp_UniverseTransform', 'SP Start', 'Starting insert of data from staging to raw', CURRENT_TIMESTAMP(), 'barb_universe.universe_raw', NULL, file_name, file_name);
   
   
   --test stored proc handled exception--->
   -- RAISE USING MESSAGE = 'TEST HANDLED ERROR MESSAGE';

    --Get number of raw data rows to be loaded - minus header record
    SET data_rows = (SELECT Record_Count FROM `barb_universe_staging`.`Daily_Universe_File_Trailer_Record`  ) -1; --Minus header record - note: result should only hold 1 record - will error if >1 row
    
    
    --00 Log header/footer info      
     INSERT INTO `barb_universe`.`Universe_HeaderFooter`
        (
        File_Creation_Datetime
        , File_Type
        , File_Version
        , BARB_File_Name
        , File_Row_Count
        , Full_File_Name
        , Date_Loaded
        )
        SELECT 
            Header.File_Creation_Datetime
            , Header.File_Type
            , Header.File_Version
            , Header.File_Name AS BARB_File_Name
            , Footer.Record_Count AS File_Row_Count
            , Header.Full_File_Name
            , CURRENT_TIMESTAMP() AS Date_Loaded
        FROM `barb_universe_staging`.`Daily_Universe_File_Header_Record` AS Header
            INNER JOIN `barb_universe_staging`.`Daily_Universe_File_Trailer_Record` As Footer
                ON Footer.Full_File_Name = Header.Full_File_Name;
    
    SET varRow_count = @@row_count;

    --log results to temp table
    INSERT INTO tmpProcess_Log_Raw_Detail 
            (ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name)
    VALUES  ('usp_UniverseTransform', 'SP step', 'SP loaded header footer info', CURRENT_TIMESTAMP(), 'Universe_HeaderFooter',   varRow_count,   file_name,  file_name); 
        
    
    
    --01 Cleanup any existing records already loaded in Raw table
    DELETE FROM  barb_universe.Universe_Raw 
    WHERE Effective_from_date in (SELECT DISTINCT Effective_from_date FROM barb_universe_staging.Daily_Universe_File_Data_Record )   -- FORCED PARTITION QUERY CRITERIA FILTER
      AND Full_File_Name in (SELECT Full_File_Name FROM barb_universe_staging.Daily_Universe_File_Data_Record GROUP BY Full_File_Name )
      AND Full_File_Name = file_name;

    --02 Load Raw table with 
    INSERT INTO barb_universe.Universe_Raw
    (
        Full_File_Name ,
        Date_Loaded ,
        YearMonth , 
        Record_Type ,
        Effective_from_date ,
        Effective_to_date ,
        Reporting_Panel_Code ,
        Audience_Category_1 ,
        Audience_Category_2 ,
        Audience_Category_3 ,
        Audience_Category_4 ,
        Audience_Category_5 ,
        Audience_Category_6 ,
        Audience_Category_7 ,
        Audience_Category_8 ,
        Audience_Category_9 ,
        Audience_Category_10 ,
        Audience_Category_11 ,
        Audience_Category_12 ,
        Audience_Category_13 ,
        Audience_Category_14 ,
        Audience_Category_15 ,
        Audience_Category_16 ,
        Audience_Category_17 ,
        Audience_Category_18 ,
        Audience_Category_19 ,
        Audience_Category_20 ,
        Audience_Category_21 ,
        Audience_Category_22 ,
        Audience_Category_23 ,
        Audience_Category_24 ,
        Audience_Category_25 ,
        Audience_Category_26 ,
        Audience_Category_27 ,
        Audience_Category_28 ,
        Audience_Category_29 ,
        Audience_Category_30 ,
        Audience_Category_31 ,
        Audience_Category_32 ,
        Audience_Category_33 ,
        Audience_Category_34 ,
        Audience_Category_35 ,
        Audience_Category_36 ,
        Audience_Category_37 ,
        Audience_Category_38 ,
        Audience_Category_39 ,
        Audience_Category_40 ,
        Audience_Category_41 ,
        Audience_Category_42 ,
        Audience_Category_43 ,
        Audience_Category_44 ,
        Audience_Category_45 ,
        Audience_Category_46 ,
        Audience_Category_47 ,
        Audience_Category_48 ,
        Audience_Category_49 ,
        Audience_Category_50 ,
        Audience_Category_51 ,
        Audience_Category_52 ,
        Audience_Category_53 ,
        Audience_Category_54 ,
        Audience_Category_55 ,
        Audience_Category_56 ,
        Audience_Category_57 ,
        Audience_Category_58 ,
        Audience_Category_59 ,
        Audience_Category_60 ,
        Audience_Category_61 ,
        Audience_Category_62 ,
        Audience_Category_63 ,
        Audience_Category_64 ,
        Audience_Category_65 ,
        Audience_Category_66 ,
        Audience_Category_67 ,
        Audience_Category_68 ,
        Audience_Category_69 ,
        Audience_Category_70 ,
        Audience_Category_71 
    )

    SELECT 
      Full_File_Name ,
      Date_Loaded ,
      CAST(CONCAT(EXTRACT(YEAR FROM Effective_from_date ), SUBSTR(CONCAT('0', CAST(EXTRACT(MONTH FROM Effective_from_date ) as STRING)),-2)) as INT64) as YearMonth ,
      Record_Type ,
      Effective_from_date ,
      Effective_to_date ,
      Reporting_Panel_Code ,
      Audience_Category_1 ,
      Audience_Category_2 ,
      Audience_Category_3 ,
      Audience_Category_4 ,
      Audience_Category_5 ,
      Audience_Category_6 ,
      Audience_Category_7 ,
      Audience_Category_8 ,
      Audience_Category_9 ,
      Audience_Category_10 ,
      Audience_Category_11 ,
      Audience_Category_12 ,
      Audience_Category_13 ,
      Audience_Category_14 ,
      Audience_Category_15 ,
      Audience_Category_16 ,
      Audience_Category_17 ,
      Audience_Category_18 ,
      Audience_Category_19 ,
      Audience_Category_20 ,
      Audience_Category_21 ,
      Audience_Category_22 ,
      Audience_Category_23 ,
      Audience_Category_24 ,
      Audience_Category_25 ,
      Audience_Category_26 ,
      Audience_Category_27 ,
      Audience_Category_28 ,
      Audience_Category_29 ,
      Audience_Category_30 ,
      Audience_Category_31 ,
      Audience_Category_32 ,
      Audience_Category_33 ,
      Audience_Category_34 ,
      Audience_Category_35 ,
      Audience_Category_36 ,
      Audience_Category_37 ,
      Audience_Category_38 ,
      Audience_Category_39 ,
      Audience_Category_40 ,
      Audience_Category_41 ,
      Audience_Category_42 ,
      Audience_Category_43 ,
      Audience_Category_44 ,
      Audience_Category_45 ,
      Audience_Category_46 ,
      Audience_Category_47 ,
      Audience_Category_48 ,
      Audience_Category_49 ,
      Audience_Category_50 ,
      Audience_Category_51 ,
      Audience_Category_52 ,
      Audience_Category_53 ,
      Audience_Category_54 ,
      Audience_Category_55 ,
      Audience_Category_56 ,
      Audience_Category_57 ,
      Audience_Category_58 ,
      Audience_Category_59 ,
      Audience_Category_60 ,
      Audience_Category_61 ,
      Audience_Category_62 ,
      Audience_Category_63 ,
      Audience_Category_64 ,
      Audience_Category_65 ,
      Audience_Category_66 ,
      Audience_Category_67 ,
      Audience_Category_68 ,
      Audience_Category_69 ,
      Audience_Category_70 ,
      Audience_Category_71 
    FROM barb_universe_staging.Daily_Universe_File_Data_Record
    WHERE Full_File_Name = file_name;
    
    SET varRow_count = @@row_count;

    --log results to temp table
    INSERT INTO tmpProcess_Log_Raw_Detail 
      (ProcessName,                           ProcessType,       ProcessMessage,              ProcessDatetime,      DestinationTable,               RowsProcessed,  BARB_File_Name,     Full_File_Name)
    VALUES 
      ('usp_UniverseTransform', 'Raw load finish', 'load completed successfully', CURRENT_TIMESTAMP(), 'barb_universe.universe_raw',   varRow_count,   file_name,  file_name);
        
        
     --check rows loaded against log
     IF data_rows != varRow_count THEN
        SET message = CONCAT('ERROR - Number of rows loaded into Raw Universe table (', CAST(data_rows as STRING), ' rows) does not match log (', CAST(varRow_count as STRING), ' rows).');
        RAISE USING MESSAGE = message;
     END IF;
     
        
        
    --03 Cleanup any rows already loaded into main universe table
    DELETE FROM  barb_universe.Universe 
    WHERE Effective_from_date in (SELECT DISTINCT Effective_from_date FROM barb_universe_staging.Daily_Universe_File_Data_Record )   -- FORCED PARTITION QUERY CRITERIA FILTER
      AND Full_File_Name in (SELECT Full_File_Name FROM barb_universe_staging.Daily_Universe_File_Data_Record GROUP BY Full_File_Name )
      AND Full_File_Name = file_name;

    --04 INSERT staged rows into main nested version of universe table
    INSERT INTO barb_universe.Universe ( Date_Loaded, Full_File_Name, sare_no, sare_name, Reporting_Panel_code, Panel_Name, Split_Transmission_Indicator, Split_Area_Name, Split_Area_Factor, Effective_from_date, Effective_to_date, YearMonth, demo )
    SELECT Date_Loaded, Full_File_Name, sare_no, sare_name, Reporting_Panel_code, Panel_Name, Split_Transmission_Indicator,  Split_Area_Name, Split_Area_Factor, Effective_from_date, Effective_to_date, YearMonth, demo
    FROM barb_universe_processing.vw_tr5_barb_universe_demos_with_ITVtables
    WHERE Full_File_Name = file_name;
    
    SET varRow_count = @@row_count;

    --log results to temp table
    INSERT INTO tmpProcess_Log_Raw_Detail 
      (ProcessName,                           ProcessType,        ProcessMessage,              ProcessDatetime,      DestinationTable,             RowsProcessed,  BARB_File_Name,     Full_File_Name)
    VALUES 
      ('usp_UniverseTransform', 'Main load finish', 'load completed successfully', CURRENT_TIMESTAMP(), 'barb_universe.universe',    varRow_count,   file_name,  file_name);
        
    
    
    --Check rows loaded against source - get number of transformed data rows to be loaded
    SET data_rows = (SELECT COUNT(*) FROM barb_universe_processing.vw_tr5_barb_universe_demos_with_ITVtables WHERE Full_File_Name = file_name );
    
    IF data_rows != varRow_count THEN   
       SET message = CONCAT('ERROR - Number of rows loaded into Transformed Universe table (', CAST(varRow_count as STRING), ' rows) does not match source row count (', CAST(data_rows as STRING), ' rows).');
       RAISE USING MESSAGE = message;
    END IF; 
   
    --load results to perm log table
    INSERT INTO `barb_universe_processing`.`Process_Log` 
          (ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name)
    SELECT ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name
    FROM tmpProcess_Log_Raw_Detail;
    
    DROP TABLE IF EXISTS tmpProcess_Log_Raw_Detail;
    
    SET result='SUCCESS';
    SELECT result as proc_result;
    
    
    
EXCEPTION WHEN ERROR THEN
  BEGIN
      DECLARE result STRING;
      SET result = CONCAT('FAILURE --> ', @@error.message);
      SELECT result as proc_result;         -- this is not really used by the Python code - instead the raised error message is logged/surfaced

      INSERT INTO tmpProcess_Log_Raw_Detail (ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name)
          VALUES ('usp_UniverseTransform', 'SP Error', @@error.message, CURRENT_TIMESTAMP(), NULL, NULL, file_name, file_name);

      INSERT INTO `barb_universe_processing`.`Process_Log` 
            (ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name)
      SELECT ProcessName, ProcessType, ProcessMessage, ProcessDatetime, DestinationTable, RowsProcessed, BARB_File_Name, Full_File_Name
      FROM tmpProcess_Log_Raw_Detail;

      DROP TABLE IF EXISTS tmpProcess_Log_Raw_Detail;

      --FileRegister - increment the error count and add the error message to the Note
      UPDATE `barb_file_register.file_register`
          SET ProcessErrors = ProcessErrors + 1,
              Note = IF(Note IS NULL, '', Note || '. ') || @@error.message
          WHERE FileName = file_name;

      RAISE USING MESSAGE = 
          'ERROR in barb_universe.usp_UniverseTransform: ' || STRING(CURRENT_TIMESTAMP()) || '. ' || @@error.message;
  END;
END;
