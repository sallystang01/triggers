CREATE LOGIN BrendaTheLibrarian  
    WITH PASSWORD = 'ReadBooks1234';  
GO  
  
CREATE USER BrendaTheLibrarian FOR LOGIN BrendaTheLibrarian;  
GO

ALTER ROLE [db_datareader] ADD MEMBER BrendaTheLibrarian

GO