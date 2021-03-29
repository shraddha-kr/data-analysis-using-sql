--ERD Fundamentals
/*A column name in the Parch & Posey database.
primary_poc
A table name in the Parch & Posey database.
web_events
A collection of tables that share connected data stored in a computer.
Database
A diagram that shows how data is structured in a database.
ERD
A language that allows us to access data stored in a database.
SQL
*/
--LIMIT
select occurred_at, account_id, channel
from web_events
limit 15;

--ORDER BY
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at ASC
LIMIT 10

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd ASC
LIMIT 20

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id ASC, total_amt_usd DESC

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id ASC

-- WHERE
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10

--WHERE NON-NUMERIC
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil'

--ARITHMETIC OPERATORS
-- Be careful to receive an error which occurs because at least one of the values
-- in the data creates a division by zero in your formula.
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id,
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;

-- LIKE
SELECT name
FROM accounts
WHERE name LIKE 'C%';

SELECT name
FROM accounts
WHERE name LIKE '%one%';

SELECT name
FROM accounts
WHERE name LIKE '%s';

-- IN
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

-- NOT IN
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

-- NOT LIKE
SELECT *
FROM accounts
WHERE name NOT LIKE 'c%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%s';
/*
using ORDER BY in a SQL query only has temporary effects, for the results of that query,
unlike sorting a sheet by column in Excel or Sheets.
The ORDER BY statement always comes in a query after the SELECT and
FROM statements, but
before the LIMIT statement. If you are using the LIMIT statement, it will always appear last. As you learn additional commands, the order of these statements will matter more.
Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators.
Remember PEMDAS from math class to help remember the order of operations
LIKE This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
IN This allows you to perform operations similar to using WHERE and =, but for more than one condition.
NOT This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
AND & BETWEEN These allow you to combine operations where all combined conditions must be true.
OR This allows you to combine operations where at least one of the combined conditions must be true.
*/
-- Quiz AND and BETWEEN
select * from orders
where standard_qty > 1000
and poster_qty = 0
and gloss_qty = 0;

--As we mentioned earlier, the ILIKE operator is used in the same way as the LIKE operator. The difference is that ILIKE allows you to perform case-insensitive pattern matching
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

-- When you use BETWEEN operator, do the results include the values of your endpoints.
select occurred_at, gloss_qty from orders
where gloss_qty between 24 and 29
order by 2

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords')
--AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
AND EXTRACT(YEAR FROM occurred_at) = 2016
ORDER BY occurred_at DESC;

-- Quiz:: OR OPERATOR
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0
AND
gloss_qty > 1000
OR
poster_qty > 1000;

SELECT name
FROM accounts
WHERE name LIKE 'C%'
OR name LIKE 'W%'
AND primary_poc LIKE '%ana%'
OR primary_poc LIKE '%Ana%'
AND primary_poc NOT LIKE '%eana%';
