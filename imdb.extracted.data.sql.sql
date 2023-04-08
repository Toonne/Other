/*

SQL server script to work with the extracted data from https://github.com/Toonne/Other/blob/main/imdb.extract.data.from.list.js

1. Usage: Replace all ' with ''
2. Place the content in the variable and run

*/

DECLARE @jsonData NVARCHAR(MAX) = 'Place movies-info.json content here';
SELECT @jsonData = BulkColumn FROM OPENROWSET (BULK 'D:\combinedfiles.json', SINGLE_NCLOB) AS JsonData;

--DELETE FROM imdb_top;
--TRUNCATE TABLE imdb_top;

--INSERT INTO imdb_top (title,imdbId,[year],rating,votes,plot,[certificate],runtime,genre,posterUrl,metascore,stars)
SELECT
	Title = JSON_VALUE([value], '$.title'),
	ImdbId = JSON_VALUE([value], '$.imdbId'),
	[Year] = JSON_VALUE([value], '$.year'),
	Rating = JSON_VALUE([value], '$.rating'),
	Votes = JSON_VALUE([value], '$.votes'),
	Plot = JSON_VALUE([value], '$.plot'),
	[Certificate] = JSON_VALUE([value], '$.certificate'),
	Runtime = JSON_VALUE([value], '$.runtime'),
	Genre = JSON_QUERY([value], '$.genre'),
	PosterUrl = JSON_VALUE([value], '$.posterUrl'), --usually a placeholder
	Metascore = JSON_VALUE([value], '$.metascore'),
	Stars = JSON_QUERY([value], '$.stars')
FROM OPENJSON(@jsonData, '$') AS MovieList

UPDATE imdb_top SET imdbId = REPLACE(imdbId, 'tt', '') WHERE imdbId LIKE 'tt%'

--Save all genres
INSERT INTO imdb_genre
	SELECT DISTINCT [value] FROM 
	STRING_SPLIT((SELECT SUBSTRING(
	( 
		SELECT ',' + REPLACE(SUBSTRING(genre, 2, LEN(genre) - 2), '"', '') FROM imdb_top FOR XML PATH('') 
	), 2 , 10000000)), ',') ORDER BY [value]

INSERT INTO imdb_genre
	SELECT DISTINCT Genre.[value]
	FROM imdb_top
	CROSS APPLY STRING_SPLIT (REPLACE(SUBSTRING(genre, 2, LEN(genre) - 2), '"', ''), ',') Genre
	ORDER BY Genre.[value]

/* Create imdb_top table */
CREATE TABLE [dbo].[imdb_top](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](511) NULL,
	[imdbId] [nvarchar](12) NULL,
	[year] [int] NULL,
	[rating] [decimal](8, 2) NULL,
	[votes] [int] NULL,
	[plot] [nvarchar](4000) NULL,
	[certificate] [nvarchar](128) NULL,
	[runtime] [nvarchar](128) NULL,
	[genre] [nvarchar](max) NULL,
	[posterUrl] [nvarchar](255) NULL,
	[metascore] [int] NULL,
	[stars] [nvarchar](max) NULL,
 CONSTRAINT [PK_imdb_top] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]) ON [PRIMARY]
GO

/* Create imdb_genre table */
CREATE TABLE [dbo].[imdb_genre](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Genre] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_imdb_genre] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY],
 CONSTRAINT [UQ_imdb_genre] UNIQUE NONCLUSTERED ([Genre] ASC) ON [PRIMARY]
) ON [PRIMARY]
GO
GO
