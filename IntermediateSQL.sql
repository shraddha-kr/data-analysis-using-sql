/*Intermediate SQL*/
--Introduction to Dataset
SELECT COUNT(*)
  FROM tutorial.aapl_historical_stock_price
  
--Counting individual columns
SELECT COUNT(high)
FROM tutorial.aapl_historical_stock_price
  
/*PP 1 - Write a query to count the number of non-null rows in the low column. */  
SELECT COUNT(low) AS low
FROM tutorial.aapl_historical_stock_price

--Counting non-numerical columns
SELECT COUNT(date) AS "Count Of Date"
FROM tutorial.aapl_historical_stock_price

/*PP 2 - Write a query that determines counts of every single column.
Which column has the most null values? */
SELECT COUNT(year) AS year,
       COUNT(month) AS month,
       COUNT(open) AS open,
       COUNT(high) AS high,
       COUNT(low) AS low,
       COUNT(close) AS close,
       COUNT(volume) AS volume
FROM tutorial.aapl_historical_stock_price

SELECT SUM(volume)
FROM tutorial.aapl_historical_stock_price

/*PP 3 - Write a query to calculate the average opening price (hint: you will 
need to use both COUNT and SUM, as well as some simple arithmetic.). */
SELECT SUM(open) / COUNT(open) AS avg_open_price
FROM tutorial.aapl_historical_stock_price

--The SQL MIN and MAX functions
SELECT MIN(volume) AS min_volume,
       MAX(volume) AS max_volume
  FROM tutorial.aapl_historical_stock_price
  
/*PP 4 - What was Apple's lowest stock price (at the time of this data collection)? */
SELECT MIN(low)
  FROM tutorial.aapl_historical_stock_price
  
/*PP 5 - What was the highest single-day increase in Apple's share value? */
SELECT MAX(close - open)
  FROM tutorial.aapl_historical_stock_price
  
SELECT AVG(high)
FROM tutorial.aapl_historical_stock_price
WHERE high IS NOT NULL

/*PP 6 - Write a query that calculates the average daily trade volume for Apple stock. */
SELECT AVG(volume) AS avg_volume
FROM tutorial.aapl_historical_stock_price

/*SQL GROUP BY*/
SELECT year,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year
 
 /*GROUP BY multiple columns*/
 SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month
 
/*PP 7 - Calculate the total number of shares traded each month. 
Order your results chronologically.*/
SELECT year, 
       month,
       SUM(volume) AS no_of_shares
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month

/*PP 8 - Write a query to calculate the average daily price change in Apple stock, grouped by year. */
SELECT year
       AVG(close - open) AS avg_daily_change
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

/*PP 9 - Write a query that calculates the lowest and highest prices that Apple stock achieved
each month.*/
SELECT year,
       month,
       MIN(low) AS lowest_price,
       MAX(high) AS highest_price
  FROM tutorial.aapl_historical_stock_price
 GROUP BY 1, 2
 ORDER BY 1, 2
 
 --The SQL HAVING clause
SELECT year,
       month,
       MAX(high) AS month_high
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING MAX(high) > 400
ORDER BY year, month
 
--The SQL CASE statement
SELECT * FROM benn.college_football_players LIMIT 10

SELECT player_name,
       year,
       CASE 
          WHEN year = 'SR' 
            THEN 'yes'
          ELSE NULL 
          END 
        AS is_a_senior
  FROM benn.college_football_players
  
/*PP 10 - Write a query that includes a column that is flagged "yes" when a player is 
from California, and sort the results with those players first. */
SELECT player_name,
       state,
       CASE 
          WHEN state = 'CA' 
            THEN 'yes'
          ELSE NULL
          END 
        AS is_from_CA
  FROM benn.college_football_players
  ORDER BY is_from_CA
  
--Adding multiple conditions to a CASE statement  
  SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
            WHEN weight > 200 THEN '201-250'
            WHEN weight > 175 THEN '176-200'
            ELSE '175 or under' END AS weight_group
  FROM benn.college_football_players
  
/*PP 11 - Write a query that includes players' names and a column that classifies them 
into four categories based on height. Keep in mind that the answer we provide is only 
one of many possible answers, since you could divide players' heights in many ways.  */
  SELECT player_name,
         height
       CASE WHEN height > 74 THEN 'over 74'
            WHEN height > 72 AND height <= 74 THEN '73-74'
            WHEN height > 70 AND height <= 72 THEN '71-72'
            ELSE 'under 70' END AS height_group
  FROM benn.college_football_players
  
  /*PP 12 - Write a query that selects all columns from benn.college_football_players and 
  adds an additional column 
  that displays the player's name if that player is a junior or senior. */
  SELECT *,
       CASE 
          WHEN year IN ('JR', 'SR') THEN player_name 
          ELSE NULL 
          END AS upperclass_player_name
  FROM benn.college_football_players
  LIMIT 10
  
  -- Using CASE with aggregate functions
  SELECT COUNT(1) AS fr_count
  FROM benn.college_football_players
 WHERE year = 'FR'
 
 SELECT CASE WHEN year = 'FR' THEN 'FR'
            ELSE 'Not FR' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY CASE WHEN year = 'FR' THEN 'FR'
               ELSE 'Not FR' END


SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY year_group              

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            *
  FROM benn.college_football_players
  LIMIT 10
               
               
/*PP 13 - Write a query that counts the number of 300lb+ players for each of 
the following regions: West Coast (CA, OR, WA), Texas, and Other (Everywhere else). */               
SELECT CASE 
    WHEN state = 'CA' THEN 'West Coast'
    WHEN state = 'OR' THEN 'West Coast'
    WHEN state = 'WA' THEN 'West Coast'
    WHEN state = 'TX' THEN 'Texas'
    ELSE 'Other' 
    END AS player_regions,
    COUNT(1) AS count
FROM benn.college_football_players
WHERE weight >= 300
GROUP BY player_regions
LIMIT 10

/*PP 14 - Write a query that calculates 
the combined weight of all underclass players (FR/SO) in California
as well as the combined weight of all upperclass players (JR/SR) in California. */
SELECT SUM(weight) AS combined_weight, CASE 
    WHEN year = 'FR' THEN 'underclass players'
    WHEN year = 'SO' THEN 'underclass players'
    WHEN year = 'JR' THEN 'upperclass players'
    WHEN year = 'SR' THEN 'upperclass players'
    ELSE NULL
    END AS class_group
FROM benn.college_football_players
WHERE state = 'CA'
GROUP BY class_group
LIMIT 10

/*Using CASE inside of aggregate functions*/
--Vertically
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY 1
 
--Horizontally
SELECT COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
  FROM benn.college_football_players
  
  /*PP 15 - Write a query that displays the number of players in each state, 
  with FR, SO, JR, and SR players in separate columns and another column for 
  the total number of players. Order results such that states with the most 
  players come first. */
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players
  FROM benn.college_football_players
 GROUP BY state
 ORDER BY total_players DESC


/*PP 16 - Write a query that shows the number of players at schools with names
that start with A through M, and the number at schools with names starting with N - Z. */
SELECT CASE WHEN school_name < 'n' THEN 'A-M'
            WHEN school_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS school_name_group,
       COUNT(1) AS players
  FROM benn.college_football_players
 GROUP BY 1

--Using SQL DISTINCT for viewing unique values
SELECT DISTINCT year, month
  FROM tutorial.aapl_historical_stock_price

/*PP 17 - Write a query that returns the unique values in the year column, in chronological order.*/
SELECT DISTINCT year
  FROM tutorial.aapl_historical_stock_price
 ORDER BY year

SELECT COUNT(DISTINCT month) AS unique_months
FROM tutorial.aapl_historical_stock_price

/*PP 18 - Write a query that counts the number of unique values in the month column for each year.*/
SELECT year,
       COUNT(DISTINCT month) AS months_count
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year
 ORDER BY year
  
/*PP 19 - Write a query that separately counts the number of unique values in the month column and the number of unique values in the `year` column. */
SELECT COUNT(DISTINCT month) AS years_count,
       COUNT(DISTINCT year) AS months_count
FROM tutorial.aapl_historical_stock_price