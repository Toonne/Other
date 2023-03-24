/*

SQL server script to work with the extracted data from https://github.com/Toonne/Other/blob/main/imdb.extract.data.from.list.js

1. Usage: Replace all ' with ''
2. Place the content in the variable and run

*/

DECLARE @jsonData NVARCHAR(MAX) = 'Place movies-info.json content here';

--INSERT INTO imdb_top (title,imdbId,year,rating,votes,plot)
SELECT
	Title = JSON_VALUE([value], '$.title'),
	ImdbId = JSON_VALUE([value], '$.imdbId'),
	[Year] = JSON_VALUE([value], '$.year'),
	Rating = JSON_VALUE([value], '$.rating'),
	Votes = JSON_VALUE([value], '$.votes'),
	Plot = JSON_VALUE([value], '$.plot')
FROM OPENJSON(@jsonData, '$') AS MovieList

UPDATE imdb_top SET imdbId = REPLACE(imdbId, 'tt', '') WHERE imdbId LIKE 'tt%'

/* Create imdb_top table */
CREATE TABLE [dbo].[imdb_top](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](511) NULL,
	[imdbId] [nvarchar](12) NULL,
	[year] [int] NULL,
	[rating] [decimal](8, 2) NULL,
	[votes] [int] NULL,
	[plot] [nvarchar](4000) NULL,
 CONSTRAINT [PK_imdb_top] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]) ON [PRIMARY]
GO
