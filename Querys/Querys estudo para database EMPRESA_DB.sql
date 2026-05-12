
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