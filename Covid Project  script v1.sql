select *
from Covid_deaths$
where continent is not NULL
order BY 3,4
--select *
--from Covid_vaccination$
--order BY 3,4

select location,date ,total_cases,new_cases,total_deaths,population
from Covid_deaths$
order BY 1,2

--total cases vs total deaths
select location,date ,total_cases,total_deaths,(total_deaths/total_cases)*100 AS deathpercentage
from Covid_deaths$
where location like '%ndia'
order BY 1,2

--total cases vs population
select location,date,population ,total_cases,(total_cases/population)*100 AS infectionPercentage
from Covid_deaths$
--where location like '%ndia'
order BY 1,2

--highest infection rate compared to population 
select location,population ,MAX(total_cases) as HighestInfectioncount,MAX(total_cases/population)*100 AS infectionPercentage
from Covid_deaths$
--where location like '%ndia'
group by population,location
order BY infectionPercentage DESC


--country with highest death count per population
select location,MAX(CAST (total_deaths As int))AS TotalDeathCount
from Covid_deaths$
--where location like '%ndia'
where continent is not NULL
group by location
order BY TotalDeathCount DESC
	


--by continent


--continents with highest death count
select continent,MAX(CAST (total_deaths As int))AS TotalDeathCount
from Covid_deaths$
--where location like '%ndia'
where continent is not NULL
group by continent
order BY TotalDeathCount DESC

---GLobal Numbers
select sum(new_cases)as totalcases,SUM(CAST(new_deaths as int)) as totaldeaths,SUM(CAST(new_deaths as int))/sum(new_cases)*100 AS deathpercentage
from Covid_deaths$
--where location like '%ndia'
where continent is not null
--Group By date
order BY 1,2


--total population vs total vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Convert(int,vac.new_vaccinations)) over	(partition by dea.location order by dea.location,dea.date) as rollingpeoplvaccinated,
--(rollingpeoplvaccinated/population)*100
From Covid_deaths$ dea
JOIN Covid_vaccination$ vac on 
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

---CTE
with POPvsVAC (continent,location,date,population,New_vaccinations,rollingpeoplvaccinated)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Convert(int,vac.new_vaccinations)) over	(partition by dea.location order by dea.location,dea.date) as rollingpeoplvaccinated
--(rollingpeoplvaccinated/population)*100
From Covid_deaths$ dea
JOIN Covid_vaccination$ vac on 
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

select *,(rollingpeoplvaccinated/population)*100
from POPvsVAC

--temp table

Drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population  numeric,
new_vaccinations numeric,
rollingpeoplvaccinated numeric)
insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Convert(int,vac.new_vaccinations)) over	(partition by dea.location order by dea.location,dea.date) as rollingpeoplvaccinated
--(rollingpeoplvaccinated/population)*100
From Covid_deaths$ dea
JOIN Covid_vaccination$ vac on 
dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3


select *,(rollingpeoplvaccinated/population)*100
from #percentpopulationvaccinated


--creating a view to store data for later visualizations

create View percentpopulationvaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(Convert(int,vac.new_vaccinations)) over	(partition by dea.location order by dea.location,dea.date) as rollingpeoplvaccinated
--(rollingpeoplvaccinated/population)*100
From Covid_deaths$ dea
JOIN Covid_vaccination$ vac on 
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated
