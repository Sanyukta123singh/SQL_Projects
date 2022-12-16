/****** Exploratory Data Analysis  ******/


  Select * FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  Where continent is not null 
  order by 3,4


  SELECT location, date, total_cases, new_cases, total_deaths, population FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  order by 1,2;

  SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS Percentage_of_Deaths, population FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  where location like '%States%'
  order by Percentage_of_Deaths desc;

  SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS Percentage_of_Deaths, population FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  where location = 'India'
  order by Percentage_of_Deaths desc;

  SELECT location, date, total_deaths, population, Round((total_deaths/population)*100,2) AS Percentage_of_Deaths FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  order by Percentage_of_Deaths desc;


  SELECT location, MAX(total_cases) as Highest_Cases, population, Round(MAX(total_deaths/population)*100,2) AS Percentage_of_Deaths 
  FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  Group by location, population
  order by Percentage_of_Deaths desc;

  SELECT location, MAX(Cast(Total_Deaths as int)) as TotalDeathCount FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  where continent is not null
  Group by location
  Order by TotalDeathCount desc;

  SELECT location, MAX(Cast(Total_Deaths as int)) as TotalDeathCount FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  where continent is null
  Group by location
  Order by TotalDeathCount desc;


  SELECT continent, MAX(Cast(Total_Deaths as int)) as TotalDeathCount FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  where continent is not null
  Group by continent
  Order by TotalDeathCount desc;

  SELECT  SUM(new_cases ) as TotalNewCases, SUM(Cast(new_Deaths as int)) as ToatlNewDeaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
  FROM [Portfolio_Project_1].[dbo].[Covid_Deaths]
  where continent is not null 
  Order by 1,2;

  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
  From [Portfolio_Project_1].[dbo].[Covid_Deaths] dea
  Join [Portfolio_Project_1].[dbo].[Covid_Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
  where dea.continent is not null 
  order by 2,3


  With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
  From [Portfolio_Project_1].[dbo].[Covid_Deaths] dea
  Join [Portfolio_Project_1].[dbo].[Covid_Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
  where dea.continent is not null 
  
)
Select *, (RollingPeopleVaccinated/Population)*100 as Percentage
From PopvsVac;


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [Portfolio_Project_1].[dbo].[Covid_Deaths] dea
Join [Portfolio_Project_1].[dbo].[Covid_Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date;
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--SET ANSI_WARNINGS OFF;
--GO


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio_Project_1].[dbo].[Covid_Deaths] dea
Join [Portfolio_Project_1].[dbo].[Covid_Vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
