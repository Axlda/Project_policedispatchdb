-- DELETE Statement: Used by administration to remove erroneous or false-alarm dispatch records.
DELETE FROM DISPATCH_ASSIGNMENT 
WHERE Case_Number = 'NJP-72727' AND Unit_ID = 'Car-308';