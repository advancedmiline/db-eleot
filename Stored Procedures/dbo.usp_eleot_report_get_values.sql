SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[usp_eleot_report_get_values]
@institution_id INT,
@user_id INT,
@instructor_id INT,
@grade_level VARCHAR(255),
@subject VARCHAR(255),
@class_segment VARCHAR(255),
@observation_start_on DATE,
@observation_end_on DATE

AS

/*
parameter list:
	@institution_id int
	@user_id int
	@instructor_id int
	@grade_level varchar(255)
	@subject varchar(255)
	@class_segment varchar(255)
	@observation_start_on date
	@observation_end_on date

result set returned:
	question_id int 
	avg_val decimal 
	cnt_distinct_answer int

examples:
	usp_eleot_report_get_values 1,null,null,null,null,null,null,null
	usp_eleot_report_get_values 1,1,1,null,null         ,'Middle','10/01/2014','11/01/2014'
	usp_eleot_report_get_values 1,1,1,null,'other','Beginning',null,null
*/

--declare 
--	@institution_id int = 1,
--    @user_id int = 1,
--    @instructor_id int = 1,
--    @grade_level varchar(255) = '10',
--    @subject varchar(255) = 'other',
--    @class_segment varchar(255) = 'Beginning',
--    @observation_start_on date = '8/18/2014',
--    @observation_end_on date = '8/20/2014'


DECLARE @sql NVARCHAR(MAX) = '
select  a.question_id, a.observation_id, a.value, a.note
from    observations o
join answers a on a.observation_id = o.id
where   1=1 
and institution_id=@institution_id 
AND ISNULL(o.status,''Submitted'') = ''Submitted'' '

IF (@user_id IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and o.user_id = @user_id '
	END
IF (@instructor_id IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and o.instructor_id = @instructor_id '
	END
IF (@grade_level IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and contains(o.grade,@grade_level) '
	END
IF (@class_segment IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and contains(o.class_segment,@class_segment) '
	END
IF (@subject IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and o.subject = @subject '
	END
IF (@observation_start_on IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and o.date >= @observation_start_on  '
	END
IF (@observation_end_on IS NOT NULL)
	BEGIN
		SET @sql = @sql + 'and o.date <= @observation_end_on  '
	END
SET @sql = @sql + 'order by a.observation_id, a.question_id'

PRINT @sql 
EXEC sp_executesql @SQL , N'
@institution_id int,
@user_id int,
@instructor_id int,
@grade_level varchar(255),
@subject varchar(255),
@class_segment varchar(255),
@observation_start_on date,
@observation_end_on date',
@institution_id=@institution_id,
@user_id=@user_id,
@instructor_id=@instructor_id,
@grade_level=@grade_level,
@subject=@subject,
@class_segment=@class_segment,
@observation_start_on=@observation_start_on,
@observation_end_on=@observation_end_on



GO
