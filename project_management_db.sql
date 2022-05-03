/********************************************************/
/*			Final Project: Cask Consulting				*/
/********************************************************/
--Team Members: 

/********************************************************/
/*		CREATE THE DATABASE FOR Cask Consulting			*/
/********************************************************/

	USE Master;
	GO

	IF EXISTS (SELECT * FROM Master.dbo.sysdatabases WHERE NAME = 'CaskConsulting')
		DROP DATABASE CaskConsulting; 
	GO

	CREATE DATABASE CaskConsulting;
	GO

	USE CaskConsulting;
	GO


/********************************************************/
/*					CREATE TABLES						*/
/********************************************************/

--	Create the Client Companies Table	
	--Schema tblClientCompanies (Company ID, Company Name, Address, City, State, Zip Code, Country, Cust.ServicePhone#) */
	
	CREATE TABLE tblClientCompanies (
		CompanyID			INT	IDENTITY (20001, 1)	PRIMARY KEY, 
		CompanyName			VARCHAR (128)	, 
	 	Address				VARCHAR (128)	,	 
		City				VARCHAR (128)	,
		State				Varchar	(128)	,
		ZipCode				INT				,
		Country				VARCHAR	(128)	,
		CustPhoneNumber		VARCHAR	(128)	,
		);

--	Create the People Table	
	--Schema tblPeople (PeopleID, First name, Last name, Address, City, State, Zip Code, Country, Phone number, Email Address, Fax Number, Company ID)
	
	CREATE TABLE tblPeople (
		PeopleID			INT	IDENTITY (10001, 1)		PRIMARY KEY, 
		FirstName			VARCHAR (128)	, 
		LastName			VARCHAR (128)	, 
	 	Address				VARCHAR (128)	,	 
		City				VARCHAR (128)	,
		State				Varchar	(128)	,
		ZipCode				INT				,
		Country				VARCHAR	(128)	,
		PhoneNumber			VARCHAR	(128)	,
		EmailAddress		VarChar (128)	,
		FaxNumber			VarChar	(128)	,
		CompanyID			INT		references tblClientCompanies,
		);
	
--	Create the Project Managers Table 
	--Schema tblProjectManagers (Manager ID, Manager Title, Manger Salary)
	
	CREATE TABLE tblProjectManagers (
		ManagerID			INT		PRIMARY KEY references tblPeople, 
		ManagerTitle		Varchar (128)	,
		ManagerSalary		Int				,
		);
	
--	Create the Employees Table
	/* Schema tblEmployees (Employee ID, Employee Title, Employee Rate, Direct Report) */
	
	CREATE TABLE tblEmployees (
		EmployeeID			INT		PRIMARY KEY references tblpeople, 
		EmployeeTitle		Varchar (128)	,
		EmployeeRate		INT				,
		DirectReport		INT		references tblpeople Not Null
		);
	 	
--	Create the Project Team Table		
	--Schema tblProjectTeam (Employee ID, Manager ID)
	
	CREATE TABLE tblProjectTeam (
		EmployeeID			INT		references tblEmployees, 
		ManagerID			INT		references tblProjectManagers,
		Primary Key (EmployeeID, ManagerID)
		);

--	Create the Projects Table			
	--Schema tblProjects (Project ID, Project Name, Associated Department, Charge Rate)
	
	CREATE TABLE tblProjects (
		ProjectID			INT				IDENTITY (90001, 1)		PRIMARY KEY	, 
		ProjectName			VarChar	(128)	Unique Not Null						,
		Department			Varchar (128)										,
		ChargeRate			FLOAT			DEFAULT 0.0							,
		);

--	Create the Proposals Table
	--Schema tblProposals (ProposalID, Proposal Year, Proposal Name, Proposal Description, Projected Due Date, Proposed Hours, Acceptance Date, Approving Managers, Employee ID, Company ID, Contact ID)*/
	
	CREATE TABLE tblProposals (
		ProposalID			INT				IDENTITY (80001, 1)		PRIMARY KEY	, 
		ProposalYear		VARCHAR (4)											,
		ProposalName		Varchar (128)										,
		ProposalDescription	Varchar (256)										,
		ProjectedDueDate	Date												,
		ProposedHours		INT				DEFAULT 0							,
		AcceptanceDate		Date												,
		ApprovingManager	INT		Not Null	references tblProjectManagers	,
		EmployeeID			INT		Not Null	references tblEmployees			,
		CompanyID			INT		Not Null	references tblClientCompanies	,
		ContactID			INT		Not Null	references tblPeople			,
		);
	 	
--	Create the Time Entries Table
	--Schema tblTimeEntries ( TimeEntryID, Current Date, Project Memo, Project ID, Employee ID)
	
	CREATE TABLE tblTimeEntries (
		TimeEntryID			INT		PRIMARY KEY									, 
		CurrentDate			Date												, 
	 	ProjectMemo			VARCHAR (256)										,	 
		ProjectID			INT		Not Null	references tblprojects			,
		EmployeeID			INT		Not Null	references tblemployees			,
		);

--	Create the ProposalProjects Table
	--Schema tblProposalProjects (Project ID, ProposalID)
	
	CREATE TABLE tblProposalProjects (
		ProjectID			INT		references	tblProjects		, 
		ProposalID			INT		references	tblProposals	,
		Primary Key (ProjectID, ProposalID)
		);
	 
--	Create the Proposal Progress Table	
	--Schema tblProposalProgress (ProposalID, Time Entry ID, Actual Hours, % of Proposed Hours)
	
	CREATE TABLE tblProposalProgress (
		TimeEntryID			INT		references	tblTimeEntries	, 
		ProposalID			INT		references	tblProposals	,
		ActualHours			INT		DEFAULT 0					,
		Primary Key (TimeEntryID, ProposalID)
		);



/********************************************************************************/
/*		CREATE INDEXES FOR TABLES IN ORDER TO SPEED UP QUERY PERFORMANCE		*/
/********************************************************************************/

/* first index on ActualHours Columnn in tblProposalProgress, because this will
	be important in answering business questions. ActualHours will be constantly queried in our 
	business questions, so creating an index on this column will greatly improve query performance*/

	CREATE INDEX idx_ActualHours
	ON tblProposalProgress (ActualHours);

/* Next index on ProposedHours and ProjectedDueDate in the tblProposals table in order to 
	speed up queries on these important columns in the table. ProposedHours and ProjectedDueDate 
	will be queried in our business questions constantly in order to see which projects may have 
	gone over their projected hours, so this index will speed up those queries*/

	CREATE INDEX idx_ProposedHours_ProjectedDueDate
	ON tblProposals (ProposedHours, ProjectedDueDate);

/* Index on ProjectName and ChargeRate in tblProjects in order to increase queries on these
	columns in our business questions. ChargeRate and projectName will be queried constantly in 
	order to perform tasks such as find which projects have gone over hours and how much money 
	is being spent on these projects, so adding an index on these columns will improve query performance*/

	CREATE INDEX idx_ProjectName_ChargeRate
	ON tblProjects (ProjectName, ChargeRate);

/* Index on CompanyName in tblClientCompanies to speed up queries which involve looking at which 
	client companies may have the best track record in projects being completed on time, or any other 
	possible variation of that query, so adding an index will improve the performance of these types 
	of queries*/

	CREATE INDEX idx_CompanyName
	ON tblClientCompanies (CompanyName);



	 	
/********************************************************/
/*				INPUT DATA INTO TABLES					*/
/********************************************************/

-- Insert data into the ClientCompanies table 8
	INSERT INTO tblClientCompanies VALUES 
	('Bakers'	, '1212 Tyler Street'		, 'Escondido', 'CA', 92553, 'US', '951-628-5371'),
	('Amazon'	, '648 Busy Ave'			, 'San Diego', 'CA', 92101, 'US', '619-292-8423'),
	('Samsung'	, '12 Harbor drive'			, 'San Diego', 'CA', 92101, 'US', '619-278-9452');

-- Insert data into the People table 12
	INSERT INTO tblPeople VALUES 
	('Darth'	, 'Vader'	, '18 Empire Lane'			, 'San Bernardino'	, 'CA', 92374, 'US', '909-987-4723', 'DarV@sdsu.edu', '909-845-3486', null) ,
	('Baby'		, 'Boss'	, '12 Executive Circle Way'	, 'Orange County'	, 'CA', 92662, 'US', '714-985-6547', 'BosB@sdsu.edu', '714-562-8432', null) ,
	('Worker'	, 'Bee'		, '9328 Wine Drive'			, 'Temecula'		, 'CA', 92592, 'US', '951-554-4724', 'WorB@sdsu.edu', '951-257-3254', null) ,
	('John'		, 'Doe'		, '2014 Anonamous Drive'	, 'Oceanside'		, 'CA', 92152, 'US', '619-554-5462', 'johD@sdsu.edu', '619-257-9875', null) ,
	('Roy'		, 'Jones'	, '1010 North Harbor Drive'	, 'San Diego'		, 'CA', 92101, 'US', '619-324-5342', 'RoyJ@sdsu.edu', '619-324-5344', null) ,	
	('Jane'		, 'Doe'		, '2014 Anonamous Drive'	, 'Oceanside'		, 'CA', 92152, 'US', '619-554-5462', 'janD@sdsu.edu', '619-257-9875', null) ,
	('John'		, 'Smith'	, '12793 Bus Lane'			, 'San Diego'		, 'CA', 92152, 'US', '619-554-5462', 'janD@sdsu.edu', '619-257-9875', null) ,
	('Worker'	, 'One'		, '2014 A Drive'			, 'Oceanside'		, 'CA', 92152, 'US', '951-554-5461', 'WorO@sdsu.edu', '951-628-5371', 20001),
	('Worker'	, 'Two'		, '2014 B Drive'			, 'Oceanside'		, 'CA', 92152, 'US', '619-554-5462', 'WorT@sdsu.edu', '619-292-8423', 20002),
	('Worker'	, 'Three'	, '2014 C Drive'			, 'Oceanside'		, 'CA', 92152, 'US', '619-554-5463', 'WrkT@sdsu.edu', '619-278-9452', 20003)
	;

-- Insert data into the Project Managers table 3
	INSERT INTO tblProjectManagers VALUES 
	(10001, 'Executive Manager'	, 500000),
	(10002, 'Senior Manager'	, 210000),
	(10003, 'Manager'			, 120000)
	;

-- Insert data into the Employees table 4
	INSERT INTO tblEmployees VALUES
	(10004, 'Sales'			, 32.14, 10003),
	(10005, 'Consulting'	, 50.00, 10002),
	(10006, 'Consulting'	, 48.12, 10002),
	(10007, 'Consulting'	, 44.00, 10002)
	;
	--does the direct report work for the employee or does the employee work for the direct report

-- Insert data into the ProjectTeam table
	INSERT INTO tblProjectTeam VALUES
	(10004, 10003),
	(10005, 10002),
	(10006, 10002),
	(10007, 10002)
	;
-- Insert data into the Projects table
	INSERT INTO tblProjects VALUES 
	('Project A', 'Sales', 85.15),
	('Project B', 'Sales', 85.15),
	('Project C', 'Sales', 85.15),
	('Project D', 'Sales', 85.15),
	('Project E', 'Sales', 85.15),
	('Project F', 'Sales', 85.15),
	('Project G', 'Sales', 85.15),
	('Project H', 'Sales', 85.15)
	;

-- Insert data into the Proposals table
	INSERT INTO tblProposals VALUES 
	('2021', 'Project A', 'Consulting Services A', '05/10/2021', 48, '4/20/2021', 10001, 10004, 20001, 10008),
	('2021', 'Project B', 'Consulting Services B', '03/10/2021', 48, '4/20/2021', 10002, 10005, 20002, 10009),
	('2021', 'Project C', 'Consulting Services B', '05/15/2022', 48, '4/20/2021', 10003, 10006, 20002, 10009),
	('2021', 'Project D', 'Consulting Services C', '12/15/2020', 48, '4/20/2021', 10001, 10007, 20003, 10010),
	('2021', 'Project E', 'Consulting Services A', '05/20/2022', 48, '4/22/2021', 10002, 10004, 20001, 10008),
	('2021', 'Project F', 'Consulting Services B', '04/01/2021', 48, '4/22/2021', 10003, 10005, 20002, 10009),
	('2021', 'Project G', 'Consulting Services B', '02/01/2022', 48, '4/22/2021', 10001, 10006, 20002, 10009),
	('2021', 'Project H', 'Consulting Services C', '06/14/2022', 48, '4/22/2021', 10002, 10007, 20003, 10010)
	;

-- Insert data into the TimeEntries table
	INSERT INTO tblTimeEntries VALUES 
	
	(70001,'4/20/2021', '', 90001, 10004),
	(70002,'4/20/2021', '', 90002, 10005),
	(70003,'4/20/2021', '', 90003, 10006),
	(70004,'4/20/2021', '', 90004, 10007),

	(70005,'4/21/2021', '', 90001, 10004),
	(70006,'4/23/2021', '', 90002, 10005),
	(70007,'3/21/2020', '', 90003, 10006),
	(70008,'4/21/2021', '', 90004, 10007),

	(70009,'4/23/2021', '', 90001, 10004),
	(70010,'4/22/2021', '', 90002, 10005),
	(70011,'3/29/2021', '', 90003, 10006),
	(70012,'4/22/2021', '', 90004, 10007),

	(70013,'4/22/2021', '', 90005, 10004),
	(70014,'5/22/2021', '', 90006, 10005),
	(70015,'4/22/2021', '', 90007, 10006),
	(70016,'4/22/2021', '', 90008, 10007)
	;

-- Insert data into the ProposalsProjects table
	INSERT INTO tblProposalProjects VALUES 
	(90001, 80001),
	(90002, 80002),
	(90003, 80003),
	(90004, 80004),
	(90005, 80005),
	(90006, 80006),
	(90007, 80007),
	(90008, 80008)
	;

-- Insert data into the ProposalProgress table
	INSERT INTO tblProposalProgress VALUES 
	
	(70001, 80001, 8),
	(70002, 80002, 8),
	(70003, 80003, 8),
	(70004, 80004, 8),  

	(70005, 80001, 8),
	(70006, 80002, 8),
	(70007, 80003, 8),
	(70008, 80004, 8),

	(70009, 80001, 4),
	(70010, 80002, 4),
	(70011, 80003, 4),
	(70012, 80004, 4),

	(70013, 80001, 40),
	(70014, 80002, 12),
	(70015, 80003, 4),
	(70016, 80004, 4);



/********************************************************/
/*		SHOW THE CONTENTS OF EACH TABLE IN TURN			*/
/********************************************************/
	
	Select * From tblClientCompanies;
	Select * from tblPeople;
	Select * from tblProjectManagers;
	Select * From tblEmployees;
	Select * From tblProjectTeam;
	Select * From tblTimeEntries;
	Select * From tblProposals;
	Select * from tblProjects;
	Select * from tblProposalProjects;
	select * from tblProposalProgress;


/********************************************************/
/*		Business Questions								*/
/********************************************************/

	--Q1 Which proposals have gone over its proposed hours?
	Select p.ProposalName, p.ProposedHours, SUM(pr.ActualHours) AS TotalHours
	From tblProposals p 
	JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
	GROUP by p.ProposalName, p.ProposedHours
	HAVING SUM(pr.ActualHours) > p.ProposedHours;

	--Q2 What percentage of proposed hours have been used up for each proposal? 
    --   Categorize the percent of proposed hours with Red >= 100%, Yellow >= 60%, Green < 60%. 
    --   Include the project manager.
	Select p.ProposalName, CAST((SUM(pr.ActualHours)/CAST(p.ProposedHours AS FLOAT)*100) as int) AS PercentHrsUsed,
    p.ProposedHours,
        CASE 
            WHEN CAST((SUM(pr.ActualHours)/CAST(p.ProposedHours AS FLOAT)*100) as int) >= 100 THEN 'Red'
            WHEN CAST((SUM(pr.ActualHours)/CAST(p.ProposedHours AS FLOAT)*100) as int) > 60 THEN 'Yellow'
            ELSE 'Green'
        END AS ProposalStatus,
    concat(ppl.FirstName,' ',ppl.LastName) as ProjectManager
	From tblProposals p 
	JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
    LEFT JOIN tblProjectManagers pm on p.ApprovingManager = pm.ManagerID
    LEFT JOIN tblPeople ppl on pm.ManagerID = ppl.PeopleID
	GROUP by p.ProposalName, p.ProposedHours, ppl.FirstName, ppl.LastName;

    --Q3 3.	What is the current total cost of each project?
    Select pr.ProjectName, (pr.ChargeRate * th.TotalHours) AS TotalCost
    FROM tblProjects pr
    LEFT JOIN (
            SELECT SUM(pp.ActualHours) as TotalHours, te.ProjectID
            FROM tblProposalProgress pp
            JOIN tblTimeEntries te on te.TimeEntryID = pp.TimeEntryID
            GROUP BY te.ProjectID
    ) AS th on pr.ProjectID = th.ProjectID
    ORDER BY TotalCost DESC;

    --Q4 Which projects are guided by proposals that are within the proposed hours?
    SELECT pj.ProjectName, pj.Department, pr.ProposedHours, pr.TotalHours, 
    CONCAT(ppl.FirstName, ' ', ppl.LastName) AS ProjectManagerName
    FROM tblprojects pj
    JOIN tblProposalProjects pp on pp.ProjectID = pj.ProjectID
    JOIN (	
        Select p.ProposalID, p.ApprovingManager, p.ProposedHours, SUM(pr.ActualHours) AS TotalHours
	    From tblProposals p 
	    JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
	    GROUP by p.ProposalID, p.ProposedHours, p.ApprovingManager
	    HAVING SUM(pr.ActualHours) < p.ProposedHours ) pr on pr.ProposalID = pp.ProposalID
    LEFT JOIN tblProjectManagers pm on pr.ApprovingManager = pm.ManagerID
    LEFT JOIN tblPeople ppl on pm.ManagerID = ppl.PeopleID;

    -- Q5 Which costly projects (Top 2) are guided by proposals that are past their planned due dates?
    Select TOP 2 WITH TIES pr.ProjectName, (pr.ChargeRate * th.TotalHours) AS TotalCost,
    due.ProposalName, due.ProjectedDueDate
    FROM tblProjects pr
    LEFT JOIN (
            SELECT SUM(pp.ActualHours) as TotalHours, te.ProjectID
            FROM tblProposalProgress pp
            JOIN tblTimeEntries te on te.TimeEntryID = pp.TimeEntryID
            GROUP BY te.ProjectID
    ) AS th on pr.ProjectID = th.ProjectID
    JOIN tblProposalProjects pp on pp.ProjectID = pr.ProjectID
    JOIN (
            SELECT pr.ProposalID, pr.ProposalName, pr.ProjectedDueDate
            from tblProposals pr
            join tblProposalProgress pp on pp.ProposalID = pr.ProposalID
            join tblTimeEntries te on pp.TimeEntryID = te.TimeEntryID
            GROUP BY pr.ProposalID, pr.ProjectedDueDate, pr.ProposalName
            HAVING MAX(te.CurrentDate) < pr.ProjectedDueDate
    ) AS due on due.ProposalID = pp.ProposalID
    ORDER BY TotalCost DESC;

    -- Q6 What is the duration in days of each proposal (difference between approval date and the latest time entry)?
    SELECT pr.ProposalName, DATEDIFF(day, pr.AcceptanceDate,pp.LatestEntry) As DurationInDays,
    CONCAT(pl.FirstName,' ',pl.LastName) AS ProjectManager, pl.PhoneNumber AS ManagerContactNo, cc.CompanyName 
    FROM tblProposals pr
    JOIN (
        SELECT pp.ProposalID, MAX(CurrentDate) as LatestEntry
        FROM tblTimeEntries te 
        JOIN tblProposalProgress pp on pp.TimeEntryID = te.TimeEntryID
        GROUP BY pp.ProposalID
    ) AS pp on pp.ProposalID = pr.ProposalID
    LEFT JOIN tblProjectManagers pm on pr.ApprovingManager = pm.ManagerID
    LEFT JOIN tblPeople pl on pm.ManagerID = pl.PeopleID
    LEFT JOIN tblClientCompanies cc on pr.CompanyID = cc.CompanyID;

 
    --Q7 What is the track record of each company in terms of being involved with proposals that are completed 
    --   within the proposed hours?

    SELECT cc.CompanyName, cc.CustPhoneNumber, cc.City, cc.[State], COUNT(pr.ProposalID) AS NumberOfProposals,
    CAST((COUNT(pr.ProposalID) - COUNT(Distinct pm.ProposalID))/CAST(COUNT(pr.ProposalID) AS Float)* 100 AS INT) AS PercentProposalsWithinHrs
    FROM tblClientCompanies cc
    LEFT JOIN tblProposals pr on cc.CompanyID = pr.CompanyID
    LEFT JOIN (
            Select SUM(pr.ActualHours) AS TotalHours, p.CompanyID, p.ProposalID
            From tblProposals p 
            JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
            GROUP by p.CompanyID, p.ProposedHours, p.ProposalID
            HAVING SUM(pr.ActualHours) > p.ProposedHours
    ) AS pm on cc.CompanyID = pm.CompanyID
    GROUP BY cc.CompanyName,cc.CustPhoneNumber,cc.City,cc.[State]
    ORDER BY PercentProposalsWithinHrs DESC


    --Q8 What is the track record of each manager in terms of managing proposals that are within the proposed hours?
    SELECT CONCAT(pl.FirstName,' ',pl.LastName) AS ProjectManager, COUNT(pr.ProposalID) AS ProjectsApproved,
    CAST((COUNT(pr.ProposalID) - COUNT(Distinct pm2.ProposalID))/CAST(COUNT(pr.ProposalID) AS Float)* 100 AS INT) AS PercentProjectsWithinHrs
    FROM tblProjectManagers pm
    JOIN tblPeople pl on pl.PeopleID = pm.ManagerID
    LEFT JOIN tblProposals pr on pm.ManagerID = pr.ApprovingManager
    LEFT JOIN (
            Select SUM(pr.ActualHours) AS TotalHours, p.ApprovingManager, p.ProposalID
            From tblProposals p 
            JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
            GROUP by p.ApprovingManager, p.ProposedHours, p.ProposalID
            HAVING SUM(pr.ActualHours) > p.ProposedHours
    ) AS pm2 on pm.ManagerID = pm2.ApprovingManager
    GROUP BY pl.FirstName, pl.LastName, pm2.TotalHours, pm2.ApprovingManager
    ORDER BY PercentProjectsWithinHrs DESC


    --Q9 Who where the last 3 employees to work on a proposal that was above its proposed hours?
    SELECT TOP 3 CONCAT(ppl2.FirstName,' ',ppl2.LastName) AS Employee, CONCAT(ppl1.FirstName,' ',ppl1.LastName) AS Manager,
    ps.ProposalName, pp.ActualHours, te.CurrentDate AS TimeEntryDate
    FROM tblProposalProgress pp
    JOIN tblTimeEntries te on te.TimeEntryID = pp.TimeEntryID
    JOIN tblEmployees em on em.EmployeeID = te.EmployeeID
    JOIN tblProjectTeam pr on pr.EmployeeID = em.EmployeeID
    JOIN tblProjectManagers pm on pm.ManagerID = pr.ManagerID   
    JOIN tblPeople ppl1 on ppl1.PeopleID = pm.ManagerID
    JOIN tblPeople ppl2 on ppl2.PeopleID = em.EmployeeID
    JOIN tblProposals ps on ps.ProposalID = pp.ProposalID
    WHERE pp.ProposalID = (
            Select p.ProposalID
            From tblProposals p 
            JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
            WHERE p.ProposalID = pp.ProposalID
            GROUP by p.ProposalID, p.ProposedHours
            HAVING SUM(pr.ActualHours) > p.ProposedHours
    )
    ORDER BY TimeEntryDate DESC;

    --Q10 Which employee(s) have worked on the projects above the proposed hours and how many hours have they put in?
   Select pr.ProposalName AS ProposalBeyondProposedHours, CONCAT(ppl.FirstName, ' ',ppl.LastName) AS EmployeeName, 
   SUM(ActualHours) AS HoursWorked, pr.TotalHours AS ProjectTotalHours, pr.ProposedHours AS ProjectProposedHours
   FROM tblProposalProgress pp
   JOIN tblTimeEntries te on te.TimeEntryID = pp.TimeEntryID
   LEFT JOIN tblEmployees em on te.EmployeeID = em.EmployeeID
   LEFT JOIN tblPeople ppl on em.EmployeeID = ppl.PeopleID
   JOIN (
            Select p.ProposalID, p.ProposedHours, SUM(pr.ActualHours) AS TotalHours, p.ProposalName
            From tblProposals p 
            JOIN tblProposalProgress pr on pr.ProposalID = p.ProposalID
            GROUP by p.ProposalID, p.ProposedHours, p.ProposalName, p.ProposedHours
            HAVING SUM(pr.ActualHours) > p.ProposedHours
   ) AS pr on pr.ProposalID = pp.ProposalID
   GROUP BY pp.ProposalID, FirstName, LastName, pr.ProposalName, pr.TotalHours, pr.ProposedHours;

