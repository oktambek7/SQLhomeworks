--Task 1:

--Write an SQL query to retrieve the database name, schema name, table name, column name, and column data type for all tables across all databases in a SQL Server instance. Ensure that system databases (master, tempdb, model, msdb) are excluded from the results.
---============Solution:

exec sp_MSforeachdb @command1 = '
if ''?'' not in (''master'', ''tempdb'', ''model'', ''msdb'')
begin
use [?]
select
	db_name(),
	table_schema,
	table_name,
	column_name,
	data_type
from INFORMATION_SCHEMA.columns;
end
'

--Task 2:

--Write a stored procedure that retrieves all stored procedure and function names along with their schema names and parameters (if they exist), including parameter data types and maximum lengths. The procedure should accept a database name as an optional parameter. If a database name is provided, it should return the information for that specific database; otherwise, it should retrieve the information for all databases in the SQL Server instance.
---===============Solution:
go

CREATE proc GetRoutineMetadata
    @DatabaseName NVARCHAR(128) = NULL  -- Optional parameter for database name
AS
BEGIN
    SET NOCOUNT ON;

    -- If a specific database is provided, query only that database
    IF @DatabaseName IS NOT NULL
    BEGIN
        -- Validate the database exists and is online
        IF NOT EXISTS (
            SELECT 1 
            FROM sys.databases 
            WHERE name = @DatabaseName 
            AND state_desc = 'ONLINE'
        )
        BEGIN
            RAISERROR ('The specified database %s does not exist or is not online.', 16, 1, @DatabaseName);
            RETURN;
        END

        -- Build and execute the query for the specific database
        DECLARE @SQL NVARCHAR(MAX) = 
            'USE ' + QUOTENAME(@DatabaseName) + ';
            SELECT 
                DB_NAME() AS DatabaseName,
                s.name AS SchemaName,
                o.name AS RoutineName,
                CASE 
                    WHEN o.type = ''P'' THEN ''Procedure''
                    WHEN o.type IN (''FN'', ''IF'', ''TF'') THEN ''Function''
                END AS RoutineType,
                p.name AS ParameterName,
                t.name AS DataType,
                CASE 
                    WHEN t.name IN (''nvarchar'', ''nchar'') THEN p.max_length / 2
                    ELSE p.max_length 
                END AS MaxLength
            FROM sys.objects o
            INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
            LEFT JOIN sys.parameters p ON o.object_id = p.object_id
            LEFT JOIN sys.types t ON p.system_type_id = t.system_type_id
            WHERE o.type IN (''P'', ''FN'', ''IF'', ''TF'')
            ORDER BY SchemaName, RoutineName, ParameterName;';

        EXEC sp_executesql @SQL;
    END
    ELSE
    BEGIN
        -- Query all databases using sp_MSforeachdb, excluding system databases
        EXEC sp_MSforeachdb @command1 = '
        IF ''?'' NOT IN (''master'', ''tempdb'', ''model'', ''msdb'')
        BEGIN
            USE [?];
            SELECT 
                DB_NAME() AS DatabaseName,
                s.name AS SchemaName,
                o.name AS RoutineName,
                CASE 
                    WHEN o.type = ''P'' THEN ''Procedure''
                    WHEN o.type IN (''FN'', ''IF'', ''TF'') THEN ''Function''
                END AS RoutineType,
                p.name AS ParameterName,
                t.name AS DataType,
                CASE 
                    WHEN t.name IN (''nvarchar'', ''nchar'') THEN p.max_length / 2
                    ELSE p.max_length 
                END AS MaxLength
            FROM sys.objects o
            INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
            LEFT JOIN sys.parameters p ON o.object_id = p.object_id
            LEFT JOIN sys.types t ON p.system_type_id = t.system_type_id
            WHERE o.type IN (''P'', ''FN'', ''IF'', ''TF'')
            ORDER BY SchemaName, RoutineName, ParameterName;
        END;
        ';
    END
END;
GO

exec GetRoutineMetadata;