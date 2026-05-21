DECLARE @AssignmentID INT = 16792277;
DECLARE @CollectionID NVARCHAR(20) = 'PR100618';

SELECT
    rs.Name0 AS ComputerName,

    sn.StateName AS DeploymentState,

    cs.ClientActiveStatus,
    cs.LastActiveTime,
    ws.LastHWScan,
    us.LastScanTime,
    us.LastErrorCode,

    os.Caption0 AS OperatingSystem,

    CASE 
        WHEN cs.ClientActiveStatus = 1
             AND us.LastScanTime IS NOT NULL
             AND DATEDIFF(DAY, us.LastScanTime, GETDATE()) <= 7
             AND ws.LastHWScan IS NOT NULL
             AND DATEDIFF(DAY, ws.LastHWScan, GETDATE()) <= 7
        THEN 'Healthy'

        WHEN cs.ClientActiveStatus = 0
        THEN 'Client Inactive'

        WHEN cs.ClientActiveStatus IS NULL
        THEN 'No Client Status'

        WHEN us.LastScanTime IS NULL
        THEN 'No Update Scan'

        WHEN DATEDIFF(DAY, us.LastScanTime, GETDATE()) > 7
        THEN 'Update Scan Outdated'

        WHEN ws.LastHWScan IS NULL
        THEN 'No Hardware Inventory'

        WHEN DATEDIFF(DAY, ws.LastHWScan, GETDATE()) > 7
        THEN 'Hardware Inventory Outdated'

        ELSE 'Needs Investigation'
    END AS HealthStatus,

    CASE
        WHEN sn.StateName = 'Compliant'
        THEN 'No action - compliant'

        WHEN sn.StateName = 'Successfully installed update(s)'
        THEN 'No action - installed successfully'

        WHEN sn.StateName = 'Pending system restart'
        THEN 'Action required - reboot server'

        WHEN sn.StateName = 'Downloaded update(s)'
        THEN 'Monitor - downloaded but not installed yet'

        WHEN sn.StateName = 'Failed to install update(s)'
        THEN 'Action required - investigate install failure'

        WHEN sn.StateName = 'Enforcement state unknown'
             AND cs.ClientActiveStatus = 1
             AND us.LastScanTime IS NOT NULL
             AND DATEDIFF(DAY, us.LastScanTime, GETDATE()) <= 7
        THEN 'Monitor - client healthy but enforcement not reported'

        WHEN sn.StateName = 'Enforcement state unknown'
        THEN 'Action required - investigate client/reporting'

        WHEN sn.StateName IS NULL
        THEN 'Action required - no deployment state reported'

        ELSE 'Review required'
    END AS RecommendedAction

FROM v_FullCollectionMembership fcm

INNER JOIN v_R_System rs
    ON rs.ResourceID = fcm.ResourceID

LEFT JOIN v_AssignmentState_Combined ascg
    ON ascg.ResourceID = rs.ResourceID
    AND ascg.AssignmentID = @AssignmentID

LEFT JOIN v_StateNames sn
    ON sn.TopicType = ascg.StateType
    AND sn.StateID = ascg.StateID

LEFT JOIN v_CH_ClientSummary cs
    ON cs.ResourceID = rs.ResourceID

LEFT JOIN v_GS_WORKSTATION_STATUS ws
    ON ws.ResourceID = rs.ResourceID

LEFT JOIN v_UpdateScanStatus us
    ON us.ResourceID = rs.ResourceID

LEFT JOIN v_GS_OPERATING_SYSTEM os
    ON os.ResourceID = rs.ResourceID

WHERE fcm.CollectionID = @CollectionID

ORDER BY
    CASE 
        WHEN sn.StateName = 'Failed to install update(s)' THEN 1
        WHEN sn.StateName = 'Enforcement state unknown' THEN 2
        WHEN sn.StateName = 'Pending system restart' THEN 3
        WHEN sn.StateName = 'Downloaded update(s)' THEN 4
        WHEN sn.StateName = 'Non-compliant' THEN 5
        WHEN sn.StateName = 'Compliant' THEN 6
        ELSE 7
    END,
    rs.Name0;