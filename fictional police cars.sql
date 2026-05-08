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