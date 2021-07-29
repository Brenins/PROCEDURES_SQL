SELECT
    --YEAR(l.dataLocacao) AS ANO,
    MONTH(l.dataLocacao) AS MES,
    --DAY(l.dataLocacao) AS  DIA,
    SUM(ft.id) AS 'Qtd Locados'
FROM locacao l
    JOIN fita ft
    ON ft.id = l.fitaid
    JOIN filme f
    ON f.id = ft.filmeid
WHERE
        l.dataLocacao BETWEEN '20191117' AND '20191230'
GROUP BY
        --YEAR(l.dataLocacao)
        MONTH(l.dataLocacao)
        --DAY(l.dataLocacao)

SELECT
    YEAR(l.dataLocacao) AS ANO,
    --MONTH(l.dataLocacao) AS MES,
    --DAY(l.dataLocacao) AS  DIA,
    SUM(ft.id) AS 'Qtd Locados'
FROM locacao l
    JOIN fita ft
    ON ft.id = l.fitaid
    JOIN filme f
    ON f.id = ft.filmeid
WHERE
        l.dataLocacao BETWEEN '20191117' AND '20191230'
GROUP BY
        YEAR(l.dataLocacao)
        --MONTH(l.dataLocacao)
        --DAY(l.dataLocacao)
