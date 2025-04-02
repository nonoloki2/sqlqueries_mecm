SELECT 
    CS.Name0 AS [Computer Name],
    BIOS.SerialNumber0 AS [Serial Number],
    BIOS.FirmwareType0 AS [Firmware Type], -- Indica se é UEFI ou Legacy
    TPM.SpecVersion AS [TPM Version],      -- Versão do TPM
    CASE 
        WHEN TPM.SpecVersion IS NOT NULL THEN 'Enabled'
        ELSE 'Not Available'
    END AS [TPM Status],
    CASE 
        WHEN BIOS.SecureBoot0 = 1 THEN 'Enabled'
        ELSE 'Disabled'
    END AS [Secure Boot Status]
FROM 
    v_GS_PC_BIOS AS BIOS
LEFT JOIN 
    v_GS_TPM AS TPM ON BIOS.ResourceID = TPM.ResourceID
LEFT JOIN 
    v_GS_COMPUTER_SYSTEM AS CS ON BIOS.ResourceID = CS.ResourceID
WHERE 
    BIOS.FirmwareType0 = 'UEFI'; -- Filtrar apenas dispositivos UEFI
