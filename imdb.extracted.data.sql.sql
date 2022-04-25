/*

SQL server script to work with the extracted data from https://github.com/Toonne/Other/blob/main/imdb.extract.data.from.list.js

1. Usage: Replace all ' with ''
2. Place the content in the variable and run

*/

DECLARE @jsonData NVARCHAR(MAX) = 'Place movies-info.json content here';

SELECT
	Title = JSON_VALUE([value], '$.title'),
	ImdbId = JSON_VALUE([value], '$.imdbId'),
	[Year] = JSON_VALUE([value], '$.year'),
	Rating = JSON_VALUE([value], '$.rating'),
	Votes = JSON_VALUE([value], '$.votes'),
	Plot = JSON_VALUE([value], '$.plot')
FROM OPENJSON(@jsonData, '$') AS MovieList
