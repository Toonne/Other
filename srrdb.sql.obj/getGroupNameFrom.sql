USE [srrdb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Skalman
-- Create date: 2024-02-26
-- Description:	Returns the group name from a release name
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[getGroupNameFrom] (@releaseName NVARCHAR(255))
RETURNS NVARCHAR(255) AS
BEGIN
	DECLARE @returnGroupName NVARCHAR(255) = ''

	DECLARE @dashGroups TABLE (Id INT, [GroupName] NVARCHAR(255))
	INSERT INTO @dashGroups VALUES
		(1,'Cheetah-TV'),
		(2,'DVD-R'),
		(3,'TEG-VCD'),
		(4,'VH-PROD'),
		(5,'C-STREAM'),
		(6,'WALTERBOSQUE-ART'),
		(7,'1-800'),
		(8,'UNiCORN-INT'),
		(9,'SD-6'),
		(10,'PsyCZ-VBR'),
		(11,'H-CORE'),
		(12,'Tsunami-Appeal'),
		(13,'TTP-TEAM'),
		(14,'CRN-TV'), -- 2003-2004 Norwegian TV
		(15,'CaMeL-TeaM'), -- also CAMEL-TEAM; 2005 mp3
		(16,'1Kp-TEAM'), -- French divx/xvid and some music
		(17,'NAPALM-TEAM'), -- 2001 French divx
		(18,'Tag-Team'), -- only 2 releases? VA_-_Strictly_Hardstyle_5_(Mixed_By_P-Kay)-2002-Tag-Team
		(19,'A-Team'), -- some TS in 2002
		(20,'THEORY-CLS'), -- German xvid, svcd
		(21,'X-Streem'), -- 2001-2003 dvdr, svcd
		(22,'B-SecToR'), -- 2002-2005 xbox, ps2
		(23,'TEG-PSX') -- 2001-2003 ps1, ps2, xbox

	IF @releaseName LIKE '%\_\_\_%' BEGIN
		DECLARE @repacked_pos int = (SELECT CHARINDEX('___repacked', @releaseName))
		DECLARE @different_pos int = (SELECT CHARINDEX('___different', @releaseName))
		DECLARE @fake_pos int = (SELECT CHARINDEX('___fake' ,@releaseName))

		IF @repacked_pos > 0 BEGIN
			SET @releaseName = SUBSTRING(@releaseName, 0, @repacked_pos)
		END
		ELSE IF @different_pos > 0 BEGIN
			SET @releaseName = SUBSTRING(@releaseName, 0, @different_pos)
		END
		ELSE IF @fake_pos > 0 BEGIN
			SET @releaseName = SUBSTRING(@releaseName, 0, @fake_pos)
		END
		ELSE IF @releaseName LIKE '%\_\_\_[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]%' BEGIN
			DECLARE @other_pos int = (SELECT CHARINDEX('___' ,@releaseName))

			SET @releaseName = SUBSTRING(@releaseName, 0, @other_pos)
		END
	END

	DECLARE @matchedhDashGroupName NVARCHAR(MAX) = (SELECT GroupName FROM @dashGroups WHERE @releaseName LIKE '%' + GroupName)

	IF LEN(@matchedhDashGroupName) > 0 BEGIN
		SET @returnGroupName = @matchedhDashGroupName
	END
	ELSE BEGIN
		IF @releaseName LIKE '%-%'
			SET @returnGroupName = (SELECT TOP (1) REVERSE([value]) FROM STRING_SPLIT(REVERSE(@releaseName), '-'))
		ELSE
			SET @returnGroupName = NULL
	END

	RETURN @returnGroupName
END
