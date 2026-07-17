SELECT DISTINCT
    'Monthly updates - April 2026 - Research Business' AS DeploymentName,
    'Research Business' AS CollectionName,
    fcm.CollectionID,
    rs.Name0 AS Hostname,
    os.Caption0 AS OperatingSystem,
    os.Version0 AS OSVersion,
    os.BuildNumber0 AS OSBuild,
    edge.Version0 AS EdgeVersion
FROM v_R_System rs

INNER JOIN v_FullCollectionMembership fcm
    ON rs.ResourceID = fcm.ResourceID

LEFT JOIN v_GS_OPERATING_SYSTEM os
    ON rs.ResourceID = os.ResourceID

LEFT JOIN (
    SELECT ResourceID, Version0
    FROM v_GS_ADD_REMOVE_PROGRAMS
    WHERE DisplayName0 LIKE '%Microsoft Edge%'

    UNION

    SELECT ResourceID, Version0
    FROM v_GS_ADD_REMOVE_PROGRAMS_64
    WHERE DisplayName0 LIKE '%Microsoft Edge%'
) edge
    ON rs.ResourceID = edge.ResourceID

WHERE
    fcm.CollectionID = 'CT100050'

ORDER BY
    edge.Version0 DESC,
    rs.Name0;
