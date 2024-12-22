SELECT * FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail]

USE [AdventureWorks2019]
GO

--Verification des types de donnees
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA= 'Purchasing' AND TABLE_NAME= 'PurchaseOrderDetail';



----code pour vérifier les valeurs manquantes par colonne dans la table PurchaseOrderDetail
DECLARE @TableName NVARCHAR(MAX) = 'Purchasing.PurchaseOrderDetail';
DECLARE @SchemaName NVARCHAR(MAX) = 'Purchasing';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @TotalRowCount INT;

SELECT @TotalRowCount = COUNT(*) FROM [AdventureWorks2019].[Purchasing].PurchaseOrderDetail;

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, ' +
    'COUNT(*) AS MissingCount, ' +
    'CAST(COUNT(*) * 100.0 / ' + CAST(@TotalRowCount AS NVARCHAR) + ' AS DECIMAL(5,2)) AS MissingPercentage ' +
    'FROM ' + @SchemaName + '.PurchaseOrderDetail WHERE [' + COLUMN_NAME + '] IS NULL',
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Purchasing'
  AND TABLE_NAME = 'PurchaseOrderDetail';

EXEC sp_executesql @SQL;



--Suppression des espaces vides si ils existent
UPDATE [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail]
	SET PurchaseOrderID = LTRIM(RTRIM(PurchaseOrderID)), 
	DueDate = LTRIM(RTRIM(DueDate)), 
	OrderQty = LTRIM(RTRIM(OrderQty)), 
	ProductID = LTRIM(RTRIM(ProductID)), 
	UnitPrice = LTRIM(RTRIM(UnitPrice)), 
	ReceivedQty = LTRIM(RTRIM(ReceivedQty)),
	RejectedQty = LTRIM(RTRIM(RejectedQty)),	
	ModifiedDate = LTRIM(RTRIM(ModifiedDate));







