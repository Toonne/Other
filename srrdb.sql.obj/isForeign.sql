USE [srrdb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Skalman
-- Create date: 2024-02-26
-- Description:	Returns true/false wether the release is foreign
-- =============================================
ALTER FUNCTION [dbo].[isForeign] (@releaseName NVARCHAR(255))
RETURNS BIT AS
BEGIN
	SET @releaseName = LOWER(@releaseName)

	DECLARE @returnValue BIT = 0
	
	DECLARE @checkStrings TABLE (Id INT IDENTITY(1,1) NOT NULL, [CheckString] NVARCHAR(255))

	DECLARE @foreignLanguages TABLE (Id INT IDENTITY(1,1) NOT NULL, [LanguageName] NVARCHAR(255))
	INSERT INTO @foreignLanguages (LanguageName) VALUES
		('french'),('truefrench'),('subfrench'),('german'),('spanish'),('italian'),('dutch'),('flemish'),('vlaams'),('belgian'),
		('norwegian'),('swedish'),('danish'),('finnish'),('icelandic'),
		('lithuanian'),('estonian'),
		('turkish'),('greek'),('russian'),('czech'),('polish'),('pldub'),('pl'),
		('DUTCH_COMICS')

	DECLARE @sceneTags TABLE (Id INT IDENTITY(1,1) NOT NULL, [Tag] NVARCHAR(255))

	INSERT INTO @sceneTags ([Tag]) VALUES
		('proper'),('internal'),('repack'),('rerip'),('readnfo'),('xxx'),
		('720p'),('1080p'),('2160p'),
		('xvid'),('divx'),('x264'),('x265'),('h264'),('h265'),('svcd'),('dvdivx'),('xvidvd'),
		('wmv'),('vc1'),('avc'),('mpeg2'),
		('complete'),('pal'),('ntsc'),('dvdr'),('dvd9'),('mdvd'),
		('dvdrip'),('bdrip'),('brrip'),('bluray'),('hd-?dvd'),('ahdtv'),('convert'),('dvd\.?scr'),('screener'),('bdscr'),
		('web'),('webrip'),('webhd'),('ddc'),('vhsrip'),('tvrip'),
		('hdtv'),('pdtv'),('tvrip'),('dsr'),('dvb'),('dtv'),('ppv'),('satrip'),('3dtv'),('dvtv'),('dvtv'),
		('limited'),('stv'),('extended'),('unrated'),('rated'),('retail'),
		('uncensored'),('alternate.cut'),('real'),('uncut'),('dubbed'),('subbed'),('custom'),('oar'),('hsbs'),
		('cam'),('ts'),('tc'),('wp'),('workprint'),('r5'),
		('fs'),('ws'),('ac3'),('dts'),('bd5'),('bd9'),
		('dl'),('multi'),('multisubs'),('md'),('ld'),('jpn'),('eur'),
		('nfo\.?fix'),('dir\.?fix'),('proof'),('proof?fix'),('subpack'),
		('final'),
		('dvd'),('covers?'),
		('nor.swe'),
		('scan.dvd'),
		('open.matte'),
		('iso'),
		('wiiu'),('xboxone'),('ps4'),
		('wii'),('ngc'),('ps3'),('ps2'),('xbox360'),('xbox'),
		('ps1'),('psp'),('3ds'),('nds'),('gba'),('gbc'),
		('nsw'),
		('remastered'),('doku'),('dl'),('ac3d'),('dtsd'),('dual'),('anime'),('hybrid'),('ml'),('kinofassung'),('eac3d'),
		('qc'),
		('hdr'),('dv')

	--clean unrelevant languages and scene tags
	DELETE FROM @foreignLanguages WHERE @releaseName NOT LIKE '%' + LanguageName + '%'
	DELETE FROM @sceneTags WHERE @releaseName NOT LIKE '%' + Tag + '%'

	--generate string to look for
	INSERT INTO @checkStrings (CheckString)
		SELECT LanguageName + '.' + Tag FROM @foreignLanguages,@sceneTags UNION
		SELECT LanguageName + '_' + Tag FROM @foreignLanguages,@sceneTags UNION
		SELECT LanguageName + '-' + Tag FROM @foreignLanguages,@sceneTags
	
	SET @returnValue = CASE WHEN EXISTS(SELECT TOP 1 * FROM @checkStrings WHERE @releaseName LIKE '%' + CheckString + '%') THEN 1 ELSE 0 END

	RETURN @returnValue
END
