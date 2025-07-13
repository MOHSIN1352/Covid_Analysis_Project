SELECT * FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT location, date, population, new_cases, total_cases, new_deaths, total_deaths FROM PortfolioProject..CovidDeath
ORDER BY 1,2

--death percentage
SELECT location, date, population, total_cases, total_deaths, 
CASE 
	WHEN CAST(total_cases AS FLOAT) = 0 THEN 0
	ELSE (CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 
	END AS DeathPercentage
FROM PortfolioProject..CovidDeath
ORDER BY 1,2


--total cases per population
SELECT location, date, population, total_cases,
CASE 
	WHEN CAST(population AS FLOAT) = 0 THEN 0
	ELSE (CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 
	END AS CasePercentage
FROM PortfolioProject..CovidDeath
--WHERE location like '%States%'
ORDER BY 1,2


--Looking with countries with highest infection rate compared to population
SELECT DISTINCT location, Population, 
MAX(total_cases) as HighInfectionCount, 
MAX(CAST (total_cases AS FLOAT)/NULLIF(CAST(population AS FLOAT),0))*100 AS PercentPopulationInfected

FROM PortfolioProject..CovidDeath
GROUP BY location, Population
ORDER BY 4 DESC

--Highest death count countries per population
SELECT Location, MAX(CAST(Total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC 


--based on continent
SELECT continent, MAX(CAST(Total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--new cases, deaths, and death percentage per day
SELECT 
    CAST(date AS DATE) AS formatted_date, 
    SUM(CAST(new_cases AS FLOAT)) AS total_cases_per_day,
	SUM(CAST (new_deaths AS FLOAT)) AS total_deaths_per_day,
	CASE 
	WHEN SUM(CAST (new_cases AS FLOAT)) = 0 THEN 0
	ELSE (SUM(CAST(new_deaths AS FLOAT))/SUM(CAST (new_cases AS FLOAT))) * 100 
	END AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent IS NOT NULL
GROUP BY CAST(date AS DATE)
ORDER BY 1


--total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) Total_vaccinations_per_day
	--(Total_vaccinations_per_day/CAST (population AS FLOAT))*100 
	FROM PortfolioProject..CovidDeath dea
	JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE  dea.continent IS NOT NULL AND TRIM(dea.continent) <> '' 
ORDER BY 1,2,3


--USE CTE

WITH PopvsVac (continent, location, date, population,new_vaccinations, RollingVaccinations) AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) RollingVaccinations
	--(Total_vaccinations_per_day/CAST (population AS FLOAT))*100 
	FROM PortfolioProject..CovidDeath dea
	JOIN PortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE  dea.continent IS NOT NULL AND TRIM(dea.continent) <> '' 
--ORDER BY 1,2,3
)
SELECT *, 
CASE WHEN CAST (population AS FLOAT) = 0 THEN 0
ELSE (RollingVaccinations/CAST (population AS FLOAT))*100 
END AS VaccinationPercentage
FROM PopvsVac

--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    TRY_CAST(vac.new_vaccinations AS NUMERIC) AS New_vaccinations,
    SUM(TRY_CAST(vac.new_vaccinations AS NUMERIC)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date, dea.location) AS RollingVaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
  AND TRIM(dea.continent) <> ''
  AND TRY_CAST(vac.new_vaccinations AS NUMERIC) IS NOT NULL; 

SELECT *,(RollingVaccinations/CAST (population AS FLOAT))*100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated



--Creating view to store data for visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    TRY_CAST(vac.new_vaccinations AS NUMERIC) AS New_vaccinations,
    SUM(TRY_CAST(vac.new_vaccinations AS NUMERIC)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date, dea.location) AS RollingVaccinations
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
  AND TRIM(dea.continent) <> ''
  AND TRY_CAST(vac.new_vaccinations AS NUMERIC) IS NOT NULL; 

SELECT * FROM PercentPopulationVaccinated









