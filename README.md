# HOL Table Schema Evolution

This hands-on lab is designed for beginners and will guide you through the seamless evolution of a table schema using Snowflake.

Let's kick things off by copy-pasting the `hol_schema_table_evolution.sql` in a Snowsight Worksheet. The script will guide you over the steps described below.

## Step 1: Setup
Create the necessary objects:
- **Database:** HOL_DB
- **Schema:** HOL_SCHEMA_EVOLUTION
- **Stage:** BANK_TRANSACTION_FILE_STAGE
- **Virtual Warehouse:** HOL_WH
- **FileFormat:** HOL_BANK_TRANSACTION_CSV_FORMAT

## Step 2: Data Preparation
- Download the CSV files (bank_transaction_1.csv and bank_transaction_2.csv) from the GitHub repository.
- Upload the files to the staging area (BANK_TRANSACTION_FILE_STAGE) either via the PUT command or Snowsight UI.

## Step 3: Initial Table Setup
- Create a table using the `INFER_SCHEMA` option based on the structure of bank_transaction_1.csv.
- Verify the table definition using the `DESCRIBE` command.
- Load records from bank_transaction_1.csv using the `COPY` command.
- Confirm the successful loading of records.

## Step 4: Schema Evolution
- Enable schema evolution on the existing table, BANK_TRANSACTION_STAGING.
- Load records from bank_transaction_2.csv using the `COPY` command, which introduces two additional columns (risk_score and payment_node).
- Re-run the `DESCRIBE` command to view the modified table structure.
- Check the new loaded records.

Follow these steps to witness a smooth schema evolution in action!
