CREATE DATABASE Manutencao
GO
USE Manutencao

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