/*COMPARISON OPERATORS*/
/*EX 1*/
SELECT year,
       month,
       west
  FROM tutorial.us_housing_units
  
/*PP 1*/
SELECT * FROM
tutorial.us_housing_units


/*PP 2 - Renaming Columns*/
SELECT year AS "Year",
       month AS "Month",
       month_name AS "Month Name",
       west AS "West",
       midwest AS "Midwest",
       south AS "South",
       northeast AS "Northeast"
  FROM tutorial.us_housing_units
  
/*EX 2 - Adding a limit*/  
SELECT *
  FROM tutorial.us_housing_units
 LIMIT 20
 
 /*PP 3 - Adding a limit*/  
SELECT *
  FROM tutorial.us_housing_units
 LIMIT 15
 
/*EX 3*/
SELECT *
  FROM tutorial.us_housing_units
 WHERE month = 1
 
/*EX 4*/
SELECT *
  FROM tutorial.us_housing_units
 WHERE west > 30
 
/*PP 4 - Did the West Region ever produce more than 50,000 housing units in one month? */
SELECT *
  FROM tutorial.us_housing_units
 WHERE west > 50
 
/*PP 4.1 - Did the South Region ever produce 20,000 or fewer housing units in one month? */
SELECT *
  FROM tutorial.us_housing_units
 WHERE south <= 20

/*EX 5*/
SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name != 'January'
 
/* You can use >, <, and the rest of the comparison operators on 
non-numeric columns as well—they filter based on alphabetical order.*/
SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name > 'January'
 
SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name > 'J'
 
/*PP 5 - Write a query that only shows rows for which the month_name 
starts with the letter "N" or an earlier letter in the alphabet. */
SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name < 'o'
 
/*EX 6*/
SELECT year,
       month,
       west,
       south,
       west + south AS south_plus_west
  FROM tutorial.us_housing_units LIMIT 20
  
/*PP 6 - Write a query that calculates the sum of all four regions in a separate column. */  
/*EX 6*/
SELECT year,
       month,
       west + south + midwest + northeast AS sum_of_all
  FROM tutorial.us_housing_units LIMIT 20
  
/*PP 6.1 - Write a query that returns all rows for which more units were produced in the 
West region than in the Midwest and Northeast combined. */  
SELECT year,
       month,
       west,
       midwest,
       northeast
FROM tutorial.us_housing_units     
WHERE  west > (midwest + northeast) 
LIMIT 20

  
/*PP 6.2 - Write a query that calculates the percentage of all houses completed in the 
United States represented by each region. Only return results from the year 2000 and later. */
SELECT year,
       month,
       west/(west + south + midwest + northeast)*100 AS west_pct,
       south/(west + south + midwest + northeast)*100 AS south_pct,
       midwest/(west + south + midwest + northeast)*100 AS midwest_pct,
       northeast/(west + south + midwest + northeast)*100 AS northeast_pct
FROM tutorial.us_housing_units     
WHERE year >= 2000
LIMIT 20