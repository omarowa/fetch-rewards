# Fetch Code Code Assessment by Omar Abouel Maaty
Located in this repo is my submission for Analytics Engineer - Coding Challenge.  
  
I utilized the software 7-Zip to extract the .gz files to json files. Following that, I used Python scripts to parse the JSON files and load tables into my localhost database. for this project I am using MySQL language. During this step, I discovered a data integrity issue with the User Json file.
  
I also noticed The rewardsReceiptItemList in the receipts.json is an array (list) of objects. Therefore, I seperated it into it's own table with a surrogate key, the receiptid and barcode to relate the receipt table and brand table together with that intermediate table.   

I utilized the software Vertabelo to construct the Entity Relationship Diagram.
  
Repo contents located in Fetch Rewards Code:
* 1st: ER Diagram folder (This folder contains a Entity Relationship diagram for the schema fetch)
  * fetch-reward-2024-11-09_23-18.png (ER Diagram Picture)
  * Information ER Diagram (Data dictionary)
    
* 2nd: SQL Queries
  * Query1.png (Image of query1.sql execution)
  * Query1.sql (This query file answers two questions listed in the coding assessment)
  * Query2.png (Image of query2.sql execution)
  * Query2.sql (This query file answers two questions listed in the coding assessment)
    
* 3rd: Data Quality Analysis
  * brands and barcode (folder containing analysis against brands table and barcode column)
      * Analysis brands and barcode.sql
      * Query1.png (Image of query execution)
      * Query2.png (image of query execution)
  * receipts (folder containing analysis against receipts table)
      * Analysis receipts and rewardsReceiptItems.sql 
      * Query1.png (Image of query execution)
      * Query2.png (image of query execution)
      * Query3.png (image of query execution)
  * users (folder containing analysis against users column)
      * Analysis.sql
      * Query1.png (Image of query execution)
      * Query2.png (image of query execution)
      * Query3.png (image of query execution)
            
* 4th: Communication with stakeholders
  * Email.txt (Email communication to stakeholders requested in coding assessment)
 
* Python Code Load JSON to SQL
  * Python Load Brands to SQL.py
  * Python Load Receipts to SQL.py
  * Python Load Users to SQL.py
  * Python Load RewardReceiptItems to SQL.py
  * Python User JSON uniqueness violation.py (This is to confirm there exists pure duplicate rows in the JSON file)
  * brands.json
  * receipts.json
  * users.json
    
* Table and Schema definitions (folder that contains table definitions for fetch schema)
  * brands.sql
  * receipts.sql
  * rewardsReceiptItems.sql
  * users.sql
 
