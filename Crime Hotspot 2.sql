-- REPORT 2: CRIME FREQUENCY BY DISTRICT
SELECT 
    l.District_ID AS Police_District,
    COUNT(i.Case_Number) AS Total_Incidents
FROM LOCATION l
JOIN INCIDENT i ON l.District_ID = i.District_ID
GROUP BY l.District_ID
ORDER BY Total_Incidents DESC;