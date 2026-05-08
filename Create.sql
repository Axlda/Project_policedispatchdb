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