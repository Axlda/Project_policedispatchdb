-- ALL queries in one file



-- ----------------------------------------------------------------------------------
-- Creating the 1NF table
USE PoliceDispatchDB;
DROP TABLE IF EXISTS RAW_CRIME_DATA;

-- MAIN AND FIRST TABLE CREAION
CREATE TABLE RAW_CRIME_DATA (
    ID VARCHAR(50),
    Case_Number VARCHAR(50),
    Incident_Date VARCHAR(100),
    Block VARCHAR(100),
    IUCR VARCHAR(20),
    Primary_Type VARCHAR(100),
    Description VARCHAR(255),
    Location_Description VARCHAR(150),
    Arrest VARCHAR(20),
    Domestic VARCHAR(20),
    Beat VARCHAR(20),
    District VARCHAR(20),
    Ward VARCHAR(20),
    Community_Area VARCHAR(20),
    FBI_Code VARCHAR(20),
    X_Coordinate VARCHAR(50),
    Y_Coordinate VARCHAR(50),
    Year VARCHAR(10),
    Updated_On VARCHAR(100),
    Latitude VARCHAR(50),
    Longitude VARCHAR(50),
    Location VARCHAR(255)
);

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------
-- 3NF
USE PoliceDispatchDB;

-- 1st creating the CRIME_TYPE reference table in 3NF
CREATE TABLE IF NOT EXISTS CRIME_TYPE (
    IUCR_Code VARCHAR(20) PRIMARY KEY,
    Primary_Description VARCHAR(100),
    Secondary_Description VARCHAR(255)
);

-- 2nd creating the LOCATION reference table in 3NF
-- The raw data only gives us district numbers, so we use that as the ID
CREATE TABLE IF NOT EXISTS LOCATION (
    District_ID VARCHAR(20) PRIMARY KEY
);

-- 3rd creating the main INCIDENT table (3NF)
CREATE TABLE IF NOT EXISTS INCIDENT (
    Case_Number VARCHAR(50) PRIMARY KEY,
    Incident_Date DATETIME,
    IUCR_Code VARCHAR(20),
    District_ID VARCHAR(20),
    Arrest_Made BOOLEAN,
    Domestic BOOLEAN,
    FOREIGN KEY (IUCR_Code) REFERENCES CRIME_TYPE(IUCR_Code),            
    FOREIGN KEY (District_ID) REFERENCES LOCATION(District_ID)
);

-- 4th creating a fictional PATROL_UNIT table (I Generated it using AI) 
CREATE TABLE IF NOT EXISTS PATROL_UNIT (
    Unit_ID VARCHAR(20) PRIMARY KEY,
    Availability_Status VARCHAR(50) NOT NULL
);

-- 5th creating the DISPATCH_ASSIGNMENT table 
CREATE TABLE IF NOT EXISTS DISPATCH_ASSIGNMENT (
    Assignment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Case_Number VARCHAR(50),
    Unit_ID VARCHAR(20),
    Dispatch_Time DATETIME NOT NULL,
    Response_Status VARCHAR(50),
    FOREIGN KEY (Case_Number) REFERENCES INCIDENT(Case_Number),
    FOREIGN KEY (Unit_ID) REFERENCES PATROL_UNIT(Unit_ID)
);
-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------
-- DATA MIGGRATIONS
USE PoliceDispatchDB;

--  Inserting the fictional patrol units
INSERT IGNORE INTO PATROL_UNIT (Unit_ID, Availability_Status) VALUES
('Car-101', 'Available'),
('Car-102', 'Dispatched'),
('Car-205', 'On Scene'),
('Unit-K9', 'Available'),
('Car-308', 'Off-Duty');


-- We use LIMIT to dynamically grab the first 5 real case numbers
INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-101', NOW(), 'En Route' FROM INCIDENT LIMIT 1 OFFSET 0;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-102', NOW(), 'On Scene' FROM INCIDENT LIMIT 1 OFFSET 1;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-205', NOW(), 'Cleared' FROM INCIDENT LIMIT 1 OFFSET 2;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Unit-K9', NOW(), 'En Route' FROM INCIDENT LIMIT 1 OFFSET 3;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-308', NOW(), 'Cleared' FROM INCIDENT LIMIT 1 OFFSET 4;

-- Fixed 

-- Clear the old 5 assignments
-- I did this because I did a mistake in evaluting the data place when I used LIMIT and the offset 
TRUNCATE TABLE DISPATCH_ASSIGNMENT;

-- Assign units to crimes from different parts of the dataset to get variety
INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-101', NOW(), 'En Route' FROM INCIDENT LIMIT 1 OFFSET 100;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-102', NOW(), 'On Scene' FROM INCIDENT LIMIT 1 OFFSET 500;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-205', NOW(), 'Cleared' FROM INCIDENT LIMIT 1 OFFSET 1000;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Unit-K9', NOW(), 'En Route' FROM INCIDENT LIMIT 1 OFFSET 1500;

INSERT INTO DISPATCH_ASSIGNMENT (Case_Number, Unit_ID, Dispatch_Time, Response_Status) 
SELECT Case_Number, 'Car-308', NOW(), 'Cleared' FROM INCIDENT LIMIT 1 OFFSET 2000;


-- I used INSERT IGNORE so if the data I impored from kaggle has some weird duplicates MYSQL safely skip them
INSERT IGNORE INTO CRIME_TYPE (IUCR_Code, Primary_Description, Secondary_Description)
SELECT DISTINCT 
    IUCR, 
    Primary_Type, 
    Description
FROM RAW_CRIME_DATA
WHERE IUCR IS NOT NULL AND IUCR != '';

-- I extractd some unique Districts
INSERT IGNORE INTO LOCATION (District_ID)
SELECT DISTINCT 
    District
FROM RAW_CRIME_DATA
WHERE District IS NOT NULL AND District != '';

-- adding the Incidents and link them
-- I converted the text dates here into proper mysql DATETIME because I created it in VARCHAR, and text 'true'/'false' into Booleans
INSERT IGNORE INTO INCIDENT (Case_Number, Incident_Date, IUCR_Code, District_ID, Arrest_Made, Domestic)
SELECT DISTINCT 
    Case_Number, 
    STR_TO_DATE(Incident_Date, '%m/%d/%Y %h:%i:%s %p'),
    IUCR, 
    District, 
    CASE WHEN Arrest = 'true' THEN 1 ELSE 0 END, 
 CASE WHEN Domestic = 'true' THEN 1 ELSE 0 END
FROM RAW_CRIME_DATA
WHERE Case_Number IS NOT NULL AND Case_Number != '';

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

USE PoliceDispatchDB;

-- REPORT 1: ACTIVE DISPATCH BOARD
SELECT 
    da.Unit_ID,
    da.Response_Status,
    i.Case_Number,
    ct.Primary_Description AS Crime_Type,
    da.Dispatch_Time
FROM DISPATCH_ASSIGNMENT da
JOIN INCIDENT i ON da.Case_Number = i.Case_Number
JOIN CRIME_TYPE ct ON i.IUCR_Code = ct.IUCR_Code
ORDER BY da.Dispatch_Time DESC;

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

-- REPORT 2: CRIME FREQUENCY BY DISTRICT
SELECT 
    l.District_ID AS Police_District,
    COUNT(i.Case_Number) AS Total_Incidents
FROM LOCATION l
JOIN INCIDENT i ON l.District_ID = i.District_ID
GROUP BY l.District_ID
ORDER BY Total_Incidents DESC;

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

-- REPORT 3: ARREST RATES (DOMESTIC VS NON-DOMESTIC)
SELECT 
    CASE WHEN Domestic = 1 THEN 'Domestic Incident' ELSE 'Standard Incident' END AS Incident_Type,
    COUNT(Case_Number) AS Total_Cases,
    SUM(Arrest_Made) AS Total_Arrests,
    ROUND((SUM(Arrest_Made) / COUNT(Case_Number)) * 100, 2) AS Arrest_Rate_Percentage
FROM INCIDENT
GROUP BY Domestic;

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

-- UPDATE Statement: Used by dispatchers to update a unit's availability status when they clear a scene.
UPDATE PATROL_UNIT 
SET Availability_Status = 'Available' 
WHERE Unit_ID = 'Car-205';


-- DELETE Statement: Used by administration to remove erroneous or false-alarm dispatch records.
DELETE FROM DISPATCH_ASSIGNMENT 
WHERE Case_Number = 'NJP-72727' AND Unit_ID = 'Car-308';
