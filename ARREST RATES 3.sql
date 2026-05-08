-- REPORT 3: ARREST RATES (DOMESTIC VS NON-DOMESTIC)
SELECT 
    CASE WHEN Domestic = 1 THEN 'Domestic Incident' ELSE 'Standard Incident' END AS Incident_Type,
    COUNT(Case_Number) AS Total_Cases,
    SUM(Arrest_Made) AS Total_Arrests,
    ROUND((SUM(Arrest_Made) / COUNT(Case_Number)) * 100, 2) AS Arrest_Rate_Percentage
FROM INCIDENT
GROUP BY Domestic;