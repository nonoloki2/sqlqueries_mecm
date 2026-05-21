SELECT 
    sys.Name0 AS ComputerName,
    arp.DisplayName0,
    arp.Version0 AS EdgeVersion,
    os.Caption0 AS OperatingSystem,
    os.Version0 AS OSVersion,
    CASE 
        WHEN os.ProductType0 = 1 THEN 'Workstation'
        WHEN os.ProductType0 IN (2,3) THEN 'Server'
        ELSE 'Unknown'
    END AS OSType
FROM v_R_System sys
INNER JOIN v_GS_ADD_REMOVE_PROGRAMS arp
    ON sys.ResourceID = arp.ResourceID
LEFT JOIN v_GS_OPERATING_SYSTEM os
    ON sys.ResourceID = os.ResourceID
WHERE arp.DisplayName0 LIKE '%Microsoft Edge%'
AND (
    CAST(PARSENAME(arp.Version0,4) AS INT) < 147
    OR (
        CAST(PARSENAME(arp.Version0,4) AS INT) = 147
        AND CAST(PARSENAME(arp.Version0,3) AS INT) < 0
    )
    OR (
        CAST(PARSENAME(arp.Version0,4) AS INT) = 147
        AND CAST(PARSENAME(arp.Version0,3) AS INT) = 0
        AND CAST(PARSENAME(arp.Version0,2) AS INT) < 3912
    )
    OR (
        CAST(PARSENAME(arp.Version0,4) AS INT) = 147
        AND CAST(PARSENAME(arp.Version0,3) AS INT) = 0
        AND CAST(PARSENAME(arp.Version0,2) AS INT) = 3912
        AND CAST(PARSENAME(arp.Version0,1) AS INT) < 60
    )
)

UNION

SELECT 
    sys.Name0 AS ComputerName,
    arp64.DisplayName0,
    arp64.Version0 AS EdgeVersion,
    os.Caption0 AS OperatingSystem,
    os.Version0 AS OSVersion,
    CASE 
        WHEN os.ProductType0 = 1 THEN 'Workstation'
        WHEN os.ProductType0 IN (2,3) THEN 'Server'
        ELSE 'Unknown'
    END AS OSType
FROM v_R_System sys
INNER JOIN v_GS_ADD_REMOVE_PROGRAMS_64 arp64
    ON sys.ResourceID = arp64.ResourceID
LEFT JOIN v_GS_OPERATING_SYSTEM os
    ON sys.ResourceID = os.ResourceID
WHERE arp64.DisplayName0 LIKE '%Microsoft Edge%'
AND (
    CAST(PARSENAME(arp64.Version0,4) AS INT) < 147
    OR (
        CAST(PARSENAME(arp64.Version0,4) AS INT) = 147
        AND CAST(PARSENAME(arp64.Version0,3) AS INT) < 0
    )
    OR (
        CAST(PARSENAME(arp64.Version0,4) AS INT) = 147
        AND CAST(PARSENAME(arp64.Version0,3) AS INT) = 0
        AND CAST(PARSENAME(arp64.Version0,2) AS INT) < 3912
    )
    OR (
        CAST(PARSENAME(arp64.Version0,4) AS INT) = 147
        AND CAST(PARSENAME(arp64.Version0,3) AS INT) = 0
        AND CAST(PARSENAME(arp64.Version0,2) AS INT) = 3912
        AND CAST(PARSENAME(arp64.Version0,1) AS INT) < 60
    )
)

ORDER BY ComputerName