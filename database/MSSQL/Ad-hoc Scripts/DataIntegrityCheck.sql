-- Data Integrity Check after 2.0 data Import
select * from partner where latitude is null
select * from fundingorg where latitude is null and MemberStatus <> 'Merged'
select * from institution where latitude is null and name <> 'Missing'

select distinct i.city, i.state, i.country from institution i
left join lu_city c ON i.city = c.name and isnull(i.state, '') = isnull(c.state,'') and isnull(i.country,'') = isnull(c.country,'') where c.latitude is null and i.name <> 'Missing'

select i.* from institution i
join country c on i.country = c.Abbreviation where c.RegionID=3 order by i.latitude