USE [AliatMAS]
GO
/****** Object:  StoredProcedure [dbo].[Job_Ejecutar_Reporte_MUTEnvioManual]    Script Date: 7/31/2023 4:08:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [Job_Ejecutar_Reporte_MUTEnvioManual]
ALTER PROCEDURE [dbo].[Job_Ejecutar_Reporte_MUTEnvioManual]

AS

BEGIN
SET NOCOUNT ON

EXEC xp_cmdshell 'B:\ArchivosFTP\Bacheros\FTP_Pase_Reportes_MUT_Manuales.bat';

SET NOCOUNT OFF
END
