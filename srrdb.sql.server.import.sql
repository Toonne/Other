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
	
CREATE NONCLUSTERED INDEX [IX-fldImdb] ON [dbo].[srrdb_file] (
	[fldImdb] ASC
) ON [PRIMARY]
GO

TRUNCATE TABLE srrdb_file

---############################
--- Batch import data
---############################

-- Convert EOL to Windows format before BCP command, otherwise it will give an error
	
--F2 = start read from line 2 (when file has header)
bcp srrdb_file in "srrdb_file-2023-01-12.csv" -S "WEB-01" -d "srrdb" -U "xxx" -P "xxx" -q -c -F2 -t ","

---############################
--- Data cleanup
---############################

--NULL strings
UPDATE srrdb_file SET fldImdb = NULL WHERE fldImdb = 'NULL'
UPDATE srrdb_file SET fldUploader = NULL WHERE fldUploader = 'NULL'
UPDATE srrdb_file SET fldNote = NULL WHERE fldNote = 'NULL'
UPDATE srrdb_file SET fldVersion = NULL WHERE fldVersion IS NOT NULL

--Remove quotation marks
UPDATE srrdb_file SET fldName = SUBSTRING(fldName, 2, LEN(fldName) - 2) WHERE fldName LIKE '"%"'
UPDATE srrdb_file SET fldGroup = SUBSTRING(fldGroup, 2, LEN(fldGroup) - 2) WHERE fldGroup LIKE '"%"'
UPDATE srrdb_file SET fldDate = SUBSTRING(fldDate, 2, LEN(fldDate) - 2) WHERE fldDate LIKE '"%"'
UPDATE srrdb_file SET fldNFO = SUBSTRING(fldNFO, 2, LEN(fldNFO) - 2) WHERE fldNFO LIKE '"%"'
UPDATE srrdb_file SET fldSRS = SUBSTRING(fldSRS, 2, LEN(fldSRS) - 2) WHERE fldSRS LIKE '"%"'
UPDATE srrdb_file SET fldCategory = SUBSTRING(fldCategory, 2, LEN(fldCategory) - 2) WHERE fldCategory LIKE '"%"'
UPDATE srrdb_file SET fldConfirmed = SUBSTRING(fldConfirmed, 2, LEN(fldConfirmed) - 2) WHERE fldConfirmed LIKE '"%"'
UPDATE srrdb_file SET fldUploader = SUBSTRING(fldUploader, 2, LEN(fldUploader) - 2) WHERE fldUploader LIKE '"%"'
UPDATE srrdb_file SET fldForeign = SUBSTRING(fldForeign, 2, LEN(fldForeign) - 2) WHERE fldForeign LIKE '"%"'
UPDATE srrdb_file SET fldNuked = SUBSTRING(fldNuked, 2, LEN(fldNuked) - 2) WHERE fldNuked LIKE '"%"'
UPDATE srrdb_file SET fldImdb = SUBSTRING(fldImdb, 2, LEN(fldImdb) - 2) WHERE fldImdb LIKE '"%"'
UPDATE srrdb_file SET fldRarHash = SUBSTRING(fldRarHash, 2, LEN(fldRarHash) - 2) WHERE fldRarHash LIKE '"%"'
UPDATE srrdb_file SET fldCompressed = SUBSTRING(fldCompressed, 2, LEN(fldCompressed) - 2) WHERE fldCompressed LIKE '"%"'

--Create an index for imdb id
CREATE NONCLUSTERED INDEX [IX-fldImdb] ON [dbo].[srrdb_file] (
	[fldImdb] ASC
) ON [PRIMARY]
GO
