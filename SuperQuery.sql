Use mmprodat
declare @VCC varchar(50), @Campana varchar(50)
set @VCC = ''
set @Campana = ''
select 'Buscando en...' as 'Buscando en...',
CASE WHEN RTrim(LTrim(@VCC)) = '' THEN 'Cualquiera' ELSE @VCC END as 'VCC',
CASE WHEN RTrim(LTrim(@Campana)) = '' THEN 'Cualquiera' ELSE @Campana END as 'Campaña'
 
--<> LOGINS POR NODO
select 'Logins por Nodo' as 'Logins por Nodo',
CurrentNodeId as Nodo,
sum(case when F1Usua02180227='Workflow' and F1AppR02310227='BarAgent' then 1 else 0 end) as 'Agentes Logueados',
sum(case when F1Usua02180227='Workflow' and F1AppR02310227='BarAgent' and estado0227='Activo' then 1 else 0 end) as 'Agentes Activos',
SUM(case when f1usua02180227='Supervisor' then 1 else 0 end) as 'Supervisores'
from MMProdat..WFUsuLog0227 (nolock)
where VirtualCC <> 'system' and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
group by CurrentNodeId
order by CurrentNodeId
 
--<> LLAMADAS
select x.*
,ISNULL(Llamadas, 0) as Llamadas
,ISNULL(Asignadas, 0) as Asignadas
,ISNULL(Hablando, 0) as Hablando
,ISNULL(Finalizando, 0) as Finalizando
,ISNULL([Hablando + Finalizando], 0) as 'Hablando + Finalizando'
,ISNULL([Asignadas + Hablando + Finalizando], 0) as 'Asignadas + Hablando + Finalizando'
,ISNULL([En cola], 0) as 'En cola'
,ISNULL([En Proceso], 0) as 'En Proceso'
from (
select 'Detalle por VCC' as 'Detalle por VCC', * from (
select '-Todos-' as VCC,
sum(case when F1Usua02180227='Workflow' and F1AppR02310227='BarAgent' then 1 else 0 end) as 'Logueados',
sum(case when F1Usua02180227='Workflow' and F1AppR02310227='BarAgent' and estado0227='Activo' then 1 else 0 end) as 'Activos'
from MMProdat..WFUsuLog0227 (nolock)
where VirtualCC <> 'system' and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
union
select VirtualCC as 'VCC',
sum(case when F1Usua02180227='Workflow' and F1AppR02310227='BarAgent' then 1 else 0 end) as 'Logueados',
sum(case when F1Usua02180227='Workflow' and F1AppR02310227='BarAgent' and estado0227='Activo' then 1 else 0 end) as 'Activos'
from MMProdat..WFUsuLog0227 (nolock)
where VirtualCC <> 'system' and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
group by VirtualCC
) a) x
left join (
select * from (
Select '-Todos-' as VCC, SUM(ISNULL(Llamadas, 0)) Llamadas,
SUM(CASE WHEN EdoAct0245 = 'LOCKED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Asignadas',
SUM(CASE WHEN EdoAct0245 = 'TAKED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Hablando',
SUM(CASE WHEN EdoAct0245 = 'ENDED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Finalizando',
SUM(CASE WHEN EdoAct0245 in ('TAKED','ENDED') THEN ISNULL(Llamadas, 0) else 0 END ) 'Hablando + Finalizando',
SUM(CASE WHEN EdoAct0245 in ('TAKED','ENDED','LOCKED') THEN ISNULL(Llamadas, 0) else 0 END ) 'Asignadas + Hablando + Finalizando',
SUM(CASE WHEN EdoAct0245 = 'QUEUED' THEN ISNULL(Llamadas, 0) else 0 END ) 'En cola' ,
SUM(CASE WHEN EdoAct0245 = '' THEN ISNULL(Llamadas, 0) else 0 END ) 'En Proceso'
from
(Select EdoAct0245,  count(* ) Llamadas
from instinte0245 (nolock)
where fecalt0245 > dateadd(hour, -1, getutcdate())
AND VirtualCC <> '' and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
and EdoAct0245 not in ('ABANDONED', 'Finished', 'CANCELLED', 'INCONSISTENT')
group by EdoAct0245
)instinte0245
union
Select VirtualCC as 'VCC', SUM(ISNULL(Llamadas, 0)) Llamadas,
SUM(CASE WHEN EdoAct0245 = 'LOCKED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Asignadas',
SUM(CASE WHEN EdoAct0245 = 'TAKED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Hablando',
SUM(CASE WHEN EdoAct0245 = 'ENDED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Finalizando',
SUM(CASE WHEN EdoAct0245 in ('TAKED','ENDED') THEN ISNULL(Llamadas, 0) else 0 END ) 'Hablando + Finalizando',
SUM(CASE WHEN EdoAct0245 in ('TAKED','ENDED','LOCKED') THEN ISNULL(Llamadas, 0) else 0 END ) 'Asignadas + Hablando + Finalizando',
SUM(CASE WHEN EdoAct0245 = 'QUEUED' THEN ISNULL(Llamadas, 0) else 0 END ) 'En cola' ,
SUM(CASE WHEN EdoAct0245 = '' THEN ISNULL(Llamadas, 0) else 0 END ) 'En Proceso'
from
(Select VirtualCC, EdoAct0245,  count(* ) Llamadas
from instinte0245 (nolock)
where fecalt0245 > dateadd(hour, -1, getutcdate())
AND VirtualCC <> '' and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
and EdoAct0245 not in ('ABANDONED', 'Finished', 'CANCELLED', 'INCONSISTENT')
group by EdoAct0245, VirtualCC
)instinte0245
group by VirtualCC) b) y
on x.VCC = y.VCC
order by Logueados desc, VCC
 
--<> CAMPAÑAS
Select 'Detalle por Campaña' as 'Detalle por Campaña',
VirtualCC, ISNULL(f1camp02930245, Campaignid) as 'Campaña', Logueados, Activos, SUM(ISNULL(Llamadas, 0)) Llamadas,
SUM(CASE WHEN EdoAct0245 = 'LOCKED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Asignadas',
SUM(CASE WHEN EdoAct0245 = 'TAKED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Hablando',
SUM(CASE WHEN EdoAct0245 = 'ENDED' THEN ISNULL(Llamadas, 0) else 0 END ) 'Finalizando',
SUM(CASE WHEN EdoAct0245 in ('TAKED','ENDED') THEN ISNULL(Llamadas, 0) else 0 END ) 'Hablando + Finalizando',
SUM(CASE WHEN EdoAct0245 in ('TAKED','ENDED','LOCKED') THEN ISNULL(Llamadas, 0) else 0 END ) 'Asignadas + Hablando + Finalizando',
SUM(CASE WHEN EdoAct0245 = 'QUEUED' THEN ISNULL(Llamadas, 0) else 0 END ) 'En cola' ,
SUM(CASE WHEN EdoAct0245 = '' THEN ISNULL(Llamadas, 0) else 0 END ) 'En Proceso'
from
(Select f1camp02930245, EdoAct0245,  count(* ) Llamadas
from instinte0245 (nolock)
where fecalt0245 > dateadd(hour, -1, getutcdate())
and EdoAct0245 not in ('ABANDONED', 'Finished', 'CANCELLED', 'INCONSISTENT')
group by f1camp02930245, EdoAct0245
)instinte0245
right join (
Select VirtualCC, Campaignid, Count( * ) 'Logueados', sum(Case when estado0227 = 'Activo' then 1 else 0 end) 'activos'
from wfusulog0227 (nolock), usercampaign (nolock)
where f1usua02180227 = 'Workflow'
and f1usua00920227 = userid
and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
group by VirtualCC, CampaignId
) TMP on instinte0245.f1camp02930245 = TMP.Campaignid
where CampaignId like CASE WHEN RTrim(LTrim(@Campana)) = '' THEN '%' ELSE '%'+@Campana+'%' END
group by VirtualCC, ISNULL(f1camp02930245, Campaignid) , Logueados, activos
order by SUM(ISNULL(Llamadas, 0))  desc
 
--<> Histórico 10 minutos motores
select 'Motores' as Motores, * from (
select VirtualCC,
campaign as 'Campaña',
ss.NodeId as 'Nodo',
crd.OutboundProcessType as 'Modo Motor',
case when CRD.OutboundProcessType = 'progressive' then '---'
when (CRD.OutboundProcessType = 'Predictive' and COI.DesiredAbandonRate = -1) then convert(varchar,COI.CorrectionManualRate) + ' - (MR)'
else cast(COI.DesiredAbandonRate*100 as varchar) end as 'T. Aband',
COI.RoutingGroup as 'RG',
COI.OutboundPrefix as 'Prefijo',
cast(AVG(elapsedtime) AS varchar)+' segundos' as 'Promedio Ring',
COUNT(*) as 'Ll. 10 min',
cast(SUM(case when Date > DATEADD(MINUTE,-5,getutcdate()) then 1 else 0 end) AS varchar) as '5 min',
cast(SUM(case when Date > DATEADD(MINUTE,-2,getutcdate()) then 1 else 0 end) AS varchar) as '2 min',
cast(SUM(case when Date > DATEADD(MINUTE,-1,getutcdate()) then 1 else 0 end) AS varchar) as '1 min',
cast(SUM(case when result = 'CONNECTED' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Connected',
cast(SUM(case when result = 'NO_ANSWER' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'No answer',
cast(SUM(case when result = 'ANSWERING_MACHINE' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Answ Mach',
cast(SUM(case when result = 'ABANDONED' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Abandoned',
cast(SUM(case when result = 'BUSY' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Busy',
cast(SUM(case when result = 'LINK_DOWN' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Link Down',
cast(SUM(case when result = 'CONGESTION' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Congestion',
cast(SUM(case when result = 'CANT_ROUTE_TO_ENDPOINT' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Can´t route',
cast(SUM(case when result = 'CONFIG_ERROR' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Config Error',
cast(SUM(case when result = 'CALL_REJECTED' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Call Rejected',
cast(SUM(case when result = 'INVALID_USE_NETWORK' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Invalid use of Network',
cast(SUM(case when result = 'NUMBER_CHANGED' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Number Changed',
cast(SUM(case when result = 'PROTOCOL_ERROR' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Protocol Error',
cast(SUM(case when result = 'BLACKLISTED_NUMBER' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Backlist',
cast(SUM(case when result = 'CALL_REJECTED_BY_ENDPOINT' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Call Rejected by endpoing',
cast(SUM(case when result = 'CAUSE_UNKNOWN' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Desconocido',
cast(SUM(case when result = 'DEAD_CONTACT' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Muerto',
cast(SUM(case when result = 'FAX' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'FAX',
cast(SUM(case when result = 'IN_PROGRESS' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'In Progress',
cast(SUM(case when result = 'NETWORK_ERROR' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Error de Red',
cast(SUM(case when result = 'NORMAL_CALL_END' then 1 else 0 end)*100/COUNT(*) AS varchar)+' %' as 'Normal Call End',
cast(SUM(case when result in ('CONNECTED','NO_ANSWER','ANSWERING_MACHINE','ABANDONED','BUSY','LINK_DOWN','CONGESTION','CANT_ROUTE_TO_ENDPOINT','CONFIG_ERROR','CALL_REJECTED','INVALID_USE_NETWORK','NUMBER_CHANGED','PROTOCOL_ERROR','BLACKLISTED_NUMBER','','CALL_REJECTED_BY_ENDPOINT','CAUSE_UNKNOWN','DEAD_CONTACT','FAX','IN_PROGRESS','NETWORK_ERROR','NORMAL_CALL_END') then 0 else 1 end)*100/COUNT(*) AS varchar)+' %' as "El resto"
from HistoricalData..ContactResultDetail CRD (nolock)
join MMProdat..CampaignOutboundInteraction COI (nolock)
on CRD.Campaign = COI.CampaignId and CRD.VirtualCC = COI.VCC
join MMProdat..OutboundProcess op (nolock)
on coi.OutboundProcessId = op.Id
join MMProdat..SystemService ss (nolock)
on op.EngineService = ss.Id
where Date > DATEADD(MINUTE,-10,getutcdate())
and VirtualCC like CASE WHEN RTrim(LTrim(@VCC)) = '' THEN '%' ELSE @VCC END
and Campaign like CASE WHEN RTrim(LTrim(@Campana)) = '' THEN '%' ELSE '%'+@Campana+'%' END
group by Campaign, crd.OutboundProcessType, VirtualCC, COI.DesiredAbandonRate, COI.CorrectionManualRate, COI.RoutingGroup, COI.OutboundPrefix, ss.NodeId
) resultados
order by resultados.[Ll. 10 min] desc