	select * from #csoex


 	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (119837,122670)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='1.1'

		UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (34741,49815)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='1.2'

		UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (5312, 10484)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='1.3'

		UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (3059,118237)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='1.4'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (25277,32590)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='1.5'


	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (18438,119855)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='2.1'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (132698, 105162)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='2.2'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (116832,71327)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='2.3'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (48378,130742)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='2.4 '
 

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (34511,130891)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='3.1'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (130891,10132)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='3.2'

 
	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (91284,22213)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='3.3'
 
	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (130710,72396)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='3.4'
 
	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (10046,57140)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='3.5'
 
	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (48019, 26469)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='3.6'

 
	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (100622,100622)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='4.1'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (282,84843)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='4.2'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (131288,122938)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='4.3'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (109335,136599)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='4.4'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (115056,131964)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.1'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (131301,140581)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.2'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (115617,125786)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.3'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (107384,132263)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.4'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (117132,37968)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.5'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (36406,57041)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.6'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (103145,105338)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='5.7'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (70958,33615)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.1'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (131286,71135)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.2'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (103142,109340)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.3'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (129810,114311)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.4'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (27483,38154)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.5'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (118241,131536)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.6'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (8621,137402)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.7'

	UPDATE #csoex SET AltAwardCodes=
	(SELECT DISTINCT STUFF( (	SELECT ',' + AltAwardCode FROM ProjectFunding AS f2	WHERE f2.ProjectFundingID IN (115740,115740)
				FOR XML PATH('') ), 1, 1, '') AS AltAwardCodes FROM ProjectFunding AS f)
	WHERE CSOCode='6.9'


	select * from #csoex