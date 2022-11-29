CREATE DATABASE Quarta_Atividade
GO
USE Quarta_Atividade
GO

CREATE TABLE cliente (
CPF                   VARCHAR(11)          NOT NULL,
nome                  VARCHAR(30)          NOT NULL,
telefone              VARCHAR(8)           NOT NULL
PRIMARY KEY(CPF)
)
GO

CREATE TABLE fornecedor (
id                    INT                  NOT NULL,
nome                  VARCHAR(15)          NOT NULL,
logradouro            VARCHAR(40)          NOT NULL,
N                     INT                  NOT NULL,
complemento           VARCHAR(20)          NOT NULL,
cidade                VARCHAR(20)          NOT NULL
PRIMARY KEY(id)
)
GO

CREATE TABLE produto (
codigo                INT                  NOT NULL,
descricao             VARCHAR(60)          NOT NULL,
fornecedor_id         INT                  NOT NULL,
preço                 DECIMAL(7, 2)        NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(fornecedor_id) REFERENCES fornecedor(id)
)
GO

CREATE TABLE venda (
codigo                INT                  NOT NULL,
produto_codigo        INT                  NOT NULL,
CPF_cliente           VARCHAR(11)          NOT NULL,
quantidade            INT                  NOT NULL,
valor_total           DECIMAL(7, 2)        NOT NULL,
data                  DATE                 NOT NULL
PRIMARY KEY(codigo, produto_codigo, CPF_cliente)
FOREIGN KEY(produto_codigo)   REFERENCES produto(codigo),
FOREIGN KEY(CPF_cliente)      REFERENCES cliente(CPF)
)
GO

INSERT INTO cliente (CPF, nome, telefone) 
VALUES      ('34578909290', 'Julio Cesar', '82736541')
GO

INSERT INTO cliente (CPF, nome, telefone) 
VALUES      ('25186533710', 'Maria Antonia', '87652314')
GO

INSERT INTO cliente (CPF, nome, telefone) 
VALUES      ('87627315416', 'Luiz Carlos', '61289012')
GO

INSERT INTO cliente (CPF, nome, telefone) 
VALUES      ('79182639800', 'Paulo Cesar', '90765273')
GO


INSERt INTO fornecedor VALUES
            (1, 'LG', 'Rod. Bandeirantes', 70000, 'Km 70', 'Itapeve'),
			(2, 'Asus', 'Av. Nações Unidas', 10206, 'Sala 225', 'São Paulo'),
			(3, 'AMD', 'Av. Nações Unidas', 10206, 'Sala 1095', 'São Paulo'),
			(4, 'Leadership', 'Av. Nações Unidas', 10206, 'Sala 87', 'São Paulo'),
			(5, 'Inno', 'Av. Nações Unidas', 10206, 'Sala 34', 'São Paulo')
GO


INSERT INTO produto VALUES
            (1, 'Monitor 19 pol.', 1, 499.99),
			(2, 'Netbook 1GB Ram 4 Gb HD', 2, 699.99),
			(3, 'Gravador de DVD - Sata', 1, 99.99),
			(4, 'Leitor de CD', 1, 49.99),
			(5, 'Processador - Phenom X3 - 2.1GHz', 3, 349.99),
			(6, 'Mouse', 4, 19.99),
			(7, 'Teclado', 4, 25.99),
			(8, 'Placa de Video - Nvidia 9800 GTX - 256MB/256 bits', 5, 599.99)
GO			

INSERT INTO venda VALUES 
            (1, 1, '25186533710', 1, 499.99, '03/09/2009'),
			(1, 4, '25186533710', 1, 49.99, '03/09/2009'),
			(1, 5, '25186533710', 1, 349.99, '03/09/2009'),
			(2, 6, '79182639800', 4, 79.99, '06/09/2009'),
			(3, 8, '87627315416', 1, 599.99, '06/09/2009'),
			(3, 3, '87627315416', 1, 99.99, '06/09/2009'),
			(3, 7, '87627315416', 1, 25.99, '06/09/2009'),
			(4, 2, '34578909290', 2, 1399.99, '08/09/2009')
GO


--1)Consultar no formato dd/mm/aaaa:
--Data da Venda 4

SELECT CONVERT(CHAR(10), data, 103) AS data
FROM venda
WHERE codigo = 4
GO
--2) Inserir na tabela Fornecedor, a coluna Telefone

ALTER TABLE fornecedor
ADD telefone   VARCHAR(8)   NULL 
GO

--3) e os seguintes dados no telefone:

UPDATE fornecedor
SET telefone = '72165371'
WHERE id = 1
GO

UPDATE fornecedor
SET telefone = '87153738'
WHERE id = 2
GO

UPDATE fornecedor
SET telefone = '36546289'
WHERE id = 4 
GO

--4) Consultar por ordem alfabética de nome, o nome, o enderço concatenado e o telefone dos fornecedores

SELECT nome,
       logradouro +', ' + CAST(N AS VARCHAR(5)) + ', ' + complemento AS end_concatenado,
	   telefone
FROM fornecedor
ORDER BY nome ASC 

--Consultar
--5) Produto, quantidade e valor total do comprado por Julio Cesar

SELECT produto_codigo,
       quantidade,
	   valor_total
FROM venda
WHERE CPF_cliente IN (
                    SELECT CPF
					FROM cliente
					WHERE nome = 'Julio Cesar'
                     )
GO


--6) Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar

SELECT CONVERT(CHAR(10), data, 103 ) AS data,
       valor_total 
FROM venda
WHERE CPF_cliente IN (
                    SELECT CPF
					FROM cliente
					WHERE nome = 'Paulo Cesar'
                     )
GO

--7) Consultar, em ordem decrescente, o nome e o preço de todos os produtos 

SELECT descricao,
      preço
FROM produto
ORDER BY descricao DESC