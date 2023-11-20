/*
HOL:          Table Schema Evolution
Level:        Beginner
Version:      v1
Script:       hol_schema_table_evolution.sql         
Create Date:  2023-11-20
Author:       Matteo Consoli
*/

-- LET'S START! 

/*
----------------------------------------------------------------------------------
STEP 1
Let's get started by creating 
- Database: HOL_DB
- Schema: HOL_SCHEMA_EVOLUTION
- Stage: BANK_TRANSACTION_FILE_STAGE
- VWH: HOL_WH
- FileFormat HOL_BANK_TRANSACTION_CSV_FORMAT 
----------------------------------------------------------------------------------
*/
CREATE DATABASE IF NOT EXISTS HOL_DB;
CREATE SCHEMA IF NOT EXISTS HOL_DB.HOL_SCHEMA_EVOLUTION;
CREATE STAGE IF NOT EXISTS BANK_TRANSACTION_FILE_STAGE;
USE SCHEMA HOL_DB.HOL_SCHEMA_EVOLUTION;
CREATE WAREHOUSE IF NOT EXISTS HOL_WH
    WAREHOUSE_SIZE = 'XSmall' 
    AUTO_SUSPEND=60 
    AUTO_RESUME=True;
CREATE OR REPLACE FILE FORMAT HOL_DB.HOL_SCHEMA_EVOLUTION.HOL_BANK_TRANSACTION_CSV_FORMAT
    TYPE = CSV
    FIELD_DELIMITER = ','
    PARSE_HEADER = True
    NULL_IF = ('NULL', 'null')
    ERROR_ON_COLUMN_COUNT_MISMATCH=false;

/*
----------------------------------------------------------------------------------
STEP 2
- Download from GitHub Repository (bank_transaction_1.csv and bank_transaction_2.csv)
- Upload them to stage BANK_TRANSACTION_FILE_STAGE via PUT command or Snowsight UI 
----------------------------------------------------------------------------------
*/

-- NO SQL STEPS AVAILABLE. Load files into stage via UI.

/*
----------------------------------------------------------------------------------
STEP 3
- Create Table using INFER_SCHEMA from bank_transaction_1.csv file
- Check table definition using DESCRIBE
- Load records in bank_transaction_1.csv using COPY command 
- Check records loaded
----------------------------------------------------------------------------------
*/

CREATE OR REPLACE TABLE BANK_TRANSACTION_STAGING
  USING TEMPLATE (
    SELECT ARRAY_AGG(object_construct(*))
      FROM TABLE(
        INFER_SCHEMA(
          LOCATION=>'@BANK_TRANSACTION_FILE_STAGE/bank_transaction_1.csv',
          FILE_FORMAT=>'HOL_BANK_TRANSACTION_CSV_FORMAT'
        )
      ));

DESCRIBE TABLE BANK_TRANSACTION_STAGING;

COPY INTO BANK_TRANSACTION_STAGING
  FROM @BANK_TRANSACTION_FILE_STAGE/bank_transaction_1.csv
  FILE_FORMAT = HOL_BANK_TRANSACTION_CSV_FORMAT
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

SELECT * FROM BANK_TRANSACTION_STAGING;

/*
----------------------------------------------------------------------------------
STEP 3
- Enable schema evolution on the table BANK_TRANSACTION_STAGING
- Check table definition using DESCRIBE
- Load records in bank_transaction_2.csv using COPY command (2 more columns added)
- DESCRIBE table (table now has two more columns: risk_score and payment_node)
- Check loaded records
----------------------------------------------------------------------------------
*/
GRANT EVOLVE SCHEMA ON TABLE HOL_DB.HOL_SCHEMA_EVOLUTION.BANK_TRANSACTION_STAGING TO ROLE PUBLIC;
ALTER TABLE BANK_TRANSACTION_STAGING SET ENABLE_SCHEMA_EVOLUTION = TRUE;

COPY INTO BANK_TRANSACTION_STAGING
  FROM @BANK_TRANSACTION_FILE_STAGE/bank_transaction_2.csv
  FILE_FORMAT = HOL_BANK_TRANSACTION_CSV_FORMAT
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

DESCRIBE TABLE BANK_TRANSACTION_STAGING;

SELECT * FROM BANK_TRANSACTION_STAGING order by RISK_SCORE ASC;
