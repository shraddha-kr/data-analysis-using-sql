--Quiz: LEFT & RIGHT
-- 1.
select distinct right(website, 3), count(*)
from accounts
group by 1;

-- 2.
select left(name, 1), count(*)
from accounts
group by 1;

--3.
select sum(num) nums, sum(letter) letters,
      case when left(name, 1) like '[Aa-Zz]' then 1 else 0 end as letter,
      case when left(name, 1) like '[0-9]' then 1 else 0 end as num
from accounts
