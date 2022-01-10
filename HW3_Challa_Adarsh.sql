USE BUDT703_DB_Student_186

ALTER TABLE [Terps.Department]
	DROP CONSTRAINT IF EXISTS fk_Department_mgrEmpSSN
	   
--SQL remove tables: 
DROP TABLE IF EXISTS [Terps.Dependent];
DROP TABLE IF EXISTS [Terps.Work];
DROP TABLE IF EXISTS [Terps.Project]; 
DROP TABLE IF EXISTS [Terps.Location];
DROP TABLE IF EXISTS [Terps.Employee];
DROP TABLE IF EXISTS [Terps.Department];


--Create Tables
CREATE TABLE [Terps.Department] (
		dptId CHAR (2) NOT NULL,
		dptName VARCHAR (15),
		mgrEmpSSN CHAR (11) NOT NULL, -- manager of the department
		mgrStartDate DATE,
		CONSTRAINT pk_Department_dptId PRIMARY KEY (dptId) )
		--CONSTRAINT fk_Department_mgrEmpSSN FOREIGN KEY (mgrEmpSSN) (using this is the end as alter function)
			--REFERENCES [Department.Employee] (sSN)
			--ON DELETE NO ACTION ON UPDATE NO ACTION)

CREATE TABLE [Terps.Employee] (
		sSN CHAR (11) NOT NULL, -- ssn example 111-12-6751
		empFName VARCHAR (20),
		empMInit VARCHAR (1),
		empLName VARCHAR (20),
		empDOB DATE,  
		empGender CHAR(1),
		empStreet VARCHAR (20), 
		empCity VARCHAR (25),
		empState CHAR(2),
		empZip VARCHAR(10) , --20783-2222 ( zip and sub zip code)
		empSalary DECIMAL (10,2) , --11,111,111.11 ( example of salary)
		sprEmpSSN CHAR (11), -- not null is not included because The CEO may not have supervisor
		dptId CHAR (2) NOT NULL,
		CONSTRAINT pk_Employee_sSN PRIMARY KEY (sSN),
		CONSTRAINT fk_Employee_sprEmpSSN FOREIGN KEY (sprEmpSSN)
			REFERENCES [Terps.Employee] (sSN)
			ON DELETE NO ACTION ON UPDATE NO ACTION,
		CONSTRAINT fk_Employee_dptId FOREIGN KEY (dptId)
			REFERENCES [Terps.Department] (dptId)
			ON DELETE NO ACTION ON UPDATE NO ACTION)
	
CREATE TABLE [Terps.Location] (     --department location table
		dptId CHAR (2) NOT NULL, 
		dptLoc VARCHAR (45) NOT NULL,
		CONSTRAINT pk_Location_dptId_dptLoc PRIMARY KEY (dptId, dptLoc),
		CONSTRAINT fk_Location_dptId FOREIGN KEY (dptId)
			REFERENCES [Terps.Department] (dptId)
			ON DELETE CASCADE ON UPDATE CASCADE)

CREATE TABLE [Terps.Project] (
		prjId CHAR (2) NOT NULL, 
		prjName VARCHAR (15),
		prjLoc VARCHAR (15),  --project location
		dptId CHAR (2) NOT NULL,
		CONSTRAINT pk_Project_prjId PRIMARY KEY (prjId),
		CONSTRAINT fk_Project_dptId FOREIGN KEY (dptId)
			REFERENCES [Terps.Department] (dptId)
			ON DELETE CASCADE ON UPDATE CASCADE )

CREATE TABLE [Terps.Work] (
		sSN CHAR (11) NOT NULL,
		prjId CHAR (2) NOT NULL, 
		hours_w DECIMAL (5,1), -- number of hours worked in a project
		CONSTRAINT pk_Work_empSSN_prjId PRIMARY KEY (sSN, prjId),
		CONSTRAINT fk_Work_empSSN FOREIGN KEY (sSN)
			REFERENCES [Terps.Employee] (sSN)
			ON DELETE NO ACTION ON UPDATE NO ACTION,
		CONSTRAINT fk_Work_prjId FOREIGN KEY (prjId)
			REFERENCES [Terps.Project] (prjId)
			ON DELETE NO ACTION ON UPDATE NO ACTION )

CREATE TABLE [Terps.Dependent] (
		sSN CHAR (11) NOT NULL, 
		dpdName VARCHAR (25) NOT NULL, 
		dpdDOB DATE, 
		dpdGender CHAR (1), 
		relationship VARCHAR (30),
		CONSTRAINT pk_Dependent_sSN_dpdName PRIMARY KEY (sSN, dpdName) ,
		CONSTRAINT fk_Dependent_sSN FOREIGN KEY (sSN)
			REFERENCES [Terps.Employee] (sSN)
			ON DELETE CASCADE ON UPDATE CASCADE )
		
		

-- insert values
INSERT INTO [Terps.Department] VALUES
	('02','Accounts', '111-12-6751', '7/27/2012')

INSERT INTO [Terps.Employee] VALUES
	('111-12-6751','Ramesh','K','Smith', '7/26/2012','M','Paris St.','Hyattsville','MD', '20783', 340000.00, NULL,'02'), --CEO of the company so no supervisor
	('111-12-6752','Suresh','H','Smith', '7/27/2012','M','Paris St.','Hyattsville','MD', '20783', 340100.00, '111-12-6751','02'),
	('111-12-6753','Paresh','H','Smith', '7/28/2012','M','Paris St.','Hyattsville','MD', '20783', 340200.00, '111-12-6751','02')

INSERT INTO [Terps.Location] VALUES
	('02', 'PrinceCounty')

INSERT INTO [Terps.Project] VALUES
	('05', 'AnalyticsTerp', 'GeorgeCounty','02')

INSERT INTO [Terps.Work] VALUES
	('111-12-6752','05', 80.4)

INSERT INTO [Terps.Dependent] VALUES
	('111-12-6751','MathewsH', '8/26/1942', 'M', 'Father')


-- Adding foreign key constraint to department for mgrEmpSSN column.
ALTER TABLE [Terps.Department] ADD 
			CONSTRAINT fk_Department_mgrEmpSSN FOREIGN KEY (mgrEmpSSN)
			REFERENCES [Terps.Employee] (sSN)
			ON DELETE NO ACTION ON UPDATE NO ACTION