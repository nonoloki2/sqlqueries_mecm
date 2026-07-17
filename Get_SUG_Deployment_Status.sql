DECLARE @AssignmentID INT = 16792277;
DECLARE @CollectionID NVARCHAR(20) = 'CT1006578';

WITH AssignmentInfo AS (
    SELECT
        AssignmentID,
        AssignmentName,
        CollectionID,
        CollectionName
    FROM v_CIAssignment
    WHERE AssignmentID = @AssignmentID
),

RawStatus AS (
    SELECT
        ai.AssignmentName,
        ai.CollectionID,
        ai.CollectionName,
        fcm.ResourceID,
        rs.Name0 AS ComputerName,
        ascg.StateType,
        ascg.StateID
    FROM v_FullCollectionMembership fcm
    INNER JOIN v_R_System rs
        ON rs.ResourceID = fcm.ResourceID
    CROSS JOIN AssignmentInfo ai
    LEFT JOIN v_AssignmentState_Combined ascg
        ON ascg.ResourceID = fcm.ResourceID
        AND ascg.AssignmentID = ai.AssignmentID
    WHERE fcm.CollectionID = @CollectionID
),

FinalStatus AS (
    SELECT
        AssignmentName,
        CollectionID,
        CollectionName,
        ResourceID,
        ComputerName,
        CASE
            WHEN MAX(CASE WHEN StateType = 301 AND StateID = 6 THEN 1 ELSE 0 END) = 1
                THEN 'Error'

            WHEN MAX(CASE WHEN StateType = 301 AND StateID IN (5,8) THEN 1 ELSE 0 END) = 1
                THEN 'In Progress'

            WHEN MAX(CASE WHEN StateType = 300 AND StateID = 2 THEN 1 ELSE 0 END) = 1
                THEN 'Non-Compliant'

            WHEN MAX(CASE WHEN StateType = 300 AND StateID = 1 THEN 1 ELSE 0 END) = 1
              OR MAX(CASE WHEN StateType = 301 AND StateID = 4 THEN 1 ELSE 0 END) = 1
                THEN 'Success / Compliant'

            ELSE 'Unknown'
        END AS OverallStatus
    FROM RawStatus
    GROUP BY
        AssignmentName,
        CollectionID,
        CollectionName,
        ResourceID,
        ComputerName
)

SELECT
    AssignmentName AS DeploymentName,
    CollectionID,
    CollectionName,
    OverallStatus,
    COUNT(*) AS TotalMachines,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(6,2)) AS Percentage
FROM FinalStatus
GROUP BY
    AssignmentName,
    CollectionID,
    CollectionName,
    OverallStatus
ORDER BY
    CASE OverallStatus
        WHEN 'Success / Compliant' THEN 1
        WHEN 'In Progress' THEN 2
        WHEN 'Error' THEN 3
        WHEN 'Non-Compliant' THEN 4
        WHEN 'Unknown' THEN 5
        ELSE 6
    END;
