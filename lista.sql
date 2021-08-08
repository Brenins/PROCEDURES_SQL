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
WHERE C.IDCLIENTE = '1'
ORDER BY
    CONCAT(C.nome, ' ', C.sobrenome)

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
END




--5) Crie uma função que informado duas datas (data inicial, data final) como parâmetro retorne a diferença em dias.

CREATE FUNCTION FN_DIFERENÇA_DIAS (@INICIO DATE, @FIM DATE)
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN  DATEDIFF(day, @INICIO, @FIM);
END
