CREATE DATABASE Locacadora_Parte03
GO
USE Locacadora_Parte03

----------------------TABELA FILME----------------------------------------------
GO
CREATE TABLE Filme (
ID					INTEGER				NOT NULL,
Titulo				VARCHAR				NOT NULL,
Ano					INTEGER				NULL
PRIMARY KEY (ID)
)
----------------------TABELA ESTRELA----------------------------------------------
GO
CREATE TABLE Estrela (
ID					INTEGER				NOT NULL,
Nome				VARCHAR(50)			NOT NULL

PRIMARY KEY (ID)
)
----------------------TABELA CLIENTE----------------------------------------------
GO
CREATE TABLE Cliente (
Num_Cadastro		INTEGER				NOT NULL,
Nome				VARCHAR(70)			NOT NULL,
Logradouro			VARCHAR(150)		NOT NULL,
Num					INTEGER				NOT NULL,
CEP					CHAR(8)				NULL
PRIMARY KEY (Num_Cadastro)
)
----------------------TABELA FILME ESTRELA--------------------------
GO
CREATE TABLE Filme_Estrela (
Filme_ID			INTEGER				NOT NULL,
Estrela_ID			INTEGER				NOT NULL

FOREIGN KEY (Filme_ID) REFERENCES Filme (ID),
FOREIGN KEY (Estrela_ID) REFERENCES Estrela (ID)
)
----------------------TABELA DVD-------------------------------------------
GO
CREATE TABLE DVD (
Num					INTEGER				NOT NULL,
Data_Fabricacao		DATE				NOT NULL,
Filme_ID			INTEGER				NOT NULL
PRIMARY KEY (Num),
FOREIGN KEY (Filme_ID) REFERENCES Filme (ID)

)
----------------------TABELA LOCACAO----------------------------------------
GO
CREATE TABLE Locacao (
DVD_Num					INTEGER				NOT NULL,
Cliente_Num_Cadastro	INTEGER				NOT NULL,
Data_Locacao			DATE				NOT NULL	DEFAULT (GETDATE()),
Data_Devolucao			DATE				NOT NULL,
Valor					DECIMAL (7, 2)		NOT NULL

PRIMARY KEY (Data_Locacao, DVD_Num, Cliente_Num_Cadastro)
FOREIGN KEY (DVD_Num) REFERENCES DVD (Num),
FOREIGN KEY (Cliente_Num_Cadastro) REFERENCES Cliente (Num_Cadastro)
)

-----------------------------RESTRIÇÕES------------------------------------------

------ANO DO FILME DEVE SER MENOR OU IGUAL A 2021--------------------------------
GO
ALTER TABLE Filme
ADD CHECK (Ano <= 2021)

------DATA DE FABRICAÇÃO DE DVD DEVE SER MENOR DO QUE HOJE-----------------------
GO
ALTER TABLE DVD
ADD CHECK (Data_Fabricacao < GETDATE())

------NÚMERO DO ENDEREÇO DE CLIENTE DEVE SER POSITIVO----------------------------
GO
ALTER TABLE Cliente
ADD CHECK (Num > 0)

------CEP DO ENDEREÇO DE CLIENTE DEVE TER, ESPECIFICAMENTE, 8 CARACTERES---------
GO
ALTER TABLE Cliente
ADD CHECK (LEN(CEP) = 8)

------DATA DE LOCAÇÃO, POR PADRÃO, DEVE SER HOJE---------------------------------

--GO
--ALTER TABLE Locacao
--ADD CHECK (Data_Locacao = GETDATE())
------DATA DE DEVOLUÇÃO DE LOCAÇÃO, DEVE SER MAIOR QUE A DATA DE LOCAÇÃO---------
GO
ALTER TABLE Locacao
ADD CONSTRAINT Verifica_Data CHECK (Data_Devolucao > Data_Locacao)

------VALOR DE LOCAÇÃO DEVE SER POSITIVO-----------------------------------------
GO
ALTER TABLE Locacao
ADD CHECK (Valor > 0)

----A ENTIDADE ESTRELA DEVERIA TER O NOME REAL DA ESTRELA, COM 50 CARACTERES-----
GO
ALTER TABLE Estrela
ADD Nome_Real		VARCHAR(50)			NULL

------VERIFICANDO UM DOS NOMES DE FILME, PERCEBEU-SE QUE O NOME DO FILME DEVERIA SER UM ATRIBUTO COM 80 CARACTERES------
GO
ALTER TABLE Filme
ALTER COLUMN Titulo			VARCHAR(80)	NOT NULL

----------------------INSERINDO DADOS DA TABELA FILME---------------------------------
GO
INSERT INTO Filme (ID, Titulo, Ano)
VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)

----------------------INSERINDO DADOS DA TABELA ESTRELA-------------------------------
GO
INSERT INTO Estrela (ID, Nome, Nome_Real)
VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

--------------------INSERINDO DADOS DA TABELA FILME_ESTRELA----------------------------
GO
INSERT INTO Filme_Estrela (Filme_ID, Estrela_ID)
VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

--------------------INSERINDO DADOS DA TABELA DVD---------------------------------------
GO
INSERT INTO DVD (Num, Data_Fabricacao, Filme_ID)
VALUES
(10001, '2020-12-02', 1001),
(10002,	'2019-10-18', 1002),
(10003,	'2020-04-03', 1003),
(10004,	'2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007,	'2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)

--------------------INSERINDO DADOS NA TABELA CLIENTE------------------------------------
GO
INSERT INTO Cliente (Num_Cadastro, Nome, Logradouro, Num, cep)
VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150,'03086050'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250,'04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169,NULL),
(5504, 'Roberta Bento',	'Rua Jayme Von Rosenburg', 36,NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235,'02917110')

--------------------INSERINDO DADOS NA TABELA LOCACAO------------------------------------
GO
INSERT INTO Locacao (DVD_Num, Cliente_Num_Cadastro, Data_Locacao, Data_Devolucao, Valor)
VALUES
(10001, 5502, '2021-02-18',	'2021-02-21', 3.50),
(10009, 5502, '2021-02-18', '2021-02-21', 3.50),
(10002, 5503, '2021-02-18', '2021-02-19', 3.50),
(10002, 5505, '2021-02-20', '2021-02-23', 3.00),
(10004, 5505, '2021-02-20',	'2021-02-23', 3.00),
(10005, 5505, '2021-02-20', '2021-02-23', 3.00),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

-----------------------------OPERAÇÕES COM DADOS------------------------------------

---OS CEP DOS CLIENTES 5503 E 5504 SÃO 08411150 E 02918190 RESPECTIVAMENTE---------------
GO
UPDATE Cliente
SET CEP = '08411150'
WHERE Num_Cadastro = 5503

UPDATE Cliente
SET CEP = '02918190'
WHERE Num_Cadastro = 5504
SELECT * FROM Cliente
---A LOCACÃO DE 2021-02-18 DO CLIENTE 5502 TEVE O VALOR DE 3.25 PARA CADA DVD ALUGADO----
GO
UPDATE Locacao
SET Valor = 3.25
WHERE Cliente_Num_Cadastro = 5502

---A LOCACÃO DE 2021-02-18 DO CLIENTE 5502 TEVE O VALOR DE 3.25 PARA CADA DVD ALUGADO----
GO
UPDATE Locacao
SET Valor = 3.25
WHERE Cliente_Num_Cadastro = 5502

-------------------------O DVD 10005 DOI FABRICADO EM 2019-07-14--------------------------
GO
UPDATE DVD
SET Data_Fabricacao = '2019-07-14'
WHERE Num = 10005

-----------------------O NOME REAL DE MILES TELLER É MILES ALEXANDER TELLER---------------
GO
UPDATE Estrela
SET Nome_Real = 'Miles Alexander Teller'
WHERE ID = 9903

-----------------------O FILME SING NÃO TEM DVD CADASTRADO E DEVE SER EXCLUIDO------------
GO
DELETE Filme
WHERE ID = 1006

----------------------------------CONSULTAR----------------------------------------------------------------
--1) FAZER UMA CONSULTA QUE RETORNE ID, ANO, NOME DO FILME (CASO O NOME DO FILME TENHA MAIS DE 10 CARACTERES,
--PARA CABER NO CAMPO DA TELA, MOSTRAR OS 10 PRIMEIROS CARACTERES, SEGUIDOS DE RETICÊNCIAS...)
--CUJOS DVDs FORAM FABRICADOS DEPOIS DE 01/01/2020

SELECT ID, Ano, CASE WHEN LEN (Titulo) > 10
THEN RTRIM (SUBSTRING(Titulo, 1, 10)) + '...'
ELSE
	Titulo
END AS Titulo
FROM Filme
WHERE ID IN
(SELECT Filme_ID FROM DVD WHERE Data_Fabricacao > '2020-01-01')

--2) FAZER UMA CONSULTA QUE RETORNE NUM, DATA_FABRICACAO, QTD_MESES_DESDE_FABRICACAO
--(QUANTOS MESES DESDE QUE O DVD FOI FABRICADO ATÉ HOJE) DO FILME INTERESTELAR.

SELECT DISTINCT Num, Data_Fabricacao,
DATEDIFF(MONTH, Data_Fabricacao, GETDATE()) AS Qtd_Meses_Desde_Fabricacao
FROM DVD

WHERE Filme_ID IN
(SELECT ID FROM Filme WHERE Titulo = 'Interestelar')

--3) FAZER UMA CONSULTA QUE RETORNE NUM_DVD, DATA_LOCACAO, DATA_DEVOLUCAO,
--DIAS_ALUGADO(TOTAL DE DIAS QUE O DVD FICOU ALUGADO) E VALOR DAS LOCAÇÕES DA CLIENTE QUE TEM, NO NOME, O TERMO ROSA

SELECT DISTINCT DVD_Num,
CONVERT(CHAR(10),Data_Locacao, 103),
CONVERT(CHAR(10),Data_Devolucao,103), Valor,
DATEDIFF (DAY, Data_Locacao, Data_Devolucao) AS Total_Dias_Alugado
FROM Locacao

WHERE Cliente_Num_Cadastro IN
(SELECT Num_Cadastro FROM Cliente WHERE Nome LIKE 'Rosa%')

--4) NOME, ENDEREÇO_COMPLETO (LOGRADOURO E NUMERO CONCATENADOS),
--CEP (FORMATO XXXXX-XXX) DOS CLIENTES QUE ALUGARAM DVD DE NUM 10002
SELECT * FROM Cliente

SELECT Nome, Logradouro + ', N°'+ CAST(Num AS VARCHAR(5)), + 'CEP: ' + 
SUBSTRING (CEP, 1, 5) + ' - ' + SUBSTRING(CEP,6, 3) AS CEP
FROM Cliente

WHERE Num_Cadastro IN
(SELECT Cliente_Num_Cadastro FROM Locacao WHERE DVD_Num IN
(SELECT Num FROM DVD WHERE Num = '10002'))

---------------------------CONSULTAR----------------------------------
--1) CONSULTAR NUM_CADASTRO DO CLIENTE, NOME DO CLIENTE, DATA_LOCACAO (FORMATO
--   DD/MM/AAAA), QTD_DIAS_ALUGADO (TOTAL DE DIAS QUE O FILME FICOU ALUGADO), TITULO DO FILME,
--   ANO DO FILME DA LOCAÇÃO DO CLIENTE CUJO NOME INICIA COM MATILDE
SELECT Cliente.Num_Cadastro, Cliente.Nome,
CONVERT (CHAR (10), Locacao.Data_Locacao, 103) AS Data_de_Alocacao,
DATEDIFF (DAY, Data_Locacao, Data_Devolucao) AS Dias_Alugos_Filme,
Filme.Titulo, Filme.Ano

FROM Cliente, Locacao, Filme

WHERE Num_Cadastro IN
(SELECT Num_Cadastro FROM Cliente WHERE Nome LIKE 'Matilde%')

--2) CONSULTAR NOME DA ESTRELA, NOME_REAL DA ESTRELA,
--   TÍTULO DOS FILMES CADASTRADOS DO ANO DE 2015
SELECT Estrela.Nome, Estrela.Nome_Real, Filme.Titulo
FROM Estrela, Filme

WHERE Titulo IN
(SELECT Titulo FROM Filme WHERE Ano = '2015')

--SELECT * FROM Filme_Estrela
--SELECT * FROM Filme
--SELECT * FROM Estrela

--3) CONSULTAR TITULO DO FILME, DATA_FABRICACAO DO DVD (FORMATO DD/MM/AAAA), CASO A
--   DIFERENÇA DO ANO DO FILME COM O ANO ATUAL SEJA MAIOR QUE 6, DEVE APARECER A DIFERENÇA
--   DO ANO COM O ANO ATUAL CONCATENADO COM A PALAVRA ANOS (EXEMPLO: 7 ANOS), CASO
--   CONTRÁRIO SÓ A DIFERENÇA (EXEMPLO: 4)
SELECT Filme.Titulo,
CONVERT (CHAR(10), Data_Fabricacao,103) AS Data_Fabricação_DVD,
CASE WHEN (DATEDIFF (YEAR, CAST(Ano AS VARCHAR(4)), GETDATE()) > 6)
	THEN 
		'' + ' Anos'
	ELSE
		''
	END AS Diferença_Anos
FROM Filme, DVD


SELECT Filme.Titulo,
CONVERT (CHAR(10), Data_Fabricacao,103) AS Data_Fabricação_DVD,
CASE WHEN DATEDIFF (YEAR, CAST(Ano AS VARCHAR(4)), GETDATE()) > 6
	THEN 
		 + (DATEDIFF (YEAR, CAST(Ano AS varchar(4)), GETDATE()))
	ELSE
		''
	END AS Diferença_Anos
from Filme, DVD