---############################
--- SQL server miscellaneous
---############################

--Insert example with support for more than 1000 rows
SET IDENTITY_INSERT dbo.testtable ON;
INSERT INTO testtable (id,name)
SELECT query.*
FROM (VALUES 
	(1,'Name A'),
  (2,'Name B'),

) AS query (id,name)

