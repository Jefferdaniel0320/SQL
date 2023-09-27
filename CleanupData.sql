USE [BlendingFormacion]
GO
/****** Object:  StoredProcedure [dbo].[CleanupData]    Script Date: 7/24/2023 12:26:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[CleanupData]
AS

Set nocount On


	Declare @EndDateDetail Datetime, @EndDateSummary Varchar(10)
	Select @EndDateDetail = dateAdd(month,-3, Convert(Datetime,Convert(Varchar(10),GetUtcDate(),101)))

	Delete 
	From Gestiones
	Where TmStmp < @EndDateDetail

	Delete 
	From Llamadas
	Where TmStmp < @EndDateDetail
	
	Delete 
	From LogsFormulario
	Where TmStmp < @EndDateDetail

	Delete
	From Test.dbo.IVRBimbo
	Where TmStmp < @EndDateDetail

Set nocount Off
