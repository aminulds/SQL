select *
from CovidExploration..CovidDeath
order by 3, 4;

--select *
--from CovidVaccination
--order by 3, 4;

select location, date, population, total_cases, new_cases, total_deaths
from CovidExploration..CovidDeath
order by 1, 2;

--Death Rate of Covid in Bangladesh
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
from CovidExploration..CovidDeath
where location ='Bangladesh'
order by 1, 2 desc;

--Cases Rate of Covid in Bangladesh
select location, date, population, total_cases, (total_cases/population)*100 as cases_rate
from CovidExploration..CovidDeath
where location ='Bangladesh'
order by 1, 2 desc;

--Highest Infection
select continent, location, population, max(total_cases) as high_cases, max((total_cases/population))*100 as cases_rate
from CovidExploration..CovidDeath
group by continent, location, population
order by 5 desc

--Highest Total Death location
select location, max(cast(total_deaths as int)) as highest_death
from CovidExploration..CovidDeath
where continent <> ' '
group by location
order by highest_death desc;

--Highest Total Death by Continent
select location, max(cast(total_deaths as int)) as highest_death
from CovidExploration..CovidDeath
where continent <> ' '
group by location
order by highest_death desc;

--Global Cases and Deaths in every day
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as date_rate
from CovidExploration..CovidDeath
where continent <> ' '
group by date
order by 1 desc;

--Total Global Covid Situation
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as date_rate
from CovidExploration..CovidDeath
where continent <> ' '
--group by date
--order by 1 desc;



-- Vaccination in the World

with PopvsVac(continent, location, date, population, new_vaccinations, rolling_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_vaccinated
from CovidExploration..CovidDeath dea
join CovidExploration..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ' '
)
select *, (rolling_vaccinated/population)*100 as vaccination_rate
from PopvsVac

-- TEMP TABLE
drop table if exists #Vaccinated
create table #Vaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population nvarchar(255),
New_vaccinations nvarchar(255),
RollingVaccinated nvarchar(255)
)
insert into #Vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_vaccinated
from CovidExploration..CovidDeath dea
join CovidExploration..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent <> ' '

select *, (convert(float, RollingVaccinated)/convert(float, Population))*100 as vaccination_rate
from #Vaccinated


--Create View
create view Vaccination AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_vaccinated
from CovidExploration..CovidDeath dea
join CovidExploration..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent <> ' '

