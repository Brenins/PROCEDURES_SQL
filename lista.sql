--1) Crie um procedimento que apresente o volume e o montante total de vendas por região e trimestre.

SELECT
    YEAR(NOTA_FISCAL.DATA) AS ANO,
    ENDERECO.REGIAO,
    DATEPART(QQ,NOTA_FISCAL.DATA) AS TRIMESTRE,
    COUNT(IDNOTA) AS VOLUME,
    SUM(TOTAL) AS MONTANTE
FROM NOTA_FISCAL
JOIN CLIENTE
    ON CLIENTE.IDCLIENTE = NOTA_FISCAL.ID_CLIENTE
JOIN ENDERECO
    ON CLIENTE.IDCLIENTE = ENDERECO.ID_CLIENTE
GROUP BY
    ENDERECO.REGIAO,
    DATEPART(QQ,NOTA_FISCAL.DATA),
    YEAR(NOTA_FISCAL.DATA)
ORDER BY
1,2,3

--2) Crie um procedimento que apresente os top 10 clientes em volume de compras.

SELECT TOP 10
    RANK() OVER(ORDER by count(CLIENTE.IDCLIENTE) DESC) as'RANK',
    CLIENTE.IDCLIENTE,
    CLIENTE.NOME,
    COUNT(CLIENTE.IDCLIENTE) AS QTD_COMPRAS
FROM NOTA_FISCAL
JOIN CLIENTE
    ON CLIENTE.IDCLIENTE = NOTA_FISCAL.ID_CLIENTE
GROUP BY
CLIENTE.IDCLIENTE,
CLIENTE.NOME


--3) Crie um procedimento que mostre os clientes que não realizaram nenhuma compra.
SELECT
    CLIENTE.IDCLIENTE,
    CONCAT(CLIENTE.NOME,' ',CLIENTE.SOBRENOME) AS NOME_COMPLETO
FROM NOTA_FISCAL
RIGHT JOIN CLIENTE
    ON CLIENTE.IDCLIENTE = NOTA_FISCAL.ID_CLIENTE
WHERE NOTA_FISCAL.IDNOTA IS NULL

--4) Crie um procedimento que apresente o faturamento e o faturamento acumulado por ano.
SELECT
    YEAR(NF1.data) AS ANO,
    SUM(NF1.TOTAL) AS TOTAL,
    (
        SELECT
            SUM(NF2.TOTAL)
        FROM NOTA_FISCAL NF2
        WHERE YEAR(NF2.DATA) <= YEAR(NF1.DATA)
    ) AS ACUMULADO
FROM NOTA_FISCAL NF1
group by
YEAR(NF1.data)
order by
1

--5) Crie um procedimento que apresente os cinco produtos mais caros por categoria (parâmetro de entrada) de produto.

SELECT TOP 5
    RANK() OVER(ORDER by (PRODUTO.VALOR) DESC) as'TOP 5',
    CATEGORIA.NOME,
    PRODUTO.IDPRODUTO,
    PRODUTO.PRODUTO,
    PRODUTO.VALOR
FROM PRODUTO
JOIN CATEGORIA
    ON PRODUTO.ID_CATEGORIA = CATEGORIA.IDCATEGORIA
WHERE CATEGORIA.IDCATEGORIA = '2'

--Funções

--1) Crie uma função que informado o sexo (M, F) como parâmetro retorne a sua descrição (Masculino, Feminino).

CREATE FUNCTION FN_COITO (@SEXO CHAR(1))
RETURNS VARCHAR(15)
AS
BEGIN
    RETURN  IIF(@SEXO = 'M', 'MASCULINO', 'FEMININO')
END


--2) Crie uma função (multi-statement table-valued function) que apresente o volume e o montante total de compras com as informações do cliente (parâmetro de entrada, código do cliente), sendo:
/*
- código;
- nome completo;
- data de nascimento (no formato PT_BR (DD/MM/YYYY);
- sexo (categorização -> M=Masculino; F=Feminino) utilize a função criada no exercício 01;
- cidade;
- estado; e
- região.

*/

CREATE FUNCTION FN_MSTV_1 (@ID INT)
RETURNS TABLE
AS
RETURN(
    SELECT
    C.idcliente AS 'Cod. Cliente',
    CONCAT(C.nome, ' ', C.sobrenome) AS 'Cliente',
    DBO.FN_COITO(C.SEXO) AS SEXO,
    FORMAT(C.NASCIMENTO,'dd/MM/yyyy') AS DATA_NASCIMENTO,
    (
        SELECT
        CONCAT(E.estado, ' - ', E.regiao, ' - ', E.cidade, ' - ', E.rua)
    FROM
        ENDERECO E
    WHERE
            E.id_cliente = C.idcliente
    ) AS 'Endereco completo',
    (
        SELECT
        count(NF.IDNOTA)
    FROM
        NOTA_FISCAL NF
    WHERE
            NF.id_cliente = C.idcliente
    ) AS 'VOLUME',
    (
        SELECT
        SUM(NF.TOTAL)
    FROM
        NOTA_FISCAL NF
    WHERE
            NF.id_cliente = C.idcliente
    ) AS 'Montante Total'
FROM
    CLIENTE C
WHERE C.IDCLIENTE = @ID
);

SELECT * from dbo.FN_MSTV_1('1');


--3) Crie uma função que informado uma data como parâmetro retorne o seu trimestre (1º TRI, 2º TRI, 3º TRI e 4º TRI).
CREATE FUNCTION FN_TRIMESTRE (@DATA DATE)
RETURNS VARCHAR(15) 
AS 
    BEGIN
    RETURN CONCAT(
            CAST(
                DATEPART(QQ, @DATA) AS VARCHAR(15)
            ), '° TRI'
        )
    )
END




SELECT
    YEAR(NOTA_FISCAL.[DATA]) AS ANO,
    DBO.FN_TRIMESTRE(NOTA_FISCAL.DATA) AS TRIMESTRE,
    SUM(ITEM_NOTA.total) AS RECEITA_TOTAL,
    SUM(PRODUTO.CUSTO_MEDIO * ITEM_NOTA.QUANTIDADE) AS CUSTO_TOTAL,
    (SUM(ITEM_NOTA.total) - SUM(PRODUTO.CUSTO_MEDIO * ITEM_NOTA.QUANTIDADE)) AS LUCRO_TOTAL,
    ((SUM(ITEM_NOTA.total) - SUM(PRODUTO.CUSTO_MEDIO * ITEM_NOTA.QUANTIDADE))/SUM(ITEM_NOTA.total))*100 AS MARGEM_LUCRO
FROM NOTA_FISCAL
JOIN ITEM_NOTA
    ON ITEM_NOTA.ID_NOTA_FISCAL = NOTA_FISCAL.IDNOTA
JOIN PRODUTO
ON ITEM_NOTA.ID_PRODUTO = PRODUTO.IDPRODUTO
GROUP BY
YEAR(NOTA_FISCAL.[DATA]),
DBO.FN_TRIMESTRE(NOTA_FISCAL.DATA)
HAVING ((SUM(ITEM_NOTA.total) - SUM(PRODUTO.CUSTO_MEDIO * ITEM_NOTA.QUANTIDADE))/SUM(ITEM_NOTA.total))*100 >= 35
order BY
1,2


select * from PRODUTO


--5) Crie uma função que informado duas datas (data inicial, data final) como parâmetro retorne a diferença em dias.

CREATE FUNCTION FN_DIFERENÇA_DIAS (@INICIO DATE, @FIM DATE)
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN  DATEDIFF(day, @INICIO, @FIM);
END


SELECT
    CLIENTE.IDCLIENTE,
    CLIENTE.NOME,
    MAX(NOTA_FISCAL.DATA) AS ULTIMA_COMPRA,
    DBO.FN_DIFERENÇA_DIAS(MAX(NOTA_FISCAL.DATA), GETDATE()) AS R,
    COUNT(NOTA_FISCAL.IDNOTA) AS F,
    SUM(NOTA_FISCAL.TOTAL) AS M
FROM NOTA_FISCAL
JOIN CLIENTE
    ON CLIENTE.IDCLIENTE = NOTA_FISCAL.ID_CLIENTE
WHERE CLIENTE.IDCLIENTE = '1'
GROUP BY
    CLIENTE.IDCLIENTE,
    CLIENTE.NOME






