--1) Crie um procedimento que apresente o volume e o montante total de vendas por região e trimestre.
ALTER PROCEDURE SP_MONTANTE_REGIAO_TRI
AS
BEGIN
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

END

EXEC SP_MONTANTE_REGIAO_TRI
--2) Crie um procedimento que apresente os top 10 clientes em volume de compras.

ALTER PROCEDURE SP_TOP10_VOL
AS
BEGIN
SELECT TOP 10
    DENSE_RANK() OVER(ORDER by count(NOTA_FISCAL.IDNOTA) desc) as'RANK',
    CLIENTE.IDCLIENTE,
    CLIENTE.NOME,
    COUNT(NOTA_FISCAL.IDNOTA) AS QTD_COMPRAS
FROM NOTA_FISCAL
JOIN CLIENTE
    ON CLIENTE.IDCLIENTE = NOTA_FISCAL.ID_CLIENTE
GROUP BY
CLIENTE.IDCLIENTE,
CLIENTE.NOME
END


--3) Crie um procedimento que mostre os clientes que não realizaram nenhuma compra.

CREATE PROCEDURE SP_CLIENTE_SEM_COMPRA
AS
BEGIN
SELECT
    CLIENTE.IDCLIENTE,
    CONCAT(CLIENTE.NOME,' ',CLIENTE.SOBRENOME) AS NOME_COMPLETO
FROM 
    NOTA_FISCAL
    RIGHT JOIN CLIENTE
        ON CLIENTE.IDCLIENTE = NOTA_FISCAL.ID_CLIENTE
WHERE NOTA_FISCAL.IDNOTA IS NULL
END




--4) Crie um procedimento que apresente o faturamento e o faturamento acumulado por ano.

CREATE PROCEDURE SP_FATURAMENTO_ACUMULADO_ANO
AS
BEGIN
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
GROUP BY
YEAR(NF1.data)
ORDER BY
1
END



--5) Crie um procedimento que apresente os cinco produtos mais caros por categoria (parâmetro de entrada) de produto.

ALTER PROCEDURE SP_TOP5_PRODUTOS (@ID INT)
AS
BEGIN
SELECT TOP 5
    RANK() OVER(ORDER by (P.VALOR) DESC) as'TOP 5',
    CAT.NOME,
    P.IDPRODUTO,
    P.PRODUTO,
    P.VALOR
FROM 
    PRODUTO P
    JOIN CATEGORIA  CAT
        ON P.ID_CATEGORIA = CAT.IDCATEGORIA
WHERE 
    CAT.IDCATEGORIA = @ID
END

EXEC SP_TOP5_PRODUTOS 2

--Funções

--1) Crie uma função que informado o sexo (M, F) como parâmetro retorne a sua descrição (Masculino, Feminino).

CREATE FUNCTION FN_SEXO (@SEXO CHAR(1))
RETURNS VARCHAR(15)
AS
BEGIN
    RETURN IIF(@SEXO = 'M', 'MASCULINO', 'FEMININO')
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

ALTER FUNCTION FN_MSTV_1 (@ID INT)
RETURNS TABLE
AS
RETURN(
    SELECT
    C.IDCLIENTE AS CLIENTE_ID,
    CONCAT(C.NOME, ' ', C.SOBRENOME) AS 'NOME',
    DBO.FN_SEXO(C.SEXO) AS SEXO,
    FORMAT(C.NASCIMENTO,'dd/MM/yyyy') AS DATA_NASCIMENTO,
    (
    SELECT
        CONCAT(E.ESTADO, ' - ', E.REGIAO, ' - ', E.CIDADE, ' - ', E.RUA)
    FROM
        ENDERECO E
    WHERE
        E.ID_CLIENTE = C.IDCLIENTE
    ) AS ENDERECO,
    (
    SELECT
        COUNT(NF.IDNOTA)
    FROM
        NOTA_FISCAL NF
    WHERE
        NF.ID_CLIENTE = C.IDCLIENTE
    ) AS 'VOLUME',
    (
    SELECT
        SUM(NF.TOTAL)
    FROM
        NOTA_FISCAL NF
    WHERE
        NF.ID_CLIENTE = C.IDCLIENTE
    ) AS MONTANTE_TOTAL
FROM
    CLIENTE C
WHERE C.IDCLIENTE = @ID
);

SELECT * from dbo.FN_MSTV_1('1');


--3) Crie uma função que informado uma data como parâmetro retorne o seu trimestre (1º TRI, 2º TRI, 3º TRI e 4º TRI).
ALTER FUNCTION FN_TRIMESTRE (@DATA DATE)
RETURNS VARCHAR(15) 
AS
BEGIN
    RETURN CONCAT(CAST(DATEPART(QQ, @DATA) AS VARCHAR(15)), '° TRI')
END;


--4) Crie uma função (multi-statement table-valued function) que gere um relatório que apresente o ano e o trimestre, seguido das seguintes métricas:




ALTER FUNCTION FN_MSTV_2 (@ANO int, @MARGEM INT)
RETURNS TABLE
AS
RETURN(
	SELECT
        YEAR(NOTA_FISCAL.[DATA]) AS ANO,
        DBO.FN_TRIMESTRE(NF.DATA) AS TRIMESTRE,
        SUM(INA.TOTAL) AS RECEITA_TOTAL,
        SUM(P.CUSTO_MEDIO * INA.QUANTIDADE) AS CUSTO_TOTAL,
        (SUM(INA.TOTAL) - SUM(P.CUSTO_MEDIO * INA.QUANTIDADE)) AS LUCRO_TOTAL,
        ((SUM(INA.TOTAL) - SUM(P.CUSTO_MEDIO * INA.QUANTIDADE))/SUM(INA.TOTAL))*100 AS MARGEM_LUCRO
    FROM 
        NOTA_FISCAL NF
        JOIN ITEM_NOTA INA
            ON INA.ID_NOTA_FISCAL = NF.IDNOTA
        JOIN PRODUTO P
            ON INA.ID_PRODUTO = P.IDPRODUTO
    WHERE 
        YEAR(NF.DATA) = @ANO
    GROUP BY
        YEAR(NF.[DATA]),
        DBO.FN_TRIMESTRE(NF.DATA)
    HAVING 
        ((SUM(INA.total) - SUM(P.CUSTO_MEDIO * INA.QUANTIDADE))/SUM(INA.total))*100 >= @Margem
);

SELECT * FROM DBO.FN_MSTV_2('2015','0') ORDER BY 1,2

--5) Crie uma função que informado duas datas (data inicial, data final) como parâmetro retorne a diferença em dias.

CREATE FUNCTION FN_DIFERENÇA_DIAS (@INICIO DATE, @FIM DATE)
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN DATEDIFF(DAY, @INICIO, @FIM);
END

/*
6) Crie uma função (multi-statement table-valued function) que informado o código do cliente apresente a matriz RFM (Recência, Frequência e Valor Monetário) do mesmo.

Tempo para retorno (R) - dias desde a última compra (utilize a função criada no exercício 05)
Frequência (F) - Número total de compras
Valor monetário (M) - quanto dinheiro total o cliente gastou.
*/
CREATE FUNCTION FN_MSTV_3 (@ID INT)
RETURNS TABLE
AS
RETURN(
    SELECT
        C.IDCLIENTE,
        C.NOME,
        MAX(NF.DATA) AS ULTIMA_COMPRA,
        DBO.FN_DIFERENÇA_DIAS(MAX(NF.DATA), GETDATE()) AS R,
        COUNT(NF.IDNOTA) AS F,
        SUM(NF.TOTAL) AS M
    FROM NOTA_FISCAL NF
    JOIN CLIENTE C
        ON C.IDCLIENTE = NF.ID_CLIENTE
    WHERE C.IDCLIENTE = @ID
    GROUP BY
        C.IDCLIENTE,
        C.NOME
);

SELECT * FROM FN_MSTV_3(1)

