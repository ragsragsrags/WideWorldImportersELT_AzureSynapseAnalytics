SET NOCOUNT ON

DECLARE @NewCutoff DATETIME = '1/1/2013'


select
	cities_count = (select count(*) from Application.Cities where @NewCutoff BETWEEN ValidFrom and ValidTo),
	cities_archive_count = (select count(*) from Application.Cities_Archive where ValidFrom <= @NewCutoff),
	countries_count = (select count(*) from Application.Countries where @NewCutoff BETWEEN ValidFrom and ValidTo),
	countries_archive_count = (select count(*) from Application.Countries_Archive where ValidFrom <= @NewCutoff),
	deliverymethods_count = (select count(*) from Application.DeliveryMethods where @NewCutoff BETWEEN ValidFrom and ValidTo),
	deliverymethods_archive_count = (select count(*) from Application.DeliveryMethods_Archive  where ValidFrom <= @NewCutoff),
	paymentmethods_count = (select count(*) from Application.PaymentMethods where @NewCutoff BETWEEN ValidFrom and ValidTo),
	paymentmethods_archive_count = (select count(*) from Application.PaymentMethods_Archive  where ValidFrom <= @NewCutoff),
	people_count = (select count(*) from Application.People where @NewCutoff BETWEEN ValidFrom and ValidTo),
	people_archive_count = (select count(*) from Application.People_Archive  where ValidFrom <= @NewCutoff),
	stateprovinces_count = (select count(*) from Application.StateProvinces where @NewCutoff BETWEEN ValidFrom and ValidTo),
	stateprovinces_archive_count = (select count(*) from Application.StateProvinces_Archive where ValidFrom <= @NewCutoff),
	transactiontypes_count = (select count(*) from Application.TransactionTypes where @NewCutoff BETWEEN ValidFrom and ValidTo),
	transactiontypes_archive_count = (select count(*) from Application.TransactionTypes_Archive  where ValidFrom <= @NewCutoff),
	purchaseorderlines_count = (select count(*) from Purchasing.PurchaseOrderLines where LastEditedWhen <= @NewCutoff),
	purchaseorders_count = (select count(*) from Purchasing.PurchaseOrders where LastEditedWhen <= @NewCutoff),
	suppliercategories_count = (select count(*) from Purchasing.SupplierCategories where @NewCutoff BETWEEN ValidFrom and ValidTo),
	suppliercategories_archive_count = (select count(*) from Purchasing.SupplierCategories_Archive where ValidFrom <= @NewCutoff),
	suppliers_count = (select count(*) from Purchasing.Suppliers where @NewCutoff BETWEEN ValidFrom and ValidTo),
	suppliers_archive_count = (select count(*) from Purchasing.Suppliers_Archive  where ValidFrom <= @NewCutoff),
	suppliertransactions_count = (select count(*) from Purchasing.SupplierTransactions where LastEditedWhen <= @NewCutoff),
	buyinggroups_count = (select count(*) from Sales.BuyingGroups where @NewCutoff BETWEEN ValidFrom and ValidTo),
	buyinggroups_archive_count = (select count(*) from Sales.BuyingGroups_Archive  where ValidFrom <= @NewCutoff),
	customercategories_count = (select count(*) from Sales.CustomerCategories where @NewCutoff BETWEEN ValidFrom and ValidTo),
	customercategories_archive_count = (select count(*) from Sales.CustomerCategories_Archive where ValidFrom <= @NewCutoff),
	customers_count = (select count(*) from Sales.Customers where @NewCutoff BETWEEN ValidFrom and ValidTo),
	customers_archive_count = (select count(*) from Sales.Customers_Archive  where ValidFrom <= @NewCutoff),
	customertransactions_count = (select count(*) from Sales.CustomerTransactions where LastEditedWhen <= @NewCutoff),
	invoicelines_count = (select count(*) from Sales.InvoiceLines where LastEditedWhen <= @NewCutoff),
	invoices_count = (select count(*) from Sales.Invoices where LastEditedWhen <= @NewCutoff),
	orderlines_count = (select count(*) from Sales.OrderLines where LastEditedWhen <= @NewCutoff),
	orders_count = (select count(*) from Sales.Orders where LastEditedWhen <= @NewCutoff),
	specialdeals_count = (select count(*) from Sales.SpecialDeals where LastEditedWhen <= @NewCutoff),
	colors_count = (select count(*) from Warehouse.Colors where @NewCutoff BETWEEN ValidFrom and ValidTo),
	colors_archive_count = (select count(*) from Warehouse.Colors_Archive where ValidFrom <= @NewCutoff),
	packagetypes_count = (select count(*) from Warehouse.PackageTypes where @NewCutoff BETWEEN ValidFrom and ValidTo),
	packagetypes_archive_count = (select count(*) from Warehouse.PackageTypes_Archive where ValidFrom <= @NewCutoff),
	stockgroups_count = (select count(*) from Warehouse.StockGroups where @NewCutoff BETWEEN ValidFrom and ValidTo),
	stockgroups_archive_count = (select count(*) from Warehouse.StockGroups_Archive where ValidFrom <= @NewCutoff),
	stockitemholdings_count = (select count(*) from Warehouse.StockItemHoldings where LastEditedWhen <= @NewCutoff),
	stockitems_count = (select count(*) from Warehouse.StockItems where @NewCutoff BETWEEN ValidFrom and ValidTo),
	stockitems_archive_count = (select count(*) from Warehouse.StockItems_Archive where ValidFrom <= @NewCutoff),
	stockitemstockgroups_count = (select count(*) from Warehouse.StockItemStockGroups  where LastEditedWhen <= @NewCutoff),
	stockitemtransactions_count = (select count(*) from Warehouse.StockItemTransactions  where LastEditedWhen <= @NewCutoff)
-- Start Cities

select
dimcity_count = (
	SELECT
		COUNT(*)
	FROM
		(
			SELECT
				C.CityID,
				C.CityName,
				[Location] = CAST(C.Location AS NVARCHAR(100)),
				[LatestRecordedPopulation] = ISNULL(C.LatestRecordedPopulation, 0),
				C.StateProvinceID
			FROM
				WideWorldImporters.Application.Cities C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo 

			UNION

			SELECT
				CA.CityID,
				CA.CityName,
				[Location] = CAST(CA.Location AS NVARCHAR(100)),
				[LatestRecordedPopulation] = ISNULL(CA.LatestRecordedPopulation, 0),
				CA.StateProvinceID
			FROM
				WideWorldImporters.Application.Cities_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo 
		) C LEFT JOIN
		(
			SELECT
				SP.StateProvinceID,
				SP.CountryID,
				SP.StateProvinceName,
				SP.SalesTerritory
			FROM
				WideWorldImporters.Application.StateProvinces SP
			WHERE
				@NewCutoff BETWEEN SP.ValidFrom AND SP.ValidTo 

			UNION

			SELECT
				SPA.StateProvinceID,
				SPA.CountryID,
				SPA.StateProvinceName,
				SPA.SalesTerritory
			FROM
				WideWorldImporters.Application.StateProvinces_Archive SPA
			WHERE
				@NewCutoff BETWEEN SPA.ValidFrom AND SPA.ValidTo
		) SP ON
			SP.StateProvinceID = C.StateProvinceID LEFT JOIN
		(
			SELECT
				C.CountryID,
				C.CountryName,
				C.Continent,
				C.Region,
				C.Subregion
			FROM
				WideWorldImporters.Application.Countries C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo 

			UNION

			SELECT
				CA.CountryID,
				CA.CountryName,
				CA.Continent,
				CA.Region,
				CA.Subregion
			FROM
				WideWorldImporters.Application.Countries_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) CA ON
			CA.CountryID = SP.CountryID

	-- End Cities
),


-- Start Customers
dimcustomer_count = (
SELECT
	COUNT(*)
FROM
	(
		SELECT 
			C.CustomerID,
			C.BillToCustomerID,
			C.CustomerCategoryID,
			C.PrimaryContactPersonID,
			C.BuyingGroupID,
			C.CustomerName,
			C.DeliveryPostalCode
		FROM
			WideWorldImporters.Sales.Customers C
		WHERE
			@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

		UNION

		SELECT 
			CA.CustomerID,
			CA.BillToCustomerID,
			CA.CustomerCategoryID,
			CA.PrimaryContactPersonID,
			CA.BuyingGroupID,
			CA.CustomerName,
			CA.DeliveryPostalCode
		FROM
			WideWorldImporters.Sales.Customers_Archive CA
		WHERE
			@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
	) C LEFT JOIN
	(
		SELECT 
			C.CustomerID,
			C.CustomerName,
			C.DeliveryPostalCode
		FROM
			WideWorldImporters.Sales.Customers C
		WHERE
			@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

		UNION

		SELECT 
			CA.CustomerID,
			CA.CustomerName,
			CA.DeliveryPostalCode
		FROM
			WideWorldImporters.Sales.Customers_Archive CA
		WHERE
			@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
	) BC ON
		BC.CustomerID = C.BillToCustomerID LEFT JOIN
	(
		SELECT
			CC.CustomerCategoryID,
			CC.CustomerCategoryName
		FROM
			WideWorldImporters.sales.CustomerCategories CC 
		WHERE
			@NewCutoff BETWEEN CC.ValidFrom AND CC.ValidTo

		UNION

		SELECT
			CCA.CustomerCategoryID,
			CCA.CustomerCategoryName
		FROM
			WideWorldImporters.sales.CustomerCategories_Archive CCA
		WHERE
			@NewCutoff BETWEEN CCA.ValidFrom AND CCA.ValidTo
	) CC ON
		CC.CustomerCategoryID = C.CustomerCategoryID LEFT JOIN
	(
		SELECT
			P.PersonID,
			P.FullName
		FROM
			WideWorldImporters.Application.People P 
		WHERE
			@NewCutoff BETWEEN P.ValidFrom AND P.ValidTo

		UNION

		SELECT
			PA.PersonID,
			PA.FullName
		FROM
			WideWorldImporters.Application.People_Archive PA
		WHERE
			@NewCutoff BETWEEN PA.ValidFrom AND PA.ValidTo
	) PA ON
		PA.PersonID = C.PrimaryContactPersonID LEFT JOIN
	(
		SELECT
			BG.BuyingGroupID,
			BG.BuyingGroupName
		FROM
			WideWorldImporters.Sales.BuyingGroups BG 
		WHERE
			@NewCutoff BETWEEN BG.ValidFrom AND BG.ValidTo

		UNION

		SELECT
			BGA.BuyingGroupID,
			BGA.BuyingGroupName
		FROM
			WideWorldImporters.Sales.BuyingGroups_Archive BGA
		WHERE
			@NewCutoff BETWEEN BGA.ValidFrom AND BGA.ValidTo
	) BG ON
		BG.BuyingGroupID = C.BuyingGroupID

-- End Customers
),

-- Start Employees
dimemployee_count = (
	SELECT
		COUNT(*)
	FROM
	(
		SELECT 
			P.PersonID,
			P.FullName,
			P.PreferredName,
			P.IsSalesperson,
			P.Photo
		FROM 
			WideWorldImporters.Application.People P 
		WHERE
			P.IsEmployee = 1 AND
			@NewCutoff BETWEEN P.ValidFrom AND P.ValidTo

		UNION

		SELECT 
			PA.PersonID,
			PA.FullName,
			PA.PreferredName,
			PA.IsSalesperson,
			PA.Photo
		FROM 
			WideWorldImporters.Application.People_Archive PA 
		WHERE
			PA.IsEmployee = 1 AND
			@NewCutoff BETWEEN PA.ValidFrom AND PA.ValidTo
	) a

-- End Employees
),

-- Start Payment Methods
dimpaymentmethod_count = (
	SELECT
		COUNT(*)
	FROM
	(
		SELECT
			PM.PaymentMethodID,
			PM.PaymentMethodName
		FROM
			WideWorldImporters.Application.PaymentMethods PM
		WHERE
			@NewCutoff BETWEEN PM.ValidFrom AND PM.ValidTo

		UNION

		SELECT
			PMA.PaymentMethodID,
			PMA.PaymentMethodName
		FROM
			WideWorldImporters.Application.PaymentMethods_Archive PMA
		WHERE
			@NewCutoff BETWEEN PMA.ValidFrom AND PMA.ValidTo
	) a
),

-- End Payment Methods


-- Start Stock Items
dimstockitem_count = (
	SELECT
		COUNT(*)
	FROM
		(
			SELECT
				[WWI Stock Item ID] = SI.StockItemID,
				[Stock Item] = SI.StockItemName,
				SI.ColorID,
				SI.OuterPackageID,
				SI.UnitPackageID,
				[Brand] = SI.Brand,
				[Size] = SI.Size,
				[Lead Time Days] = SI.LeadTimeDays,
				[Quantity Per Outer] = SI.QuantityPerOuter,
				[Is Chiller Stock] = SI.IsChillerStock,
				[Barcode] = SI.Barcode,
				[Tax Rate] = SI.TaxRate,
				[Unit Price] = SI.UnitPrice,
				[Recommended Retail Price] = SI.RecommendedRetailPrice,
				[Typical Weight Per Unit] = SI.TypicalWeightPerUnit,
				[Photo] = SI.Photo
			FROM
				WideWorldImporters.Warehouse.StockItems SI
			WHERE
				@NewCutoff BETWEEN SI.ValidFrom AND SI.ValidTo

			UNION

			SELECT
				[WWI Stock Item ID] = SIA.StockItemID,
				[Stock Item] = SIA.StockItemName,
				SIA.ColorID,
				SIA.OuterPackageID,
				SIA.UnitPackageID,
				[Brand] = SIA.Brand,
				[Size] = SIA.Size,
				[Lead Time Days] = SIA.LeadTimeDays,
				[Quantity Per Outer] = SIA.QuantityPerOuter,
				[Is Chiller Stock] = SIA.IsChillerStock,
				[Barcode] = SIA.Barcode,
				[Tax Rate] = SIA.TaxRate,
				[Unit Price] = SIA.UnitPrice,
				[Recommended Retail Price] = SIA.RecommendedRetailPrice,
				[Typical Weight Per Unit] = SIA.TypicalWeightPerUnit,
				[Photo] = SIA.Photo
			FROM
				WideWorldImporters.Warehouse.StockItems_Archive SIA
			WHERE
				@NewCutoff BETWEEN SIA.ValidFrom AND SIA.ValidTo
		) SI LEFT JOIN
		(
			SELECT
				C.ColorID,
				C.ColorName
			FROM
				WideWorldImporters.Warehouse.Colors C 
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.ColorID,
				CA.ColorName
			FROM
				WideWorldImporters.Warehouse.Colors_Archive CA 
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) C ON
			C.ColorID = SI.ColorID LEFT JOIN
		(
			SELECT
				PT.PackageTypeID,
				PT.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes PT 
			WHERE
				@NewCutoff BETWEEN PT.ValidFrom AND PT.ValidTo

			UNION

			SELECT
				PTA.PackageTypeID,
				PTA.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes_Archive PTA 
			WHERE
				@NewCutoff BETWEEN PTA.ValidFrom AND PTA.ValidTo
		) SP ON
			SP.PackageTypeID = SI.UnitPackageID LEFT JOIN
		(
			SELECT
				PT.PackageTypeID,
				PT.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes PT 
			WHERE
				@NewCutoff BETWEEN PT.ValidFrom AND PT.ValidTo

			UNION

			SELECT
				PTA.PackageTypeID,
				PTA.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes_Archive PTA 
			WHERE
				@NewCutoff BETWEEN PTA.ValidFrom AND PTA.ValidTo
		) BP ON
			BP.PackageTypeID = SI.OuterPackageID

	-- End Stock Items
),

-- Start Suppliers
dimsupplier_count = (
	SELECT
		COUNT(*)
	FROM
		(
			SELECT 
				S.SupplierID,
				S.SupplierCategoryID,
				S.PrimaryContactPersonID,
				S.SupplierName,
				S.SupplierReference,
				S.PaymentDays,
				S.DeliveryPostalCode
			FROM 
				WideWorldImporters.Purchasing.Suppliers S
			WHERE
				@NewCutoff BETWEEN S.ValidFrom AND S.ValidTo

			UNION

			SELECT
				SA.SupplierID,
				SA.SupplierCategoryID,
				SA.PrimaryContactPersonID,
				SA.SupplierName,
				SA.SupplierReference,
				SA.PaymentDays,
				SA.DeliveryPostalCode
			FROM
				WideWorldImporters.Purchasing.Suppliers_Archive SA
			WHERE
				@NewCutoff BETWEEN SA.ValidFrom AND SA.ValidTo
		) S LEFT JOIN
		(
			SELECT 
				SC.SupplierCategoryID,
				SC.SupplierCategoryName
			FROM
				WideWorldImporters.Purchasing.SupplierCategories SC 
			WHERE
				@NewCutoff BETWEEN SC.ValidFrom AND SC.ValidTo

			UNION

			SELECT
				SCA.SupplierCategoryID,
				SCA.SupplierCategoryName
			FROM
				WideWorldImporters.Purchasing.SupplierCategories_Archive SCA
			WHERE
				@NewCutoff BETWEEN SCA.ValidFrom AND SCA.ValidTo
		) SC ON
			SC.SupplierCategoryID = S.SupplierCategoryID LEFT JOIN
		(
			SELECT
				P.PersonID,
				P.FullName
			FROM
				WideWorldImporters.Application.People P
			WHERE
				@NewCutoff BETWEEN P.ValidFrom AND P.ValidTo

			UNION

			SELECT
				PA.PersonID,
				PA.FullName
			FROM
				WideWorldImporters.Application.People_Archive PA
			WHERE
				@NewCutoff BETWEEN PA.ValidFrom AND PA.ValidTo
		) P ON
			P.PersonID = S.PrimaryContactPersonID

	-- End Suppliers
),

-- Start Transaction Types
dimtransationtype_count = (
	SELECT
		COUNT(*)
	FROM
	(
		SELECT
			TT.[TransactionTypeID],
			TT.TransactionTypeName
		FROM
			WideWorldImporters.Application.TransactionTypes TT
		WHERE
			@NewCutoff BETWEEN TT.ValidFrom AND TT.ValidTo

		UNION 

		SELECT
			TTA.[TransactionTypeID],
			TTA.TransactionTypeName
		FROM
			WideWorldImporters.Application.TransactionTypes_Archive TTA
		WHERE
		@NewCutoff BETWEEN TTA.ValidFrom AND TTA.ValidTo
	) a

	-- End Transaction Types
),


-- Start Movement
fctmovement_count = (
	SELECT
		COUNT(*)
	FROM
		WideWorldImporters.Warehouse.StockItemTransactions SIT LEFT JOIN
		(
			SELECT
				SI.StockItemID,
				SI.StockItemName
			FROM
				WideWorldImporters.Warehouse.StockItems SI 
			WHERE
				@NewCutoff BETWEEN Si.ValidFrom AND SI.ValidTo

			UNION

			SELECT
				SIA.StockItemID,
				SIA.StockItemName
			FROM
				WideWorldImporters.Warehouse.StockItems_Archive SIA
			WHERE
				@NewCutoff BETWEEN SIA.ValidFrom AND SIA.ValidTo
		) SI ON
			SI.StockItemID = SIT.StockItemID LEFT JOIN
		(
			SELECT
				C.CustomerID,
				C.CustomerName
			FROM
				WideWorldImporters.Sales.Customers C 
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.CustomerID,
				CA.CustomerName
			FROM
				WideWorldImporters.Sales.Customers_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) C ON 
			C.CustomerID = SIT.CustomerID LEFT JOIN
		(
			SELECT
				S.SupplierID,
				S.SupplierName
			FROM
				WideWorldImporters.Purchasing.Suppliers S 
			WHERE
				@NewCutoff BETWEEN S.ValidFrom AND S.ValidTo

			UNION

			SELECT
				SA.SupplierID,
				SA.SupplierName
			FROM
				WideWorldImporters.Purchasing.Suppliers_Archive SA
			WHERE
				@NewCutoff BETWEEN SA.ValidFrom AND SA.ValidTo
		) S ON 
			S.SupplierID = SIT.SupplierID LEFT JOIN
		(
			SELECT
				TT.TransactionTypeID,
				TT.TransactionTypeName
			FROM
				WideWorldImporters.Application.TransactionTypes TT 
			WHERE
				@NewCutoff BETWEEN TT.ValidFrom AND TT.ValidTo

			UNION

			SELECT
				TTA.TransactionTypeID,
				TTA.TransactionTypeName
			FROM
				WideWorldImporters.Application.TransactionTypes_Archive TTA
			WHERE
				@NewCutoff BETWEEN TTA.ValidFrom AND TTA.ValidTo
		) TT ON 
			TT.TransactionTypeID = SIT.TransactionTypeID
	WHERE
		SIT.LastEditedWhen <= @NewCutoff

-- End Movements
),


-- Start Orders
fctorder_count = (
	SELECT
		COUNT(*)
	FROM
		WideWorldImporters.Sales.Orders O LEFT JOIN
		WideWorldImporters.Sales.OrderLines OL ON
			OL.OrderID = O.OrderID LEFT JOIN 
		(
			SELECT
				C.CustomerID,
				C.DeliveryCityID,
				C.CustomerName
			FROM
				WideWorldImporters.Sales.Customers C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.CustomerID,
				CA.DeliveryCityID,
				CA.CustomerName
			FROM
				WideWorldImporters.Sales.Customers_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) C ON
			C.CustomerID = O.CustomerID LEFT JOIN
		(
			SELECT
				C.CityID,
				C.CityName
			FROM
				WideWorldImporters.Application.Cities C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.CityID,
				CA.CityName
			FROM
				WideWorldImporters.Application.Cities_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) CI ON
			CI.CityID = C.DeliveryCityID LEFT JOIN
		(
			SELECT
				SI.StockItemID,
				SI.StockItemName
			FROM
				WideWorldImporters.Warehouse.StockItems SI 
			WHERE
				@NewCutoff BETWEEN SI.ValidFrom AND SI.ValidTo

			UNION

			SELECT
				SIA.StockItemID,
				SIA.StockItemName
			FROM
				WideWorldImporters.Warehouse.StockItems_Archive SIA 
			WHERE
				@NewCutoff BETWEEN SIA.ValidFrom AND SIA.ValidTo
		) SI ON
			SI.StockItemID = OL.StockItemID LEFT JOIN
		(
			SELECT
				P.PersonID,
				P.FullName
			FROM
				WideWorldImporters.Application.People P 
			WHERE
				@NewCutoff BETWEEN P.ValidFrom AND P.ValidTo

			UNION

			SELECT
				PA.PersonID,
				PA.FullName
			FROM
				WideWorldImporters.Application.People_Archive PA 
			WHERE
				@NewCutoff BETWEEN PA.ValidFrom AND PA.ValidTo
		) P ON
			P.PersonID = O.SalespersonPersonID LEFT JOIN
		(
			SELECT
				P.PersonID,
				P.FullName
			FROM
				WideWorldImporters.Application.People P 
			WHERE
				@NewCutoff BETWEEN P.ValidFrom AND P.ValidTo

			UNION

			SELECT
				PA.PersonID,
				PA.FullName
			FROM
				WideWorldImporters.Application.People_Archive PA 
			WHERE
				@NewCutoff BETWEEN PA.ValidFrom AND PA.ValidTo
		) P2 ON
			P2.PersonID = O.PickedByPersonID LEFT JOIN
		(
			SELECT
				PT.PackageTypeID,
				PT.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes PT 
			WHERE
				@NewCutoff BETWEEN PT.ValidFrom AND PT.ValidTo

			UNION

			SELECT
				PTA.PackageTypeID,
				PTA.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes_Archive PTA 
			WHERE
				@NewCutoff BETWEEN PTA.ValidFrom AND PTA.ValidTo
		) PT ON
			PT.PackageTypeID = OL.PackageTypeID
	WHERE
		O.LastEditedWhen <= @NewCutoff AND
		OL.LastEditedWhen <= @NewCutoff

	-- End Orders
),


-- Start Purchases
fctpurchase_count = (
	SELECT
		COUNT(*)
	FROM
		WideWorldImporters.Purchasing.PurchaseOrders PO LEFT JOIN
		WideWorldImporters.Purchasing.PurchaseOrderLines POL ON
			POL.PurchaseOrderID = PO.PurchaseOrderID LEFT JOIN
		(
			SELECT 
				S.SupplierID,
				S.SupplierName
			FROM
				WideWorldImporters.Purchasing.Suppliers S
			WHERE
				@NewCutoff BETWEEN S.ValidFrom AND S.ValidTo

			UNION

			SELECT 
				SA.SupplierID,
				SA.SupplierName
			FROM
				WideWorldImporters.Purchasing.Suppliers_Archive SA
			WHERE
				@NewCutoff BETWEEN SA.ValidFrom AND SA.ValidTo
		) S ON
			S.SupplierID = PO.SupplierID LEFT JOIN
		(
			SELECT
				SI.StockItemID,
				SI.StockItemName,
				SI.QuantityPerOuter
			FROM
				WideWorldImporters.Warehouse.StockItems SI 
			WHERE
				@NewCutoff BETWEEN SI.ValidFrom AND SI.ValidTo

			UNION

			SELECT
				SIA.StockItemID,
				SIA.StockItemName,
				SIA.QuantityPerOuter
			FROM
				WideWorldImporters.Warehouse.StockItems_Archive SIA
			WHERE
				@NewCutoff BETWEEN SIA.ValidFrom AND SIA.ValidTo
		) SI ON
			SI.StockItemID = POL.StockItemID LEFT JOIN
		(
			SELECT
				PT.PackageTypeID,
				PT.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes PT
			WHERE
				@NewCutoff BETWEEN PT.ValidFrom AND PT.ValidTo

			UNION

			SELECT
				PTA.PackageTypeID,
				PTA.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes_Archive PTA
			WHERE
				@NewCutoff BETWEEN PTA.ValidFrom AND PTA.ValidTo
		) PT ON
			PT.PackageTypeID = POL.PackageTypeID
	WHERE
		PO.LastEditedWhen <= @NewCutoff AND
		POL.LastEditedWhen <= @NewCutoff

	-- End Purchases
),


-- Start Sales
fctsale_count = (
	
	SELECT
		COUNT(*)
	FROM
		WideWorldImporters.Sales.Invoices I LEFT JOIN
		WideWorldImporters.Sales.InvoiceLines IL ON
			IL.InvoiceID = I.InvoiceID LEFT JOIN
		(
			SELECT
				C.CustomerID,
				C.CustomerName,
				C.DeliveryCityID
			FROM
				WideWorldImporters.Sales.Customers C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.CustomerID,
				CA.CustomerName,
				CA.DeliveryCityID
			FROM
				WideWorldImporters.Sales.Customers_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) CU ON
			CU.CustomerID = I.CustomerID LEFT JOIN
		(
			SELECT
				C.CityID,
				C.CityName
			FROM
				WideWorldImporters.Application.Cities C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.CityID,
				CA.CityName
			FROM
				WideWorldImporters.Application.Cities_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) C ON
			C.CityID = CU.DeliveryCityID LEFT JOIN
		(
			SELECT
				C.CustomerID,
				C.CustomerName
			FROM
				WideWorldImporters.Sales.Customers C
			WHERE
				@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

			UNION

			SELECT
				CA.CustomerID,
				CA.CustomerName
			FROM
				WideWorldImporters.Sales.Customers_Archive CA
			WHERE
				@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
		) BCU ON
			BCU.CustomerID = I.BillToCustomerID LEFT JOIN
		(
			SELECT
				SI.StockItemID,
				SI.StockItemName,
				SI.IsChillerStock
			FROM
				WideWorldImporters.Warehouse.StockItems SI
			WHERE
				@NewCutoff BETWEEN SI.ValidFrom AND SI.ValidTo

			UNION

			SELECT
				SIA.StockItemID,
				SIA.StockItemName,
				SIA.IsChillerStock
			FROM
				WideWorldImporters.Warehouse.StockItems_Archive SIA
			WHERE
				@NewCutoff BETWEEN SIA.ValidFrom AND SIA.ValidTo
		) SI ON
			SI.StockItemID = IL.StockItemID LEFT JOIN
		(
			SELECT
				P.PersonID,
				P.FullName
			FROM
				WideWorldImporters.Application.People P
			WHERE
				@NewCutoff BETWEEN P.ValidFrom AND P.ValidTo

			UNION

			SELECT
				PA.PersonID,
				PA.FullName
			FROM
				WideWorldImporters.Application.People_Archive PA
			WHERE
				@NewCutoff BETWEEN PA.ValidFrom AND PA.ValidTo
		) SP ON
			SP.PersonID = I.SalespersonPersonID LEFT JOIN
		(
			SELECT
				PT.PackageTypeID,
				PT.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes PT
			WHERE
				@NewCutoff BETWEEN PT.ValidFrom AND PT.ValidTo

			UNION

			SELECT
				PTA.PackageTypeID,
				PTA.PackageTypeName
			FROM
				WideWorldImporters.Warehouse.PackageTypes_Archive PTA
			WHERE
				@NewCutoff BETWEEN PTA.ValidFrom AND PTA.ValidTo
		) PT ON
			PT.PackageTypeID = IL.PackageTypeID
	WHERE	
		I.LastEditedWhen <= @NewCutoff AND
		IL.LastEditedWhen <= @NewCutoff 
	-- End Sales
),

-- Start Stock Holdings
fctstockholding_count = (
	SELECT 
		COUNT(*)
	FROM
		WideWorldImporters.Warehouse.StockItemHoldings SIH JOIN
		(
			SELECT
				SI.StockItemID,
				SI.StockItemName
			FROM
				WideWorldImporters.Warehouse.StockItems SI
			WHERE
				@NewCutoff BETWEEN SI.ValidFrom AND SI.ValidTo

			UNION

			SELECT
				SIA.StockItemID,
				SIA.StockItemName
			FROM
				WideWorldImporters.Warehouse.StockItems_Archive SIA
			WHERE
				@NewCutoff BETWEEN SIA.ValidFrom AND SIA.ValidTo
		) SI ON
			SI.StockItemID = SIH.StockItemID
	WHERE
		SIH.LastEditedWhen <= @NewCutoff

	-- End Stock Holdings
),

-- Start Transactions
fcttransaction_count = (
	SELECT
		COUNT(*)
	FROM
	(
		SELECT
			CT.TransactionDate,
			CT.CustomerTransactionID,
			CAST(NULL AS INT) AS SupplierTransactionID
		FROM
			WideWorldImporters.Sales.CustomerTransactions CT LEFT JOIN
			WideWorldImporters.Sales.Invoices I ON
				I.InvoiceID = CT.InvoiceID LEFT JOIN
			(
				SELECT
					C.CustomerID,
					C.CustomerName
				FROM
					WideWorldImporters.Sales.Customers C 
				WHERE
					@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

				UNION 

				SELECT
					CA.CustomerID,
					CA.CustomerName
				FROM
					WideWorldImporters.Sales.Customers_Archive CA 
				WHERE
					@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
			) C ON
				C.CustomerID = COALESCE(I.CustomerID, CT.CustomerID) LEFT JOIN
			(
				SELECT
					C.CustomerID,
					C.CustomerName
				FROM
					WideWorldImporters.Sales.Customers C 
				WHERE
					@NewCutoff BETWEEN C.ValidFrom AND C.ValidTo

				UNION 

				SELECT
					CA.CustomerID,
					CA.CustomerName
				FROM
					WideWorldImporters.Sales.Customers_Archive CA 
				WHERE
					@NewCutoff BETWEEN CA.ValidFrom AND CA.ValidTo
			) BC ON
				BC.CustomerID = CT.CustomerID LEFT JOIN
			(
				SELECT
					TT.TransactionTypeID,
					TT.TransactionTypeName
				FROM
					WideWorldImporters.Application.TransactionTypes  TT 
				WHERE
					@NewCutoff BETWEEN TT.ValidFrom AND TT.ValidTo

				UNION 

				SELECT
					TTA.TransactionTypeID,
					TTA.TransactionTypeName
				FROM
					WideWorldImporters.Application.TransactionTypes_Archive  TTA 
				WHERE
					@NewCutoff BETWEEN TTA.ValidFrom AND TTA.ValidTo
			) TT ON
				TT.TransactionTypeID = CT.TransactionTypeID LEFT JOIN
			(
				SELECT
					PM.PaymentMethodID,
					PM.PaymentMethodName
				FROM
					WideWorldImporters.Application.PaymentMethods PM 
				WHERE
					@NewCutoff BETWEEN PM.ValidFrom AND PM.ValidTo

				UNION 

				SELECT
					PMA.PaymentMethodID,
					PMA.PaymentMethodName
				FROM
					WideWorldImporters.Application.PaymentMethods_Archive PMA
				WHERE
					@NewCutoff BETWEEN PMA.ValidFrom AND PMA.ValidTo
			) PM ON
				PM.PaymentMethodID = CT.PaymentMethodID
		WHERE
			CT.LastEditedWhen <= @NewCutoff

		UNION ALL

		SELECT
			ST.TransactionDate,
			CAST(NULL AS INT),
			ST.SupplierTransactionID
		FROM
			WideWorldImporters.Purchasing.SupplierTransactions ST LEFT JOIN
			(
				SELECT
					S.SupplierID,
					S.SupplierName
				FROM
					WideWorldImporters.Purchasing.Suppliers S 
				WHERE
					@NewCutoff BETWEEN S.ValidFrom AND S.ValidTo

				UNION 

				SELECT
					SA.SupplierID,
					SA.SupplierName
				FROM
					WideWorldImporters.Purchasing.Suppliers_Archive SA 
				WHERE
					@NewCutoff BETWEEN SA.ValidFrom AND SA.ValidTo
			) S ON
				S.SupplierID = ST.SupplierID LEFT JOIN
			(
				SELECT
					TT.TransactionTypeID,
					TT.TransactionTypeName
				FROM
					WideWorldImporters.Application.TransactionTypes  TT 
				WHERE
					@NewCutoff BETWEEN TT.ValidFrom AND TT.ValidTo

				UNION 

				SELECT
					TTA.TransactionTypeID,
					TTA.TransactionTypeName
				FROM
					WideWorldImporters.Application.TransactionTypes_Archive  TTA 
				WHERE
					@NewCutoff BETWEEN TTA.ValidFrom AND TTA.ValidTo
			) TT ON
				TT.TransactionTypeID = ST.TransactionTypeID LEFT JOIN
			(
				SELECT
					PM.PaymentMethodID,
					PM.PaymentMethodName
				FROM
					WideWorldImporters.Application.PaymentMethods PM 
				WHERE
					@NewCutoff BETWEEN PM.ValidFrom AND PM.ValidTo

				UNION 

				SELECT
					PMA.PaymentMethodID,
					PMA.PaymentMethodName
				FROM
					WideWorldImporters.Application.PaymentMethods_Archive PMA
				WHERE
					@NewCutoff BETWEEN PMA.ValidFrom AND PMA.ValidTo
			) PM ON
				PM.PaymentMethodID = ST.PaymentMethodID
		WHERE
			ST.LastEditedWhen <= @NewCutoff
	) a

	-- End Transactions
)

