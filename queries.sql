-- PART ONE

-- Join the two tables so that every column and record appears, regardless of if there is not an owner_id .

SELECT *
    FROM owners o
    LEFT JOIN vehicles v
    ON o.id = v.owner_id;

-- Count the number of cars for each owner. Display the owners first_name , last_name and count of vehicles. The first_name should be ordered in ascending order.

SELECT o.first_name, o.last_name, COUNT(v.id)
    FROM owners o
    JOIN vehicles v
    ON o.id = v.owner_id
    GROUP BY o.first_name, o.last_name
    ORDER BY COUNT(v.id) ASC;

-- Count the number of cars for each owner and display the average price for each of the cars as integers. Display the owners first_name , last_name, average price and count of vehicles. The first_name should be ordered in descending order. Only display results with more than one vehicle and an average price greater than 10000.

SELECT o.first_name, o.last_name, CAST(AVG(v.price) AS INT) AS average_price, COUNT(v.id)
    FROM owners o
    JOIN vehicles v
    ON o.id = v.owner_id
    GROUP BY o.first_name, o.last_name
    HAVING COUNT(v.id) > 1 AND AVG(v.price) > 10000
    ORDER BY o.first_name DESC;

-- PART TWO

-- The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime

-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER';

-- From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.

-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.

-- Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2
  FROM game
  WHERE id = '1012';

-- You can combine the two steps into a single query with a JOIN.

-- SELECT *
--   FROM game JOIN goal ON (id=matchid)
-- The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. (If we wanted to be more clear/specific we could say
-- ON (game.id=goal.matchid)

-- The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.

-- Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT goal.player, goal.teamid, game.stadium, game.mdate
  FROM game 
  JOIN goal ON (id=matchid)
  WHERE teamid = "GER";

-- Use the same JOIN as in the previous question.

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT game.team1, game.team2, goal.player
  FROM goal
  JOIN game ON (id=matchid)
  WHERE goal.player LIKE 'Mario%';

-- The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime
  FROM goal
  JOIN eteam ON teamid=id
  WHERE gtime<=10;

-- To JOIN game with eteam you could use either
-- game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)

-- Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT game.mdate, eteam.teamname
  FROM game
  JOIN eteam ON (team1=eteam.id)
  WHERE coach = 'Fernando Santos';

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player
  FROM goal
  JOIN game ON game.id = goal.matchid
  WHERE stadium = 'National Stadium, Warsaw';

-- The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.

SELECT DISTINCT(player)
  FROM game JOIN goal ON matchid = id
  WHERE teamid != 'GER' AND (team1 = 'GER' OR team2 = 'GER');

-- Show teamname and the total number of goals scored.

SELECT teamname, COUNT(player) as total_goals
  FROM eteam JOIN goal ON id=teamid
  GROUP BY teamname;

-- Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(player) as total_goals
  FROM game JOIN goal ON id=matchid
  GROUP BY stadium;

-- For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT matchid, mdate, COUNT(player)
 FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
 GROUP BY matchid;

--  For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT matchid, mdate, COUNT(player)
 FROM game JOIN goal ON matchid = id 
 WHERE teamid='GER' AND (team1 = 'GER' OR team2 = 'GER')
 GROUP BY matchid;

-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.

SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
  FROM game JOIN goal ON matchid = id
  GROUP BY matchid  
  ORDER BY mdate, matchid, team1, team2;

-- List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962;

-- Give year of 'Citizen Kane'.

SELECT yr
  FROM movie
  WHERE title='Citizen Kane';

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id, title, yr
  FROM movie
  WHERE title LIKE "%Star Trek%"
  ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?

SELECT DISTINCT(a.id)
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE a.name='Glenn Close';

-- What is the id of the film 'Casablanca'

SELECT id
  FROM movie
  WHERE title='Casablanca';

-- Obtain the cast list for 'Casablanca'.

-- what is a cast list?
-- Use movieid=11768, (or whatever value you got from the previous question)

SELECT a.name
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE c.movieid=11768;

-- Obtain the cast list for the film 'Alien'

SELECT a.name
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE m.title = 'Alien';

-- List the films in which 'Harrison Ford' has appeared

SELECT m.title
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE a.name='Harrison Ford';

--  List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

SELECT m.title
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE a.name='Harrison Ford' AND c.ord != 1;

-- List the films together with the leading star for all 1962 films.

 SELECT m.title, a.name
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE c.ord = 1 AND m.yr = 1962;

--  Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr, COUNT(title) 
  FROM movie 
  JOIN casting ON movie.id=movieid
  JOIN actor   ON actorid=actor.id
  WHERE name='Rock Hudson'
  GROUP BY yr
  HAVING COUNT(title) > 2;

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT title, name
  FROM movie 
  JOIN casting ON (movieid=movie.id AND ord=1)
  JOIN actor ON (actorid=actor.id)
  WHERE movie.id IN (SELECT movieid 
   FROM casting
   WHERE actorid IN (
    SELECT id
    FROM actor
    WHERE name='Julie Andrews'));

-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

SELECT a.name
  FROM actor a
  JOIN casting c ON a.id = actorid
  JOIN movie m ON m.id = movieid
  WHERE c.ord = 1
  GROUP BY a.name
  HAVING COUNT(m.title) >= 15
  ORDER BY a.name ASC;

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT m.title, COUNT(actorid)
 FROM movie m
 JOIN casting c ON m.id=c.movieid
 JOIN actor a ON a.id=c.actorid
 WHERE m.yr = 1978
 GROUP BY m.title
 ORDER BY COUNT(actorid) DESC, title DESC;

-- List all the people who have worked with 'Art Garfunkel'.

SELECT name
  FROM movie 
  JOIN casting ON (movieid=movie.id)
  JOIN actor ON (actorid=actor.id)
  WHERE movie.id IN (SELECT movieid 
   FROM casting
   WHERE actorid IN (
    SELECT id
    FROM actor
    WHERE name='Art Garfunkel'))
  AND actor.name != 'Art Garfunkel'