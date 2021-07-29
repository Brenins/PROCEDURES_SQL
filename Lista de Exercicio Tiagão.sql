--01) Exiba a quantidade total de locações de um determinado filme. (Exibir o id, nome do filme e quantidade de locações)

/*CREATE PROCEDURE SP_QTA_LOCADO_FILME_NOME
    (@batata VARCHAR(100))
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        f.id,
        f.descricao as Filme,
        COUNT(f.id) AS 'Qtd Locados'
    FROM locacao l
        JOIN fita ft
        ON ft.id = l.fitaid
        JOIN filme f
        ON f.id = ft.filmeid
    WHERE
		f.descricao like '%'+@batata+'%'
    GROUP BY
        f.id,
		f.descricao
END */


--02) Exiba todas as locações efetuadas por um determinando cliente. (Exibir o id, nome do cliente e quantidade de locações)

/*
CREATE PROCEDURE SP_QTD_LOCACOES_POR_CLIENTE (@texto varchar(100))
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        clienteId,
        cliente.nome,
        COUNT(clienteId) as QTD_Locacoes
    FROM locacao
    JOIN cliente
        on locacao.clienteId = cliente.id
    WHERE cliente.nome like '%'+@texto+'%'
    GROUP BY
        clienteId,
        cliente.nome
END

EXEC SP_QTD_LOCACOES_POR_CLIENTE Pedro
*/




--exec 4
SELECT 
        clienteId,
        cliente.nome,
        COUNT(clienteId) as QTD_devolver
    FROM locacao
    JOIN cliente
        on locacao.clienteId = cliente.id
    WHERE dataDevolucao is NULL
    GROUP BY
        clienteId,
        cliente.nome



