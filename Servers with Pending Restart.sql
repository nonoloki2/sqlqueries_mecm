SELECT
    rs.Name0 AS Hostname,
    os.Caption0 AS OperatingSystem,
    os.BuildNumber0 AS Build,
    cdr.ClientState AS PendingRestartCode,
    CASE 
        WHEN ISNULL(cdr.ClientState, 0) = 0 THEN 'No'
        ELSE 'Yes'
    END AS PendingRestart
FROM v_R_System rs

INNER JOIN v_GS_OPERATING_SYSTEM os
    ON rs.ResourceID = os.ResourceID

LEFT JOIN v_CombinedDeviceResources cdr
    ON rs.ResourceID = cdr.MachineID

WHERE
    rs.Operating_System_Name_and0 LIKE '%Server%'
    AND (
        os.Caption0 LIKE '%2008%' OR
        os.Caption0 LIKE '%2012%' OR
        os.Caption0 LIKE '%2016%' OR
        os.Caption0 LIKE '%2019%' OR
        os.Caption0 LIKE '%2022%' OR
        os.Caption0 LIKE '%2025%'
    )

ORDER BY
    PendingRestart DESC,
    rs.Name0;