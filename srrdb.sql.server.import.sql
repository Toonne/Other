/*

SQL server script to import a phpMyAdmin export from srrdb main table.

*/

CREATE TABLE [dbo].[srrdb_file](
	[fldName] [nvarchar](255) NOT NULL,
	[fldGroup] [nvarchar](255) NULL,
	[fldDate] [nvarchar](255) NULL,
	[fldNFO] [nvarchar](255) NULL,
	[fldSRS] [nvarchar](255) NULL,
	[fldCategory] [nvarchar](255) NULL,
	[fldConfirmed] [nvarchar](255) NULL,
	[fldUploader] [nvarchar](255) NULL,
	[fldForeign] [nvarchar](255) NULL,
	[fldNuked] [nvarchar](255) NULL,
	[fldImdb] [nvarchar](255) NULL,
	[fldRarHash] [nvarchar](255) NULL,
	[fldNote] [nvarchar](255) NULL,
	[fldCompressed] [nvarchar](255) NULL,
	[fldVersion] [nvarchar](255) NULL,
PRIMARY KEY ([fldName]))
GO

---############################
--- Batch import data
---############################

-- Convert EOL to Windows format before BCP command, otherwise it will give an error
	
--F2 = start read from line 2 (when file has header)
bcp srrdb_file in "srrdb_file-2023-01-12.csv" -S "WEB-01" -d "srrdb" -U "xxx" -P "xxx" -q -c -F2 -t ","

---############################
--- Data cleanup
---############################

UPDATE srrdb_file SET fldImdb = NULL WHERE fldImdb = 'NULL'
UPDATE srrdb_file SET fldImdb = SUBSTRING(fldImdb, 2, LEN(fldImdb) - 2) WHERE fldImdb LIKE '"%"'
UPDATE srrdb_file SET fldName = SUBSTRING(fldname, 2, LEN(fldName) - 2) WHERE fldName LIKE '"%"'
