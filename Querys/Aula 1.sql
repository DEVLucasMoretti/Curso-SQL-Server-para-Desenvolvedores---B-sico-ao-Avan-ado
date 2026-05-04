CREATE DATABASE TesteDB_02;

DROP DATABASE TesteDB_02;

USE TesteDB;

CREATE TABLE tb_Pessoas
(
		Id INT,
		Nome VARCHAR(50),
		SobreNome VARCHAR(50),
		Idade INT,
		Altura NUMERIC(3,2)
);

CREATE TABLE TipoNumericos
(
	numero_Bigint BIGINT, -- vai de -2^53 até 2^63 menos 1
	numero_Int INT, -- vai de -2^31 até 2^31
	numero_Smalint SMALLINT,  -- vai de -2^15 até 2^15
	numero_Tinyint TINYINT,  -- vai de 0 até 255
	numero_Byte_ehverdade BIT, -- 0 --> False  1 --> Verdadeiro   NULL    2,-1,(tudo que vier diferente de 0 ou 1) --> coverte para 1 TRUE
	numero_Decimal_pontoFlutuante DECIMAL(10,2), --    10 é a precisão e 2 é a escala(precisão,escala), se não colcar, por padrão ja vem (18,0)
	numero_Numeric_pontoFlutuante NUMERIC(10,2), --    10 é a precisão e 2 é a escala(precisão,escala), se não colcar, por padrão ja vem (18,0)
	numero_Dinheiro_Money  MONEY,
	numero_Dinheiro_SmallMoney  SmallMONEY,

	numero_Real REAL,  -- -3,4 ^38 até -1,18^38  || 1,18^--38 até 3,4^38
	numero_Float  FLOAT -- 1,79^308 até -2,23^-308  || 2,23^-308 até 1,79^308
)

CREATE TABLE tb_TipoDados
(
	imagem_1 BINARY(5), 
	imagem_2 VARBINARY(5),
	imagem_3 IMAGE, --2^31 -1

	--Data Hora
	DataHor_Date DATE,  --01-01-0001 até 31-12-9999
	DataHora_DateTime DATETIME,  --01-01-1753 até 31-12-9999 horas de 00:00:00 até 23:59:59
	DataHora_DateTime2 DATETIME2, --01-01-0001 até 31-12-9999 horas de 00:00:00 até 23:59:59.9999999 com 7 milesimos de segundo de precisão, melhor performance
	DataHora_DateTimeOffSet  DATETIMEOFFSET ,--armazena Data/Hora e Fuso Horário do País.
	DataHora_SmallDateTime SMALLDATETIME, --01-01-1900 até 06-06-2079 horas de 00:00 até 23:59:59
	DataHora_Time TIME, -- Armazena somente a Hora 00:00 até 23:59:59.9999999

	--  Cadeias de Caractéres
	Texto_Char CHAR(4), -- Tem comprimento Fixo  F _ _ _  --> F '' '' ''  ele preenche com caracter vazio se não colocar nada, ou seja, sempre 4 espaços se não colcocar  --MAXIMO DE 8.000 caracteres
	Texto_Varchar VARCHAR(4), -- Não fixo F + '' ''  --MAXIMO DE 8.000 caracteres
	Texto_Text TEXT, -- MAXIMO DE 2^31 caracteres  muito MAIOR

	Texto_NChar NCHAR(1), -- _ _ --MAXIMO DE 4.000 caracteres
	Texto_NVarchar NVARCHAR(2), -- _ _ _ _ + _ _   --MAXIMO DE 4.000 caracteres
	Texto_NText NTEXT, -- MAXIMO DE 2^31 - 1 caracteres
);

CREATE TABLE Tb_Produto
(
	ProdutoId INT IDENTITY(1,1)  --NOT NULL por padrão, caso quiser que aceita valor nulo colocar NULL
)

ALTER TABLE Tb_Produto
ADD CONSTRAINT Pk_Produto PRIMARY KEY(ProdutoId)

CREATE TABLE Tb_Cliente
(
	CPF VARCHAR(12) NOT NULL,
	Idade INT NOT NULL,
	DataCriacao DATETIME2 NOT NULL DEFAULT GETDATE(), -- O Default, caso não passado parametro do INSERT ele coloca um valor padrão nesse caso o GetDate(pega a data e hora do computador)
	CONSTRAINT UQ_Cliente_CPF UNIQUE(CPF),
	CONSTRAINT Ck_Cliente_Idade CHECK (Idade > 16) -- o check vai fazer com que somente idade maiores que 16 sejam inseridas na coluna idade.
)

ALTER TABLE Tb_Cliente
ADD CONSTRAINT Ck_Cliente_Idade CHECK (Idade > 16)

ALTER TABLE Tb_Cliente
ADD CONSTRAINT DF_Cliente_DataCriacao DEFAULT(GETDATE()) FOR DataCriacao



CREATE TABLE TB_CLIENTE
(
	Id INT IDENTITY(1,1),
	Nome VARCHAR(70),
	CPF VARCHAR(11),
	DataNascimento DATETIME2,
	Email VARCHAR(70),

	CONSTRAINT PK_CLIENTE PRIMARY KEY (Id)
)
INSERT INTO TB_CLIENTE
(Nome, CPF, DataNascimento,Email)
VALUES
('Rodolfo Neves', '22342424','1980-07-21','Rodolfo.Nevves2@gmail.com')

INSERT INTO TB_CLIENTE
VALUES
('Clever Neves', '22342424','1900-05-23','Clever.Nevves2@gmail.com'),
('Nerson Neves', '22342424','1982-03-25','Nerson.Nevves2@gmail.com'),
('Nerson Neves', '22342424','1982-03-25','Nerson.Nevves2@gmail.com')

SELECT * FROM TB_CLIENTE

SELECT TOP 2 * FROM TB_CLIENTE

SELECT DISTINCT Nome, * FROM TB_CLIENTE



-- BEGIN TRAN    COMMIT   ROLLBACK

BEGIN TRAN
UPDATE TB_CLIENTE SET CPF = '12345678910'
ROLLBACK

SELECT * FROM TB_CLIENTE