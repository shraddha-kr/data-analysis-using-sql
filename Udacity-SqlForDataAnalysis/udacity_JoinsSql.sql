--Joins
SELECT *
  -- orders.*, accounts.*
  FROM accounts
  JOIN orders
    ON accounts.id = orders.account_id;

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
  FROM accounts
  JOIN orders
    ON accounts.id = orders.account_id;


--Quiz Joins
-- 1.
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
  FROM web_events w
  JOIN accounts a
    ON w.account_id = a.id
 WHERE a.name = 'Walmart';

 -- 2.
 SELECT r.name region, sr.name salesrep, a.name account
   FROM sales_reps sr
   JOIN region r
     ON sr.region_id = r.id
   JOIN accounts a
     ON a.sales_rep_id = sr.id
ORDER BY a.name ASC;

-- 3.
SELECT r.name region, a.name account,
       o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

-- Quiz
-- 1.
SELECT r.name region, sr.name salesrep, a.name account
  FROM sales_reps sr
  JOIN region r
    ON sr.region_id = r.id
    AND r.name = 'Midwest'
  JOIN accounts a
    ON a.sales_rep_id = sr.id
ORDER BY a.name ASC;

-- 2.
SELECT r.name region, sr.name salesrep, a.name account
  FROM sales_reps sr
  JOIN region r
    ON sr.region_id = r.id
    AND r.name = 'Midwest'
  JOIN accounts a
    ON a.sales_rep_id = sr.id
    AND sr.name LIKE 'S%'
ORDER BY a.name ASC;

-- 3.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

-- 4.
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

--- Quiz - GROUPBY
--1.
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;
--2.
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;
--3.
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;
