/*Writing SubQueries in SQL*/
-- Subquery Basics
-- First, the database runs the "inner query"—the part between the parentheses:
SELECT sub.*
FROM (
        SELECT *
        FROM tutorial.sf_crime_incidents_2014_01
        WHERE day_of_week = 'Friday'
     ) sub
WHERE sub.resolution = 'NONE'    
LIMIT 5

--Without a SubQuery
SELECT *
FROM tutorial.sf_crime_incidents_2014_01
WHERE day_of_week = 'Friday'
AND resolution = 'NONE'    
LIMIT 5

/*Write a query that selects all Warrant Arrests from the 
tutorial.sf_crime_incidents_2014_01 dataset, then wrap it in an outer query 
that only displays unresolved incidents. */
    SELECT sub.*
      FROM (
            SELECT *
              FROM tutorial.sf_crime_incidents_2014_01
             WHERE descript = 'WARRANT ARREST'
           ) sub
     WHERE sub.resolution = 'NONE'
     
--Using subqueries to aggregate in multiple stages
SELECT LEFT(sub.date, 2) AS cleaned_month,
       sub.day_of_week,
       AVG(sub.incidents) AS average_incidents
  FROM (
        SELECT day_of_week,
               date,
               COUNT(incidnt_num) AS incidents
          FROM tutorial.sf_crime_incidents_2014_01
         GROUP BY 1,2
       ) sub
 GROUP BY 1,2
 ORDER BY 1,2
 
 /*PP - Write a query that displays the average number of monthly incidents for each category. 
 Hint: use tutorial.sf_crime_incidents_cleandate to make your life a little easier. */

SELECT sub.category,
       AVG(sub.incidents) AS avg_incidents_per_month
  FROM (
        SELECT EXTRACT('month' FROM cleaned_date) AS month,
               category,
               COUNT(1) AS incidents   --they want no of incidents not which all incidents
          FROM tutorial.sf_crime_incidents_cleandate
         GROUP BY 1,2
       ) sub
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 5

/* Subqueries in conditional logic */
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
 WHERE Date = (SELECT MIN(date)
                 FROM tutorial.sf_crime_incidents_2014_01
              )
/*The above query works because the result of the subquery is only one cell.
Most conditional logic will work with subqueries containing one-cell results. 
However, IN is the only type of conditional logic that will work when the inner 
query contains multiple results*/              
SELECT *
FROM tutorial.sf_crime_incidents_2014_01
WHERE Date IN (SELECT date
                 FROM tutorial.sf_crime_incidents_2014_01
                ORDER BY date
                LIMIT 5
              )
/*Note that you should not include an alias when you write a subquery in a 
conditional statement. This is because the subquery is treated as an individual 
value (or set of values in the IN case) rather than as a table.*/

/*Joining subqueries
It's fairly common to join a subquery that hits the same table as the outer query 
rather than filtering in the WHERE clause. 
*/
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN ( SELECT date
           FROM tutorial.sf_crime_incidents_2014_01
          ORDER BY date
          LIMIT 5
       ) sub
    ON incidents.date = sub.date
    
/* When you join, the requirements for your subquery output aren't as stringent
as when you use the WHERE clause.*/    
SELECT incidents.*,
       sub.incidents AS incidents_that_day
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN ( SELECT date,
          COUNT(incidnt_num) AS incidents
           FROM tutorial.sf_crime_incidents_2014_01
          GROUP BY 1
       ) sub
    ON incidents.date = sub.date
 ORDER BY sub.incidents DESC, time    
 
/*PP - Write a query that displays all rows from the three categories with the
fewest incidents reported. */
SELECT incidents.*,
       sub.count AS total_incidents_in_category
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN (
        SELECT category,
               COUNT(*) AS count
          FROM tutorial.sf_crime_incidents_2014_01
         GROUP BY 1
         ORDER BY 2
         LIMIT 3
       ) sub
    ON sub.category = incidents.category

/*You could solve this much more efficiently by aggregating the two tables separately, 
then joining them together so that the counts are performed across far smaller datasets*/
SELECT COALESCE(acquisitions.month, investments.month) AS month,
       acquisitions.companies_acquired,
       investments.companies_rec_investment
  FROM (
        SELECT acquired_month AS month,
               COUNT(DISTINCT company_permalink) AS companies_acquired
          FROM tutorial.crunchbase_acquisitions
         GROUP BY 1
       ) acquisitions
       
 FULL JOIN (
        SELECT funded_month AS month,
               COUNT(DISTINCT company_permalink) AS companies_rec_investment
          FROM tutorial.crunchbase_investments
         GROUP BY 1
       )investments

    ON acquisitions.month = investments.month
 ORDER BY 1 DESC


/*IMP - Write a query that counts the number of companies founded and acquired by quarter 
starting in Q1 2012. 
Create the aggregations in two separate queries, then join them. */
    SELECT COALESCE(companies.quarter, acquisitions.quarter) AS quarter,
           companies.companies_founded,
           acquisitions.companies_acquired
      FROM (
            SELECT founded_quarter AS quarter,
                   COUNT(permalink) AS companies_founded
              FROM tutorial.crunchbase_companies
             WHERE founded_year >= 2012
             GROUP BY 1
           ) companies
      
      LEFT JOIN (
            SELECT acquired_quarter AS quarter,
                   COUNT(DISTINCT company_permalink) AS companies_acquired
              FROM tutorial.crunchbase_acquisitions
             WHERE acquired_year >= 2012
             GROUP BY 1
           ) acquisitions
        
        ON companies.quarter = acquisitions.quarter
     ORDER BY 1

--Subqueries and UNIONs
SELECT *
  FROM tutorial.crunchbase_investments_part1

 UNION ALL

 SELECT *
   FROM tutorial.crunchbase_investments_part2
   
  /*perform operations on the entire combined dataset */
  SELECT COUNT(*) AS total_rows
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1

         UNION ALL

        SELECT *
          FROM tutorial.crunchbase_investments_part2
       ) sub
       
/*PP Write a query that ranks investors from the combined dataset above by the 
total number of investments they have made. */    
SELECT * FROM tutorial.crunchbase_companies LIMIT 5

SELECT investor_name,
       COUNT(*) AS investments
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1

         UNION ALL

        SELECT *
          FROM tutorial.crunchbase_investments_part2
       ) sub
GROUP BY 1
ORDER BY 2 DESC

/*PP- Write a query that does the same thing as in the previous problem, except only 
for companies that are still operating. Hint: operating status is in tutorial.crunchbase_companies. */


SELECT investments.investor_name,
       COUNT(investments.*) AS investments
  FROM tutorial.crunchbase_companies companies
  JOIN (
        SELECT *
          FROM tutorial.crunchbase_investments_part1
         
         UNION ALL
        
         SELECT *
           FROM tutorial.crunchbase_investments_part2
       ) investments
    ON investments.company_permalink = companies.permalink
 WHERE companies.status = 'operating'
 GROUP BY 1
 ORDER BY 2 DESC

//