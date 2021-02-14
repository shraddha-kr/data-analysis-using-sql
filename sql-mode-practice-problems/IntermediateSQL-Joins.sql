/* Intermediate SQL - JOINS */
--Anatomy of a join
SELECT teams.conference AS conference,
       AVG(players.weight) AS average_weight
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
 GROUP BY teams.conference
 ORDER BY AVG(players.weight) DESC
 
 /*PP 1 -Write a query that selects the school name, player name, position,
 and weight for every player in Georgia, ordered by weight (heaviest to lightest). 
 Be sure to make an alias for the table, and to reference all column names in relation 
 to the alias. */
SELECT  players.school_name, 
        players.player_name, 
        players.position,
        players.weight
FROM benn.college_football_players players
WHERE players.state = 'GA'
ORDER BY players.weight DESC
 
SELECT DISTINCT(state) FROM benn.college_football_players LIMIT 10
SELECT * FROM benn.college_football_teams LIMIT 10

--INNER JOIN
/*PP 2 - Write a query that displays player names, school names and 
conferences for schools in the "FBS (Division I-A Teams)" division.*/
SELECT  
        players.player_name, 
        teams.school_name,
        teams.conference
FROM benn.college_football_players players
JOIN benn.college_football_teams teams
ON teams.school_name = players.school_name
WHERE teams.division = 'FBS (Division I-A Teams)'
LIMIT 10

--OUTER JOINS
/*PP 3 - Write a query that performs an inner join 
between the tutorial.crunchbase_acquisitions table and the 
tutorial.crunchbase_companies table, but instead of listing 
individual rows, count the number of non-null rows in each table. */
SELECT COUNT(1)
FROM tutorial.crunchbase_companies companies
INNER JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink


SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_companies companies
JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
    
/*PP 4 - Modify the query above to be a LEFT JOIN. Note the difference in results.  */
SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink

/*PP 5 - Count the number of unique companies (don't double-count companies) and unique 
acquired companies by state. Do not include results for which there is no state data, 
and order by the number of acquired companies from highest to lowest. */
SELECT * FROM tutorial.crunchbase_companies LIMIT 10
SELECT * FROM tutorial.crunchbase_acquisitions LIMIT 10

SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_companies_acquired
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC
 
/*PP 6 - Rewrite the previous practice query in which you counted 
total and acquired companies by state, but with a RIGHT JOIN instead 
of a LEFT JOIN. The goal is to produce the exact same results. */
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS acquired_companies
  FROM tutorial.crunchbase_acquisitions acquisitions
 RIGHT JOIN tutorial.crunchbase_companies companies
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC

-- Filtering in the ON clause
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
   AND acquisitions.company_permalink != '/company/1000memories'
 ORDER BY 1

-- Filtering in the where clause
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE acquisitions.company_permalink != '/company/1000memories'
    OR acquisitions.company_permalink IS NULL
 ORDER BY 1
 
 
SELECT * FROM tutorial.crunchbase_companies companies LIMIT 10
SELECT * FROM tutorial.crunchbase_acquisitions acquisitions LIMIT 10

SELECT COUNT(DISTINCT investments.investor_name) inv_count, 
       investments.investor_name
FROM tutorial.crunchbase_investments investments
GROUP BY 2
ORDER BY 1 DESC
LIMIT 20

/*PP 7 - Write a query that shows a company's name, "status" (found in the Companies table), 
and the number of unique investors in that company. Order by the number of investors from 
most to fewest. Limit to only companies in the state of New York.*/
SELECT companies.name AS company_name,
       companies.status,
       COUNT(DISTINCT investments.investor_name) AS unqiue_investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 WHERE companies.state_code = 'NY'
 GROUP BY 1,2
 ORDER BY 3 DESC

/*PP 8 - Write a query that lists investors based on the number of companies in which they 
are invested. Include a row for companies with no investor, and order from most companies to least. */
SELECT * FROM tutorial.crunchbase_investments LIMIT 10


SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1
 ORDER BY 2 DESC
 
 --SQL FULL JOIN/ FULL OUTER JOIN
 SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
  FROM tutorial.crunchbase_companies companies
  FULL JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 

/*PP 9 - Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1 
using a FULL JOIN. Count up the number of rows that are matched/unmatched as in the example above.*/
 SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NULL
                      THEN companies.permalink ELSE NULL END) AS companies_only,
           COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NOT NULL
                      THEN companies.permalink ELSE NULL END) AS both_tables,
           COUNT(CASE WHEN companies.permalink IS NULL AND investments.company_permalink IS NOT NULL
                      THEN investments.company_permalink ELSE NULL END) AS investments_only
      FROM tutorial.crunchbase_companies companies
      FULL JOIN tutorial.crunchbase_investments_part1 investments
        ON companies.permalink = investments.company_permalink
        
        
/*Intermediate-3*/
-- UNION & UNION ALL
SELECT *
  FROM tutorial.crunchbase_investments_part1

 UNION ALL

 SELECT *
   FROM tutorial.crunchbase_investments_part2
   
/*PP - 1  Write a query that appends the two crunchbase_investments datasets 
above (including duplicate values). Filter the first dataset to only companies 
with names that start with the letter "T", and filter the second to companies 
with names starting with "M" (both not case-sensitive). Only include the 
company_permalink, company_name, and investor_name columns. */
SELECT company_permalink, company_name, investor_name 
FROM tutorial.crunchbase_investments_part1
WHERE company_name ILIKE 'T%'
UNION ALL
SELECT company_permalink, company_name, investor_name 
FROM tutorial.crunchbase_investments_part2
WHERE company_name ILIKE 'M%'

/*PP - 2 Write a query that shows 3 columns. The first indicates which dataset
(part 1 or 2) the data comes from, the second shows company status, and the 
third is a count of the number of investors.

Hint: you will have to use the tutorial.crunchbase_companies table as well as the investments tables. 
And you'll want to group by status and dataset. */


SELECT 'investments_part1' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1,2

 UNION ALL
 
 SELECT 'investments_part2' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part2 investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1,2

-- Using comparison operators with joins
-- ON Condition
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3
 
 
-- WHERE Condition
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
 WHERE investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2 ,3
 
-- Joining on multiple keys
SELECT companies.permalink,
       companies.name,
       investments.company_name,
       investments.company_permalink
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND companies.name = investments.company_name

-- Self joining tables
SELECT DISTINCT japan_investments.company_name,
       japan_investments.company_permalink
  FROM tutorial.crunchbase_investments_part1 japan_investments
  JOIN tutorial.crunchbase_investments_part1 gb_investments
    ON japan_investments.company_name = gb_investments.company_name
   AND gb_investments.investor_country_code = 'GBR'
   AND gb_investments.funded_at > japan_investments.funded_at
 WHERE japan_investments.investor_country_code = 'JPN'
 ORDER BY 1        