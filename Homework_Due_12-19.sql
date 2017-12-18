
/*

Answer the following questions from the article
"Questions about Primary and Foreign Keys You Were To Shy To Ask"

https://www.red-gate.com/simple-talk/sql/t-sql-programming/questions-about-primary-and-foreign-keys-you-were-too-shy-to-ask
Insert the answers after the questions and turn them in with this file.


What purpose does the primary key of a table serve?
	Provides a mechanism for ensuring that the rows in a table are unqiue,.

What purpose do primary key values serve?
	Values contained in the column or columns that make up the primary key serve to identify each of those rows.

Can a table have unique values other than the primary key?
	A foreign key is also a type of constraint placed on one or more columns in a table. This foreign key is A UNIQUE value references from another table. In the other
	table, it would be a primary key.

Can a primary key column contain NULL values (certification question)?
	No

What is a composite primary key?
	More than one column acting as a primary key

What is a clustered index?
	a CLUSTERED index determines the physical sort order of the entire table, based on the key columns.

If a clustered index is already present on the table when the primary key is created, 
what type of index is created on the primary key?
	Nonclustered Index

A foreign key is a type of __________ placed on one or more columns in a table.
	Constraint

How does the foreign key enforce referential integrity between tables?
	Because you can only add permitted data to the foreign key columns in the child table. If the foreign key being referenced is not
	a primary key in another table, it cannot work. It would be invalid. The keys must match. 

Research:  What is the recommended limit of outgoing foreign keys per table?
	A table can reference a maximum of 253 other tables and columns as foreign keys. 

Research:  How many incoming foreign key references can a table support?
A table can support up to 253 foreign keys

A primary key is defined as nullable by default. True or False.
	False

What is a surrogate key?
	A single column, usually an INT, that identifies each row in the table but is not related to the rest of the table's data in any meanigful
	way. It really has no meaning, just to provbide a quick and easy way to point to a row of data.

What is an advantage to using the IDENTITY field as a primary key.
	Referential Integrity

What is a GUID?
A GUID (global unique identifier) is a term used by Microsoft for a number that its programming generates to create a unique identity for an entity such as a Word document.
 GUIDs are widely used in Microsoft products to identify interfaces, replica sets, records, and other objects.

How do composite primary keys affect performance?
	Makes it more complexx for each key to be included. 


What is a natural key?
	A natural key (also known as business key) is a type of unique key, 
	found in relational model database design, that is formed of attributes that already exist in the real world. 

What are the advantages and disadvantages for natural keys?
	Advantage: More in line with traditional relational thinking. Could make searching for relevbant information easier and do not 
	require additional columns. 
	Disadvantage: Might raise issues if business logic changes. 

How you you specify a nonclustered index for the primary key
	
	When you create a primary key, SQL Server automatically creates an index based on the key columns. If no clustered index is defined on the table, 
	SQL Server creates a clustered index; otherwise, a nonclustered index is created. 
	That said, you can specify that a nonclustered index be created instead of a clustered index, 
	thus overriding the default. If a clustered index already exists, 
	then you have no choice but to create a nonclustered index on the primary key

Why is the primary key often matched with the clustered index in a table?
	

What are the requirments for a foreign key?
	Foreign key must reference the parent table if it's in a child table. Must be unique. Can be null.
	The foreign key must reference a primary key or unique constraint.  
	A foreign key must also have the same number of columns as the number of columns in the referenced constraint.
	 Limited to the values in the referenced columns

What are the four options that can be set for a foreign key to affect what 
happens if the parent row is deleted?  What do these options do?

NO ACTION: The database engine raises an error if you try to modify data in the parent table that is being referenced in the child table. 
			This is the default behavior.
CASCADE: The database engine updates or deletes the corresponding rows in the child data if you update
 or delete that data in the parent table.

SET NULL: The database engine sets the foreign key columns to NULL in the child table
 if you update or delete the corresponding values in the parent table.

SET DEFAULT: The database engine sets the foreign key columns to their default values 
in the child table if you update or delete the corresponding values in the parent table.

What two SQL operations use the CASCADE option on the foreign key?
	UPDATE and DELETE

Does SQL Server automatically create indexes on foreign keys?
	

How do you disable and re-enable foreign keys on a table?

What is the name of the system view used to view information on all primary and 
foreign keys in the database?

sys.key_constraints

SQL Exercise

At the bottom of this file, write a script that does the following in the specified order.
The script must run a single time without error.  Use comments and the PRINT statement to
indicate each step in the script.

Create a new database called Homework and run the rest of the commands in that database.


Create the Countries table with the following fields:

CountryID, INT
CountryName, VARCHAR(50) (Indexed)
Population, BIGINT  
Currency, VARCHAR(50) 

Add CountryID as the primary key and name the key pk_Country.

Create the Cities table with the following fields:

CityID, INT, PRIMARY KEY
CityName, VARCHAR(50) (Indexed)
CountryID, INT (Indexed)
Population, BIGINT 

Specify CityID as the primary key using the simplest syntax available and 
let the database give it a name automatically.

Create the Books table with the following fields:

ISBN, VARCHAR(15)
DatePurchased, DATE 
Title, VARCHAR(255) (Indexed)
AuthorID, INT (Indexed)

AFTER the CREATE TABLE statement, add a composite, NONclustered primary key to 
the table on the ISBN and DatePurchased fields.

Drop the primary key that you added in the last step and use an ALTER TABLE 
statement to add the following field to the table:

BookID, INT, PRIMARY KEY

Write a SELECT statement that returns the record for this new primary key 
from the sys.key_constraints view.

Use the ALTER TABLE statement to add a foreign key to Cities that links the CountryID 
field in that table to the CountryID field in Countries.  
Use the CASCADE option that will delete all cities within a given country when that 
country is deleted from the Countries table.

Write statements to insert three records into each of the tables you created above.
Write UPDATE statements to increase the population of each of the countries and 
cities you've added by 15%.



*/

USE MASTER
if (select count(*) 
    from sys.databases where name = 'Homework') > 0
BEGIN
		DROP DATABASE Homework;
END




create database Homework;
GO
	PRINT 'DATABASE CREATED'

USE Homework;
	PRINT 'Using Homework Database';

exec sp_changedbowner 'sa';
	PRINT 'Congratulations! You are now the owner of the Homework database';

CREATE TABLE Countries
(
CountryID INT NOT NULL IDENTITY (1, 1),
CountryName VARCHAR(50), --(Indexed)
[Population] BIGINT,  
Currency VARCHAR(50), 
CONSTRAINT [PK_Country] PRIMARY KEY (CountryID)
);
	PRINT 'Table "Countries" Created!';

CREATE TABLE Cities

(CityID INT NOT NULL IDENTITY (1,1), 
CityName VARCHAR(50), --(Indexed)
CountryID INT NOT NULL, --(Indexed)
[Population] BIGINT
PRIMARY KEY (CityID)
 );

	PRINT 'Table "Cities" Created!';

CREATE TABLE Books
(
ISBN VARCHAR(15) NOT NULL,
DatePurchased DATE, 
Title VARCHAR(255), --(Indexed)
AuthorID INT --(Indexed)
CONSTRAINT PK_Books PRIMARY KEY NONCLUSTERED (ISBN, DatePurchased)
);

	PRINT 'Table "Books" Created!';
ALTER TABLE Books
DROP  CONSTRAINT PK_Books;
 
	PRINT 'Table "Books" Altered!';

ALTER TABLE Books

ADD
BookID INT NOT NULL IDENTITY(1, 1)
CONSTRAINT PK_BooksID PRIMARY KEY (BookID);



	PRINT 'Table "Books" Altered!';

--select *
--from 
--sys.key_constraints
--where name = 'PK_BooksID'

	PRINT 'Primary Key "PK_BooksID" Found!';

ALTER TABLE Cities
ADD CONSTRAINT FK_CountryID FOREIGN KEY (CountryID) REFERENCES Countries(CountryID) ON DELETE CASCADE;
	
	PRINT 'Table "Cities" Modified!';

--INSERT STATEMENTS
--COUNTRIES
INSERT INTO Countries
(CountryName, [Population], Currency)
VALUES ('United States', '323100000000', 'USD'),
		('England', '531000000', 'GBD'),
		('Italy', '60600000', 'EU');

	PRINT 'Table "Countries" Populated!';

--CITIES

INSERT INTO Cities
(CityName, CountryID, [Population])
Values ('New York', 1, '8538000'),
		('London', 2, '8780000'),
		('Rome', 3, '2868000');

	PRINT 'Table "Cities" Populated!';
--BOOKS

INSERT INTO Books
(ISBN, DatePurchased, Title)
Values ('1259587541', GETDATE(), 'Practical Electronics for Inventors, Fourth Edition'),
		('1259587401', GETDATE(), 'Programming the Raspberry Pi, Second Edition: Getting Started with Python'),
		('1608196704', GETDATE(), 'The Doomsday Machine: Confessions of a Nuclear War Planner');

		
	PRINT 'Table "Books" Populated!';

UPDATE Countries
SET [Population] = [Population] * 1.15;

	PRINT 'Population Increase!';

UPDATE Cities
SET [Population] = [Population] * 1.15;
	
	PRINT 'Population Increase!';
	

