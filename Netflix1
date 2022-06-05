# PortfiloProjects
select *
from netflix_titles$

-- count the # of movies  Per country 
select Distinct country, count(*) over (partition by country ) as #_of_movies
from netflix_titles$
where country is not null and type='movie'

----Select the TV show where seasons are less than 5 for selected countries
 select title,duration
from netflix_titles$
where country IN ('South Korea' ,'United States','United kingdom')and type='TV Show' AND duration <'5 Seasons'

----select the total shows per rating
select count (*)as total_shows ,rating
from netflix_titles$
where release_year >2017 AND type= 'TV Show'
Group By rating

----select the total showsand movies  per release_year
select count (*)as total,release_year
from netflix_titles$
Group By release_year 
having release_year >2017 
