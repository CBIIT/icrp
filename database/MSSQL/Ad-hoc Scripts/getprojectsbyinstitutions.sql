USE [icrp_data]
GO

	SELECT * INTO #projs  FROM 
	(
		SELECT 
		AwardCode, AltAwardCode, ProjectTitle, ProjectStartDate, ProjectEndDate, TechAbstract, PublicAbstract,
			CASE IsPrincipalInvestigator
			WHEN 1 THEN PI ELSE NULL
			END AS PI,
			CASE IsPrincipalInvestigator
			WHEN 0 THEN PI ELSE NULL
			END AS Collaborator,
		Institution, [Institution CIty], [Institution Country], 
		CSOCode, CancerSite, ORC_ID, FundingOrg, FundingOrgType
		FROM
		(select f.Title AS ProjectTitle, p.AwardCode, f.AltAwardCode, p.ProjectStartDate, p.ProjectEndDate, a.TechAbstract, a.PublicAbstract, 
		CONCAT(pi.LastName, '. ', pi.FirstName) AS PI, pi.IsPrincipalInvestigator,
		i.Name AS Institution, i.City AS 'Institution CIty', i.Country AS 'Institution Country', 
		cso.CSOCode, ct.Name AS CancerSite, pi.ORC_ID, o.Name AS FundingOrg, o.Type AS FundingOrgType
		from project p
		join projectfunding f on p.projectid = f.projectid
		join projectfundinginvestigator pi on f.ProjectFundingID = pi.ProjectFundingID
		join Institution i ON pi.InstitutionID = i.InstitutionID
		join FundingOrg o on f.fundingorgid = o.FundingOrgID
		join ProjectCSO cso ON cso.ProjectFundingID = f.ProjectFundingID
		join ProjectCancerType pct ON pct.ProjectFundingID = f.ProjectFundingID
		join CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
		join ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID
		where i.name in(
			'Fred Hutchinson Cancer Research Center', 
			'Oregon Health & Science University',
			'University of British Columbia', 
			'University of Washington',
			'British Columbia Cancer Research Centre',
			'BC Cancer Agency', 
			'BC Cancer Agency - Sindi Ahluwalia Hawkins Centre for the Southern Interior', 
			'BC Cancer Agency - Fraser Valley Cancer Centre', 
			'BC Cancer Agency - Vancouver Island Centre', 
			'BC Cancer Agency - Abbotsford Centre', 
			'BC Cancer Agency - Centre for the North')

		UNION

		select f.Title AS ProjectTitle, p.AwardCode, f.AltAwardCode, p.ProjectStartDate, p.ProjectEndDate, a.TechAbstract, a.PublicAbstract, 
		CONCAT(pi.LastName, '. ', pi.FirstName) AS PI, pi.IsPrincipalInvestigator,
		i.Name AS Institution, i.City AS 'Institution CIty', i.Country AS 'Institution Country', 
		cso.CSOCode, ct.Name AS CancerSite, pi.ORC_ID, o.Name AS FundingOrg, o.Type AS FundingOrgType
		from project p
		join projectfunding f on p.projectid = f.projectid
		join projectfundinginvestigator pi on f.ProjectFundingID = pi.ProjectFundingID
		join Institution i ON pi.InstitutionID = i.InstitutionID
		join FundingOrg o on f.fundingorgid = o.FundingOrgID
		join ProjectCSO cso ON cso.ProjectFundingID = f.ProjectFundingID
		join ProjectCancerType pct ON pct.ProjectFundingID = f.ProjectFundingID
		join CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
		join ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID
		where i.name in(
			'Fred Hutchinson Cancer Research Center', 
			'Oregon Health & Science University',
			'University of British Columbia', 
			'University of Washington',
			'British Columbia Cancer Research Centre',
			'BC Cancer Agency', 
			'BC Cancer Agency - Sindi Ahluwalia Hawkins Centre for the Southern Interior', 
			'BC Cancer Agency - Fraser Valley Cancer Centre', 
			'BC Cancer Agency - Vancouver Island Centre', 
			'BC Cancer Agency - Abbotsford Centre', 
			'BC Cancer Agency - Centre for the North')
		 and pi.IsPrincipalInvestigator = 0) tmp		 
	) projs
	ORDER BY AwardCode, AltAwardCode, PI

SELECT AwardCode, 
	STUFF(
	(SELECT DISTINCT ', ' + AltAwardCode FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS AltID,

	MAX(ProjectTitle) AS ProjectTitle,

	MIN(ProjectStartDate) AS ProjectStartDate,

	MAX(ProjectEndDate) AS ProjectEndDate,

	MAX(FundingOrg) AS FundingOrg,

	MAX(FundingOrgType) AS FundingOrgType,

	MAX(TechAbstract) AS TechAbstract,

	MAX(PublicAbstract) AS PublicAbstract,
	
	MAX(PI) AS PI,
		
	STUFF(
	(SELECT DISTINCT ', ' + Collaborator FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS Collaborators,

	STUFF(
	(SELECT DISTINCT ', ' + [ORC_ID] FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS [ORC_IDs],

	STUFF(
	(SELECT DISTINCT ', ' + Institution FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS Institutions,

	STUFF(
	(SELECT DISTINCT ', ' + [Institution City] FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS [Institution Citys],

	STUFF(
	(SELECT DISTINCT ', ' + [Institution Country] FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS [Institution Countries],

	STUFF(
	(SELECT DISTINCT ', ' + CSOCode FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS csos,

	STUFF(
	(SELECT DISTINCT ', ' + CancerSite FROM #projs
	WHERE AwardCode = p.AwardCode 
	FOR XML PATH ('')), 1,1, ''
	) AS sites
	
FROM #projs AS p
GROUP BY AwardCode

