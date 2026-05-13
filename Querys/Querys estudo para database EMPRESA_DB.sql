
SELECT Cidade, Pais, Regiao FROM TB_ENDERECO
WHERE Regiao IS NULL
SELECT Cidade, Pais, ISNULL(Regiao, 'Não é mais NULL Visualmente') FROM TB_ENDERECO
WHERE Regiao IS NULL
USE Empresa_DB



SELECT NomeCompleto, Contato, Cargo FROM TB_CLIENTE
UNION 
SELECT Empresa, Contato, Cargo FROM TB_FORNECEDOR

--UNION faz um distict por de baixo dos panos, dado repetido desconsidera
SELECT Pais FROM TB_ENDERECO
WHERE ClienteID IS NOT NULL
UNION 
SELECT Pais FROM TB_ENDERECO
WHERE FornecedorID IS NOT NULL
--UNION All Pega até os dados repetidos
SELECT Pais FROM TB_ENDERECO
WHERE ClienteID IS NOT NULL
UNION ALL
SELECT Pais FROM TB_ENDERECO
WHERE FornecedorID IS NOT NULL


--INTERSECT
-- Retorna todos os itens que estão em Comum entre 2 Querys

SELECT Pais FROM TB_ENDERECO
 WHERE ClienteID IS NOT NULL
INTERSECT
SELECT Pais FROM TB_ENDERECO
 WHERE FuncionarioId IS NOT NULL

 --> Paises em Comum entre as 2 Querys : EUA e Reino Unido


--EXCEPT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
SELECT Pais FROM TB_ENDERECO
 WHERE ClienteID IS NOT NULL
EXCEPT
SELECT Pais FROM TB_ENDERECO
 WHERE FuncionarioId IS NOT NULL

SELECT NumeroPedido, AVG(Preco) FROM TB_DETALHE_PEDIDO
GROUP BY NumeroPedido

--SUM() soma, MIN() minimo, AVG meida, COUNT() qtde linhas


--HAVING
SELECT NumeroPedido, COUNT(*) FROM TB_DETALHE_PEDIDO
 WHERE NumeroPedido IN(10248,10249,10250,10251)
GROUP BY NumeroPedido
HAVING COUNT(*) = 3


--QUAL PRODUTO TEVE MAIOR QUANTIDADE DE VENDAS NO MÊS 7 DE 1996

SELECT * FROM TB_PEDIDO
SELECT * FROM TB_DETALHE_PEDIDO
SELECT * FROM TB_PRODUTO

SELECT TOP 1 PR.Descricao, SUM (DP.Quantidade) as SOMA FROM TB_PEDIDO P
INNER JOIN TB_DETALHE_PEDIDO DP ON DP.NumeroPedido = P.NumeroPedido
INNER JOIN TB_PRODUTO PR ON PR.ProdutoId = DP.ProdutoId
 WHERE P.DataPedido BETWEEN '1996-07-01 00:00:00' AND '1996-07-31 00:00:00'
 GROUP BY PR.Descricao
ORDER BY SOMA desc

--QUAL CLIENTE TEVE O MAIOR GASTO NO MÊS 7 de 1996
SELECT * FROM TB_PEDIDO
SELECT * FROM TB_DETALHE_PEDIDO
SELECT * FROM TB_PRODUTO
SELECT * FROM TB_CLIENTE

SELECT TOP 1  C.NomeCompleto, SUM (DP.Preco * DP.Quantidade) SOMA FROM TB_PEDIDO P
INNER JOIN TB_DETALHE_PEDIDO DP ON DP.NumeroPedido = P.NumeroPedido
INNER JOIN TB_CLIENTE C ON C.ClienteId = P.ClienteId
 WHERE P.DataPedido BETWEEN '1996-07-01 00:00:00' AND '1996-07-31 00:00:00'
 GROUP BY C.NomeCompleto
ORDER BY SOMA desc

--LISTA DE TODOS OS CLIENTES QUE MORAM NA ALEMANHA

SELECT * FROM TB_CLIENTE
SELECT * FROM TB_ENDERECO

SELECT C.NomeCompleto, E.Pais FROM TB_CLIENTE C
INNER JOIN TB_ENDERECO E ON C.ClienteId = E.ClienteId
 WHERE Pais = 'Alemanha'

--LISTA DE TODOS OS CLIENTES QUE COMPRARAM PRODUTOS DA CATEGORIA DE BEBIDA
SELECT * FROM TB_PEDIDO
SELECT * FROM TB_DETALHE_PEDIDO
SELECT * FROM TB_CLIENTE
SELECT * FROM TB_CATEGORIA
SELECT * FROM TB_PRODUTO

SELECT C.NomeCompleto, CT.Descricao FROM TB_CLIENTE C
INNER JOIN TB_PEDIDO P ON C.ClienteId = P.ClienteId
INNER JOIN TB_DETALHE_PEDIDO DP  ON DP.NumeroPedido = P.NumeroPedido
INNER JOIN TB_PRODUTO PR ON PR.ProdutoId = DP.ProdutoId
INNER JOIN TB_CATEGORIA CT ON CT.CategoriaId = PR.CategoriaId
 WHERE CT.CategoriaId = 1




 --TRAGA A DESCRIÇÃO DOS PRODUTOS QUE POSSUEM O PREÇO MAIOR QUE A MÉDIA DE TODOS OS PRODUTOS

SELECT P.Descricao FROM TB_PRODUTO P
WHERE P.Preco > (SELECT AVG(P2.Preco) FROM TB_PRODUTO P2)

--TRAGA TODOS OS CLIENTES QUE EXISTA PEDIDOS NO MÊS 7 DE 1996

SELECT C.* FROM TB_CLIENTE C
WHERE EXISTS (SELECT * FROM TB_PEDIDO P
              WHERE C.ClienteId = P.ClienteId
              AND P.DataPedido BETWEEN '1996-07-01' AND '1996-07-31')

--TRAGA O NOME E O TOTAL DE PEDIDOS DE CADA CLIENTE

SELECT C.NomeCompleto,
       (SELECT COUNT(*) FROM TB_PEDIDO P WHERE P.ClienteId = C.ClienteId) [Total Pedidos]
FROM TB_CLIENTE C
ORDER BY [Total Pedidos]


-- QUAIS CARGOS POSSSUEM MÉDIA SALARIAL MAIOR QUE A MÉDIA SALARIA DO CARGO DE Coordenador de Vendas Internas

SELECT F1.Cargo,
       AVG(F1.Salario)
FROM TB_FUNCIONARIO F1
GROUP BY F1.Cargo
HAVING AVG(F1.Salario) > (SELECT AVG(F2.Salario) FROM TB_FUNCIONARIO F2
                          WHERE F2.Cargo = 'Coordenador de Vendas Internas')



						  -- QUAL PRODUTO TEVE MAIS VENDAS EM 07 DE 1996

SELECT
    C1.Descricao,
    C1.Quantidade
FROM
(
    SELECT TOP 1 PR.Descricao, SUM(D.Quantidade) Quantidade
    FROM TB_PRODUTO PR
        JOIN TB_DETALHE_PEDIDO D ON PR.ProdutoId = D.ProdutoId
    WHERE D.NumeroPedido IN
    (
        SELECT PE.NumeroPedido
        FROM TB_PEDIDO PE
        WHERE PE.DataPedido BETWEEN '1996-07-01' AND '1996-07-31'
    )
    GROUP BY PR.Descricao
    ORDER BY SUM(D.Quantidade) DESC
) AS C1



-- VENDEDOR QUE TEVE O MAIOR VALOR NO TOTAL DE SUAS VENDAS

SELECT C1.NomeCompleto, C1.Total
FROM
(
    SELECT TOP 1 C2.NomeCompleto,
           SUM(D.Preco) Total
    FROM TB_DETALHE_PEDIDO D
    JOIN
    (
        SELECT PE.NumeroPedido,
               F.NomeCompleto
        FROM TB_PEDIDO PE
        JOIN TB_FUNCIONARIO F
            ON PE.FuncionarioId = F.FuncionarioId
        WHERE F.Cargo = 'Representante de Vendas'
    ) AS C2
        ON C2.NumeroPedido = D.NumeroPedido
    GROUP BY C2.NomeCompleto
    ORDER BY Total DESC
) AS C1

--ESTRUTURA  CASE
SELECT   NumeroPedido,
		 SUM(Preco) AS TOTAL_VENDAS,
		 CASE
			 WHEN SUM(Preco) >=50
				 THEN 'META ATINGIDA'
			 WHEN SUM(Preco) >=20 AND SUM(Preco) <=50
				 THEN 'ACEITÁVEL'
			 ELSE
			     'NÃO ATINGIDA'
		 END AS STATUS_VENDA
  FROM   TB_DETALHE_PEDIDO
GROUP BY NumeroPedido

PRINT CONCAT('A','B','C')
PRINT CONCAT('   A','B','C')
PRINT CONCAT('TESTE','  TESTE')
PRINT CONCAT('TESTE',LTRIM('  TESTE'))   -- Tira o espaço a Esquerda da STRING
PRINT CONCAT(RTRIM('TESTE   '),('TESTE'))-- Tira o espaço a Direita  da STRING

PRINT TRIM ('    TESTE    ')+'T' -- Tira o espaço da Direita e Esquerda de uma STRING


PRINT LEFT('TESTE,',3) --Retorna os 3 carcteres partindo da esquerda
PRINT RIGHT('TESTE',3) --Retorna os 3 carcteres partindo da direita

PRINT SUBSTRING('TESTES',1,3)
PRINT SUBSTRING('TESTES',3,2)  --usada para "fatiar" um pedaço da String dando a posição incial e quantos caracteres a direita vai pegar.

PRINT LEN('TESTE')  --Retorna a quantidade de Caracteres da String
PRINT UPPER('uppper deixa tudo em caixa alta, ou seja, letra maiúscula')
PRINT LOWER('LOWER deixa tudo em caixa BAIXA, ou seja, letra MINÚSCULA')

PRINT REPLICATE('Q',50)--replica a x vezes a quantidade da string colocada

PRINT CONCAT(REPLICATE('0',6), 0.44)

PRINT REPLACE('TESTE','T','M') -- troca as letra por outra

PRINT REVERSE('TESTE')  --escreve ao contrário


--Funções de Conversão de Dados
--CAST
SELECT CAST(GETDATE() AS VARCHAR)
SELECT GETDATE()

--CONVERT(tipo de dados que queremos, qual dado que será covertido, opcional(Codigo de formatações))
--Converter Data
SELECT CONVERT(VARCHAR, GETDATE())
SELECT CONVERT(VARCHAR, GETDATE(),1)-- dd/MM/yy  05/13/26
SELECT CONVERT(VARCHAR, GETDATE(),101)-- dd/MM/yyyy  05-13-2026
SELECT CONVERT(VARCHAR, GETDATE(),110) --data com traço 05-13-2026
SELECT CONVERT(VARCHAR, GETDATE(),108) --somente hora 09:52:49
SELECT CONVERT(VARCHAR, GETDATE(),20) -- 2026-05-13 09:52:39

--DECIMAL
SELECT CONVERT(DECIMAL(10,2),'123123.12333333331111') --2 casas decimais
--INT
SELECT CONVERT(INT,'1234')

SELECT
	CONCAT('Produto ', P.Descricao,' tem o preço de ', D.Preco)
	FROM TB_PRODUTO P
	JOIN TB_DETALHE_PEDIDO  D ON P.ProdutoId = D.ProdutoId
	
SELECT
	'Produto '+ P.Descricao +' tem o preço de '+ CONVERT(VARCHAR,D.Preco)
	FROM TB_PRODUTO P
	JOIN TB_DETALHE_PEDIDO  D ON P.ProdutoId = D.ProdutoId


SELECT SYSDATETIME()      --data e hora do computador precisa 
SELECT SYSDATETIMEOFFSET()--data e hora do computador precisa e fuso
SELECT GETUTCDATE() --tras o horário de greenwich

SELECT DATENAME(DAY, GETDATE())
SELECT DATENAME(MONTH, GETDATE())
SELECT DATENAME(DAY, GETDATE())
SELECT DATENAME(WEEKDAY, GETDATE())
SELECT DATENAME(YEAR, GETDATE())

SELECT DATEPART(WEEKDAY, GETDATE()) --qual número do dia da semana de 1 a 7 
--DATEDIF serve para ver a difereça em horas, dias... Entre duas datas incial, final
SELECT DATEDIFF(HOUR, '2026-05-01','2026-05-10') AS Diferença_Em_Horas
SELECT DATEDIFF(MINUTE, '2026-05-01','2026-05-10') AS Diferença_Em_Minutos
SELECT DATEDIFF(SECOND, '2026-05-01','2026-05-10') AS Diferença_Em_Segundos
SELECT DATEDIFF(DAY, '2026-05-01','2026-05-10') AS Diferença_Em_Dias
SELECT DATEDIFF(MONTH, '2026-05-01','2026-05-10') AS Diferença_Em_Meses
SELECT DATEDIFF(WEEK, '2026-05-01','2026-05-10') AS Diferença_Em_Semanas

--Caso estorar o valor do retorno usamos BIGINT
SELECT DATEDIFF(MICROSECOND, '2026-05-01','2026-05-10') AS Diferença_Em_Semanas
SELECT DATEDIFF_BIG(MICROSECOND, '2026-05-01','2026-05-10') AS Diferença_Em_Semanas


--COMO ADICIONAR DIAS NA DATA
SELECT DATEADD(DAY,10,GETDATE())  --adicona 10 dias
SELECT DATEADD(MONTH,5,GETDATE())  --adicona 10 dias
SELECT DATEADD(YEAR,5,GETDATE())  --adicona 10 dias


--Verficar se é uma Data
PRINT ISDATE('2000-13-33')  --retorna 0 não é uma data
PRINT ISDATE('2000-03-03')  --retorna  1  é uma data



--Funções Matemáticas
PRINT CEILING(4.1)--arrendoda para o primiero inteiro MAIOR que o número que passarmos
PRINT FLOOR(4.1)  --arrendoda para o primiero inteiro menor que o número que passarmos

PRINT RAND() --gera um numero aleatório


PRINT ROUND(123.1231123,2) --arrdonda
PRINT(CONVERT(DECIMAL(10,2),123.1231123))

PRINT POWER(2,3) --potencia de um número



--EXEMPLOS AVANÇADOS 1
SELECT  C2.NomeCompleto,
        C2.Cargo,
        C2.ANO_MES,
        C2.SOMATORIA_QUANTIDADE,
        C2.SOMATORIA_PRECO,
        C2.VALOR_TOTAL,

        CASE
            WHEN C2.VALOR_TOTAL >= 5000
                THEN 'BATEU A META'
            ELSE
                'NÃO BATEU A META'
        END AS [STATUS]

FROM
    (SELECT CLI.NomeCompleto,
            CLI.Cargo,
            C1.ANO_MES,
            C1.SOMATORIA_QUANTIDADE,
            C1.SOMATORIA_PRECO,
            C1.VALOR_TOTAL
			FROM
	(SELECT P.ClienteId,
        SUBSTRING(CONVERT(VARCHAR, P.DataPedido, 120), 1, 7) AS ANO_MES,
        SUM(D.Quantidade) SOMATORIA_QUANTIDADE,
        SUM(D.Preco) SOMATORIA_PRECO,
        SUM(D.Quantidade) * SUM(D.Preco) VALOR_TOTAL
    FROM TB_DETALHE_PEDIDO D
    JOIN TB_PEDIDO P ON D.NumeroPedido = P.NumeroPedido
GROUP BY P.ClienteId,
         SUBSTRING(CONVERT(VARCHAR, P.DataPedido, 120), 1, 7)) AS C1
JOIN TB_CLIENTE CLI ON C1.ClienteId = CLI.ClienteId) AS C2

--EXEMPLOS AVANÇADOS 2

SELECT  C1.CATEGORIA,
        C1.ANO,
        CONVERT(DECIMAL(15,2), C1.FATURAMENTO) AS FATURAMENTO,
        (C1.FATURAMENTO/C2.FATURAMENTO) * 100 [PERCENTUAL (%)]

FROM
    (SELECT CA.Descricao CATEGORIA,
            YEAR(PE.DataPedido) AS ANO,
            SUM(DE.Quantidade * DE.Preco) AS FATURAMENTO
        FROM TB_DETALHE_PEDIDO DE
        JOIN TB_PRODUTO PR
            ON DE.ProdutoId = PR.ProdutoId
        JOIN TB_CATEGORIA CA
            ON CA.CategoriaId = PR.CategoriaId
        JOIN TB_PEDIDO PE
            ON PE.NumeroPedido = DE.NumeroPedido
        WHERE YEAR(PE.DataPedido) = 1996
        GROUP BY CA.Descricao, YEAR(PE.DataPedido)) AS C1

INNER JOIN

    (SELECT YEAR(PE.DataPedido) AS ANO,
            SUM(DE.Quantidade * DE.Preco) AS FATURAMENTO
        FROM TB_DETALHE_PEDIDO DE
        JOIN TB_PRODUTO PR
            ON DE.ProdutoId = PR.ProdutoId
        JOIN TB_CATEGORIA CA
            ON CA.CategoriaId = PR.CategoriaId
        JOIN TB_PEDIDO PE
            ON PE.NumeroPedido = DE.NumeroPedido
        WHERE YEAR(PE.DataPedido) = 1996
        GROUP BY YEAR(PE.DataPedido)) C2

ON C1.ANO = C2.ANO

ORDER BY C1.FATURAMENTO DESC