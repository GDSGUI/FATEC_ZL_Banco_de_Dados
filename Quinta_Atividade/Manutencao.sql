CREATE DATABASE Manutencao_Parte04
GO
USE Manutencao_Parte04

----------------------TABELA USERS-----------------------

--A PK DE USERS DEVE SER DE AUTO INCREMENTO, INICIANDO EM 1, COM INCREMENTO DE 1--
--O VALOR PADR�O DA COLUNA PASSWORD DA TABELA USERS, DEVER� SER 123MUDAR--
--A COLUNA USERNAME DA TABELA USERS DEVE TER RESTRI��O DE UNICIDADE--
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

--A COLUNA USERS_ID DA TABELA ASSOCIATIVA � FK DA COLUNA ID, TABELA USERS--
--A COLUNA PROJECTS_ID DA TABELA ASSOCIATIVA � FK DA COLUNA ID, TABELA PROJECTS--

GO
CREATE TABLE Users_Has_Projects (
Users_ID			INT				NOT NULL,
Projects_ID			INT				NOT NULL

PRIMARY KEY (Users_ID, Projects_ID)
FOREIGN KEY (Users_ID) REFERENCES Users (ID),
FOREIGN KEY (Projects_ID) REFERENCES Projects (ID)
)

--A COLUNA DATE DA TABELA PROJECTS DEVE VERIFICAR SE A DATA � POSTERIOR QUE 01/09/2014.
--CASO CONTR�RIO, O REGISTRO N�O DEVE SER INSERIDO

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
('Re-folha', 'Refatora��o das Folhas', '05/09/2014'),
('Manuten��o PC�s', 'Manuten��o PC�s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')


insert into projects (name, description, data) values
('Re-folha', 'Refatora��o das Folhas', '05/09/2014'),
('Manuten��o PC�s', 'Manuten��o PC�s', '06/09/2014'),
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

----------------------CONSIDERAR AS SITUA��ES-----------------------------------

--O PROJETO DE MANUTEN��O ATRASOU, MUDAR A DATA PARA 12/09/2014--
GO
UPDATE Projects
SET Data = '12/09/2014'
WHERE Name LIKE 'Manuten��o%'

--O USERNAME DE APARECIDO (USAR O NOME COMO CONDI��O DE MUDAN�A) EST� FEIO, MUDAR PARA RH_CIDO
GO
UPDATE Users
SET Username = 'Rh_cido'
WHERE Name = 'aparecido'
--MUDAR O PASSWORD DO USERNAME RH_MARIA (USAR O USERNAME COMO CONDI��O DE MUDAN�A)
--PARA 888@*, MAS A CONDI��O DEVE VERIFICAR SE O PASSWORD DELA AINDA � 123mudar
UPDATE Users
SET Password = '888@*'
WHERE Username = 'Rh_maria' AND Password = '123mudar'

--O USER DD ID 2 N�O PARTICIPA MAIS DO PROJETO 10002, REMOV�-LO DA ASSOCIATIVA--
DELETE Users_Has_Projects
WHERE Users_ID = 2
SELECT * FROM Users_Has_Projects

--------------------------------------CONSULTAR---------------------------------------
--1) FAZER UMA CONSULTA QUE RETORNE ID, NOME, EMAIL, USERNAME E CASO A SENHA SEJA DIFERENTE DE 123mudar, MOSTRAR********(8 ASTERISCOS),
-- CASO CONTR�RIO, MOSTRAR A PR�PRIA SENHA.
SELECT ID, Name, Email, Username,
	CASE WHEN Password = '123mudar'
		THEN Password
	ELSE
		'********'
END AS Password
FROM Users

--2) CONSIDERANDO QUE O PROJETO 10001 DUROU 15 DIAS, FAZER UMA CONSULTA QUE MOSTRE
--O NOME DO PROJETO, DESCRI��O, DATA, DATA_FINAL DO PROJETO REALIZADO POR USU�RIO DE E-MAIL
--aparecido@empresa.com

SELECT Name,Description,
CONVERT(CHAR(10),Data, 103) AS Data,
CONVERT(CHAR(10), DATEADD(DAY, 15, Data), 103) AS Data_Final
FROM Projects

WHERE ID IN
(SELECT Projects_ID FROM Users_Has_Projects
WHERE Users_ID IN

(SELECT ID
FROM Users
WHERE Email = 'aparecido@empresa.com')
)

--3) FAZER UMA CONSULTA QUE RETORNE O NOME E O EMAIL DOS USU�RIOS QUE EST�O ENVOLVIDOS NO PROJETO DE NOME AUDITORIA
SELECT Name, Email
FROM Users

WHERE ID IN
(SELECT Users_ID FROM Users_Has_Projects
WHERE Projects_ID IN

(SELECT ID FROM Projects
WHERE Name = 'Auditoria')
)

--4) CONSIDERANDO QUE O CUSTO DIARIO DO PROJETO, CUJO NOME TEM O TERMO MANUTEN��O, � DE 79.85 E ELE DEVE FINALIZAR 16/09/2014,
--   CONSULTAR, NOME, DESCRI��O, DATA, DATA_FINAL E CUSTO_TOTAL DO PROJETO
SELECT Name, Description, 
CONVERT(CHAR(10),Data, 103) AS Data_Inicial,
CONVERT(CHAR(10),'16/09/2014', 103) AS Data_Final, 79.85 AS Custo_Diario,
DATEDIFF(DAY, Data, '16/09/2014') AS Dias_Manuten��o,
DATEDIFF(DAY, Data, '2014-09-16') * 79.85 AS Custo_Total_Projeto
FROM Projects

WHERE Name LIKE 'Manuten��o%'

------------------------------------FAZER----------------------------------------------------------------
--A) ADICIONAR USER (6; JOAO; TI_JOAO; 123mudar; JOAO@EMPRESA.COM)
INSERT INTO Users (Name, Username, Password, Email)
VALUES
('Joao', 'TI_Joao', '123mudar', 'Joao@Empresa.com')

--B) ADICIONAR PROJECT (10004; ATUALIZA��O DE SISTEMAS; MODICA��O DE SISTEMAS OPERACIONAIS NOS PC'S; 12/09/2014)
INSERT INTO Projects (Name, Description, Data)
VALUES
('Atualiza��o de sistemas', 'Modifica��o de sistemas operacionais nos PC`S', '12/09/2014')

-----------------------------------------C) CONSULTAR-----------------------------------------------------------------------
--1) ID, NAME E EMAIL DE USERS, ID, NAME, DESCRIPTION E DATA DE PROJECTS, DOS USUARIOS QUE PARTICIPARAM DO PROJETO NAME RE-FOLHA
SELECT DISTINCT Users.ID, Users.Name, Users.Email,
Projects.ID, Projects.Name, Projects.Description, Projects.Data

FROM Users, Projects, Users_Has_Projects

WHERE Users_ID = Users_Has_Projects.Users_ID
AND Projects.Name LIKE 'Re-folha%'

--2) NAME DOS PROJECTS QUE N�O TEM USERS
SELECT DISTINCT Projects.Name
FROM Projects LEFT OUTER JOIN Users_Has_Projects
ON Projects.ID = Users_Has_Projects.Projects_ID
WHERE Users_Has_Projects.Users_ID IS NULL

--3) NAME DOS USERS QUE N�O TEM PROJECTS
SELECT DISTINCT Users.Name
FROM Users LEFT OUTER JOIN Users_Has_Projects
ON Users.ID = Users_Has_Projects.Users_ID
WHERE Users_Has_Projects.Projects_ID IS NULL

-------------------------C) CONSULTAR----------------------------
--Quantos projetos n�o tem usu�rios associados a ele.
--A coluna de chamar qty_projects_no_users

SELECT COUNT(PRJ.ID) AS Qtd_Projects_no_Users
FROM Projects PRJ LEFT OUTER JOIN Users_Has_Projects UHP
ON PRJ.ID = UHP.Projects_ID
WHERE UHP.Users_ID IS NULL

--Id do projeto, nome do projeto, qty_users_project (quantidade de usu�rios por
--projeto) em ordem alfab�tica crescente pelo nome do projeto
SELECT PRJ.ID, PRJ.Name,
COUNT(US.ID) AS Qtd_Users_Project
FROM Projects PRJ, Users US, Users_Has_Projects UHP
WHERE PRJ.ID = UHP.Projects_ID
	AND US.ID = UHP.Users_ID
GROUP BY PRJ.ID, PRJ.Name