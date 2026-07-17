DECLARE @AssignmentID INT = 13992277;
DECLARE @CollectionID NVARCHAR(20) = 'CT100618';

SELECT
    rs.Name0 AS ComputerName,

    -- STATUS DO DEPLOYMENT
    sn.StateName AS DeploymentState,

    -- CLIENT STATUS
    cs.ClientActiveStatus,
    cs.LastActiveTime,

    -- HEARTBEAT / INVENTORY
    ws.LastHWScan,

    -- SCAN UPDATE
    us.LastScanTime,
    us.LastErrorCode,

    -- OS
    os.Caption0 AS OperatingSystem

FROM v_FullCollectionMembership fcm

INNER JOIN v_R_System rs
    ON rs.ResourceID = fcm.ResourceID

-- Deployment
LEFT JOIN v_AssignmentState_Combined ascg
    ON ascg.ResourceID = rs.ResourceID
    AND ascg.AssignmentID = @AssignmentID

LEFT JOIN v_StateNames sn
    ON sn.TopicType = ascg.StateType
    AND sn.StateID = ascg.StateID

-- Client
LEFT JOIN v_CH_ClientSummary cs
    ON cs.ResourceID = rs.ResourceID

-- Hardware inventory (melhor proxy de heartbeat)
LEFT JOIN v_GS_WORKSTATION_STATUS ws
    ON ws.ResourceID = rs.ResourceID

-- Scan
LEFT JOIN v_UpdateScanStatus us
    ON us.ResourceID = rs.ResourceID

-- OS
LEFT JOIN v_GS_OPERATING_SYSTEM os
    ON os.ResourceID = rs.ResourceID

WHERE fcm.CollectionID = @CollectionID
ORDER BY rs.Name0;
