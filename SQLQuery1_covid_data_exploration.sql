-- schema of the table covid deaths and vaccines
select *
from Portfolio_project_01..Covid_deaths


select *
from Portfolio_project_01..Covid_deaths

--Exploring data regards COVID_Deaths

select location,date,total_cases,new_cases,total_deaths,population
from Portfolio_project_01..Covid_deaths
order by 1,2

-- Total case vs Total deaths
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercent
from Portfolio_project_01..Covid_deaths
Where location like 'India'
order by date DESC

--Total cases vs Population gives spread of covid
select location,date,total_cases,population,(total_cases/population)*100 as spreadofcovid
from Portfolio_project_01..Covid_deaths
where location like 'India'
order by 1,2

--Looking at countries with highest infection rate compared to population
select location, population, Max(total_cases) as highestinfectioncount,(max(total_cases)/population)*100 as percentofpopulinfect
from Portfolio_project_01..Covid_deaths
group by location,population
order by percentofpopulinfect desc

-- showing countries with highest death count per poulation
select location, Max( cast (total_deaths as int)) as totaldeathcount
from Portfolio_project_01..Covid_deaths
where continent is not null
group by location
order by totaldeathcount desc



--global data

select date, SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(cast(new_cases as int))*100 as deathpercentage
from Portfolio_project_01..Covid_deaths
where continent is not null
group by date
order by 1,2

select  SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast (new_deaths as int))/sum((new_cases))*100 as deathpercentage
from Portfolio_project_01..Covid_deaths
where continent is not null


--total population vs vaccination - global data
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations
from Portfolio_project_01..Covid_deaths dea
Join Portfolio_project_01..Covid_Vaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3


select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as dynamicvaccinatedpeople
from Portfolio_project_01..Covid_deaths dea
Join Portfolio_project_01..Covid_Vaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3


-- using CTE
with populationvsvaccination(continent, location, date, population , new_vaccinations,dynamicvaccinatedpeople)
as
(
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as dynamicvaccinatedpeople
from Portfolio_project_01..Covid_deaths dea
Join Portfolio_project_01..Covid_Vaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
)
select *, (dynamicvaccinatedpeople/population)*100
from populationvsvaccination 


-- creating view 
Create view percentpopulationvaccinated as
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.date) as dynamicvaccinatedpeople
from Portfolio_project_01..Covid_deaths dea
Join Portfolio_project_01..Covid_Vaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null