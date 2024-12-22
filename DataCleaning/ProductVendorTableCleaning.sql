SELECT * FROM [AdventureWorks2019].[Purchasing].[ProductVendor]


----Verification des types de donnees
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='Purchasing' AND TABLE_NAME='ProductVendor'



----code pour vérifier les valeurs manquantes par colonne dans la table ProductVendor
DECLARE @TableName NVARCHAR(MAX) = 'Purchasing.ProductVendor';
DECLARE @SchemaName NVARCHAR(MAX) = 'Purchasing';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @TotalRowCount INT;

SELECT @TotalRowCount = COUNT(*) FROM [AdventureWorks2019].[Purchasing].[ProductVendor];

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, ' +
    'COUNT(*) AS MissingCount, ' +
    'CAST(COUNT(*) * 100.0 / ' + CAST(@TotalRowCount AS NVARCHAR) + ' AS DECIMAL(5,2)) AS MissingPercentage ' +
    'FROM ' + @SchemaName + '.ProductVendor WHERE [' + COLUMN_NAME + '] IS NULL',
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Purchasing'
  AND TABLE_NAME = 'ProductVendor';

EXEC sp_executesql @SQL;

--Gestion des valeurs manquantes de la colonne OnOrderQty de la table ProductVendor
UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 3
WHERE MinOrderQty = 1 
  AND MaxOrderQty = 5 
  AND UnitMeasureCode = 'CAN' 
  AND OnOrderQty IS NULL;


UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 3
WHERE MinOrderQty = 1 
  AND MaxOrderQty = 5 
  AND UnitMeasureCode = 'CTN' 
  AND OnOrderQty IS NULL;


UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 300
WHERE MinOrderQty = 100 
  AND MaxOrderQty = 1000 
  AND UnitMeasureCode = 'EA' 
  AND OnOrderQty IS NULL;

UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 60
WHERE MinOrderQty = 20 
  AND MaxOrderQty = 100 
  AND UnitMeasureCode = 'DZ' 
  AND OnOrderQty IS NULL;

UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 3
WHERE MinOrderQty = 1 
  AND MaxOrderQty = 5 
  AND UnitMeasureCode = 'DZ' OR UnitMeasureCode='CS' 
  AND OnOrderQty IS NULL;


UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 300
WHERE MinOrderQty = 100 
  AND MaxOrderQty = 1000 
  AND UnitMeasureCode = 'DZ' 
  AND OnOrderQty IS NULL;


UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 60
WHERE MinOrderQty = 20 
  AND MaxOrderQty = 100 
  AND UnitMeasureCode = 'GAL' OR UnitMeasureCode='PAK'
  AND OnOrderQty IS NULL;


UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
SET OnOrderQty = 500
WHERE MinOrderQty = 500 
  AND MaxOrderQty = 2000 
  AND UnitMeasureCode = 'EA' 
  AND OnOrderQty IS NULL;


--Suppression des espaces vides si ils existent
UPDATE [AdventureWorks2019].[Purchasing].[ProductVendor]
	SET ProductID = LTRIM(RTRIM(ProductID)), 
	BusinessEntityID = LTRIM(RTRIM(BusinessEntityID)), 
	AverageLeadTime = LTRIM(RTRIM(AverageLeadTime)), 
	StandardPrice = LTRIM(RTRIM(StandardPrice)), 
	LastReceiptCost = LTRIM(RTRIM(LastReceiptCost)), 
	LastReceiptDate = LTRIM(RTRIM(LastReceiptDate)), 
	MinOrderQty = LTRIM(RTRIM(MinOrderQty)), 
	MaxOrderQty = LTRIM(RTRIM(MaxOrderQty)),
	OnOrderQty = LTRIM(RTRIM(OnOrderQty)),	
	UnitMeasureCode = LTRIM(RTRIM(UnitMeasureCode)),
	ModifiedDate = LTRIM(RTRIM(ModifiedDate));

--Modification du type des colonnes LastReceiptDate pour qu'elle soit de type DATE au lieu de DATETIME car le temps reste non definit.
ALTER TABLE [AdventureWorks2019].[Purchasing].[ProductVendor] ALTER COLUMN LastReceiptDate DATE;