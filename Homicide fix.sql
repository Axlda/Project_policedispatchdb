USE PoliceDispatchDB;

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