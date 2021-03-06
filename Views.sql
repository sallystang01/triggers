--#1

CREATE VIEW [dbo].[LEADS ENTERED PER DAY]
AS
select count(leadid) [Amount of Leads Entered], concat(DATEPART(month, recorddate), '-', datepart(day, RecordDate), '-', DATEPART(year, recorddate)) [Day]
from Leads
group by concat(DATEPART(month, recorddate), '-', datepart(day, RecordDate), '-', DATEPART(year, recorddate))

GO


--#2

CREATE VIEW [LeadsEnteredPerWeek]
AS
select count(leadid) [Number of Leads], datepart(week, RecordDate) [Week]
from Leads
group by datepart(week, recorddate)
GO
--#3

create view [NoActivityLeads]
AS
select LeadID, datediff(DAY, l.ModifiedDate, GETDATE()) [Number of Days], l.JobTitle, c.CompanyName, 
	concat(contactfirstname, ', ',ContactLastName) [Primary Contact Name], c.Phone, c.EMail 
from Leads l
inner join
companies c
on l.CompanyID = c.CompanyID
inner join
Contacts co
on co.ContactID = l.ContactID
where  datediff(DAY, l.ModifiedDate, GETDATE()) < 7
GO

--#4
CREATE VIEW [NumberOfLeadsBySource]
AS
select count(leadid) [Number of Leads], SourceID
from leads
group by SourceID
GO

--#5
CREATE VIEW [ActiveContacts]
AS
select co.CompanyName, co.Agency, c.ContactID, c.CourtesyTitle, concat(c.contactfirstname, ', ' ,c.ContactLastName) [Contact Name],
		c.Title, c.Phone, c.Extension, c.Fax, c.EMail, c.Comments, c.Active, c.ModifiedDate
from contacts c
inner join
Companies co
on co.CompanyID = c.CompanyID
where Active <> 0
GO

--#6
CREATE VIEW [CallList]
AS
select l.LeadID, l.JobTitle, c.CompanyName, l.JobDescription, l.Location, co.ContactFirstName, co.ContactLastName, co.Phone,
		datediff(DAY, ActivityDate, GETDATE()) [Days Since Last Activity]
from Leads l
inner join
Companies c
on c.CompanyID = l.CompanyID
inner join
Contacts co
on co.ContactID = l.ContactID
inner join
Activities a
on a.LeadID = l.LeadID
GO
--#7

CREATE VIEW [SearchLogActivities30Days]
AS
select ActivityID, ActivityDate, ActivityType, datediff(DAY, ActivityDate, GETDATE()) [Number of Days], Complete
from Activities 
where  datediff(DAY, ActivityDate, GETDATE()) < 30
GO

--#8
CREATE VIEW [LeadReport]
AS
select l.LeadID, l.RecordDate, l.JobTitle, l.JobDescription, l.EmploymentType, l.Location,
	l.Active, l.CompanyID, c.CompanyName, c.Agency, l.AgencyID, l.ContactID, concat(co.contactfirstname, ', ', co.contactlastname) [Contact],
	co.Title, co.Phone, co.EMail	,l.SourceID, s.SourceName
from Leads l
inner join
Companies c
on l.CompanyID = c.CompanyID
inner join
Contacts co
on co.ContactID = l.ContactID
inner join
Sources s
on s.SourceID = l.SourceID

GO

