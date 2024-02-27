---############################
--- Import SQL server management
---############################

--"Have, missing from srrdb"
SELECT uhr.*,srrdb.fldName
FROM user_have_releases uhr
LEFT JOIN srrdb_file srrdb ON (uhr.Release = srrdb.fldName)
WHERE fldName IS NULL

--"Have, missing imdb on srrdb"
SELECT uhr.*,srrdb.fldName
FROM user_have_releases uhr
LEFT JOIN srrdb_file srrdb ON (uhr.Release = srrdb.fldName)
WHERE fldName IS NOT NULL AND fldImdb IS NULL

--"Have, not in imdb_top"
SELECT uhr.Release,srrdb.fldImdb
FROM user_have_releases uhr
LEFT JOIN srrdb_file srrdb ON (uhr.Release = srrdb.fldName)
LEFT JOIN imdb_top imdb ON (srrdb.fldImdb = imdb.imdbId)
WHERE srrdb.fldName IS NOT NULL AND imdb.Id IS NULL

--"Top movies - no releases"
SELECT imdb_top.*
FROM imdb_top
LEFT JOIN srrdb_import srrdb ON (imdb_top.imdbId = srrdb.fldImdb)
WHERE srrdb.fldImdb IS NULL
ORDER BY votes DESC

--"Have, nuked releases. TODO: improve (lists each multiple times)"
SELECT uhr.*,pre.[name],nuke.reason
FROM user_have_releases uhr
LEFT JOIN pre ON (uhr.Release = pre.[name])
LEFT JOIN nuke on (pre.id = nuke.pre_id)
WHERE pre.[name] IS NOT NULL AND nuke_id IS NOT NULL

--"Have, wrong casing compared to pre"
SELECT uhr.Release, pre.[name]
FROM user_have_releases uhr
LEFT JOIN pre ON (uhr.Release = pre.[name])
WHERE uhr.Release COLLATE Latin1_General_CS_AS != pre.[name] COLLATE Latin1_General_CS_AS 

--"Have, dupe releases" (based on imdb id)
SELECT STRING_AGG(CAST(uhr.Release AS nvarchar(MAX)), ', '), fldImdb, COUNT(*)
FROM user_have_releases uhr
LEFT JOIN srrdb_file srrdb ON (uhr.Release = srrdb.fldName)
GROUP BY fldImdb
HAVING COUNT(*) >= 2
ORDER BY COUNT(*) DESC

--"Don't have that is in imdb top"
SELECT Title,imdbid,('https://www.imdb.com/title/tt' + imdbid + '/'),[year],rating,votes
FROM imdb_top
WHERE imdbId NOT IN ((SELECT fldImdb FROM user_have_releases uhr LEFT JOIN srrdb_file ON (uhr.Release = fldname) WHERE fldimdb IS NOT NULL))
ORDER BY votes DESC

--"Don't have that is in imdb top, without imdb lookup"
SELECT * FROM (SELECT
	MAX(Title) AS Title,
	imdbid AS ImdbId,
	('https://www.imdb.com/title/tt' + imdbid + '/') AS ImdbUrl,
	MAX([year]) AS [Year],
	MAX(rating) AS Rating,
	MAX(votes) AS Votes,
	COUNT(srrdb.fldName) AS ReleaseAmount,
	STRING_AGG(CAST(srrdb.fldName AS nvarchar(MAX)), ', ') AS Releases
FROM imdb_top
LEFT JOIN srrdb_file srrdb ON (
	imdb_top.imdbId = srrdb.fldImdb AND
	srrdb.fldForeign = 'no' AND
	srrdb.fldName LIKE '%720p%' AND
	srrdb.fldName NOT LIKE '%.multi.%' AND srrdb.fldName NOT LIKE '%subpack%' AND srrdb.fldName NOT LIKE '%.VC1.%' AND srrdb.fldName NOT LIKE '%.WMV.%' AND  srrdb.fldName NOT LIKE '%.WMV-%' AND srrdb.fldName NOT LIKE '%.audiopack.%' AND
	srrdb.fldName NOT LIKE '%.THEATRICAL.%' AND
	srrdb.fldName NOT LIKE '%-EwDp' AND srrdb.fldName NOT LIKE '%-MHQ' AND srrdb.fldName NOT LIKE '%-MARS' AND srrdb.fldName NOT LIKE '%-LiBRARiANS' AND srrdb.fldName NOT LIKE '%-TABULARiA'
)
WHERE imdbId NOT IN ((SELECT fldImdb FROM _have_releases uhr LEFT JOIN srrdb_file ON (uhr.Release = fldname) WHERE fldimdb IS NOT NULL))
GROUP BY imdb_top.imdbId
HAVING COUNT(srrdb.fldName) = 1
) AS query
ORDER BY query.Votes DESC
