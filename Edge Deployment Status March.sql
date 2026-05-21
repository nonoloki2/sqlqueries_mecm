WITH EdgeData AS (
    SELECT 
        rs.ResourceID,
        edge.Version0
    FROM v_R_System rs
    INNER JOIN v_FullCollectionMembership fcm 
        ON rs.ResourceID = fcm.ResourceID
    INNER JOIN (
        SELECT ResourceID, Version0
        FROM v_GS_ADD_REMOVE_PROGRAMS
        WHERE DisplayName0 LIKE '%Microsoft Edge%'

        UNION ALL

        SELECT ResourceID, Version0
        FROM v_GS_ADD_REMOVE_PROGRAMS_64
        WHERE DisplayName0 LIKE '%Microsoft Edge%'
    ) edge
        ON rs.ResourceID = edge.ResourceID
    WHERE fcm.CollectionID = 'RS100050'
),

TotalDevices AS (
    SELECT COUNT(DISTINCT ResourceID) AS TotalCollectionDevices
    FROM v_FullCollectionMembership
    WHERE CollectionID = 'RS100050'
)

SELECT 
    'Monthly updates - April 2026 - Research Business' AS DeploymentName,
    'Research Business' AS CollectionName,
    'RS100050' AS CollectionID,
    ed.Version0 AS EdgeVersion,
    COUNT(DISTINCT ed.ResourceID) AS DevicesWithVersion,
    td.TotalCollectionDevices,
    CAST(
        (COUNT(DISTINCT ed.ResourceID) * 100.0) / td.TotalCollectionDevices 
        AS DECIMAL(6,2)
    ) AS PercentInstalled
FROM EdgeData ed
CROSS JOIN TotalDevices td
GROUP BY 
    ed.Version0,
    td.TotalCollectionDevices
ORDER BY 
    DevicesWithVersion DESC,
    ed.Version0 DESC;