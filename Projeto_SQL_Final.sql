/*PROJETO SQL ULTIMA SCHOOL*/

/*1- Coloque os dados no Dbeaver – todos os csvs devem pertencer a 1 único database*/
SELECT  *
FROM CovidDeaths cd
WHERE iso_code NOT LIKE 'OWID%'


SELECT *
FROM CovidVaccinations cv 
WHERE iso_code NOT LIKE 'OWID%'

/*2- Faça uma tabela com uma coluna de total de casos e outra com total de mortes por país*/
SELECT location AS 'localização',
SUM(new_cases) AS total_de_casos,
SUM(new_deaths) AS total_de_mortes 
FROM CovidDeaths cd
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1 
ORDER BY total_de_mortes DESC 

/*3- Mostre a probabilidade de morrer se contrair covid em cada país */
WITH prob_morrer_se_contr  AS(
SELECT location, 
SUM(new_deaths) AS total_de_mortes,
SUM(new_cases) AS total_de_casos
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1
ORDER BY 3 DESC)

SELECT location, total_de_casos, total_de_mortes,
CAST(total_de_mortes AS FLOAT) / CAST(total_de_casos AS FLOAT) * 100 AS probabilidade_de_morte
FROM prob_morrer_se_contr  
GROUP BY 1 
ORDER BY 4 DESC 

/*4- Faça uma tabela com uma coluna de total de casos  e outra com total população por país*/
SELECT location AS 'localização' , 
SUM(new_cases) AS total_de_casos,
population 'população' 
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1
ORDER BY 3 DESC

/*5- Mostre a probabilidade de se infectar com Covid por país */
WITH prob_contr AS(
SELECT location, 
SUM(new_cases) AS total_de_casos,
population 
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1
ORDER BY 3 DESC)

SELECT location, total_de_casos, population,
CAST(total_de_casos AS FLOAT) / CAST(population AS FLOAT) * 100 AS probabilidade_de_infecção
FROM prob_contr  
GROUP BY 1 
ORDER BY 4 DESC 

/*6- Quais são os países com maior taxa de infecção?*/
WITH tx_infec AS(
SELECT location, 
SUM(new_cases) AS total_de_casos,
population 
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1
ORDER BY 3 DESC)

SELECT location, total_de_casos, population,
CAST(total_de_casos AS FLOAT) / CAST(population AS FLOAT) * 100 AS taxa_de_infecção
FROM tx_infec  
GROUP BY 1 
ORDER BY 4 DESC 
LIMIT 10;

/*7- Quais são os países com maior taxa de morte?*/
WITH tx_morte AS(
SELECT location, 
SUM(new_deaths) AS total_de_mortes,
population 
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1
ORDER BY 3 DESC)

SELECT location, total_de_mortes, population,
CAST(total_de_mortes AS FLOAT) / CAST(population AS FLOAT) * 100 AS taxa_de_morte
FROM tx_morte
GROUP BY 1 
ORDER BY 4 DESC 
LIMIT 10;

/*8- Mostre os continentes com a maior taxa de morte*/
WITH tx_morte_cont AS(
SELECT continent, 
SUM(new_deaths) AS total_de_mortes,
SUM(population) AS população_total  
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%'
GROUP BY 1
ORDER BY 3 DESC)

SELECT continent, total_de_mortes, população_total ,
CAST(total_de_mortes AS FLOAT) / CAST(população_total  AS FLOAT) * 100 AS taxa_de_morte
FROM tx_morte_cont
GROUP BY 1 
ORDER BY 4 DESC 
LIMIT 10;

/*9- População Total vs Vacinações: mostre a porcentagem da população que recebeu pelo menos uma vacina contra a Covid
 a.Importante mostrar acumulado de vacina por data e localização*/
WITH porc_popu_prim_dose AS(
SELECT location, 
SUM(new_vaccinations) AS total_vacinas,
population AS população_total
FROM CovidDeaths cd 
WHERE iso_code NOT LIKE 'OWID%' 
GROUP BY 1
ORDER BY 3 DESC) 

SELECT location, total_vacinas, população_total,
CAST(total_vacinas AS FLOAT) / CAST(população_total AS FLOAT) * 100 AS tx_população_pelo_menos_uma_dose
FROM porc_popu_prim_dose 
GROUP BY 1
ORDER BY 3 DESC 

/*10- Crie uma view para armazenar dados para vizualização posteriores*/

CREATE VIEW CovidInfo as 
SELECT  *
FROM CovidDeaths cd
WHERE iso_code NOT LIKE 'OWID%'
