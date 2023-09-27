BEGIN TRY
    exec [dbo].[Job_Export_Reporte_MUT]
    -- Registro de ejecución exitosa en la tabla
    INSERT INTO AliatMAS.dbo.JobExecutionsSP_Reporte_MUT (JobName, StartTime, EndTime, Status)
    VALUES ('JobExecutionsSP_Reporte_MUT', GETDATE(), GETDATE(), 'Exitoso');

END TRY
BEGIN CATCH
    -- Registro de ejecución fallida en la tabla
    INSERT INTO AliatMAS.dbo.JobExecutionsSP_Reporte_MUT (JobName, StartTime, EndTime, Status)
    VALUES ('JobExecutionsSP_Reporte_MUT', GETDATE(), NULL, 'Fallido');

END CATCH
