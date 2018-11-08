select p.AwardCode, f.altAwardCode, f.Amount, f.Category,  o.Name AS FundingOrg, ProjectStartDate, ProjectEndDate, BudgetStartDate, BudgetEndDate from ProjectFunding f
join fundingorg o on f.FundingOrgID = o.FundingOrgID
join project p on p.projectID = f.ProjectID
where BudgetStartDate is null or BudgetEndDate is null or BudgetEndDate < BudgetStartDate or 
	  p.ProjectStartDate is null or p.ProjectEndDate  is null or p.ProjectEndDate  <  p.ProjectStartDate OR 
	  f.Amount is null OR f.Amount < 0
ORDER BY p.ProjectStartDate