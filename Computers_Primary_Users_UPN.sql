SELECT DISTINCT
    umr.UniqueUserName AS LoginRaw,
    RIGHT(umr.UniqueUserName, CHARINDEX('\', REVERSE(umr.UniqueUserName) + '\') - 1) AS Login,
    usr.User_Principal_Name0 AS UPN,
    umr.MachineResourceName AS ComputerName
FROM v_UserMachineRelationship umr
LEFT JOIN v_R_User usr
    ON LOWER(RIGHT(umr.UniqueUserName, CHARINDEX('\', REVERSE(umr.UniqueUserName) + '\') - 1))
     = LOWER(RIGHT(usr.Unique_User_Name0, CHARINDEX('\', REVERSE(usr.Unique_User_Name0) + '\') - 1))
WHERE LOWER(RIGHT(umr.UniqueUserName, CHARINDEX('\', REVERSE(umr.UniqueUserName) + '\') - 1)) IN (
'WKSa550','WKS0224'
)
ORDER BY ComputerName, Login;
