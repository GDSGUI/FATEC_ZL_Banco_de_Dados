CREATE DATABASE Terceira_Atividade
GO
USE Terceira_Atividade

CREATE Table Pacientes (
CPF				CHAR (11)		NOT NULL,
Nome			VARCHAR (50)	NOT NULL,
Rua				VARCHAR (50)	NOT NULL,
Numero			INT				NOT NULL,
Bairro			VARCHAR (20)	NOT NULL,
Telefone		INT				NULL,
Data_Nasc		Date			NOT NULL

PRIMARY KEY (CPF)
)

GO
CREATE TABLE Medico (
Codigo			INT				NOT NULL,
Nome			VARCHAR (50)	NOT NULL,
Especialidade	VARCHAR (50)	NOT NULL

PRIMARY KEY (Codigo)
)
GO
CREATE TABLE Prontuario (
Data					DATE				NOT NULL,
CPF_Paciente			CHAR (11)			NOT NULL,
Codigo_Medico			INT					NOT NULL,
Diagnostico				VARCHAR (50)		NOT NULL,
Medicamento				VARCHAR (50)		NOT NULL

PRIMARY KEY (Data, CPF_Paciente, Codigo_Medico)
FOREIGN KEY (CPF_Paciente)
			REFERENCES Pacientes (CPF),
FOREIGN KEY (Codigo_Medico)
			REFERENCES Medico (Codigo)
)

GO
----Inserindo Valores para a Tabela de Pacientes
INSERT INTO Pacientes (CPF, Nome, Rua, Numero, Bairro, Telefone, Data_Nasc)
VALUES
(35454562890, 'Jos� Rubens', 'Campos Salles', 2750, 'Centro', 21450998, '1954-10-18'),
(29865439810, 'Ana Clara', 'Sete de Setembro', 178, 'Centro', 97382764, '1960-05-29'),
(82176534800, 'Marcos Aur�lio', 'Tim�teo Penteado', 236, 'Vila Galv�o', 68172651, '1980-09-24'),
(12386758770, 'Maria Rita', 'Castello Branco', 7765, 'Vila Ros�lia', NULL, '1975-03-30'),
(92173458910, 'Joana de Souza', 'XV de Novembro', 289, 'Centro', 21276579, '1944-04-24')

GO
--Inserindo Dados na tabela M�dico
INSERT INTO Medico (Codigo, Nome, Especialidade)
VALUES
(1, 'Wilson', 'Pediatra'),
(2, 'Marcia Matos', 'Geriatra'),
(3, 'Carolina Oliveira', 'Ortopedista'),
(4, 'Vinicius Araujo', 'Cl�nico Geral')

GO
--Inserindo dados na tabela Prontu�rio
INSERT INTO Prontuario (Data, CPF_Paciente, Codigo_Medico, Diagnostico, Medicamento)
VALUES
('2020-09-10', 35454562890, 2, 'Reumatismo', 'Celebra'),
('2020-09-10', 92173458910, 2, 'Renite Al�rgica', 'Allegra'),
('2020-09-12', 29865439810, 1, 'Inflama��o de garganta', 'Nimesulida'),
('2020-09-13', 35454562890, 2, 'H1N1', 'Tamiflu'),
('2020-09-15', 82176534800, 4, 'Gripe', 'Resprin'),
('2020-09-15', 12386758770, 3, 'Bra�o Quebrado', 'Dorflex + Gesso')

-----------------------------Consultar-------------------------------------
--Nome e Endere�o (concatenado) dos pacientes com mais de 50 anos
SELECT PC.Nome, 'Rua: ' + PC.Rua + ', N� ' + CAST (PC.Numero AS VARCHAR(10)) + ' , Bairro: ' + PC.Bairro AS Endere�o, PC.Data_Nasc

FROM Pacientes PC

WHERE (DATEDIFF (YEAR, CAST(PC.Data_Nasc AS VARCHAR(4)), GETDATE ()) > 50)

--Qual a especialidade de Carolina Oliveira
SELECT MD.Nome, MD.Especialidade
FROM Medico MD

WHERE MD.Nome LIKE 'Carolina%'

--Qual medicamento receitado para reumatismo
SELECT PR.Diagnostico, PR.Medicamento
FROM Prontuario PR

WHERE PR.Diagnostico LIKE 'Reuma%'

--------------------------Consultar Subqueries
--Diagn�stico e Medicamento do paciente Jos� Rubens em suas consultas
--Nome e especialidade do(s) M�dico(s) que atenderam Jos� Rubens.
--Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
SELECT MD.Nome, SUBSTRING (MD.Especialidade, 1,3) + '.' AS Especialidade
FROM Medico MD

WHERE Codigo IN (
SELECT Codigo FROM Prontuario
						WHERE CPF_Paciente IN(	
											SELECT CPF FROM Pacientes
																WHERE Nome = 'Jos� Rubens')
																)
--CPF (Com a m�scara XXX.XXX.XXX-XX), Nome, Endere�o completo (Rua, n� - Bairro), Telefone (Caso nulo, mostrar um tra�o (-)) dos pacientes do m�dico Vinicius
SELECT SUBSTRING (CPF, 1, 3) + '.' + SUBSTRING (CPF, 4,3) + ',' + SUBSTRING (CPF, 7, 3) + '-' + SUBSTRING (CPF, 10, 2) AS CPF,
Nome, 'Rua: ' + Rua + ', N� ' + CAST (Numero AS VARCHAR(10)) + ' , Bairro: ' + Bairro AS Endere�o,
	CASE WHEN Telefone IS NULL
		THEN '-'
			ELSE Telefone
		END AS telefone

FROM Pacientes
WHERE CPF IN (
			SELECT CPF_Paciente
							FROM Prontuario
										WHERE Codigo_Medico IN (
														SELECT Codigo
																FROM Medico
																WHERE Nome LIKE 'Vinicius%'
																)
													)
--Quantos dias fazem da consulta de Maria Rita at� hoje
SELECT DATEDIFF(DAY, Data, GETDATE()) AS Dias_Pos_Consulta
FROM Prontuario
WHERE CPF_Paciente IN (
			SELECT CPF
				FROM Pacientes
				WHERE Nome = 'Maria Rita'
				)
--Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE Pacientes
SET Telefone = '98345621'
WHERE Nome = 'Maria Rita'
--Alterar o Endere�o de Joana de Souza para Volunt�rios da P�tria, 1980, Jd. Aeroporto
UPDATE Pacientes
SET Rua = 'Voluntarios da Patria',
    Numero = 1980,
	bairro = 'Jd. Aeroporto' 
WHERE nome = 'Joana de Souza'
