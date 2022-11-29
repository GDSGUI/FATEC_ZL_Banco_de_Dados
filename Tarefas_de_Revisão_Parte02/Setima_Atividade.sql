CREATE DATABASE viagens
GO

USE viagens
GO

CREATE TABLE motorista (
codigo                 INT                NOT NULL,
nome                   VARCHAR(30)        NOT NULL,
data_nascimento        DATE               NOT NULL,
naturalidade           VARCHAR(30)        NOT NULL
PRIMARY KEY(codigo)
)
GO

CREATE TABLE onibus (
placa                  VARCHAR(8)         NOT NULL,
marca                  VARCHAR(20)        NOT NULL,
ano                    INT                NOT NULL,
descricao              VARCHAR(30)        NOT NULL
PRIMARY KEY(placa)
)
GO

CREATE TABLE viagem (
codigo                 INT                NOT NULL,
onibus_placa           VARCHAR(8)         NOT NULL, 
motorista_codigo       INT                NOT NULL,
hora_de_saida          TIME               NOT NULL,
hora_de_chegada        TIME               NOT NULL,
destino                VARCHAR(30)        NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(onibus_placa) REFERENCES onibus(placa),
FOREIGN KEY(motorista_codigo)  REFERENCES motorista(codigo)     
)
GO


INSERT INTO motorista (codigo, nome, data_nascimento, naturalidade)
VALUES                (12341, 'Julio Cesar', '1978-04-18', 'S�o Paulo')
GO

INSERT INTO motorista (codigo, nome, data_nascimento, naturalidade)
VALUES                (12342, 'Mario Carmo', '2002-07-29', 'Americana')
GO

INSERT INTO motorista (codigo, nome, data_nascimento, naturalidade)
VALUES                (12343, 'Lucio Castro', '1969-12-01', 'Campinas')
GO

INSERT INTO motorista (codigo, nome, data_nascimento, naturalidade)
VALUES                (12344, 'Andr� Figueiredo', '1999-05-14', 'S�o Paulo')
GO

INSERT INTO motorista (codigo, nome, data_nascimento, naturalidade)
VALUES                (12345, 'Luiz Carlos', '2001-01-09', 'S�o Paulo')
GO


INSERT INTO onibus (placa, marca, ano, descricao)
VALUES             ('adf0965', 'Mercedes', 1999, 'Leito')
GO

INSERT INTO onibus (placa, marca, ano, descricao)
VALUES             ('bhg7654', 'Mercedes', 2002, 'Sem Banheiro')
GO

INSERT INTO onibus (placa, marca, ano, descricao)
VALUES             ('dtr2093', 'Mercedes', 2001, 'Ar Condicionado')
GO

INSERT INTO onibus (placa, marca, ano, descricao)
VALUES             ('gui7625', 'Volvo', 2001, 'Ar Condicionado')
GO


INSERT INTO viagem (codigo, onibus_placa, motorista_codigo, hora_de_saida, hora_de_chegada, destino)
VALUES             (101, 'adf0965', 12343, '10:00', '12:00', 'Campinas')
GO

INSERT INTO viagem (codigo, onibus_placa, motorista_codigo, hora_de_saida, hora_de_chegada, destino)
VALUES             (102, 'gui7625', 12341, '7:00', '12:00', 'Araraquara')
GO

INSERT INTO viagem (codigo, onibus_placa, motorista_codigo, hora_de_saida, hora_de_chegada, destino)
VALUES             (103, 'bhg7654', 12345, '14:00', '22:00', 'Rio de Janeiro')
GO

INSERT INTO viagem (codigo, onibus_placa, motorista_codigo, hora_de_saida, hora_de_chegada, destino)
VALUES             (104, 'dtr2093', 12344, '18:00', '21:00', 'Sorocaba')
GO



--1) Consultar, da tabela viagem, todas as horas de chegada e sa�da, 
-- convertidas em formato HH:mm (108) e seus destinos

SELECT CONVERT(CHAR(5), hora_de_saida, 108) AS hora_de_saida,
       CONVERT(CHAR(5), hora_de_chegada, 108) AS hora_de_chegada,
	   destino
FROM viagem
GO


--2) Consultar, com subquery, o nome do motorista que viaja para Sorocaba 

SELECT nome
FROM motorista
WHERE codigo IN (
                SELECT motorista_codigo
				FROM viagem
				WHERE destino = 'Sorocaba'
				)
GO


--3) Consultar, com subquery, a descri��o do �nibus que vai para o Rio de Janeiro

SELECT descricao
FROM onibus
WHERE placa IN (
               SELECT onibus_placa
			   FROM viagem 
			   WHERE destino LIKE 'Rio de Jan%'
			   )
GO


--4) Consultar, com Subquery, a descri��o, a marca e o ano do �nibus 
-- dirigido por Luiz Carlos

SELECT descricao, 
       marca,
	   ano
FROM onibus
WHERE placa IN (
               SELECT onibus_placa
			   FROM viagem
			   WHERE motorista_codigo IN (
			                             SELECT codigo 
										 FROM motorista
										 WHERE nome = 'Luiz Carlos'
										 )
			   )
GO


--5) Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos 

SELECT nome,
       DATEDIFF(YEAR, data_nascimento, GETDATE()) AS idade,
	   naturalidade
	  
FROM motorista
GROUP BY nome, data_nascimento, naturalidade
HAVING AVG(DATEDIFF(YEAR, data_nascimento, GETDATE())) > 30
GO


SELECT * FROM viagem
SELECT * FROM onibus
SELECT * FROM motorista
