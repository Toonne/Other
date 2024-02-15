--SQL Server commands and interesting queries

--Generate SrrHash
UPDATE
releaselist_db
    SET SrrHash = SUBSTRING(master.dbo.fn_varbintohexstr(HASHBYTES('SHA1', CAST(LOWER(Release) AS varchar(255)))), 3, 40)
WHERE SrrHash IS NULL
--Note: CAST is to ensure the value is correct, nvarchar() gives a bad value

--An example using join with another table
SELECT TOP (1000) releaselist_db.*,releaselist_file.Id
FROM [srrdb].[dbo].[releaselist_db]
LEFT JOIN releaselist_file ON (('./' + SUBSTRING(SrrHash, 1, 1) + '/' + SUBSTRING(SrrHash, 2, 2) + '/' + [releaselist_db].Release + '.srr') = releaselist_file.Release)

--As a computed column (a bit slow when doing heaps of data):
CREATE OR ALTER FUNCTION BinToHexString(@Bin VARBINARY(max)) RETURNS VARCHAR(max) AS
BEGIN
    RETURN '0x' + cast('' AS xml).value('xs:hexBinary(sql:variable("@Bin") )', 'varchar(max)'); 
END

--Formula:
(lower(substring([dbo].[BinToHexString](hashbytes('SHA1',CONVERT([varchar](255),lower([Title])))),(3),(40))))
  
--Generating copy commands:
SELECT 
Title,
CopyCommand = 'copy \\srrNAS\srrdb\files\srr_files\' + SUBSTRING(query.SrrHash,1,1) + '\' + SUBSTRING(query.SrrHash,2,2) + '\' + Title + '.srr C:\requestedsrrs\'
FROM (
    SELECT *, SrrHash = SUBSTRING(master.dbo.fn_varbintohexstr(HASHBYTES('SHA1', CAST(LOWER(Title) AS varchar(255)))), 3, 40)
FROM requestTemp
) query

--Using a system/configuration table with the base path, and a view to get the locations of the srr-files in SQL-server
CREATE OR ALTER VIEW [dbo].[requestTempView] AS
    SELECT
        Title,
        SrrHash,
        SrrPath = [system].SrrBasePath + SUBSTRING(SrrHash,1,1) + '\' + SUBSTRING(SrrHash,2,2) + '\' + Title + '.srr'
    FROM [dbo].[requestTemp]
    CROSS APPLY (SELECT TOP 1 SrrBasePath FROM [system]) [system]
