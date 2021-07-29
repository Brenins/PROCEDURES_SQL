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

