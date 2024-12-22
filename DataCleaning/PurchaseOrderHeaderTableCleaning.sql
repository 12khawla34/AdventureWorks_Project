SELECT * FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]

USE [AdventureWorks2019]
GO

--Verification des types de donnees
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA= 'Purchasing' AND TABLE_NAME= 'PurchaseOrderHeader';



--Modification du type des colonnes OrderDate et ShipDate pour qu'elle soit de type DATE au lieu de DATETIME car le temps reste le meme.
ALTER TABLE [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] ALTER COLUMN OrderDate DATE; 
ALTER TABLE [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] ALTER COLUMN ShipDate DATE; 






----code pour vérifier les valeurs manquantes par colonne dans la table PurchaseOrderHeader
DECLARE @TableName NVARCHAR(MAX) = 'Purchasing.PurchaseOrderHeader';
DECLARE @SchemaName NVARCHAR(MAX) = 'Purchasing';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @TotalRowCount INT;

SELECT @TotalRowCount = COUNT(*) FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader];

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, ' +
    'COUNT(*) AS MissingCount, ' +
    'CAST(COUNT(*) * 100.0 / ' + CAST(@TotalRowCount AS NVARCHAR) + ' AS DECIMAL(5,2)) AS MissingPercentage ' +
    'FROM ' + @SchemaName + '.PurchaseOrderHeader WHERE [' + COLUMN_NAME + '] IS NULL',
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Purchasing'
  AND TABLE_NAME = 'PurchaseOrderHeader';

EXEC sp_executesql @SQL;





-- Vérification des doublons dans la table PurchaseOrderHeader
DECLARE @col_name NVARCHAR(100);
DECLARE col_cursor CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Purchasing' AND TABLE_NAME = 'PurchaseOrderHeader'
  AND COLUMN_NAME NOT IN ('PurchaseOrderID'); 

OPEN col_cursor;
FETCH NEXT FROM col_cursor INTO @col_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 
        'SELECT ''' + @col_name + ''' AS ColumnName, ' +
        @col_name + ' AS Value, COUNT(*) AS DuplicateCount ' +
        'FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] ' +
        'GROUP BY ' + @col_name + ' ' +
        'HAVING COUNT(*) > 1;';

    EXEC sp_executesql @sql;

    FETCH NEXT FROM col_cursor INTO @col_name;
END;

CLOSE col_cursor;
DEALLOCATE col_cursor;



--Suppression des espaces vides si ils existent
UPDATE [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]
	SET RevisionNumber = LTRIM(RTRIM(RevisionNumber)), 
	Status = LTRIM(RTRIM(Status)), 
	EmployeeID = LTRIM(RTRIM(EmployeeID)), 
	VendorID = LTRIM(RTRIM(VendorID)), 
	ShipMethodID = LTRIM(RTRIM(ShipMethodID)), 
	OrderDate = LTRIM(RTRIM(OrderDate)), 
	ShipDate = LTRIM(RTRIM(ShipDate)), 
	SubTotal = LTRIM(RTRIM(SubTotal)),
	TaxAmt = LTRIM(RTRIM(TaxAmt)),	
	Freight = LTRIM(RTRIM(Freight)),
	ModifiedDate = LTRIM(RTRIM(ModifiedDate));			