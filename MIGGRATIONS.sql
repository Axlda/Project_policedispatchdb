USE PoliceDispatchDB;

-- Extracting some unique crime types
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