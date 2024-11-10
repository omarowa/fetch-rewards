# Fetch Code Code Assessment by Omar Abouel Maaty
Located in this repo is my submission for Analytics Engineer - Coding Challenge.  
  
I utilized the software 7-Zip to extract the .gz files to json files. Following that, I used Python scripts to parse the JSON files and load tables into my localhost database. for this project I am using MySQL language. During this step, I discovered a data integrity issue with the User Json file. I also noticed The rewardsReceiptItemList in the receipts.json is an array (list) of objects. Therefore, I seperated it into it's own table with the receiptid and barcode to relate the receipt table and brand table together with that intermediate table.   

I utilized the software Vertabelo to construct the Entity Relationship Diagram.
  
Repo contents located in Fetch Rewards Code:
* ER Diagram folder
  * This folder contains a Entity Relationship diagram for the schema fetch
 
* Python Code Load JSON to SQL
  * Python Load Brands to SQL.py
  * Python Load Receipts to SQL.py
  * Python Load Users to SQL.py
  * Python Load RewardReceiptItems to SQL.py
  * Python User JSON uniqueness violation.py (This is to confirm there exists pure duplicate rows in the JSON file)
  * brands.json
  * receipts.json
  * users.json
 
