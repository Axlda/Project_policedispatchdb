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