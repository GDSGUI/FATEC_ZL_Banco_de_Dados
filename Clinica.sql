--DBA: Guilherme Gomes
--Data: 14/10/2022


CREATE DATABASE Clinica
GO
USE Clinica

-------------------TABELA PACIENTE----------------------
CREATE TABLE Paciente (
Num_Beneficiario							INT					NOT NULL,
Nome										VARCHAR (200)		NOT NULL,
Logradouro									VARCHAR (200)		NOT NULL,
Numero										INT					NOT NULL,
CEP											CHAR (8)			NULL,
Complemento									VARCHAR (200)		NOT NULL,
Telefone									VARCHAR (11)		NOT NULL

PRIMARY KEY (Num_Beneficiario)
)
GO
---------------------INSERIR DADOS NA TABELA PACIENTE---------------------------------------
INSERT INTO Paciente (Num_Beneficiario, Nome, Logradouro, Numero, CEP, Complemento, Telefone)
VALUES
(99901, 'Washington Silva', 'R. Anhaia', 150, 02345000, 'Casa', 922229999),
(99902, 'Luiz Ricardo', 'R. Voluntários da Pátria', 2251, 03254010, 'Bloco B.Apto 25', 923450987),
(99903,	'Maria Elisa', 'Av. Aguia de Haia', 1188, 06987020, 'Apto 1208', 912348765),
(99904, 'José Araujo', 'R. XV de Novembro', 18, 03678000, 'Casa', 945674312),
(99905, 'Joana Paula', 'R. 7 de Abril', 97, 01214000, 'Conjunto 3 - Apto 801', 912095674)

SELECT * FROM Paciente

-------------------------------------TABELA ESPECIALIDADE------------------------------------------------

CREATE TABLE Especialidade (
ID					INT				NOT NULL,
Especialidade		VARCHAR (200)	NOT NULL

PRIMARY KEY (ID)
)
GO
----------------INSERINDO DADOS NA TABELA ESPECIALIDADE----------------------------------
INSERT INTO Especialidade
VALUES
(1, 'Otorrinolaringologista'),
(2, 'Urologista'),
(3, 'Geriatra'),
(4,	'Pediatra')

SELECT * FROM Especialidade

-----------------------------------TABELA MEDICO---------------------------------------------------------

CREATE TABLE Medico (
Codigo							INT						NOT NULL,
Nome							VARCHAR (200)			NOT NULL,
Logradouro						VARCHAR (200)			NOT NULL,
Numero							INT						NOT NULL,
CEP								CHAR (8)				NULL,
Complemento						VARCHAR (200)			NOT NULL,
Contato							VARCHAR (11)			NOT NULL,
Especialidade_ID				INT						NOT NULL

PRIMARY KEY (Codigo)
FOREIGN KEY (Especialidade_ID)
		REFERENCES Especialidade (ID)
)

-------------------INSERINDO DADOS NA TABELA MEDICO---------------------------------
INSERT INTO Medico (Codigo, Nome, Logradouro, Numero, CEP, Complemento, Contato, Especialidade_ID)
VALUES
(100001, 'Ana Paula', 'R. 7 de Setembro', 256, 03698000, 'Casa', 915689456, 1),
(100002, 'Maria Aparecida', 'Av. Brasil', 32, 02145070, 'Casa', 923235454, 1),
(100003, 'Lucas Braga', 'Av. do Estado', 3210, 05241000, 'Apto 205', 963698585, 2),
(100004, 'Gabriel Oliveira', 'Av. Dom Helder Camara', 350, 03145000, 'Apto 602', 932458745, 3)

SELECT * FROM Medico

---------------------------TABELA CONSULTA-------------------------------------------
CREATE TABLE Consulta (
PacienteNum_Beneficiario							INT						NOT NULL,
Medico_Codigo										INT						NOT NULL,
Data_Hora											DATETIME				NOT NULL,
Observacao											VARCHAR (200)			NOT NULL

PRIMARY KEY (PacienteNum_Beneficiario, Medico_Codigo)
FOREIGN KEY (PacienteNum_Beneficiario)
		REFERENCES Paciente (Num_Beneficiario),
FOREIGN KEY (Medico_Codigo)
		REFERENCES Medico (Codigo)
)
GO

-----------------INSERINDO DADOS NA TABELA CONSULTA-------------------------------------------
INSERT INTO Consulta (PacienteNum_Beneficiario, Medico_Codigo, Data_Hora, Observacao)
VALUES
(99901, 100002, '2021-09-04 13:20', 'Infecção Urina'),
(99902, 100003, '2021-09-04 13:15',	'Gripe'),
(99901, 100001, '2021-09-04 12:20', 'Ingecção Garganta')

------------------------------ADICIONANDO A TABELA DIA ATENDIMENTO----------------------------
ALTER TABLE Medico
ADD Dia_Atendimento			VARCHAR (100)		NULL

------------------------------DIAS DA SEMANA DE ATENDIMENTO---------------------------------
UPDATE Medico
SET Dia_Atendimento = '2° feira'
WHERE codigo = 100001
--------------------------------------
UPDATE Medico 
SET Dia_Atendimento = '4° feira'
WHERE codigo = 100002
---------------------------------------
UPDATE Medico
SET Dia_Atendimento = '2° feira'
WHERE codigo = 100003
----------------------------------------
UPDATE Medico
SET Dia_Atendimento = '5° feira'
WHERE codigo = 100004

select * from Medico

---------------A ESPECIALIDADE PEDIATRA NÃO ESTÁ MAIS DISPONIVEL, EXCLUIR--------------------
DELETE Especialidade
WHERE ID = 4

SELECT * FROM Especialidade
----------------------------------------------------------------------------------------------

ALTER TABLE Medico
ALTER COLUMN Dia_Atendimento VARCHAR(200) NOT NULL

------------------RENOMEAR A COLUNA DIA_ATENDIMENTO PARA DIA_SEMANA_ATENDIMENTO---------------------
EXEC sp_rename 'dbo.Medico.Dia_Atendimento', 'Dia_Semana_Atendimento', 'column';
select * from Medico

-------------------------------------------------------------------------------------------------

------ATUALIZAR OS DADOS DO MÉDICO LUCAS BORGES QUE PASSOU A RESIDIR À AV. BRAS LEME, N°. 876, APTO 504, CEP 02122000

UPDATE Medico
SET Logradouro = 'Av. Bras Leme'
WHERE codigo = 100003
---------------------------------
UPDATE Medico
SET Numero = 876
WHERE codigo = 100003
---------------------------------
UPDATE Medico
SET CEP = 02122000
WHERE codigo = 100003
---------------------------------
UPDATE Medico
SET Complemento = 'Apto 504'
WHERE codigo = 100003

SELECT * FROM Medico
