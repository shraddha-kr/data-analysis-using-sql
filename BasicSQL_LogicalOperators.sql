/*SQL-LogicalOperators*/

/*Intro to Datasets*/
SELECT * FROM tutorial.billboard_top_100_year_end LIMIT 20

SELECT *
FROM tutorial.billboard_top_100_year_end
ORDER BY year DESC, year_rank


/*SQL - Like*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" LIKE 'Snoop%'

/*Wildcards & ILIKE*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" ILIKE 'snoop%'

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE artist ILIKE 'dr_ke'

/*PP1 - Write a query that returns all rows for 
which Ludacris was a member of the group.*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" ILIKE '%Ludacris%'

/*PP2 - Write a query that returns all rows for 
which the first artist listed in the group has a name that begins with "DJ".*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" LIKE 'DJ%'

/*The SQL IN operator*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank IN (1, 2, 3)

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris')

/*PP 3 - Write a query that shows all of the entries for Elvis and M.C. Hammer. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE artist ILIKE '%Elvis%'

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE artist IN ('Elvis', 'Jan Hammer', 'M.C. Hammer', 'Hammer', 'Elvis Presley')

/*SQL Between*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank BETWEEN 5 AND 10

/*PP 4 - Write a query that shows all top 100 songs from January 1, 1985 through December 31, 1990.*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year BETWEEN 1985 AND 1990

/*The IS NULL operator*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE artist IS NULL

/*PP 5 - Write a query that shows all of the rows for which song_name is null.*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name IS NULL

/*The SQL AND operator*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2012
  AND year_rank <= 10
  AND "group" ILIKE '%feat%'
  
/*PP 6 - Write a query that surfaces all rows for top-10 hits for which Ludacris is part of the Group. */  
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10
 AND "group" ILIKE '%Ludacris%'
 
/*PP 7 - Write a query that surfaces the top-ranked records in 1990, 2000, and 2010. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank = 1
AND year IN ('1990', '2000', '2010')
 
/*PP 8 - Write a query that lists all songs from the 1960s with "love" in the title. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year BETWEEN 1960 AND 1969
  AND song_name ILIKE '%love%'
  
/*The SQL OR operator*/  
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND ("group" ILIKE '%macklemore%' OR "group" ILIKE '%timberlake%')  

/*PP 9 - Write a query that returns all rows for top-10 songs that featured either Katy Perry or Bon Jovi. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10
AND ("group" ILIKE '%Perry%' OR "group" ILIKE '%Jovi%')

/*PP 10 - Write a query that returns all songs with titles that contain the word "California" in either the 1970s or 1990s. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name ILIKE '%California%'
AND (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 AND 1999)

/*PP 11 -Write a query that lists all top-100 recordings that feature Dr. Dre before 2001 or after 2009. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" ILIKE '%Dr. Dre%'
AND (year <= 2000 OR year >= 2010)

/*The SQL NOT operator*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND "group" NOT ILIKE '%macklemore%'
   
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND artist IS NOT NULL   

/*Write a query that returns all rows for songs that were 
on the charts in 2013 and do not contain the letter "a". */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
AND song_name NOT ILIKE '%a%'

/*Sorting data with SQL ORDER BY
* Ordering by single column
*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
ORDER BY year_rank
 
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
ORDER BY year_rank DESC

/*PP 12 -Write a query that returns all rows from 2012, ordered by song title from Z to A. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2012
ORDER BY song_name DESC

/*Ordering by multiple column*/
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 3
ORDER BY year DESC, year_rank
 --The results are sorted by the first column mentioned (year), then by year_rank afterward. 
 
/*PP 13 - Write a query that returns all rows from 2010 ordered by rank, with artists ordered 
alphabetically for each song. */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2010
ORDER BY year_rank, artists

/*PP 14 - Write a query that shows all rows for which T-Pain was a group member, ordered by
rank on the charts, from lowest to highest rank (from 100 to 1).  */
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "groups" ILIKE '%T-Pain%'
ORDER BY year_rank DESC

/*PP 15 - Write a query that returns songs that ranked between 10 and 20 (inclusive) in 1993, 
2003, or 2013. Order the results by year and rank, and leave a comment on each line of the 
WHERE clause to indicate what that line does.*/
SELECT song_name, year
FROM tutorial.billboard_top_100_year_end
WHERE year_rank BETWEEN 10 AND 20
AND year IN ('1993', '2003', '2013')
ORDER BY year, year_rank DESC
