/*AdvancedSQL-WindowFunctions*/
--Basic windowing syntax
SELECT duration_seconds,
       SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
  
--Narrow the window from the entire datset to individual groups, within the dataset
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
  
/*Write a query modification of the above example query that shows the duration of each ride as a 
percentage of the total time accrued by riders from each start_terminal */
SELECT * FROM tutorial.dc_bikeshare_q1_2012 LIMIT 5



SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS start_terminal_sum,
       (duration_seconds/SUM(duration_seconds) OVER (PARTITION BY start_terminal))*100 AS pct_of_total_time
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY 1, 4 DESC
 LIMIT 10

--The usual suspects: SUM, COUNT, and AVG
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_total,
       COUNT(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_count,
       AVG(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_avg
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 
SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_total,
       COUNT(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_count,
       AVG(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_avg
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 
 /*Write a query that shows a running total of the duration of bike rides (similar to the last example), 
 but grouped by end_terminal, and with ride duration sorted in descending order. */
SELECT end_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY end_terminal ORDER BY duration_seconds DESC)
         AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'

--ROW_NUMBER()
SELECT start_terminal,
       start_time,
       duration_seconds,
       ROW_NUMBER() OVER (ORDER BY start_time)
                    AS row_number
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
LIMIT 10

--Using the PARTITION BY clause will allow you to begin counting 1 again in each partition.
SELECT start_terminal,
       start_time,
       duration_seconds,
       ROW_NUMBER() OVER (PARTITION BY start_terminal
                          ORDER BY start_time)
                    AS row_number
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
LIMIT 20

--RANK() and DENSE_RANK()
SELECT start_terminal,
       duration_seconds,
       RANK() OVER (PARTITION BY start_terminal
                    ORDER BY start_time)
              AS rank
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 
/*PP Write a query that shows the 5 longest rides from each starting terminal, ordered by terminal, 
and longest to shortest rides within each terminal.
Limit to rides that occurred before Jan. 8, 2012. */
--RANK() and DENSE_RANK()
SELECT start_terminal,
       duration_seconds,
       RANK() OVER (PARTITION BY start_terminal
                    ORDER BY start_time)
              AS rank
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'

--NTILE
SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
          AS quartile,
       NTILE(5) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS quintile,
       NTILE(100) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds
 
select DISTINCT(start_terminal) from tutorial.dc_bikeshare_q1_2012 order by start_terminal asc
select COUNT(DISTINCT(start_terminal)) from tutorial.dc_bikeshare_q1_2012 

/*Write a query that shows only the duration of the trip and the percentile into which that
duration falls (across the entire dataset—not partitioned by terminal). */
SELECT duration_seconds,
       NTILE(100) OVER (ORDER BY duration_seconds)
         AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY 1 DESC

--LAG & LEAD
SELECT start_terminal,
       duration_seconds,
       LAG(duration_seconds, 1) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
       LEAD(duration_seconds, 1) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds
 
--This is especially useful if you want to calculate differences between rows:
SELECT start_terminal,
       duration_seconds,
       duration_seconds -LAG(duration_seconds, 1) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS difference
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds

/*The first row of the difference column is null because there is no previous row from which to pull. 
Similarly, using LEAD will create nulls at the end of the dataset. If you'd like to make the results 
a bit cleaner, you can wrap it in an outer query to remove nulls*/
SELECT *
  FROM (
    SELECT start_terminal,
           duration_seconds,
           duration_seconds -LAG(duration_seconds, 1) OVER
             (PARTITION BY start_terminal ORDER BY duration_seconds)
             AS difference
      FROM tutorial.dc_bikeshare_q1_2012
     WHERE start_time < '2012-01-08'
     ORDER BY start_terminal, duration_seconds
       ) sub
 WHERE sub.difference IS NOT NULL

--Defining a window alias
--The WINDOW clause, if included, should always come after the WHERE clause.
SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER ntile_window AS quartile,
       NTILE(5) OVER ntile_window AS quintile,
       NTILE(100) OVER ntile_window AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
WINDOW ntile_window AS
         (PARTITION BY start_terminal ORDER BY duration_seconds)
 ORDER BY start_terminal, duration_seconds
 
 SELECT *
  FROM tutorial.worldwide_earthquakes LIMIT 10

--Pivot 
SELECT years.*,
       earthquakes.*
  FROM tutorial.worldwide_earthquakes earthquakes
 CROSS JOIN (
       SELECT year
         FROM (VALUES (2000),(2001),(2002),(2003),(2004),(2005),(2006),
                      (2007),(2008),(2009),(2010),(2011),(2012)) v(year)
       ) years











