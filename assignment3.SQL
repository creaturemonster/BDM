//Question 1: What is the number of Distinct Usernames? 
SELECT Count(DISTINCT(name))
FROM users; 

//Question 2: Output all possible user.status values (e.g., ‘Undergrad’,
etc) along with the number of users for each status, in descending order. 
SELECT users.status, COUNT(*)
FROM users
GROUP BY status
Order By Count(*) DESC;

//Question 3: Output the top-20 user names, ordered by popularity. If there
are ties for the 20th position, output all of them (i.e., your “top-20” can have more than 20 names in this case).
DROP VIEW  IF EXISTS  test.popular_users; 
create view test.popular_users 
as
select name, count(*) cnt
from users 
group by name;

select DISTINCT p.name, p.cnt  from test.popular_users p, (select * from popular_users order by cnt desc limit 20) t
where p.cnt = t.cnt
order by p.cnt DESC ;

//Question 4 : We’ll call a name gender neutral if the set of users that
have it contains both males and females. Find all gender-neutral user names, ordered alphabetically.
SELECT DISTINCT u1.name 
FROM users AS u1, users AS u2
WHERE u1.name=u2.name AND u1.sex="Male" AND u2.sex="Female"
ORDER BY name ASC;

//Question 5:Output the uid, name, and sex of all users that are
interested in the same sex as theirs. Order your output by uid, ascending.

SELECT u.uid, name, sex
FROM users AS u, interested_in AS I
WHERE u.uid=I.uid AND (u.sex="Male" and I.`in`="Men" or u.sex="Female" AND I.`in`="Women")
ORDER BY uid ASC; 

//Question 6:Output the uid, name, and sex of all users that are
interested in both ‘Men’ and ‘Women’. Order your output by uid, ascending.

SELECT u.uid, name, sex
FROM users AS u, interested_in AS I1, interested_in AS I2
WHERE u.uid=I1.uid AND u.uid=I2.uid AND I1.`in`="Men" AND I2.`in`="Women"
ORDER BY uid ASC;

//Question 7:Now, find the set of gender-neutral names, but only
among those users that are interested in both ‘Men’ and ‘Women’; again, order names alphabetically.
[On your own: Is the percentage of gender-neutral names among users interested in both ‘Men’ and ‘Women’ similar
to the same percentage over all users?]

SELECT names
FROM users
WHERE uid IN (SELECT uid FROM users WHERE interested_in="Men" AND interested_in="Women")
ORDER BY names DESC; 

//Question 8: Find the users that share the most interests with user 830782.
Output the uid, name, and count of common interests for those users. Additionally, restrict your output only
to users that share at least two interests with 830782, and order the output by descending count, breaking ties by
ascending uid.
[On your own: How about finding the top-100 pairs of users with the largest number of common interests? You can
restrict your answer to users that are of opposite sex. If you try to run this on the server, please be mindful of your
fellow students!!]

SELECT uid
FROM users
WHERE uid IN (SELECT uid FROM users WHERE users.uid=830782);

//Question 9: Return the total number of active actors in the database. An active
actor is one whose most recent movie is released after the year 2006 (i.e., year > 2006).

SELECT DISTINCT name
FROM movies, movie_actors
WHERE YEAR >2006
LIMIT 0 , 30

//Question 10:  Return the number of movies where the audience rating is
strictly higher than the critics’ rating. Do not forget to scale the two ratings to the same range (i.e., either multiply
audience ratings by two, or divide critic ratings by two). 

SELECT Count(DISTINCT(movies))
FROM imdb
WHERE audience_rating>critic_rating/2;

//Question 11: Return the directors’ name that have made movies which
were rated higher by audiences than critics, as well as movies which were rated higher by critics than audiences.
Again, do not forget to scale ratings to the same range. Sort the results in ascending order of name. 

SELECT name
FROM movie_directors
INNER JOIN movies.movieID=movie_directors.movieID
WHERE critic_rating<(audience.rating*2)AND audience_rating IN (SELECT audience_rating FROM movies WHERE audience_rating>crutic_rating/2
GROUP BY movie_directors.name ASC; 

//Question 12: Return the actors’ name who have collaborated with ‘Tom
Cruise’ in the largest number of movies. If there is a tie, sort by name in ascending order.

SELECT movie_actors.name
FROM movie_actors
INNER JOIN movies.movieID=movie_actors.movieID
WHERE movieID IN (SELECT movieID FROM movies.actors WHERE name="Tom Cruise")
Order By Count(movie_actors.name);

//Question 13: Find the top-10 active actors (as defined in Question 4)
whose movies receive the most audience ratings in total. For example, if ‘Tom Hanks’ had played in three movies,
whose audience num ratings are 30, 20, and 10 respectively, then the total number of ratings of his movies
would be 30 + 20 + 10 = 60.

SELECT name, count(name)
FROM movie_actors
GROUP BY movieID
HAVING name>=10 IN (SELECT count(name) FROM movie_actors GROUP BY movieID);

//Question 14: Similar to Question 4, but each director
should have at least 5 movies rated higher by audiences and at least 5 rated higher by critics. Output the directors’
name, num higher by audience, num higher by critics and sort the results in descending order of
num higher by audience + num higher by critics, breaking ties in ascending order of name.

SELECT d1.name, d2.num_higher_by_audience, d1.num_higher_by_critics
FROM
(
SELECT DISTINCT d1.name, count(*) AS num_higher_by_critics
FROM (
SELECT DISTINCT d.name, count(*) AS num_higher_by_audience
FROM movie_directors AS d, movies AS m
WHERE m.movieID = d.movieID
AND m.critic_rating < m.audience_rating *2
GROUP BY d.name
HAVING count(*) >=5
) AS d1, movie_directors AS d2, movies AS m1
WHERE d1.name = d2.name
AND d2.movieID = m1.movieID
AND m1.critic_rating > m1.audience_rating *2
GROUP BY d1.name
HAVING count(*) >=5) AS d1,
(SELECT DISTINCT d.name, count(*) AS num_higher_by_audience
FROM movie_directors AS d, movies AS m
WHERE m.movieID = d.movieID
AND m.critic_rating < m.audience_rating *2
GROUP BY d.name
HAVING count(*) >=5) AS d2
WHERE d1.name=d2.name
ORDER BY  d2.num_higher_by_audience+ d1.num_higher_by_critics desc, d1.name;


//Question 15: Find all actors who have acted in four or more
movies by the same director since 2005. Output actor name, director name, num movies together,
ordering results first by number of movies in descending order and breaking ties by actor’s name.

SELECT a.name, d.name, COUNT( * ) AS num_movies_together
FROM movie_directors AS d, movies AS m, movie_actors AS a
WHERE m.movieID = d.movieID
AND m.year >=2005
AND a.movieId = d.movieID
GROUP BY a.name, d.name
HAVING COUNT( * ) >=4
ORDER BY COUNT( * ) DESC , a.name;

//Question 16: One analyst wants to find a set of all-time best movies. He
considers two metrics at the same time: its audience rating and the number of ratings audience num ratings.
The analyst uses the following rule to determine whether one movie is better than another: For two movies textttm1
and m2, we define that m1 dominates m2 if and only if m1 has a higher average rating and m1 receives more ratings.
Find a set of movies’ title, audience num ratings, audience rating, so that each movie in this set
is not dominated by any other movie in the database. Return the output in ascending order of title. [This type
of query is also known as a skyline query.]

SELECT title, audience_num_ratings, audience_rating
FROM movies
WHERE 
(title,  audience_num_ratings,audience_rating) 
NOT IN 
(
SELECT r2.title, r2.audience_num_ratings, r2.audience_rating
FROM movies AS r1, movies AS r2
WHERE r2.audience_rating < r1.audience_rating
AND r2.audience_num_ratings < r1.audience_num_ratings
)
ORDER BY title;
