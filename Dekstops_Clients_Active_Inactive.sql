SELECT
    SYS.Name0 AS ComputerName,
    SYS.User_Name0 AS LastLoggedOnUser,
    SYS.User_Domain0 AS UserDomain,
    SYS.Operating_System_Name_and0 AS OperatingSystem,
    OS.Caption0 AS OSCaption,
    OS.Version0 AS OSVersion,
    OS.BuildNumber0 AS OSBuild,
    CASE
        WHEN OS.BuildNumber0 LIKE '10%' THEN 'Windows 10/11'
        ELSE 'Other'
    END AS OSFamily,
    SYS.Client0 AS SCCMClientInstalled,
    SYS.Active0 AS SCCMClientActive,
    CASE
        WHEN SYS.Client0 = 1 AND SYS.Active0 = 1 THEN 'Client Installed - Active'
        WHEN SYS.Client0 = 1 AND (SYS.Active0 = 0 OR SYS.Active0 IS NULL) THEN 'Client Installed - Inactive'
        WHEN SYS.Client0 = 0 OR SYS.Client0 IS NULL THEN 'Client Not Installed'
        ELSE 'Unknown'
    END AS SCCMClientStatus,
    SYS.Client_Version0 AS SCCMClientVersion,
    SYS.AD_Site_Name0 AS ADSiteName,
    SYS.Resource_Domain_OR_Workgr0 AS DomainOrWorkgroup,
    SYS.Last_Logon_Timestamp0 AS LastLogonTimestamp,
    SYS.Creation_Date0 AS SCCMRecordCreationDate,
    SYS.Obsolete0 AS Obsolete,
    SYS.Decommissioned0 AS Decommissioned
FROM v_R_System SYS
LEFT JOIN v_GS_OPERATING_SYSTEM OS
    ON SYS.ResourceID = OS.ResourceID
WHERE
    SYS.Obsolete0 = 0
    AND SYS.Decommissioned0 = 0
    AND (
        OS.Caption0 LIKE '%Windows 10%'
        OR OS.Caption0 LIKE '%Windows 11%'
        OR SYS.Operating_System_Name_and0 LIKE '%Windows 10%'
        OR SYS.Operating_System_Name_and0 LIKE '%Windows 11%'
    )
ORDER BY
    SCCMClientStatus,
    ComputerName;