--CREATE FUNCTION FN_DATA_MINUTOS(@MIN INT, @DTINI DATETIME, @DTFIM DATETIME) RETURNS @TAB TABLE(DATA DATETIME) AS BEGIN WHILE @DTINI <= @DTFIM BEGIN
--INSERT INTO @TAB
--VALUES (@DTINI)
--SET @DTINI = DATEADD(MINUTE, @MIN, @DTINI)
--END RETURN
--END

--SET LANGUAGE English
--SELECT *
--FROM FN_DATA_MINUTOS(60, '2021-07-28 19:00', '2021-07-28 23:59')


-- ***************** FUNCTION IN LINE TABLE **********************

--CREATE FUNCTION FN_LOCACOES_POR_DATA(@DATA DATETIME)
--RETURNS TABLE
--AS
--RETURN(
--
--    SELECT *
--FROM locacao
--WHERE dataLocacao >= @DATA
--)


--SELECT *
--FROM FN_LOCACOES_POR_DATA('2019-01-01')