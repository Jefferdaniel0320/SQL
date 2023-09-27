--Consultas SQL
-------------------------------------------------------------------------------------------------------
-- Consultar tabla y ordenar por fecha
select * from Gestiones order by TmStmp desc
-------------------------------------------------------------------------------------------------------
-- Para eliminar una tabla
delete from tabla1
-------------------------------------------------------------------------------------------------------
-- Resetear campos de IDENTITY
dbcc CHECKIDENT ('tabla1',RESEED,0) 
-------------------------------------------------------------------------------------------------------
-- Insertar registros en una tabla
insert into tabla1 values(1) 
-------------------------------------------------------------------------------------------------------
--Prefijos de salida
select * from CampaignOutboundInteraction
where VCC= 'nebrija' order by OutboundPrefix
-------------------------------------------------------------------------------------------------------
--Prefijos de DNIS
select * from MMProDat..CampaignInboundInteraction (nolock) order by DNIS
-------------------------------------------------------------------------------------------------------
--Prefijos de PEERS
select * from MMProDat..VCCIpPeer (nolock) order by PeerName
-------------------------------------------------------------------------------------------------------
--Prefijos Salientes
select * from MMProDat..CampaignOutboundInteraction (nolock) order by OutboundPrefix
-------------------------------------------------------------------------------------------------------
--Consultar los hosts de una DB
select * from MMProDat..Host
-------------------------------------------------------------------------------------------------------
--Direccion de la campaña
select top 10 * from InteractionDetail 
where Campaign = 'Ecuador_Display' 
and Direction = 'S'
order by StartDate desc
-------------------------------------------------------------------------------------------------------
-- Contar cantidad de elementos
select count(*)
  from BlacklistPhones;
-------------------------------------------------------------------------------------------------------
-- Eliminar info de la DB
SELECT TOP (1000) [Telefono]
      ,[TmStmp]
  FROM [Leadfy].[dbo].[BlacklistPhones]
  where TmStmp = '2022-05-27 16:09:21.563'

-- Ojo, ese se corre despues de mirar el de arriba

  delete BlacklistPhones 
  where TmStmp = '2022-05-27 16:09:21.563'
-------------------------------------------------------------------------------------------------------
-- Crear tabla con campo como identity y Primary Key
CREATE TABLE [dbo].[Especialidad](
	[idEspecialidad] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[especialidad] [varchar](30) NULL)
GO
-------------------------------------------------------------------------------------------------------
  -- Validar usuarios disponibles (activos)
 CREATE PROCEDURE [dbo].[GetAgentsActive2] ( 
@callerID varchar(50), @VirtualCC varchar(50) , @CampaignId varchar(50)
)
AS

Select distinct count (UserId) --VirtualCC, Campaignid, Count( * ) 'Logueados', sum(Case when estado0227 = 'Activo' then 1 else 0 end) 'activos'
from MMProDat..wfusulog0227 (nolock) -- TABLA A VALIDAR
join MMProDat..usercampaign (nolock)
on f1usua00920227 = userid
where f1usua02180227 = 'Workflow' -- Estado del agente
and f1usua00920227 = userid
and VirtualCC = @VirtualCC
and CampaignId = @CampaignId
and estado0227 = 'Activo'
and UserId not in

(
select distinct F1Usua00920245 from MMProDat..instinte0245 (nolock)
)

-- execute GetAgentsActive2 '2825' , 'hromero' , 'telefonia_jvaldez'
-------------------------------------------------------------------------------------------------------
-- Validar Codigos de Pais y Area
select * from MMProDat..ContactImportCountry (nolock)

select * from MMProDat..ContactImportArea (nolock)
-- Si se desea filtrar por codigos de Area
select * from MMProDat..ContactImportArea (nolock) where CountryID = 57
-------------------------------------------------------------------------------------------------------
-- Validar Interacciones en cierta campaña
select * from InteractionDetail
where VirtualCC = 'ENTELCHILE'
order by StartDate desc
-------------------------------------------------------------------------------------------------------
-- Procedimiento para Resetear un IDENTITY
-- Validar la tabla a Eliminar
select * from tabla1
-- Eliminar los registros de la tabla
delete from tabla1
-- Reiniciar el IDENTITY
DBCC CHECKIDENT ('tabla a reiniciar' , RESEED, 0) 
-- Insertar registros nuevos en la tabla
insert into tabla1 values(5401,999999999,1)
-------------------------------------------------------------------------------------------------------
SELECT * FROM Paciente
-- Para insertar un registro en una tabla
INSERT INTO Paciente values('Roberto1','Perez1','2017-01-04','piedra Buena 21','ESP','','','')
-- Se recomineda siempre especificar los campos que se van a agregar
INSERT INTO Paciente (nombre,apellido,fnacimiento,domicilio,idpais,telefono,email,observacion) 
values('Roberto1','Perez1','2017-01-04','piedra Buena 21','ESP','','','')
-------------------------------------------------------------------------------------------------------
select * from Paciente where apellido = 'robles'
-- Para eliminar un registro, se hace de la siguiete forma
DELETE FROM Paciente where idPaciente = 4
-------------------------------------------------------------------------------------------------------
-- Para modificar los valores de una columna de  una tabla
ALTER TABLE Llamadas alter column DNI varchar (250)
-------------------------------------------------------------------------------------------------------
-- Para actualizar un registro o campo de una tabla
UPDATE Paciente SET observacion='Pacientes Creados desde UI'
UPDATE HistoricalData..InteractionMultimediaParts SET RepositoryBackUpStatus = NULL
UPDATE HistoricalData..InteractionMultimediaParts SET RepositoryAttempts = '1'
-------------------------------------------------------------------------------------------------------
-- Clausula WHERE
SELECT * FROM Paciente WHERE nombre='Claudia' and apellido='Lopez'
DELETE FROM Paciente WHERE idPaciente = 2
UPDATE Paciente SET observacion='Paciente Actualizado desde UI' WHERE idPaciente=5
-------------------------------------------------------------------------------------------------------
-- Agregar campos en una DB
ALTER TABLE dbo.Gestiones ADD [RUC] [varchar](100) NULL
ALTER TABLE dbo.Gestiones ADD [RazonSocial] [varchar](100) NULL
ALTER TABLE dbo.Gestiones ADD [TipoEstablecimiento] [varchar](100) NULL
ALTER TABLE dbo.Gestiones ADD [Email] [varchar](100) NULL
ALTER TABLE dbo.Gestiones ADD [Cargo] [varchar](100) NULL

ALTER TABLE dbo.Llamadas ADD [RUC] [varchar](100) NULL
ALTER TABLE dbo.Llamadas ADD [RazonSocial] [varchar](100) NULL
ALTER TABLE dbo.Llamadas ADD [TipoEstablecimiento] [varchar](100) NULL
ALTER TABLE dbo.Llamadas ADD [Email] [varchar](100) NULL
ALTER TABLE dbo.Llamadas ADD [Cargo] [varchar](100) NULL
-------------------------------------------------------------------------------------------------------
select * from Gestiones Order by TmStmp desc
--delete from Gestiones
--delete from Llamadas
select * from Llamadas Order by TmStmp desc

--delete from Llamadas
--where ContactName = 'test'
-------------------------------------------------------------------------------------------------------
-- Para validar las gestiones de un formulario
select top 100 * from HISTORICALDATA..InteractionDetail (nolock) order by StartDate desc
-------------------------------------------------------------------------------------------------------
-- Para validar el estado de los lotes cargados en un Motor
select*from HISTORICALDATA..ContactResultDetail
where VCCNumId = 22
and ImportationId = 'TdE2_rpt_RA_SERVINFORM_20220805'
order by ImportationId desc
-------------------------------------------------------------------------------------------------------
-- Para validar un ID con su numero de telefono de un Motor
select*from MMProdat..ContactImportPhone
where ContactVCC = 22
and ContactId = '00409064D'
-------------------------------------------------------------------------------------------------------
-- Para consultar las llamadas de Motor
select * from MMProdat..OutboundProcessContact
--update MMProdat..OutboundProcessContact
--set Status = NULL
where vcc = 'servinform'
and BatchId='TdE_rpt_RA_SERVINFORM_20220708' 
and ScheduledDate IS NOT NULL
-------------------------------------------------------------------------------------------------------
-- Para consultar ID contra el numero de tel en un Motor
select*from MMProdat..ContactImportPhone
-------------------------------------------------------------------------------------------------------
-- Para ver la gestion de los lotes
select * from HISTORICALDATA..InteractionActorDetail
where VirtualCC = 'servinform'
and Campaign = 'regular_a'
and StartDate between '2022-11-10 00:00:00.000' and '2022-11-10 23:59:00.000'
order by 4 desc

-- Para ver los numeros de telefono filtrados
select Id,date, replace(replace(REPLACE(DestinationAddress,'-',''),'[',''),']',''),Result, BatchId from HISTORICALDATA..ContactResultDetail
where VirtualCC = 'servinform'
and Campaign = 'regular_a'
and Date between '2022-11-10 00:00:00.000' and '2022-11-10 23:59:00.000'
and Result = 'CONGESTION'

-- Para ver la cantidad de resultados con congestion por lotes
select COUNT(Id), BatchId from HISTORICALDATA..ContactResultDetail
where VirtualCC = 'servinform'
and Campaign = 'regular_a'
and Date between '2022-11-10 00:00:00.000' and '2022-11-10 23:59:00.000'
and Result = 'CONGESTION'
group by BatchId
-------------------------------------------------------------------------------------------------------
 -- Para seleccionar los valores unicos de una tabla
Select distinct CampaignId from Snowball..Gestiones
-------------------------------------------------------------------------------------------------------
-- Consulta total de atenciones por Agente en una fecha especifica 
SELECT Agent, count(*) AS Contador FROM HistoricalData..ContactResultDetail
where VirtualCC = 'pricet'
--and Agent = 'hilda.upton'
--and Agent = 'dafne.hernandez'
and Date between '2023-04-23 00:00:00.000' and '2023-04-24 23:59:00.000'
GROUP BY Agent
HAVING COUNT(*)>1;
-------------------------------------------------------------------------------------------------------
-- Revision de avance de BackUp
SELECT RepositoryBackUpStatus, count(*) AS Contador FROM HistoricalData..InteractionMultimediaParts
GROUP BY RepositoryBackUpStatus
HAVING COUNT(*)>1;
-------------------------------------------------------------------------------------------------------
--Activamos las opciones avanzadas requisito indispensable para activar xp_cmdshell
sp_configure 'show advanced options', '1'
--Aplicamos los cambios
RECONFIGURE
--Habilitamos xp_cmdshell
sp_configure 'xp_cmdshell', '1' 
--Aplicamos los cambios
RECONFIGURE
-------------------------------------------------------------------------------------------------------
--Activamos las opciones avanzadas requisito indispensable para activar xp_cmdshell
sp_configure 'show advanced options', '1'
--Aplicamos los cambios
RECONFIGURE
--Deshabilitamos xp_cmdshell
sp_configure 'xp_cmdshell', '0' 
--Aplicamos los cambios
RECONFIGURE
-------------------------------------------------------------------------------------------------------
-- Consultar los resultados de Reagenda
select*from MMProDat..OutboundProcessContact
-------------------------------------------------------------------------------------------------------
-- Consultar por campos 
select TOP(500) NumberOfTransferred, Campaign, OriginalCampaign, TimeStamp from HistoricalData..InteractionActorDetail (nolock)
where IsTransferred = '1'
--and VirtualCC = 'noverite'
--and NumberOfTransferred != 'VALIDACION'
order by TimeStamp desc
-------------------------------------------------------------------------------------------------------
-- Para validar que IVR estan activos en una campaña
select CampaignId, SelfServiceProcess, OutOfTimeProcess from MMProDat..CampaignInboundInteraction
-------------------------------------------------------------------------------------------------------
-- Actualizar estado de agenda de reportes en OCC del estado Running a Active
-- https://inconcert.atlassian.net/wiki/spaces/i6Docs/pages/1533706305/Actualizar+estado+de+agenda+de+reportes+en+OCC+del+estado+Running+a+Active.
cassandra-cli -h 172.16.235.6 -- IP I6
use SummarizerData;
set ReportSchedules['f978151f-c2b9-48c3-99ff-74a30d9ab3ec']['State']='active'; -- este cod '19394255-0fcc-4bc5-9b59-1faf420a386f' se obtiene de  buscar el row_id en el inspeccionar.
exit;
-------------------------------------------------------------------------------------------------------
-- Validar HotFix
select * from MMProDat..HotFix (nolock)
-------------------------------------------------------------------------------------------------------
-- lists all job information for the NightlyBackups job.  
USE msdb ;  
GO  
EXEC dbo.sp_help_jobhistory   
    @job_name = 'FTP_Reportes' ; 
GO
-------------------------------------------------------------------------------------------------------
