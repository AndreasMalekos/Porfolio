--SELECT *
--FROM CovidDeaths
--WHERE continent IS NOT NULL
--ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths
--ORDER BY 1,2

----Percentage of Total Deaths over Total Cases in Cyprus
--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM CovidDeaths
--WHERE location like 'Cyprus'
--ORDER BY 1,2

---- Percentage of Total Cases over Population in Cyprus
--SELECT location, date, population, total_cases, (total_cases/population)*100 AS TotalCasesPercentage
--FROM CovidDeaths
--WHERE location like 'Cyprus'
--ORDER BY 1, 2

---- Countries with higest Total Cases over Population %
--SELECT location, MAX(total_cases) AS Infections, MAX(total_cases)/population * 100 AS PercentPopupationInfected
--FROM CovidDeaths
--GROUP BY location,population
--ORDER BY PercentPopupationInfected DESC

----Percentage of Deaths over Population per Country
--SELECT location, MAX(CAST(total_deaths as int))/population * 100 AS PerDeathPop
--FROM CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location, population
--ORDER BY PerDeathPop DESC

----Total Deaths per Continent (Correct)
--SELECT location, MAX(CAST(total_deaths as int))
--FROM CovidDeaths
--WHERE continent IS NULL
--GROUP BY location
--ORDER BY MAX(CAST(total_deaths as int)) DESC

----Total Deaths per Continent (Wrong)
----Drill down for Tableau
--SELECT continent, MAX(CAST(total_deaths as int))
--FROM CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY MAX(CAST(total_deaths as int)) DESC

---- Global new cases daily
--SELECT SUM(new_cases) AS CasesGlobal, SUM(CAST(new_deaths AS int)) AS DeathsGlobal, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS MortalityRateGlobal
--FROM CovidDeaths
--WHERE continent is not null


----Rolling count of vaccinations in each country
--SELECT DT.location, DT.date, VT.new_vaccinations
--,SUM(CONVERT(bigint, VT.new_vaccinations)) OVER (PARTITION BY DT.location ORDER BY DT.location, DT.date) AS VaccinationsRolling
--,DT.population
--,SUM(CONVERT(bigint, VT.new_vaccinations)) OVER (PARTITION BY DT.location ORDER BY DT.location, DT.date)/DT.population
--FROM CovidDeaths DT JOIN CovidVaccinations VT
--	ON DT.location = VT.location AND DT.date = VT.date
--WHERE DT.continent IS NOT NULL

----Rolling count of vaccinations in each country (CTE)
--WITH RollingVaccinationsTable (location, date, new_vaccinations, vaccinationsrolling, population)
--AS
--(
--SELECT DT.location, DT.date, VT.new_vaccinations
--,SUM(CONVERT(bigint, VT.new_vaccinations)) OVER (PARTITION BY DT.location ORDER BY DT.location, DT.date) AS vaccinationsrolling
--,DT.population
--FROM CovidDeaths DT JOIN CovidVaccinations VT
--	ON DT.location = VT.location AND DT.date = VT.date
--WHERE DT.continent IS NOT NULL
--)
--SELECT location, date, new_vaccinations, vaccinationsrolling, population
--FROM RollingVaccinationsTable

------Rolling count of vaccinations in each country (Temp Table)
--DROP TABLE IF EXISTS #RollingVaccinationsTable
--CREATE Table #RollingVaccinationsTable
--(
--location nvarchar(255),
--date datetime,
--new_vaccinations numeric,
--vaccinationrolling numeric,
--population numeric
--)
--INSERT INTO #RollingVaccinationsTable
--SELECT DT.location, DT.date, VT.new_vaccinations
--,SUM(CONVERT(bigint, VT.new_vaccinations)) OVER (PARTITION BY DT.location ORDER BY DT.location, DT.date) AS vaccinationsrolling
--,DT.population
--FROM CovidDeaths DT JOIN CovidVaccinations VT
--	ON DT.location = VT.location AND DT.date = VT.date
--WHERE DT.continent IS NOT NULL

--SELECT *
--FROM #RollingVaccinationsTable

--Create View 
--Rolling count of vaccinations in each country
--CREATE VIEW VaccinationRolling AS
--SELECT DT.location, DT.date, VT.new_vaccinations
--,SUM(CONVERT(bigint, VT.new_vaccinations)) OVER (PARTITION BY DT.location ORDER BY DT.location, DT.date) AS VaccinationsRolling
--,DT.population
--,SUM(CONVERT(bigint, VT.new_vaccinations)) OVER (PARTITION BY DT.location ORDER BY DT.location, DT.date)/DT.population * 100 AS VaccinationsRollingPercent
--FROM CovidDeaths DT JOIN CovidVaccinations VT
--	ON DT.location = VT.location AND DT.date = VT.date
--WHERE DT.continent IS NOT NULL















