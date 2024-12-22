SELECT * FROM [AdventureWorks2019].[Purchasing].[Vendor]


----code pour vérifier les valeurs manquantes par colonne dans la table Vendor

DECLARE @TableName NVARCHAR(MAX) = 'Purchasing.Vendor';
DECLARE @SchemaName NVARCHAR(MAX) = 'Purchasing';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @TotalRowCount INT;

SELECT @TotalRowCount = COUNT(*) FROM [AdventureWorks2019].[Purchasing].[Vendor];

SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, ' +
    'COUNT(*) AS MissingCount, ' +
    'CAST(COUNT(*) * 100.0 / ' + CAST(@TotalRowCount AS NVARCHAR) + ' AS DECIMAL(5,2)) AS MissingPercentage ' +
    'FROM ' + @SchemaName + '.Vendor WHERE [' + COLUMN_NAME + '] IS NULL',
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Purchasing'
  AND TABLE_NAME = 'Vendor';

EXEC sp_executesql @SQL;






--Suppression de la colonne PurchasingWebServiceURL car elle contient 94,23 pourcent des valeurs manquantes
ALTER TABLE [AdventureWorks2019].[Purchasing].[Vendor] 
DROP COLUMN PurchasingWebServiceURL;








--code pour vérifier les doublons par colonne dans la table Vendor
DECLARE @cols AS NVARCHAR(MAX)

SELECT @cols = STRING_AGG(QUOTENAME(column_name), ', ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'Purchasing' AND table_name = 'Vendor'
  AND column_name NOT IN ('BusinessEntityID', 'ModifiedDate'); 

-- Création d'une boucle pour vérifier les doublons par colonne dans la table Vendor
DECLARE @col_name NVARCHAR(100)
DECLARE col_cursor CURSOR FOR
SELECT column_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'Purchasing' AND table_name = 'Vendor'
  AND column_name NOT IN ('BusinessEntityID', 'ModifiedDate');

OPEN col_cursor
FETCH NEXT FROM col_cursor INTO @col_name

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'SELECT ' + @col_name + ', COUNT(*) ' +
               'FROM [AdventureWorks2019].[Purchasing].[Vendor] ' +
               'GROUP BY ' + @col_name + ' ' +
               'HAVING COUNT(*) > 1;';

    EXEC sp_executesql @sql;

    FETCH NEXT FROM col_cursor INTO @col_name
END

CLOSE col_cursor
DEALLOCATE col_cursor;





--Verification des types de donnees
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'Purchasing' AND TABLE_NAME = 'Vendor'  ;






--Modification du type de la colonne ModifiedDate pour qu'elle soit de type DATE au lieu de DATETIME car le temps reste le meme.
ALTER TABLE [AdventureWorks2019].[Purchasing].[Vendor] ALTER COLUMN ModifiedDate DATE;





--Suppression des espaces vides si ils existent
UPDATE [AdventureWorks2019].[Purchasing].[Vendor] 
SET BusinessEntityID = LTRIM(RTRIM(BusinessEntityID)),
	AccountNumber = LTRIM(RTRIM(AccountNumber)), 
	Name = LTRIM(RTRIM(Name)), 
	CreditRating = LTRIM(RTRIM(CreditRating)), 
	PreferredVendorStatus = LTRIM(RTRIM(PreferredVendorStatus)), 
	ActiveFlag = LTRIM(RTRIM(ActiveFlag)),   
	ModifiedDate = LTRIM(RTRIM(ModifiedDate));

