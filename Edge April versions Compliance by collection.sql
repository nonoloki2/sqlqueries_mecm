WITH AprilEdgeVersions AS (
    SELECT '146.0.3856.97'  AS EdgeVersion UNION ALL
    SELECT '146.0.3856.109' UNION ALL
    SELECT '147.0.3912.60'  UNION ALL
    SELECT '146.0.3856.117' UNION ALL
    SELECT '146.0.3856.130' UNION ALL
    SELECT '147.0.3912.72'  UNION ALL
    SELECT '146.0.3856.139' UNION ALL
    SELECT '147.0.3912.86'
),

EdgeRaw AS (
    SELECT 
        fcm.ResourceID,
        arp.Version0 AS EdgeVersion
    FROM v_FullCollectionMembership fcm
    INNER JOIN v_GS_ADD_REMOVE_PROGRAMS arp
        ON fcm.ResourceID = arp.ResourceID
    WHERE 
        fcm.CollectionID = 'PR10267E'
        AND arp.DisplayName0 = 'Microsoft Edge'

    UNION ALL

    SELECT 
        fcm.ResourceID,
        arp64.Version0 AS EdgeVersion
    FROM v_FullCollectionMembership fcm
    INNER JOIN v_GS_ADD_REMOVE_PROGRAMS_64 arp64
        ON fcm.ResourceID = arp64.ResourceID
    WHERE 
        fcm.CollectionID = 'PR10267E'
        AND arp64.DisplayName0 = 'Microsoft Edge'
),

EdgeOnePerDevice AS (
    SELECT
        ResourceID,
        MAX(EdgeVersion) AS EdgeVersion
    FROM EdgeRaw
    GROUP BY ResourceID
),

TotalDevices AS (
    SELECT COUNT(DISTINCT ResourceID) AS Total
    FROM v_FullCollectionMembership
    WHERE CollectionID = 'PR10267E'
)

SELECT
    a.EdgeVersion AS AprilEdgeVersion,
    COUNT(DISTINCT e.ResourceID) AS Devices,
    MAX(t.Total) AS TotalDevices,
    CAST(
        COUNT(DISTINCT e.ResourceID) * 100.0 / MAX(t.Total)
        AS DECIMAL(6,2)
    ) AS Percentage
FROM AprilEdgeVersions a
LEFT JOIN EdgeOnePerDevice e
    ON a.EdgeVersion = e.EdgeVersion
CROSS JOIN TotalDevices t
GROUP BY a.EdgeVersion
ORDER BY Devices DESC;