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

