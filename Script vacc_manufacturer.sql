
-- ici on a la somme des vaccinations par date
SELECT country, SUM(total_vaccinations) AS Somme_vaccinated, AVG(total_vaccinations) AS Moyenne_vaccinated, 
	   CAST(date as DATE) AS date_vaccination, MAX(total_vaccinations) AS Max_vaccinated,
       MIN(total_vaccinations) AS Min_vaccinated, count(distinct vaccine) AS Nombre_vaccin_utilisé
FROM  vacination.country_vacc_manufacturer
GROUP BY country, date_vaccination 
ORDER BY date_vaccination ASC
LIMIT 100000;



-- Ici on aura la somme des vaccinations par pays
SELECT country, SUM(total_vaccinations) AS vaccine
FROM vacination.country_vacc_manufacturer
GROUP BY country
LIMIT 1000;

-- Ici on veut avoir le total des vaccinations en fonction du type de vaccin et le pays 
SELECT country, SUM(total_vaccinations) AS Total_vaccine, vaccine
FROM vacination.country_vacc_manufacturer
GROUP BY vaccine, country
LIMIT 1000;

-- Ici on veut savoir le nombre de vaccin utilisé par pays
SELECT country, SUM(total_vaccinations) AS Total_vaccin, count(distinct vaccine) AS Nombre_vaccin_utilisé
FROM vacination.country_vacc_manufacturer
GROUP BY country
LIMIT 1000;

-- Ici on veut afficher le total des vaccinations en 2020 et le nombre de vaccin utilisé par jour 
SELECT country, SUM(total_vaccinations) AS Total_vaccin, 
       count(distinct vaccine) AS Nombre_vaccin_utilisé,
       CAST(date AS DATE) AS Date
FROM vacination.country_vacc_manufacturer
GROUP BY country, Date
HAVING date LIKE "%2020%"
ORDER BY Date ASC
LIMIT 100000;

-- Ici on veut afficher le total des vaccinations en 2021 et le nombre de vaccin utilisé par jour 
SELECT country, SUM(total_vaccinations) AS Total_vaccin, 
       count(distinct vaccine) AS Nombre_vaccin_utilisé,
       CAST(date AS DATE) AS Date
FROM vacination.country_vacc_manufacturer
GROUP BY country, Date
HAVING date LIKE "%2021%"
ORDER BY Date ASC
LIMIT 100000;

-- Ici on veut afficher le total des vaccinations en 2022 et le nombre de vaccin utilisé par jour 
SELECT country, SUM(total_vaccinations) AS Total_vaccin, 
       count(distinct vaccine) AS Nombre_vaccin_utilisé,
       CAST(date AS DATE) AS Date
FROM vacination.country_vacc_manufacturer
GROUP BY country, Date
HAVING date LIKE "%2022%"
ORDER BY Date ASC Limit 100000;

-- Ici on veut savoir le nombre de vaccinés journalier et nombre de type de vaccin utilisé
SELECT country, SUM(total_vaccinations) AS Total_vaccin, count(distinct vaccine) AS Nombre_vaccin_utilisé,
       CAST(date AS DATE) AS Date
FROM vacination.country_vacc_manufacturer
GROUP BY country, Date
ORDER BY Date ASC
LIMIT 100000;

