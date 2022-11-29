CREATE DATABASE Revisao_Primeira_Vez
GO
USE Revisao_Primeira_Vez
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marília Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matemática da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciências da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Física I',26,68.00,4,104),
(10005,'Geometria Analítica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Física III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

--1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.
SELECT DISTINCT ET.nome AS Nome_Livro, ET.valor AS Valor_Livro, ED.nome AS Nome_Editora, AT.nome AS Nome_Editora
FROM autor AT, editora ED, estoque ET, compra CP
WHERE	ET.codigo = CP.codEstoque
AND		ED.codigo = ET.codEditora
AND		AT.codigo = ET.codAutor

--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT DISTINCT		ET.nome, CP.qtdComprada, CP.valor
FROM		estoque ET, compra CP

WHERE ET.codigo = CP.codEstoque
AND CP.codigo = 15051
--3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).
SELECT	EDI.nome,

CASE WHEN (LEN(EDI.nome) > 10 )
		THEN
			RTRIM(SUBSTRING(EDI.site, 5, LEN(EDI.site)))
			ELSE
			EDI.site
		END AS Site
FROM	estoque ET, editora EDI
WHERE ET.codEditora = EDI.codigo
AND		EDI.nome LIKE 'Makron books'

--4) Consultar nome do livro e Breve Biografia do David Halliday	
SELECT ET.nome, AT.biografia
FROM estoque ET, autor AT

WHERE ET.codAutor = AT.codigo
AND AT.nome LIKE 'David Halliday'

--5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT CP.codigo, CP.qtdComprada
FROM compra CP, estoque ET

WHERE CP.codEstoque = ET.codigo
AND		ET.nome LIKE 'Sistemas%'

SELECT * FROM compra
WHERE codigo = 15053

--6) Consultar quais livros não foram vendidos
SELECT * FROM
editora ET LEFT JOIN compra CP
ON ET.codigo = CP.codEstoque
AND ET.nome IS NULL

--7) Consultar quais livros foram vendidos e não estão cadastrados
SELECT ET.nome
FROM estoque ET RIGHT OUTER JOIN compra CP
ON ET.codigo = CP.codEstoque
AND		ET.nome IS NULL

--8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT ET.nome, EDI.site,
CASE WHEN (LEN(EDI.site) > 10)
		THEN
			RTRIM(SUBSTRING(EDI.site,5, LEN(EDI.site)))
		ELSE
			EDI.site
END AS Site
FROM estoque ET RIGHT OUTER JOIN editora EDI

ON  ET.codEditora = EDI.codigo
AND		ET.quantidade IS NULL


--9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
Select AT.nome, AT.biografia,
Case WHEN(SUBSTRING(AT.biografia, 1,9) = 'Doutorado' )
		Then 'PH.D ' + SUBSTRING(AT.biografia, 10, 50)
			ELSE
		AT.biografia
END AS Biografia
from autor AT LEFT OUTER JOIN estoque ET
ON	AT.codigo = ET.codAutor
AND	ET.nome  IS NULL

--10) Consultar o nome do Autor, e o maior valor de Livro no estoque. 
--Ordenar por valor descendente	
SELECT AT.nome
FROM autor AT, estoque ET
WHERE AT.codigo = ET.codAutor
AND ET.valor IN
	(SELECT MAX(valor)
	FROM estoque)
ORDER BY AT.nome
--11) Consultar o código da compra, o total de livros comprados e a 
--soma dos valores gastos. Ordenar por Código da Compra ascendente.	
Select codigo, SUM (qtdComprada) AS Quantidade_Comprada, SUM (valor) AS Soma_Valor_Gasto
FROM compra
group by codigo

--12) Consultar o nome da editora e a média de preços dos livros em estoque.
--Ordenar pela Média de Valores ascendente.	
SELECT EDI.nome AS Nome_Editora, 
	CAST(AVG(ET.valor) AS DECIMAL(7,2)) AS Media_Valores
FROM estoque ET, editora EDI
WHERE EDI.codigo = ET.codEditora
GROUP BY EDI.nome
ORDER BY Media_Valores ASC

/*
13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, 
o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), 
criar uma coluna status onde:	
	Caso tenha menos de 5 livros em estoque, escrever Produto em 
		Ponto de Pedido
	Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	A Ordenação deve ser por Quantidade ascendente
*/
SELECT e.nome AS nomeLivro, e.quantidade, ed.nome AS nomeEditora, 
	CASE WHEN (LEN(ed.site) > 10)
		THEN
			SUBSTRING(ed.site, 5, LEN(ed.site) - 4)
		ELSE
			ed.site
	END AS site,
	CASE WHEN (e.quantidade < 5)
		THEN
			'Produto em Ponto de Pedido'
		ELSE
			CASE WHEN (e.quantidade > 10)
				THEN
					'Estoque Suficiente'
				ELSE
					'Prodto Acabando'
			END
	END AS status
FROM estoque e, editora ed
WHERE ed.codigo = e.codEditora

/*
14) Para montar um relatório, é necessário montar uma consulta com a 
seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, 
Info Editora (Nome da Editora + Site) de todos os livros	
	Só pode concatenar sites que não são nulos
*/
SELECT e.codigo, e.nome AS nomeLivro, a.nome AS nomeAutor,
	CASE WHEN (ed.site IS NULL)
		THEN
			ed.nome	
		ELSE
			ed.nome + ' - ' + ed.site
	END AS infoEditora
FROM estoque e, editora ed, autor a
WHERE ed.codigo = e.codEditora
	AND a.codigo = e.codAutor

--15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos 
--meses da compra até hoje	
SELECT DISTINCT codigo, DATEDIFF(DAY, dataCompra, GETDATE()) AS dias, 
	DATEDIFF(MONTH, dataCompra, GETDATE()) AS meses
FROM compra

--16) Consultar o código da compra e a soma dos valores gastos das compras 
--que somam mais de 200.00	
SELECT codigo, SUM(valor) AS soma_compra
FROM compra
GROUP BY codigo
HAVING SUM(valor) > 200.00
