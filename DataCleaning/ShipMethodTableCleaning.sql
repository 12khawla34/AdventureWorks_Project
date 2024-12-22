SELECT * FROM [AdventureWorks2019].[Purchasing].[ShipMethod]

USE [AdventureWorks2019]
GO

--Verification des types de donnees
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA= 'Purchasing' AND TABLE_NAME= 'ShipMethod'




--Modification du type de la colonne ModifiedDate pour qu'elle soit de type DATE au lieu de DATETIME car le temps reste le meme.
ALTER TABLE [AdventureWorks2019].[Purchasing].[ShipMethod] ALTER COLUMN ModifiedDate DATE;


--Suppression des espaces vides si ils existent
UPDATE [AdventureWorks2019].[Purchasing].[ShipMethod]
	SET Name = LTRIM(RTRIM(Name)), 
	ShipBase = LTRIM(RTRIM(ShipBase)), 
	ShipRate = LTRIM(RTRIM(ShipRate)), 
	rowguid = LTRIM(RTRIM(rowguid)), 
	ModifiedDate = LTRIM(RTRIM(ModifiedDate));




----code pour vérifier les valeurs manquantes par colonne dans la table ShipMethod

DECLARE @TableName NVARCHAR(MAX) = 'Purchasing.ShipMethod';
DECLARE @SchemaName NVARCHAR(MAX) = 'Purchasing';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @TotalRowCount INT;

-- Calcul du nombre total de lignes dans la table
SELECT @TotalRowCount = COUNT(*) FROM [AdventureWorks2019].[Purchasing].[ShipMethod];

-- Création de la requête dynamique pour vérifier les valeurs manquantes dans chaque colonne
SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName, ' +
    'COUNT(*) AS MissingCount, ' +
    'CAST(COUNT(*) * 100.0 / ' + CAST(@TotalRowCount AS NVARCHAR) + ' AS DECIMAL(5,2)) AS MissingPercentage ' +
    'FROM ' + @SchemaName + '.ShipMethod WHERE [' + COLUMN_NAME + '] IS NULL',
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Purchasing'
  AND TABLE_NAME = 'ShipMethod';

-- Exécution de la requête dynamique
EXEC sp_executesql @SQL;





