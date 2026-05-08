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