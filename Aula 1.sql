---- Criar
--CREATE PROCEDURE SP_HELLO_WORLD
--AS
--BEGIN
--	SELECT 'OLA MUNDO!';
--END;

----Executar
--EXEC SP_HELLO_WORLD;


--CREATE PROCEDURE SP_FILME_VALOR
--AS
--BEGIN
--	SELECT descricao, valor
--	FROM filme
--END

--EXEC SP_FILME_VALOR



--EXEC sp_helptext 'SP_FILME_VALOR';


--EXERCICIO 1 TIAGAO

--ALTER PROCEDURE SP_DATA_HORA
--AS
--BEGIN
--	SELECT GETDATE() AS 'DATETIME';
--END
--EXEC SP_DATA_HORA
--EXEC sp_rename 'Atual', 'Novo';


--EXERCICIO 2
--CREATE PROCEDURE ALTERA_DEVOLUCAO
--AS
--BEGIN
--	UPDATE locacao
--	SET dataDevolucao = GETDATE()
--	WHERE clienteId = 1 and fitaId = 29;
--END

--EXEC ALTERA_DEVOLUCAO; 
--SELECT * FROM locacao;


--Exercicio 3
--ALTER PROCEDURE SP_PESQUISA_FILME_TITULO
--AS
--BEGIN
--	SELECT 
--		FILME.descricao AS 'NOME'
--	FROM filme
--	WHERE FILME.descricao LIKE '%IT%'
--END

--EXEC SP_PESQUISA_FILME_TITULO