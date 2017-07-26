drop table #dupPI
go 

select ncri.ProjectFundingID INTO #dupPI from
(select * from projectfunding where DataUploadStatusID=69) ncri
join ProjectFundingInvestigator pi on pi.ProjectFundingID = ncri.ProjectFundingID
GROUP BY ncri.ProjectFundingID having count(*) > 1

select * from #dupPI

select DISTINCT p.ProjectFundingID,  i.* from institution i
JOIN (select * from ProjectFundingInvestigator where ProjectFundingID IN (SELECT ProjectFundingID FROM #dupPI)) p ON i.institutionID = p.InstitutionID
ORDER BY p.ProjectFundingID

select * from ProjectFundingInvestigator where InstitutionID in(2181,4471,4426,3548,4339,4302,4472)

begin transaction

delete ProjectFundingInvestigator
--select pi.* from ProjectFundingInvestigator pi
from ProjectFundingInvestigator pi
join institution i ON pi.Institutionid = i.institutionid
where i.name in ('MRC Human Genome Mapping Project Resource Centre','MRC Centre for Inflammation Research','National Primary Care Research & Development Centre',
'University of Marburg','University Amedeo Avogadro of Piemonte Orientale','Centre for Cancer Biology','Roslin Institute')

select DISTINCT p.ProjectFundingID,  i.* from institution i
JOIN (select * from ProjectFundingInvestigator where ProjectFundingID IN (SELECT ProjectFundingID FROM #dupPI)) p ON i.institutionID = p.InstitutionID
ORDER BY p.ProjectFundingID

delete institution where name in ('MRC Human Genome Mapping Project Resource Centre','MRC Centre for Inflammation Research','National Primary Care Research & Development Centre',
'University of Marburg','University Amedeo Avogadro of Piemonte Orientale','Centre for Cancer Biology','Roslin Institute')

select ncri.ProjectFundingID from
(select * from projectfunding where DataUploadStatusID=70) ncri
join ProjectFundingInvestigator pi on pi.ProjectFundingID = ncri.ProjectFundingID
GROUP BY ncri.ProjectFundingID having count(*) > 1

--commit

rollback

--select top 1 * from datauploadstatus order by DataUploadStatusID desc
--select top 1 * from datauploadlog order by DataUploadStatusID desc

--select top 1 * from icrp_data.dbo.datauploadstatus order by DataUploadStatusID desc
--select top 1 * from icrp_data.dbo.datauploadlog order by DataUploadStatusID desc

--update icrp_dataload.dbo.datauploadlog set ProjectFundingInvestigatorCount = 17478 where DataUploadStatusID=69
--update icrp_data.dbo.datauploadlog set ProjectFundingInvestigatorCount = 17478 where DataUploadStatusID=70


