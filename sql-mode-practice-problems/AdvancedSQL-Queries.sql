-- Advanced SQL--
/*SQL Data Types*/
/*PP 1 - Convert the funding_total_usd and founded_at_clean columns 
in the tutorial.crunchbase_companies_clean_date table to strings 
(varchar format) using a different formatting function for each one. */
SELECT CAST(funding_total_usd AS varchar) AS funding_total_usd_string,
       founded_at_clean::varchar AS founded_at_string
FROM tutorial.crunchbase_companies_clean_date

/*Note that because the companies.founded_at_clean column is stored as a 
string, it must be cast as a timestamp before it can be subtracted from another timestamp.*/
SELECT companies.permalink,
       companies.founded_at_clean,
       acquisitions.acquired_at_cleaned,
       acquisitions.acquired_at_cleaned -
         companies.founded_at_clean::timestamp AS time_to_acquisition
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL
 --you can see that the time_to_acquisition column is an interval, not another date.
 
 /*intervals:: The interval is defined using plain-English terms like '10 seconds'
 or '5 months'. Also note that adding or subtracting a date column and an interval 
 column results in another date column as in the above query.*/
 SELECT companies.permalink,
       companies.founded_at_clean,
       companies.founded_at_clean::timestamp +
         INTERVAL '1 week' AS plus_one_week
  FROM tutorial.crunchbase_companies_clean_date companies
 WHERE founded_at_clean IS NOT NULL

--now 
 SELECT companies.permalink,
       companies.founded_at_clean,
       NOW() - companies.founded_at_clean::timestamp AS founded_time_ago
  FROM tutorial.crunchbase_companies_clean_date companies
 WHERE founded_at_clean IS NOT NULL
 
 /*PP 2 - Write a query that counts the number of companies acquired within 3 years,
 5 years, and 10 years of being founded (in 3 separate columns).
 Include a column for total companies acquired as well. Group by category 
 and limit to only rows with a founding date. */
SELECT * FROM tutorial.crunchbase_companies_clean_date LIMIT 10
SELECT companies.category_code,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
                       THEN 1 ELSE NULL END) AS acquired_3_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
                       THEN 1 ELSE NULL END) AS acquired_5_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
                       THEN 1 ELSE NULL END) AS acquired_10_yrs,
       COUNT(1) AS total
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL
 GROUP BY 1
 ORDER BY 5 DESC

/*Using SQL STring Functions to clean data*/
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01 LIMIT 10
  
--LEFT/RIGHT/LENGTH  
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01
  
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, 17) AS cleaned_time
  FROM tutorial.sf_crime_incidents_2014_01
  
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, LENGTH(date) - 11) AS cleaned_time
  FROM tutorial.sf_crime_incidents_2014_01
  
SELECT location,
       TRIM(both '()' FROM location)
  FROM tutorial.sf_crime_incidents_2014_01  
  
--POSITION and STRPOS  
SELECT incidnt_num,
       descript,
       POSITION('A' IN descript) AS a_position
  FROM tutorial.sf_crime_incidents_2014_01
  
SELECT incidnt_num,
       descript,
       STRPOS(descript, 'A') AS a_position
  FROM tutorial.sf_crime_incidents_2014_01  
  
/*PP - Write a query that separates the `location` field into separate fields for 
latitude and longitude. You can compare your results against the actual `lat` and `lon` 
fields in the table. */
SELECT location,
       TRIM(leading '(' FROM LEFT(location, POSITION(',' IN location) - 1)) AS lattitude,
       TRIM(trailing ')' FROM RIGHT(location, LENGTH(location) - POSITION(',' IN location) ) ) AS longitude
  FROM tutorial.sf_crime_incidents_2014_01
  
--CONCAT
SELECT incidnt_num,
       day_of_week,
       LEFT(date, 10) AS cleaned_date,
       CONCAT(day_of_week, ', ', LEFT(date, 10)) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01 LIMIT 10
  
SELECT CONCAT(lat, ', ', lon) AS loci
FROM tutorial.sf_crime_incidents_2014_01 LIMIT 10
  
--Alternatively, you can use two pipe characters (||) to perform the same concatenation:
SELECT incidnt_num,
       day_of_week,
       LEFT(date, 10) AS cleaned_date,
       day_of_week || ', ' || LEFT(date, 10) AS day_and_date
  FROM tutorial.sf_crime_incidents_2014_01
  
/*PP Create the same concatenated location field, but using the || syntax instead of CONCAT.*/  
SELECT '(' || lat || ', ' || lon || ')' AS concat_location,
       location
  FROM tutorial.sf_crime_incidents_2014_01  
  
/*PP Write a query that creates a date column formatted YYYY-MM-DD. */  
   SELECT incidnt_num,
           date,
           SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS cleaned_date
      FROM tutorial.sf_crime_incidents_2014_01  
  
SELECT incidnt_num,
       address,
       UPPER(address) AS address_upper,
       LOWER(address) AS address_lower
  FROM tutorial.sf_crime_incidents_2014_01
  
/*PP Write a query that returns the `category` field, but with the first letter 
capitalized and the rest of the letters in lower-case. */
SELECT incidnt_num,
       category,
       UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, LENGTH(category) - 1)) AS category_cleaned
  FROM tutorial.sf_crime_incidents_2014_01
  
--Turning strings into dates  
  SELECT incidnt_num,
       date,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2))::date AS cleaned_date
  FROM tutorial.sf_crime_incidents_2014_01
  /*We've wrapped the entire set of concatenated substrings in parentheses and 
  cast the result in the date format. We could also cast it as timestamp, which
  includes additional precision (hours, minutes, seconds).*/
  
/*PP - Write a query that creates an accurate timestamp using the date and time 
columns in tutorial.sf_crime_incidents_2014_01. Include a field that is exactly 1 week later as well. */
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp
        + INTERVAL '1 week' AS timestamp_plus_interval
  FROM tutorial.sf_crime_incidents_2014_01
  
  -- Turning dates into more useful dates
  --You can use EXTRACT to pull the pieces apart one-by-one:
  SELECT cleaned_date,
       EXTRACT('year'   FROM cleaned_date) AS year,
       EXTRACT('month'  FROM cleaned_date) AS month,
       EXTRACT('day'    FROM cleaned_date) AS day,
       EXTRACT('hour'   FROM cleaned_date) AS hour,
       EXTRACT('minute' FROM cleaned_date) AS minute,
       EXTRACT('second' FROM cleaned_date) AS second,
       EXTRACT('decade' FROM cleaned_date) AS decade,
       EXTRACT('dow'    FROM cleaned_date) AS day_of_week
  FROM tutorial.sf_crime_incidents_cleandate
  
/*The DATE_TRUNC function rounds a date to whatever precision you specify. 
The value displayed is the first value in that period.
So when you DATE_TRUNC by year, any value in that year will be listed as January 1st of that year:*/
SELECT cleaned_date,
       DATE_TRUNC('year'   , cleaned_date) AS year,
       DATE_TRUNC('month'  , cleaned_date) AS month,
       DATE_TRUNC('week'   , cleaned_date) AS week,
       DATE_TRUNC('day'    , cleaned_date) AS day,
       DATE_TRUNC('hour'   , cleaned_date) AS hour,
       DATE_TRUNC('minute' , cleaned_date) AS minute,
       DATE_TRUNC('second' , cleaned_date) AS second,
       DATE_TRUNC('decade' , cleaned_date) AS decade
  FROM tutorial.sf_crime_incidents_cleandate
  
/*Write a query that counts the number of incidents reported by week. 
Cast the week as a date to get rid of the hours/minutes/seconds. */
SELECT * FROM tutorial.sf_crime_incidents_cleandate LIMIT 10

SELECT DATE_TRUNC('week'   , cleaned_date)::date AS weekly_incidents,
       COUNT(*) AS incidents
FROM tutorial.sf_crime_incidents_cleandate
GROUP BY weekly_incidents
ORDER BY incidents
  
/* Now time/TimeZones*/
SELECT CURRENT_DATE AS date,
       CURRENT_TIME AS time,
       CURRENT_TIMESTAMP AS timestamp,
       LOCALTIME AS localtime,
       LOCALTIMESTAMP AS localtimestamp,
       NOW() AS now  
  
  
SELECT CURRENT_TIME AS time,
       CURRENT_TIME AT TIME ZONE 'PST' AS time_pst
       
/*Write a query that shows exactly how long ago each indicent was reported. 
Assume that the dataset is in Pacific Standard Time (UTC - 8). */       
SELECT incidnt_num,
       cleaned_date,
       NOW() AT TIME ZONE 'PST' AS now,
       NOW() AT TIME ZONE 'PST' - cleaned_date AS time_ago 
  FROM tutorial.sf_crime_incidents_cleandate LIMIT 2
  
/*COALESCE
Occasionally, you will end up with a dataset that has some nulls that you'd
prefer to contain actual values. This happens frequently in numerical data 
(displaying nulls as 0 is often preferable), and when performing outer joins
that result in some unmatched rows. In cases like this, you can use COALESCE to replace the null values:
*/  
SELECT incidnt_num,
       descript,
       COALESCE(descript, 'No Description')
  FROM tutorial.sf_crime_incidents_cleandate
 ORDER BY descript DESC  
 LIMIT 5
  
  