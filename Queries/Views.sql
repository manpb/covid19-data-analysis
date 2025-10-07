
--Shows likeloohood of dying if infected

CREATE VIEW DeathsVsCases AS
SELECT 
	location, MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths, 
	ROUND((MAX(total_deaths)/NULLIF(MAX(total_cases),0))*100,2) AS deathsVscases
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
GO

SELECT * FROM DeathsVsCases;
GO

--Shows percentage of population infected

CREATE VIEW CasesVsPopulation AS
SELECT 
    location,
    SUM(TRY_CAST(new_cases AS BIGINT)) AS total_cases,
    MAX(TRY_CAST(population AS BIGINT)) AS population,
    ROUND(SUM(TRY_CAST(new_cases AS FLOAT)) * 100.0 / NULLIF(MAX(TRY_CAST(population AS FLOAT)),0), 2) AS cases_vs_population_percent
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
GO

SELECT * FROM CasesVsPopulation;
GO

--Shows mortality burden relative to the population

CREATE VIEW DeathsVsPopulation AS
SELECT 
    location,
    SUM(TRY_CAST(new_deaths AS BIGINT)) AS total_deaths,
    MAX(TRY_CAST(population AS BIGINT)) AS population,
    ROUND(SUM(TRY_CAST(new_deaths AS FLOAT)) * 100.0 / NULLIF(MAX(TRY_CAST(population AS FLOAT)),0), 2) AS deaths_vs_population_percent
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
GO

SELECT * FROM DeathsVsPopulation;
GO

--Tracks vaccination progress in each location by date

CREATE VIEW RollingVaccinations AS
SELECT 
    dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_vaccinations_to_date
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON	dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GO

SELECT * FROM RollingVaccinations;
GO

--Aggregates cases and deaths by continent

CREATE VIEW ContinentSummary AS
SELECT 
    continent,
    SUM(TRY_CAST(new_cases AS BIGINT)) AS total_cases,
    SUM(TRY_CAST(new_deaths AS BIGINT)) AS total_deaths,
    ROUND(SUM(TRY_CAST(new_deaths AS FLOAT)) * 100.0 / NULLIF(SUM(TRY_CAST(new_cases AS FLOAT)),0), 2) AS deaths_vs_cases_percent
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
GO

SELECT * FROM ContinentSummary;
GO