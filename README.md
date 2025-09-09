# WideWorldImporters Extract-Load-Transform (ELT) in Azure Synapse Analytics

This is an ELT of Microsoft's sample database WideWorldImporters in Azure Synapse Analytics. I'm using Azure SQL Database for warehousing for practice development to save on cost.  I've tried it also on dedicated sql pool, the configurations are almost the same with some minor tweaks in the configuration.  

I have created the following pipelines:

+ LoadWideWorldImporters - Extracts and Loads data into the warehouse database.  This is an incremental load based on the ValidFrom/ValidTo or LastEditedWhen field dates.  This can be a stand-alone pipeline but can also be integrated in another pipeline so that they have the same processing dates preventing loss of warehouse data. <img width="1407" height="396" alt="image" src="https://github.com/user-attachments/assets/43439bad-02c4-4573-9b61-87ef51cda6d3" />. You can use WWI_Tables.json file to configure the tables/columns that you need to loaded and set it to the Tables variable.
+ LoadWideWorldImportersTest - This is integrated in LoadWideWorldImporters pipeline to validate data processed.  This can also be stand-alone you just need to set the cutoff date properly. <img width="1498" height="391" alt="image" src="https://github.com/user-attachments/assets/22cd4af3-1afa-4694-8339-4b3a2c525a4d" />. You will also need to configure which tables you need validated using WWI_Validate_Conf.json and set it to the Default Value of Tables variable. 
+ WarehouseWideWorldImporters - Transforms the loaded data into the warehouse tables.  LoadWideWorldImporters pipeline is integrated in the process so latest data gets always loaded before the transformation.<img width="1485" height="281" alt="image" src="https://github.com/user-attachments/assets/14bc7450-b967-4f43-8d61-512059617ea1" />. You can use WWI_WH_Dimension.json and WWI_WH_Fact.json files to configure which warehouse tables you want processed and set it to the Fact_Items and Dimension_Items parameters.
+ ProcessWideWorldImportersTable - This will process the transformation of data to its warehouse table.  I've created this one so it could be re-used.  In WarehouseWideWorldImporters, I've created a loop to process the warehouse tables and executes this pipeline. <img width="1074" height="286" alt="image" src="https://github.com/user-attachments/assets/a007bb7b-fc70-40eb-88d8-c5fc40253945" />
+ WarehouseWideWorldImportersTest - This is integrated in WarehouseWideWorldImporters pipeline to validate data processed.  This can also be stand-alone you just need to set the cutoff data propertly. <img width="827" height="385" alt="image" src="https://github.com/user-attachments/assets/c0f9b816-e72c-48ab-8039-345f75fdd0a7" />. You can use the WWI_WH_Validate_Conf.json to configure the validations you want implemented and set it to the TableValidations variable.  Here is the sample: <img width="1025" height="735" alt="image" src="https://github.com/user-attachments/assets/c909404e-a361-411f-9083-9b24cf91e315" />.  The following are the type of validations included:
     + ValidationSPs - Custom sps to validate a warehouse table.
     + NotNullFields - Fields you want to validate as not nulls.
     + UniqueFields - Fields you want to validate as unique including null value.
     + NotNullUniqueFields - Fields you want to validate as unique not including the null values.
     + ForeignKeyFields - Fields you want to validate as constrained to primary table fields. The tables used for warehousing here is already constrained properly in the table level but this should come useful when tables warehouse are not constrained.
+ WarehouseWideWorldImportersValidationSPTests - This is integrated in WarehouseWideWorldImportersTest to process the validation stored procedures. <img width="561" height="290" alt="image" src="https://github.com/user-attachments/assets/a00427ba-2aa6-4db2-bc73-64e5bc976a6d" />


These are the bacpac files you can restore in Azure with the stored procedures added.

+ Source Database: https://uelness-my.sharepoint.com/:u:/g/personal/ruelragpa_uelness_onmicrosoft_com/EdzjfEb0udxJkC2gH8pKAOEBgSjiaNl0bB11i4HI8B3vSw?e=DcnuIe
+ Warehouse Database: https://uelness-my.sharepoint.com/:u:/g/personal/ruelragpa_uelness_onmicrosoft_com/EQUKKovrHPNEqQJcfuK2R7kB-OtN8n7Cf-baIP55KgFxhA?e=npZnO7

The date needs to start at least in 1/1/2013 and then you can increase date incrementally say 1/1/2014 and so on.  When this gets published, you may need have to set it to utcdate.

<img width="543" height="471" alt="image" src="https://github.com/user-attachments/assets/3508c69d-f8e7-49f2-9cf7-99b1bbaca12e" />

You can see the logs in the following tables in WideWorldImportersWH database:
+ Integration.LoadHistory - The load history status per table and cutoff date
+ Integration.WarehouseHistory - The warehouse history status per table and cutoff date
+ Integration.DataValidationErrors - Data validation errors found in LoadWideWorldImportersTest and WarehouseWideWorldImportersTest pipelines
