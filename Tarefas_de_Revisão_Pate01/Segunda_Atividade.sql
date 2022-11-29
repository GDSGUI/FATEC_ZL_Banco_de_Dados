CREATE DATABASE Segunda_Atividade

GO

USE Segunda_Atividade
GO
CREATE TABLE Carro (
Placa				VARCHAR (15)				NOT NULL,
Marca				VARCHAR (10)				NOT NULL,
Modelo				VARCHAR (20)				NOT NULL,
Cor					VARCHAR (30)				NOT NULL,
Ano					INT							NOT NULL

PRIMARY KEY (Placa)
)

GO
CREATE TABLE Cliente (
Nome				VARCHAR (50)				NOT NULL,
Logradouro			VARCHAR (200)				NOT NULL,
Numero				INT							NOT NULL,
Bairro				VARCHAR (30)				NOT NULL,
Telefone			INT							NOT NULL,
Carro_Cliente		VARCHAR (15)				NOT NULL

PRIMARY KEY (Carro_Cliente),
FOREIGN KEY (Carro_Cliente)
		REFERENCES Carro (Placa)
)

GO
CREATE TABLE Pecas (
Codigo				INT		IDENTITY (1, 1)		NOT NULL,
Nome				VARCHAR (50)				NOT NULL,
Valor				INT							NOT NULL

PRIMARY KEY (Codigo)
)

GO
CREATE TABLE Servico (
Carro_Servico		VARCHAR (15)				NOT NULL,
Peca				INT							NOT NULL,
Quantidade			INT							NOT NULL,
Valor				INT							NOT NULL,
Data				DATE						NOT NULL

PRIMARY KEY (Carro_Servico, Peca, Data),

FOREIGN KEY (Carro_Servico)
	REFERENCES Carro (Placa) ,
)

-------------------------DADOS DO CARRO------------------------------
GO
INSERT INTO Carro (Placa, Marca, Modelo, Cor, Ano)
VALUES
('AFT9087', 'VW', 'Gol', 'Preto', 2007),
('DXO9876', 'Ford', 'Ka', 'Azul', 2000),
('EGT4631', 'Renault', 'Clio', 'Verde', 2004),
('LKM7380', 'Fiat', 'Palio', 'Prata', 1997),
('BCD7521', 'Ford', 'Fiesta', 'Preto', 1999)

-------------------------DADOS DO CLIENTE-------------------------------
GO
INSERT INTO Cliente (Nome, Logradouro, Numero, Bairro, Telefone, Carro_Cliente)
VALUES
('João Alves', 'R. Pereira Barreto', 1258, 'jd. Oliveiras', 21549658, 'DXO9876'),
('Ana Maria', 'R. 7 de Setembro', 259, 'Centro', 96588541, 'LKM7380'),
('Clara Oliveira', 'Av. Nações Unidas', 10254, 'Pinheiros', 24589658, 'EGT4631'),
('José Simões', 'R.XV de Novembro', 36, 'Água Branca', 78952459, 'BCD7521'),
('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', 69582549, 'AFT9087')

--------------------------DADOS DA PEÇA----------------------------------
GO
INSERT INTO Pecas (Nome, Valor)
VALUES
('Vela', 70),
('Correia Dentada', 125),
('Trambulador', 90),
('Filtro de Ar', 30)

-----------------------------DADOS DO SERVIÇO-------------------------------
GO
INSERT INTO Servico (Carro_Servico, Peca, Quantidade, Valor, Data)
VALUES
('DXO9876', 1, 4, 280, '01/08/2020'),
('DXO9876', 4, 1, 30, '01/08/2020'),
('EGT4631', 3, 1, 90, '02/08/2020'),
('DXO9876', 2, 1, 125, '07/08/2020')

-------------------------Consultar em SUBQUERIES-----------------------------
--Telefone do dono do carro Ka, Azul
GO
SELECT Telefone
FROM Cliente

WHERE Cliente.Carro_Cliente IN
(SELECT Placa from Carro WHERE Cor LIKE 'Azul' AND Cor LIKE 'Azul')

--Endereço concatenado do cliente que fez o serviço do dia 02/08/2009
GO
SELECT logradouro +', Nº'+CAST(numero AS VARCHAR(5))+ ', ' + bairro AS Endereço
FROM cliente
WHERE Carro_Cliente IN (
SELECT placa FROM carro
					WHERE placa IN (
SELECT Carro_Servico FROM Servico
					WHERE data = '02/08/2020')
							 )
---------------------------------CONSULTAR-----------------------------------------
--Placas dos carros de anos anteriores a 2001
GO
SELECT Placa
FROM Carro

WHERE Ano < 2001

--Marca, modelo e cor, concatenado dos carros posteriores a 2005
SELECT 'MARCA: ' + Marca + ', MODELO: ' + Modelo + ', COR: ' + Cor AS Carros_Pos_2005
FROM Carro

WHERE Carro.Ano > 2005

select * From Carro

--Código e nome das peças que custam menos de R$80,00

SELECT Codigo, Nome
FROM Pecas

WHERE Valor < 80