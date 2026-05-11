
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