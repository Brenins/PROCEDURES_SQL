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


--03) Calcule o valor total de locações para as categorias de filme com base nas locações do mês/ano (mês e ano serão parâmetros IN)


SELECT 
    cat.id AS 'Código Da Categoria', cat.descricao AS 'Categoria',
    SUM(f.valor) AS 'Valor Do Filme'
FROM 
    locacao l 
INNER JOIN fita ft
ON ft.id = l.fitaid
INNER JOIN filme f
ON f.id = ft.filmeid
INNER JOIN categoria cat
ON cat.id = f.categoriaid
where MONTH(l.dataLocacao)


--04) Listar quais clientes precisam devolver filmes.

/*
CREATE PROCEDURE SP_LISTAR_DEV_POR_CLIENTE
AS
BEGIN
    SET NOCOUNT ON;
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
END

EXEC SP_LISTAR_DEV_POR_CLIENTE
*/



--05) Listar quais filmes nunca foram locados.
/*
CREATE PROCEDURE SP_LISTAR_FILMES_NUNCA_LOCADOS
AS
BEGIN
    SELECT 
        f.id,
        f.descricao AS 'Nome Do Filme'
    FROM 
        locacao l
    INNER JOIN fita ft
    ON ft.id = l.fitaid
    RIGHT JOIN filme f
    ON f.id = ft.filmeid
    WHERE
        ft.id IS NULL
END

EXEC SP_LISTAR_FILMES_NUNCA_LOCADOS
*/


--6
/*
CREATE PROCEDURE SP_CLIENTES_QUE_NUNCA_LOCARAM
AS
BEGIN
    SET NOCOUNT ON
    SELECT 
        cliente.id,
        cliente.nome
    FROM CLIENTE
        JOIN locacao
        on cliente.id = locacao.clienteId
    where cliente.id not in (select clienteId from locacao)
END
EXEC SP_CLIENTES_QUE_NUNCA_LOCARAM
*/


--7
/*
SELECT top 1
    cliente.id,
    cliente.nome,
    locacao.dataLocacao AS 'Ultima Locacao'
FROM CLIENTE
    JOIN locacao
    on cliente.id = locacao.clienteId
where cliente.id = (
    SELECT
    CLIENTE.id
FROM cliente
WHERE CLIENTE.nome LIKE '%LUCIANA%'
)
order by dataLocacao desc
*/

SELECT
    f.id AS 'Código Do Filme', 
    f.descricao as 'Filme',
    COUNT(f.id) AS QTD,
    RANK() OVER(ORDER by count(f.id) DESC) as'RANK'
FROM locacao l
INNER JOIN fita ft
    ON ft.id = l.fitaid
INNER JOIN filme f
    ON f.id = ft.filmeid
GROUP BY 
    f.id, f.descricao
