USE MASTER
if (select count(*) 
    from sys.databases where name = 'JobSearch') > 0
BEGIN
		DROP DATABASE JobSearch;
END

create database JobSearch

GO
USE JobSearch

exec sp_changedbowner 'sa'

create table Sources
(
SourceID int not null identity (1, 1),
SourceName nchar(100),
SourceType nchar(100) ,
SourceLink nchar(200),
Description nchar(1000) 
primary key (SourceID)

)

Create table BusinessTypes
(
BusinessID int not null identity (1, 1),
BusinessType nchar(100) not null 
Primary key (BusinessID)
)


create table Companies
(
CompanyID int not null identity (1, 1),
CompanyName nchar(100) not null,
Address1 nchar(50) not null,
Address2 nchar(50) null,
City nchar(50) not null,
[State] nchar(50) not null,
ZIP nchar(20) not null,
Phone nchar(15) not null,
Fax nchar(15) null,
EMail nchar(50)  null,
Website nchar(100) null,
JobDescription nchar(1000) null,
BusinessType int  null,
Agency bit not null,
ModifiedDate datetime DEFAULT GETDATE(),
primary key (CompanyID),

)

create INDEX IDX_Companies on COMPANIES(COMPANYID)
GO




create table Contacts
(
ContactID int not null identity (1, 1),
CompanyID int  not null,
CourtesyTitle nchar(50) ,
ContactFirstName nchar(50) ,
ContactLastName nchar(50) ,
Title nchar(20),
Phone nchar(15) ,
Extension nchar(10),
Fax nchar(15) ,
EMail nchar(10) ,
Comments nchar(1000) ,
Active int ,
ModifiedDate datetime DEFAULT GETDATE(),
PRIMARY KEY (ContactID),

)


CREATE INDEX IDX_CONTACTS on CONTACTS(CONTACTID)
GO

Create table Leads
(
LeadID int not null identity(1, 1),
RecordDate datetime DEFAULT GETDATE(),
JobTitle nchar(50) ,
[JobDescription] nchar(1000) ,
EmploymentType nchar(50)  
	CONSTRAINT CK_EmploymentType CHECK (EmploymentType IN ('Full Time', 'Part Ttime', 'Temporary')),
Location nchar(100) ,
Active bit CONSTRAINT DF_Active DEFAULT (1)  ,
CompanyID int  ,
AgencyID int  ,
ContactID int  ,
SourceID int ,
Selected nchar(20) ,
ModifiedDate datetime DEFAULT GETDATE(),
CONSTRAINT CK_ModifiedDate_NoFutureDates CHECK (ModifiedDate <= GETDATE()),
PRIMARY KEY (LeadID)

)

CREATE INDEX IDX_LEADS on LEADS(LEADID)
GO

create table Activities 
(
ActivityID int not null identity (1, 1),
LeadID int  ,
ActivityDate datetime DEFAULT GETDATE(),
ActivityType nchar(50) ,
ActivityDetails nchar(50),
Complete int ,
ReferenceLink nchar(255) ,
ModifiedDate datetime DEFAULT GETDATE(),
PRIMARY KEY (ActivityID)
)
GO
CREATE INDEX IDX_ACTIVITIES on ACTIVITIES(ACTIVITYID)
GO
CREATE TRIGGER trgRecordModifyLeads
ON Leads
AFTER Insert, UPDATE
AS
BEGIN

	UPDATE		l
	SET			l.ModifiedDate = GETDATE()
	FROM		Leads l
	

END
GO


CREATE TRIGGER trgRecordModifyActivities
ON Activities
AFTER Insert, UPDATE
AS
BEGIN

	UPDATE		a
	SET			a.ModifiedDate = GETDATE() 
	FROM		Activities a
	

END
go

CREATE TRIGGER trgCheckIDLead
ON activities
AFTER INSERT, UPDATE
AS
	IF EXISTS
	(
		SELECT LeadID
		FROM inserted
		WHERE LeadID NOT IN (SELECT LeadID FROM Leads)
	)
BEGIN	
RAISERROR ('This is not a valid ID. Please enter a valid ID to continue.', 16,1)

END
go

CREATE TRIGGER dbo.trg_CheckIDcompany
ON leads
AFTER INSERT, UPDATE
AS
	IF EXISTS
	(
		SELECT CompanyID
		FROM inserted
		WHERE CompanyID NOT IN (SELECT CompanyID FROM Companies)
	)
BEGIN	
RAISERROR ('This is not a valid ID. Please enter a valid ID to continue.', 16,1)

END
go




CREATE TRIGGER trgCheckIDcontact
ON leads
AFTER INSERT, UPDATE
AS
	IF EXISTS
	(
		SELECT ContactID
		FROM inserted
		WHERE ContactID NOT IN (SELECT ContactID FROM Contacts)
	)
BEGIN	
RAISERROR ('This is not a valid ID. Please enter a valid ID to continue.', 16,1)

END
go

CREATE TRIGGER trgCheckIDsource
ON leads
AFTER INSERT, UPDATE
AS
	IF EXISTS
	(
		SELECT SourceID
		FROM inserted
		WHERE SourceID NOT IN (SELECT SourceID FROM Companies)
	)
BEGIN	
RAISERROR ('This is not a valid ID. Please enter a valid ID to continue.', 16,1)

end
GO

CREATE TRIGGER trgCheckIDBusiness
ON companies
AFTER INSERT, UPDATE
AS
	IF EXISTS
	(
		SELECT BusinessType
		FROM inserted
		WHERE BusinessType NOT IN (SELECT BusinessID FROM BusinessTypes)
	)
BEGIN	
RAISERROR ('This is not a valid ID. Please enter a valid ID to continue.', 16,1)

end
GO


CREATE TRIGGER TRG_ActivityDelete_main
ON leads
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.leadID IN (select distinct leadID FROM Activities))
    BEGIN
        RAISERROR('Specified LeadID referenced by Activity records. Record not deleted.',16,1)
		 ROLLBACK TRANSACTION 
  end   
END
GO



CREATE TRIGGER TRG_CompanyDelete
ON companies
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.companyID IN (select distinct companyID FROM leads))
    BEGIN
        RAISERROR('Specified CompanyID referenced by Lead records. Record not deleted.',16,1)
		 ROLLBACK TRANSACTION 
  end   
END
GO

CREATE TRIGGER TRG_DeleteContact
ON contacts
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.contactID IN (select distinct ContactID FROM leads))
    BEGIN
        RAISERROR('Specified ContactID referenced by Lead records. Record not deleted.',16,1)
		 ROLLBACK TRANSACTION 
  end   
END
GO

CREATE TRIGGER TRG_SourceDelete
ON sources
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.sourceID  in(select distinct sourceID FROM leads))
    BEGIN
        RAISERROR('Specified CompanyID referenced by Lead records. Record not deleted.',16,1)
		 ROLLBACK TRANSACTION 
  end   
END
GO

CREATE TRIGGER TRG_SourceDelete_MAIN
ON leads
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.sourceID  in(select distinct sourceID FROM sources))
    BEGIN
        RAISERROR('Specified CompanyID referenced by Lead records. Record not deleted.',16,1)
		 ROLLBACK TRANSACTION 
  end   
END
GO


CREATE TRIGGER TRG_CompanyDelete_MAIN
ON leads
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.CompanyID  in(select distinct companyID FROM Companies))
    BEGIN
       
	   RAISERROR('Specified CompanyID referenced by Lead records. Record not deleted.',16,1)
   ROLLBACK TRANSACTION 
  end 
    
END
GO

CREATE TRIGGER TRG_ContactDelete_MAIN
ON leads
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.ContactID  in(select distinct ContactID FROM Contacts))
    BEGIN
       
	   RAISERROR('Specified CompanyID referenced by Lead records. Record not deleted.',16,1)
   ROLLBACK TRANSACTION 
  end 
    
END
GO

