# WideWorldImporters Extract-Load-Transform (ELT) in Azure Synapse Analytics

This is an ELT of Microsoft's sample database WideWorldImporters in Azure Synapse Analytics. I'm using Azure SQL Database for warehousing for practice development to save on cost.  I've tried it also on dedicated sql pool, the configurations are almost the same with some minor tweaks in the configuration.  

I have created the following pipelines:
     + LoadWideWorldImporters - Extracts and Loads data into the warehouse database.  This is an incremental load based on the ValidFrom/ValidTo or LastEditedWhen field dates.  This can be a stand-alone pipeline but can also be integrated in another pipeline so that they have the same processing dates preventing loss of warehouse data.    
     + WarehouseWideWorldImporters - Transforms the loaded data into the warehouse tables.  LoadWideWorldImporters pipeline is included in the process so latest data gets always loaded before the transformation.  
     + ProcessWideWorldImportersTable - This processing the transformation of data by warehouse table.  I've created this one so it could be re-used.  In WarehouseWideWorldImporters, I've created a loop to process the warehouse tables and executes this pipeline.

<img width="1432" height="396" alt="image" src="https://github.com/user-attachments/assets/ed6fde9c-82af-4f78-8637-94c7edce6a8a" />

These are the bacpac files you can restore in Azure with the stored procedures added.

Source Database: https://uelness-my.sharepoint.com/:u:/g/personal/ruelragpa_uelness_onmicrosoft_com/EdzjfEb0udxJkC2gH8pKAOEBgSjiaNl0bB11i4HI8B3vSw?e=DcnuIe
Warehouse Database: https://uelness-my.sharepoint.com/:u:/g/personal/ruelragpa_uelness_onmicrosoft_com/EQUKKovrHPNEqQJcfuK2R7kB-OtN8n7Cf-baIP55KgFxhA?e=npZnO7

For validation, you may use WideWorldImporters_Count.sql in WideWorldImporters database and WideWorldImportersWH_Count.sql in WideWorldImportersWH database to check if the same count are in wwi.db and wwi_wh.db.  Just update the date in WideWorldImporters_Count.sql to the same date set in the pipeline.  

<img width="543" height="471" alt="image" src="https://github.com/user-attachments/assets/3508c69d-f8e7-49f2-9cf7-99b1bbaca12e" />

The date needs to start in 1/1/2013 and then you can increase date incrementally say 1/1/2014 and so on.  When this gets published, you may need have to set it to utcdate.

