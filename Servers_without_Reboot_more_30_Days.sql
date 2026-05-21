SELECT
    sys.Name0 AS ComputerName,
    os.Caption0 AS OperatingSystem,
    os.Version0 AS OSVersion,
    os.LastBootUpTime0 AS LastBootUpTime,
    DATEDIFF(DAY, os.LastBootUpTime0, GETDATE()) AS DaysSinceLastReboot,
    sys.Client0 AS SCCMClientInstalled,
    sys.Active0 AS SCCMClientActive,
    sys.Last_Logon_Timestamp0 AS LastLogonTimestamp
FROM v_R_System sys
INNER JOIN v_GS_OPERATING_SYSTEM os
    ON sys.ResourceID = os.ResourceID
WHERE
    os.ProductType0 IN (2,3) -- Domain Controller / Server
    AND os.Caption0 LIKE '%Windows Server%'
    AND os.LastBootUpTime0 IS NOT NULL
    AND DATEDIFF(DAY, os.LastBootUpTime0, GETDATE()) > 30
ORDER BY
    DaysSinceLastReboot DESC,
    sys.Name0;