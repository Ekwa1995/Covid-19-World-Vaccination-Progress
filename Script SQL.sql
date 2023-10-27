-- Table country_vacc

-- Ici on veut savoir le nombre de vaccin administré par pays
SELECT 
	country, 
	SUM(total_vaccinations) AS Total_vaccination, 
	SUM(people_vaccinated) AS Total_people_vaccinated,
	SUM(people_fully_vaccinated) AS Total_people_fully_vaccinated
FROM 
    vacination.country_vacc
WHERE 
    people_vaccinated IS NOT NULL AND people_fully_vaccinated IS NOT NULL
GROUP BY 
	country
ORDER BY 
	Total_vaccination DESC
LIMIT 100000;

-- Ici nous créeons une table temporaire qui nous permettra d'effectuer un certains nombre de calcul 
USE vacination;
CREATE TEMPORARY TABLE temp_vaccination_info AS
  SELECT distinct country, SUM(total_vaccinations) AS Total_vaccination, 
                SUM(people_vaccinated) AS Total_people_vaccinated,
                SUM(people_fully_vaccinated) AS Total_people_fully_vaccinated
FROM vacination.country_vacc
WHERE people_vaccinated AND people_fully_vaccinated IS NOT NULL
GROUP BY country
ORDER BY Total_vaccination DESC
LIMIT 10000;

-- Ici on calculera le pourcentage de vaccination par pays 
SELECT country, Total_vaccination, Total_people_vaccinated, Total_people_fully_vaccinated,
       (Total_people_fully_vaccinated/Total_people_vaccinated)*100 AS Pourcentage_vaccinations
FROM temp_vaccination_info
ORDER BY Pourcentage_vaccinations ASC;

-- Ici on veut savoir le taux de vaccination journalier
USE vacination;
CREATE TEMPORARY TABLE vaccinations_daily AS
  SELECT distinct country, SUM(daily_vaccinations_raw) AS Total_daily_vaccination_raw, 
                SUM(daily_vaccinations) AS Total_daily_vaccination
FROM vacination.country_vacc
WHERE daily_vaccinations IS NOT NULL AND daily_vaccinations_raw IS NOT NULL
GROUP BY country
ORDER BY Total_daily_vaccination DESC
LIMIT 10000;

-- Pourcentage de vacination journalier
SELECT country, Total_daily_vaccination_raw, Total_daily_vaccination, 
       (Total_daily_vaccination_raw/Total_daily_vaccination)*100 AS Pourcentage_daily_vaccination
FROM vaccinations_daily
WHERE Total_daily_vaccination IS NOT NULL AND Total_daily_vaccination_raw IS NOT NULL 
ORDER BY Pourcentage_daily_vaccination ASC
LIMIT 10000;


-- Table country_vacc_manufacturer

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


-- Jointures et table temporaires

-- Ici on affiche les date de vaccinations, leurs totaux de vacinations par jour et le type de vaccin utilisé 
USE vacination;
CREATE VIEW vacc_total AS
SELECT coun.country, manu.total_vaccinations,  CAST(manu.date AS DATE) AS Date, 
       manu.vaccine
FROM country_vacc AS coun
LEFT JOIN country_vacc_manufacturer AS manu
ON coun.country = manu.country
GROUP BY coun.country, manu.total_vaccinations, Date, manu.vaccine;

-- Ici nous avons utilisé le total de vaccination de la table country_vacc
USE vacination;
CREATE VIEW country_vacc_total AS
SELECT coun.country, coun.total_vaccinations,  CAST(manu.date AS DATE) AS Date, 
        manu.vaccine
FROM country_vacc AS coun
LEFT JOIN country_vacc_manufacturer AS manu
ON coun.country = manu.country
GROUP BY coun.country, coun.total_vaccinations, Date, manu.vaccine;
