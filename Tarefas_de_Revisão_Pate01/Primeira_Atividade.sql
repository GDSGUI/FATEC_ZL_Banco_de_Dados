CREATE DATABASE Primeira_Atividade

GO
USE Primeira_Atividade

GO
CREATE TABLE Aluno
(
RA					CHAR (8)			NOT NULL,
Nome				VARCHAR (50)		NOT NULL,
Sobrenome			VARCHAR (50)		NOT NULL,
Rua					VARCHAR (200)		NOT NULL,
Numero				INT					NOT NULL,
Bairro				VARCHAR (30)		NOT NULL,
CEP					CHAR (8)			NULL,
Telefone			NUMERIC				NULL

PRIMARY KEY (RA)
)
GO

CREATE TABLE Cursos
(
Codigo				INT		IDENTITY (1,1)	NOT NULL,
Nome				VARCHAR (30)			NOT NULL,
Carga_Horaria		INT						NOT NULL,
Turno				VARCHAR (20)			NOT NULL

PRIMARY KEY (Codigo)
)

GO
CREATE TABLE Disciplinas
(
Codigo				INT	IDENTITY (1,1)	NOT NULL,
Nome				VARCHAR (30)		NOT NULL,
Carga_Horaria		INT					NOT NULL,
Turno				VARCHAR (20)		NOT NULL,
Semestre			INT					NOT NULL

PRIMARY KEY (Codigo)
)


INSERT INTO Aluno (RA, Nome, Sobrenome, Rua, Numero, Bairro, CEP, Telefone)
VALUES
(12345, 'José', 'Silva', 'Almirante Noronha', 236, 'Jardim São Paulo', 1589000, 69875287),
(12346, 'Ana', 'Maria Bastos', 'Anhaia', 1568, 'Barra Funda', 3569000, 25698526),
(12347,	'Mario', 'Santos', 'XV de Novembro', 1841, 'Centro', 1020030, NULL),
(12348, 'Marcia', 'Neves', 'Voluntários da Patria', 225, 'Santana', 2785090, 78964152)

GO

INSERT INTO Cursos (Nome, Carga_Horaria, Turno)
VALUES
('Informática', 2800, 'Tarde'),
('Informática', 2800, 'Noite'),
('Logistica' ,2650, 'Tarde'),
('Logistica' ,2650, 'Noite'),
('Plásticos' ,2500, 'Tarde'),
('Plásticos' ,2500, 'Tarde')

GO
INSERT INTO Disciplinas (Nome, Carga_Horaria, Turno, Semestre)
VALUES
('Informática', 4, 'Tarde', 1),
('Informática', 4, 'Noite', 1),
('Quimica', 4, 'Tarde', 1),
('Quimica', 4, 'Noite', 1),
('Banco de Dados |', 2, 'Tarde', 3),
('Banco de Dados |', 2,	'Noite', 3),
('Estrutura de Dados', 4, 'Tarde', 4),
('Estrutura de Dados', 4, 'Noite', 4)

------------------------Consultar----------------------------------------
--Nome e Sobrenome, como completo dos alunos matriculados
SELECT Nome + ' ' + Sobrenome AS Nome_Completo
FROM Aluno

--Rua, N°, Bairro e CEP como Endereço do aluno que não tem telefone
SELECT 'Rua ' + Rua + ', N° ' + CAST (Numero AS VARCHAR (10)) + ', Bairro: ' + Bairro+ ', CEP:' + CEP
FROM Aluno
WHERE Aluno.Telefone IS NULL

--Telefone do Aluno com RA 12348
SELECT Nome , Telefone
FROM Aluno

WHERE RA = 12348

SELECT * FROM Aluno

--Nome e Turno dos Curso com 2800 horas
SELECT Nome, Turno
FROM Cursos

WHERE Carga_Horaria = 2800

--O Semestre do curso de Banco de Dados l Noite
SELECT Nome, Turno
FROM Disciplinas

WHERE Nome LIKE 'Banco%'
AND Disciplinas.Turno LIKE 'Noite'