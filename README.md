# WideWorldImporters Extract-Load-Transform (ELT) in Azure Synapse Analytics

This is an ELT of WideWorldImporters in Azure Synapse Analytics IDE. I'm using Azure SQL Database for warehousing for practice development to save on cost.  I've tried it also on dedicated sql pool, the configurations are almost the same with some minor tweaks in the configuration.  

I have 3 pipelines created, 2 main pipelines.  LoadWideWorldImporters to Extract and Load data and WarehouseWideWorldImporters to Transform the loaded data to warehouse tables. 

<img width="1432" height="396" alt="image" src="https://github.com/user-attachments/assets/ed6fde9c-82af-4f78-8637-94c7edce6a8a" />

Source Database: Update this to azure

Warehouse Database: 

For validation, you may use WideWorldImporters_Count.sql in WideWorldImporters database and WideWorldImporters_Count.sql in WideWorldImportersWH database to check if the same count are in wwi.db and wwi_wh.db.  Just update the date in WideWorldImporters_Count.sql to the same date in the date you set in the pipeline.  

<img width="543" height="471" alt="image" src="https://github.com/user-attachments/assets/3508c69d-f8e7-49f2-9cf7-99b1bbaca12e" />

The date needs to start in 1/1/2013 and then you can increase date incrementally say 1/1/2014 and so on.  When this get published, you may need have to set it to utcdate.

