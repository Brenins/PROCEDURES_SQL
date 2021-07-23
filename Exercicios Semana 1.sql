-- ####### Pr�tica Stored Procedures ################

--Exec 1

--CREATE PROCEDURE SP_QTA_LOCADO_CATEGORIA (@batata VARCHAR(100))
--AS
--BEGIN
--	SET NOCOUNT ON;

--	SELECT
--		f.descricao as Filme,
--		COUNT(f.id) AS 'Qtd Locados'
--	FROM locacao l
--		JOIN fita ft
--		ON ft.id = l.fitaid
--		JOIN filme f
--		ON f.id = ft.filmeid
--	WHERE
--		f.categoriaId = (
--			SELECT
--				categoria.id
--			FROM categoria
--			WHERE categoria.descricao like '%'+ @batata +'%'
--		)
--	GROUP BY
--		f.descricao
--END;

--EXEC SP_QTA_LOCADO_CATEGORIA Drama


--exec 2
--CREATE PROCEDURE SP_UPTADE_STATUS (@cliente VARCHAR(100))
--AS
--BEGIN
--	SET NOCOUNT ON
	
--	IF (SELECT ativo FROM cliente WHERE CLIENTE.nome LIKE '%'+@cliente+'%') != '0'
--		UPDATE cliente
--		SET ativo = 0
--		WHERE
--			CLIENTE.nome LIKE '%'+@cliente+'%'
--	ELSE
--		UPDATE cliente
--		SET ativo = 1
--		WHERE
--			CLIENTE.nome LIKE '%'+@cliente+'%'
--END


--EXEC SP_UPTADE_STATUS Pedro



CREATE PROCEDURE SP_UPDATE_FILMES_VALORES_10 (@categoria VARCHAR(100))
AS
BEGIN
    SET NOCOUNT ON

    UPDATE filme
       SET VALOR = Valor + ((valor/100) * 10)
    WHERE categoriaId = (
    SELECT
        categoria.id
    FROM categoria
    WHERE categoria.descricao like '%'+@categoria+'%'
)
END

EXEC SP_UPDATE_FILMES_VALORES_10 Ação

