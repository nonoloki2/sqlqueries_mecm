SELECT
    rs.Name0 AS MachineName,
    scu.TopConsoleUser0 AS LogonAccount,
    usr.User_Principal_Name0 AS UPN,
    arp.DisplayName0 AS InstalledProduct,
    arp.Publisher0 AS Publisher,
    '''' + CAST(arp.Version0 AS VARCHAR(50)) AS ThinkCellVersion,
    COUNT(md.MeterDataID) AS PowerPointUsage,
    MAX(md.StartTime) AS LastUsed
FROM v_R_System rs

-- Usuário da máquina
LEFT JOIN v_GS_SYSTEM_CONSOLE_USAGE_MAXGROUP scu
    ON rs.ResourceID = scu.ResourceID

-- Resolver UPN corretamente
LEFT JOIN v_R_User usr
    ON usr.Unique_User_Name0 = scu.TopConsoleUser0

-- Think-cell instalado
INNER JOIN (
    SELECT DISTINCT
        ResourceID,
        DisplayName0,
        Publisher0,
        Version0
    FROM v_GS_ADD_REMOVE_PROGRAMS
    WHERE DisplayName0 LIKE '%think-cell%'

    UNION

    SELECT DISTINCT
        ResourceID,
        DisplayName0,
        Publisher0,
        Version0
    FROM v_GS_ADD_REMOVE_PROGRAMS_64
    WHERE DisplayName0 LIKE '%think-cell%'
) arp
    ON rs.ResourceID = arp.ResourceID

-- Metering
LEFT JOIN v_MeterData md
    ON md.ResourceID = rs.ResourceID

LEFT JOIN v_MeteredFiles mf
    ON mf.MeteredFileID = md.FileID
    AND mf.FileName = 'POWERPNT.EXE'
    AND md.StartTime >= DATEADD(MONTH, -6, GETDATE())

GROUP BY
    rs.Name0,
    scu.TopConsoleUser0,
    usr.User_Principal_Name0,
    arp.DisplayName0,
    arp.Publisher0,
    arp.Version0

ORDER BY
    LastUsed DESC;