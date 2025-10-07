USE CovidDeaths;

SELECT * FROM CovidDeaths 
ORDER BY 3,4;

--SELECT * FROM CovidVaccinations
--ORDER BY 3,4;

--select data that I'm going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2;

--case fatality rates

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS deathVscases
FROM CovidDeaths
ORDER BY 1,2;

SELECT location, MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths, 
ROUND((MAX(total_deaths)/MAX(total_cases))*100,2) AS deathsVscases
FROM CovidDeaths
WHERE location LIKE '%kingdom%'
GROUP BY location;

--case fatality rate by country

SELECT location, MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths, 
ROUND((MAX(total_deaths)/NULLIF(MAX(total_cases),0))*100,2) AS deathsVscases
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY deathsVscases DESC;

--case fatality rate by continent

SELECT continent, SUM(TRY_CAST(new_cases AS BIGINT)) AS total_cases, SUM(TRY_CAST(new_deaths AS BIGINT)) AS total_deaths,
ROUND((SUM(TRY_CAST(new_deaths AS FLOAT))/NULLIF(SUM(TRY_CAST(new_cases AS FLOAT)),0))*100,2) AS deathsVsCases
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY deathsVscases DESC;

--cases by population

SELECT location,  MAX(TRY_CAST(population AS BIGINT)) AS population, SUM(TRY_CAST(new_cases AS BIGINT)) AS total_cases,
ROUND((SUM(TRY_CAST(new_cases AS FLOAT))/NULLIF(MAX(TRY_CAST(population AS FLOAT)),0))*100,2) AS percentofpopulationinfected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY percentofpopulationinfected DESC;

SELECT 
    location, population, date, MAX(total_cases) AS highest_infection_count, 
    ROUND(MAX(total_cases/population)*100,2) AS percent_population_infected
FROM CovidDeaths
GROUP BY 
    location, population, date
ORDER BY percent_population_infected DESC;

--deaths by population 

SELECT location, SUM(TRY_CAST(new_deaths AS BIGINT)) AS total_deaths, MAX(TRY_CAST(population AS BIGINT)) AS population,
ROUND((SUM(TRY_CAST(new_deaths AS FLOAT))/NULLIF(MAX(TRY_CAST(population AS FLOAT)),0))*100,2) AS deathsbypopulation
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY deathsbypopulation DESC;

--no of deaths by country

SELECT location, MAX(TRY_CAST(total_deaths AS BIGINT)) AS total_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC;

-- no of deaths by continent

SELECT * FROM CovidDeaths 
WHERE continent LIKE '%america%'
ORDER BY 3,4;

SELECT continent, SUM(TRY_CAST(new_deaths AS BIGINT)) AS total_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths DESC;

-- global numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS BIGINT)) AS total_deaths,
ROUND((SUM(CAST(new_deaths AS BIGINT))/SUM(new_cases))*100,2) AS deathVscases
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;	

--total deaths and cases globally

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS BIGINT)) AS total_deaths,
ROUND((SUM(CAST(new_deaths AS BIGINT))/SUM(new_cases))*100,2) AS deathVscases
FROM CovidDeaths
WHERE continent IS NOT NULL;


--joins

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_vaccinations_to_date
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON	dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

--CTE to reduce the query complexity

WITH popVsvac (continent, location, date, population, new_vaccinations, total_vaccinations_to_date)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_vaccinations_to_date
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON	dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, ROUND((total_vaccinations_to_date/population)*100,2) AS vaccinationsVsPopulation
FROM popVsvac;

--cases & deaths after vaccination started

WITH RollingCovid AS (
    SELECT 
        dea.continent,
        dea.location,
        dea.date,
        TRY_CAST(dea.new_cases AS BIGINT) AS new_cases,
        TRY_CAST(dea.new_deaths AS BIGINT) AS new_deaths,
        TRY_CAST(vac.new_vaccinations AS BIGINT) AS new_vaccinations,

        -- 7-day rolling averages
        AVG(TRY_CAST(dea.new_cases AS FLOAT)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_cases_7d,
        AVG(TRY_CAST(dea.new_deaths AS FLOAT)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_deaths_7d,
        AVG(TRY_CAST(vac.new_vaccinations AS FLOAT)) 
            OVER (PARTITION BY dea.location ORDER BY dea.date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_vaccinations_7d
    FROM CovidDeaths dea
    LEFT JOIN CovidVaccinations vac
        ON dea.location = vac.location
       AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *
FROM RollingCovid
ORDER BY location, date;

--time series for all countries

SELECT
    dea.location,
    dea.population,
    dea.date,
    MAX(dea.total_cases) AS highest_infection_count,
    ROUND(
        (MAX(dea.total_cases) * 100.0) / NULLIF(dea.population, 0),
        2
    ) AS percent_population_infected
FROM CovidDeaths dea
WHERE dea.continent IS NOT NULL   -- exclude continents and regions
GROUP BY dea.location, dea.population, dea.date
ORDER BY dea.location, dea.date ASC;

--time series infections vs populations

SELECT 
    dea.location,
    dea.date,
    MAX(TRY_CAST(dea.population AS BIGINT)) OVER (PARTITION BY dea.location) AS population,
    MAX(TRY_CAST(dea.total_cases AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS highest_infection_count,
    ROUND(
        MAX(TRY_CAST(dea.total_cases AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.date)*100/
        NULLIF(MAX(TRY_CAST(dea.population AS FLOAT)) OVER (PARTITION BY dea.location),0),2)
        AS percent_population_infected
FROM CovidDeaths dea
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;