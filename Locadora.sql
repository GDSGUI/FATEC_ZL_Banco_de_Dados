--DBA: Guilherme Gomes
--Data: 22/10/2022

CREATE DATABASE Locadora
GO
USE Locadora
GO
----------------------TABELA FILME----------------------------------------------
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
Data_Locacao			DATE				NOT NULL,
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

--SELECT CONVERT(CHAR(10), GETDATE(), 103) AS hoje

------NÚMERO DO ENDEREÇO DE CLIENTE DEVE SER POSITIVO----------------------------
GO
ALTER TABLE Cliente
ADD CHECK (Num > 0)

------CEP DO ENDEREÇO DE CLIENTE DEVE TER, ESPECIFICAMENTE, 8 CARACTERES---------
GO
ALTER TABLE Cliente
ADD CHECK (LEN(CEP) = 8)

--alter table Cliente
--add cep	char(8)		CHECK(len(cep) =8)	null

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

--SELECT * FROM Filme

----------------------INSERINDO DADOS DA TABELA ESTRELA-------------------------------
GO
INSERT INTO Estrela (ID, Nome, Nome_Real)
VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', NULL),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')
-----SELECT * FROM Estrela--------

--------------------INSERINDO DADOS DA TABELA FILME_ESTRELA----------------------------
GO
INSERT INTO Filme_Estrela (Filme_ID, Estrela_ID)
VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

---SELECT * FROM Filme_Estrela---

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

---SELECT * FROM DVD---

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
(10002, 5505, '2021-02-20', '2021-02-23', 3.50),
(10004, 5505, '2021-02-20',	'2021-02-23', 3.50),
(10005, 5505, '2021-02-20', '2021-02-23', 3.50),
(10001, 5501, '2021-02-24', '2021-02-26', 3.50),
(10008, 5501, '2021-02-24', '2021-02-26', 3.50)

-----------------------------OPERAÇÕES COM DADOS------------------------------------

---OS CEP DOS CLIENTES 5503 E 5504 SÃO 08411150 E 02918190 RESPECTIVAMENTE---------------
UPDATE Cliente
SET CEP = '08411150'
WHERE Num_Cadastro = 5503

UPDATE Cliente
SET CEP = '02918190'
WHERE Num_Cadastro = 5504

--SELECT * FROM Cliente--

---A LOCACÃO DE 2021-02-18 DO CLIENTE 5502 TEVE O VALOR DE 3.25 PARA CADA DVD ALUGADO----
UPDATE Locacao
SET Valor = 3.25
WHERE Cliente_Num_Cadastro = 5502

---A LOCAÇÃO DE 2021-02-24 DO CLIENTE 5501 TEVE O VALOR DE 3.10 PARA CADA DVD ALUGADO----
UPDATE Locacao
SET Valor = 3.10
WHERE Cliente_Num_Cadastro = 5501

--SELECT * FROM Locacao--

-------------------------O DVD 10005 DOI FABRICADO EM 2019-07-14--------------------------
UPDATE DVD
SET Data_Fabricacao = '2019-07-14'
WHERE Num = 10005

---SELECT * FROM DVD---

-----------------------O NOME REAL DE MILES TELLER É MILES ALEXANDER TELLER---------------
UPDATE Estrela
SET Nome_Real = 'Miles Alexander Teller'
WHERE ID = 9903

---SELECT * FROM Estrela---

-----------------------O FILME SING NÃO TEM DVD CADASTRADO E DEVE SER EXCLUIDO------------
DELETE Filme
WHERE ID = 1006

---SELECT * FROM Filme---
---SELECT * FROM DVD-----
---------------------------------------CONSULTAR------------------------------------------
---- 1) FAZER UM SELECT QUE RETORNE OS NOMES DOS FILMES DE 2014---------------------------
SELECT Titulo FROM Filme WHERE Ano = 2014
---SELECT * FROM Filme---

---- 2) FAZER UM SELECT QUE RETORNE O ID E O ANO DO FILME BIRDMAN-------------------------
SELECT ID, Ano FROM Filme WHERE Titulo = 'Birdman'
---SELECT * FROM Filme---

---- 3) FAZER UM SELECT QUE RETORNE O ID E O ANO DO FILME QUE CHAMA PLASH
SELECT ID, Ano FROM Filme WHERE Titulo = ' Plash'

---- 4) FAZER UM SELECT QUE RETORNE O ID, O NOME E O NOME_REAL DA ESTRELA CUJO NOME COMEÇA COM STEVE-----
SELECT ID, Nome, Nome_Real FROM Estrela WHERE Nome LIKE'Steve%'

---- 5) FAZER UM SELECT QUE RETORNE FILMEID E A DATA FABRICAÇÃO EM FORMATO (DD/MM/YYYY) (APELIDAR DE FAB) DOS FILMES FABRICADOS A PARTIR DE 01-01-2020---------------
SELECT Filme_ID, CONVERT(CHAR(10), Data_Fabricacao, 103) AS FAB FROM DVD
WHERE Data_Fabricacao >= '01-01-2020'

---- 6) FAZER SELECT QUE RETORNE DVDNUM, DATA LOCAÇÃO, DATA DEVOLUÇÃO, VALOR E VALOR COM MULTA DE ACRÉSCIMO DE 2.00 DA LOCAÇÃO DO CLIENTE 5505-----------------------
SELECT Cliente_Num_Cadastro, DVD_Num, Data_Locacao, Data_Devolucao,Valor + (2.00) AS Valor_Multa_Cliente FROM Locacao
WHERE Cliente_Num_Cadastro = 5505

---- 7) FAZER UM SELECT QUE RETORNE LOGRADOURO, NUM E CEP DE MATILDE LUZ
SELECT Logradouro, Num, CEP FROM Cliente
WHERE Nome = 'Matilde Luz'

---- 8) FAZER UM SELECT QUE RETORNE NOME REAL DE MICHAEL KEATON
SELECT Nome_Real FROM Estrela
WHERE Nome = 'Michael Keaton'

---- 9) FAZER UM SELECT QUE RETORNE O NUM CADASTRO, O NOME E O ENDEREÇO COMPLETO,
------- CONCATENADO (LOGRADOURO, NUMERO E CEP), APELIDO END_COMP, DOS CLIENTES CUJO ID É MAIOR OU IGUAL 5503

SELECT Num_Cadastro, Nome + ', ' + Logradouro + ', N° ' +CONVERT(VARCHAR(10), Num) + ',  CEP:  ' + CEP AS Endereco_Completo FROM Cliente
WHERE  Num_Cadastro >= 5503


----------------------------EX DDL DML SQL---------------------------------------------------------------------------------

/*
CREATE DATABASE Manutencao
GO
USE Manutencao

----------------------TABELA USERS-----------------------

--A PK DE USERS DEVE SER DE AUTO INCREMENTO, INICIANDO EM 1, COM INCREMENTO DE 1--
--O VALOR PADRÃO DA COLUNA PASSWORD DA TABELA USERS, DEVERÁ SER 123MUDAR--
--A COLUNA USERNAME DA TABELA USERS DEVE TER RESTRIÇÃO DE UNICIDADE--
--A PK DE USERS DEVE SER DE AUTO INCREMENTO, INICIANDO EM 1, COM INCREMENTO DE 1--

GO
CREATE TABLE Users (
ID					INT				IDENTITY (1, 1)			NOT NULL,
Name				VARCHAR(45)								NOT NULL,
Username			VARCHAR(45)								NOT NULL,
Password			VARCHAR(45)		DEFAULT ('123mudar')	NOT NULL,
Email				VARCHAR(45)								NOT NULL

PRIMARY KEY (ID)
)

-----------------------TABELA PROJECTS-------------------

-- A PK DE PROJECTS DEVE SER DE AUTO INCREMENTO, INICIANDO EM 10001, COM INCREMENTO DE 1--
GO
CREATE TABLE Projects (
ID					INT				IDENTITY (10001, 1)		NOT NULL,
Name				VARCHAR(45)								NOT NULL,
Description			VARCHAR(45)								NOT NULL,
Data				DATE									NOT NULL

PRIMARY KEY (ID)

)

---------------------TABELA USERS_HAS_PROJECTS------------

--A COLUNA USERS_ID DA TABELA ASSOCIATIVA É FK DA COLUNA ID, TABELA USERS--
--A COLUNA PROJECTS_ID DA TABELA ASSOCIATIVA É FK DA COLUNA ID, TABELA PROJECTS--

GO
CREATE TABLE Users_Has_Projects (
Users_ID			INT				NOT NULL,
Projects_ID			INT				NOT NULL

PRIMARY KEY (Users_ID, Projects_ID)
FOREIGN KEY (Users_ID) REFERENCES Users (ID),
FOREIGN KEY (Projects_ID) REFERENCES Projects (ID)
)

--A COLUNA DATE DA TABELA PROJECTS DEVE VERIFICAR SE A DATA É POSTERIOR QUE 01/09/2014.
--CASO CONTRÁRIO, O REGISTRO NÃO DEVE SER INSERIDO

GO
ALTER TABLE Projects
ADD		CHECK(Data > '01/09/2014')


--------------------------MODIFICAR A COLUNA USERNAME DA TABELA USERS PARA VARCHAR(10)---------
GO
ALTER TABLE Users
ALTER COLUMN Username			VARCHAR(10)		NOT NULL

GO
ALTER TABLE Users
ADD CONSTRAINT  AK_Username		UNIQUE(Username)

------------MODIFICAR A COLUNA PASSWORD DA TABELA Users PARA VARCHAR(8)---------
GO
ALTER TABLE Users
ALTER COLUMN Password			VARCHAR(8)		NOT NULL

GO
DBCC CHECKIDENT('Users', RESEED, 1)
--------------------INSERINDO DADOS NA TABELA USERS-----------------------------
GO
INSERT INTO Users (Name, Username, Email)
VALUES
('Maria','Rh_Maria', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', 'paulo@empresa.com'),
('Ana', 'Rh_Ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', 'aparecido@empresa.com')

------------------------ATUALIZANDO SENHAS--------------------
GO
UPDATE Users
SET Password = '123@456'
WHERE ID = 2

GO
UPDATE Users
SET Password = '55@!cido'
WHERE ID = 5

--------------------INSERINDO DADOS NA TABELA PROJECTS------------------------
ALTER TABLE Projects
ALTER COLUMN Description		VARCHAR(45)			NULL

GO
INSERT INTO Projects (Name, Description, Data)
VALUES
('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
('Manutenção PC´s', 'Manutenção PC´s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')

----------------INSERINDO DADOS NA TABELA USERS_HAS_PROJECTS---------------------------
GO
INSERT INTO Users_Has_Projects(Users_ID, Projects_ID)
VALUES 
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

----------------------CONSIDERAR AS SITUAÇÕES-----------------------------------

--O PROJETO DE MANUTENÇÃO ATRASOU, MUDAR A DATA PARA 12/09/2014--
GO
UPDATE Projects
SET Data = '12/09/2014'
WHERE Name LIKE 'Manutenção%'

--O USERNAME DE APARECIDO (USAR O NOME COMO CONDIÇÃO DE MUDANÇA) ESTÁ FEIO, MUDAR PARA RH_CIDO
GO
UPDATE Users
SET Username = 'Rh_cido'
WHERE Name = 'aparecido'
--MUDAR O PASSWORD DO USERNAME RH_MARIA (USAR O USERNAME COMO CONDIÇÃO DE MUDANÇA)
--PARA 888@*, MAS A CONDIÇÃO DEVE VERIFICAR SE O PASSWORD DELA AINDA É 123mudar
UPDATE Users
SET Password = '888@*'
WHERE Username = 'Rh_maria' AND Password = '123mudar'

--O USER DD ID 2 NÃO PARTICIPA MAIS DO PROJETO 10002, REMOVÊ-LO DA ASSOCIATIVA--
DELETE Users_Has_Projects
WHERE Users_ID = 2
SELECT * FROM Users_Has_Projects
*/