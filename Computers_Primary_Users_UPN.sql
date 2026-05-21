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
'mewa550','m050224','m050598','m59t001','mbk9001','m050154','m050152','m3cb001',
'm050581','m050591','mj2g001','m050590','m050551','m050999','m050007','m050571',
'm050585','m050144','m050033','mb5v001','m050143','m050592','m050223','mamc001',
'm050582','m8zm150','m050597','m5kj001','m050222','m050587','m050593','m050561',
'mewa141','m050000','m9cb101','m050584','m050586','mf20010','m050142','m050140',
'm050141','m050157','m9ca145','m050583','m050580','m050153','m050148','m9ca146',
'm050596','m050149','m050003','m050151','m050002','m050155','m050589','m050005',
'm9ca156','m9ca148','m050156','m050004','m050200','mxj7001','m050150','mewb001',
'm050160','m050001','m050158','m050552','m050147','m050588','m9ca149','m050595',
'm050594','m050572','m050009','m050011','m050570','m050542','m050550','m050161',
'm050560','m050052','m050599'
)
ORDER BY ComputerName, Login;