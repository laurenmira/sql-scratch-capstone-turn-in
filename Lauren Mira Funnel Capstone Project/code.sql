SELECT *
FROM survey
LIMIT 10;


SELECT question, COUNT (user_id)
FROM survey
GROUP BY questions;


SELECT *
FROM quiz
LIMIT 10;

SELECT *
FROM home_try_on
LIMIT 10;

SELECT *
FROM purchase
LIMIT 10;



1st attempt (incorrect): 
WITH browse as
(SELECT user_id, 
 CASE
  WHEN h.user_id IS NOT NULL THEN 'True'
  ELSE 'False'
  END AS 'is_home_try_on', 
 h.number_of_pairs, 
 CASE
  WHEN p.user_id IS NOT NULL THEN 'True'
  ELSE 'False'
  END AS 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
)
SELECT *
FROM browse
LIMIT 10;


CORRECT WAY: 
SELECT q.user_id, 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
LIMIT 10; 


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 )
SELECT COUNT (*) as 'num_quiz_takers', SUM(is_home_try_on) as 'num_home_try_on', 
SUM (is_purchase) as 'num_purchase'
FROM conversions;


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 )
SELECT COUNT (*) as 'num_quiz_takers', SUM(is_home_try_on) as 'num_home_try_on', 
1.0 * SUM (is_home_try_on) / COUNT (*) as 'home_try_on_pct', 
SUM (is_purchase) as 'num_purchase', 
1.0 * SUM (is_purchase) / SUM (is_home_try_on) as 'purchase_pct'
FROM conversions;


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 )
SELECT COUNT (*) as 'num_quiz_takers', SUM(is_home_try_on) as 'num_home_try_on', 
1.0 * SUM (is_home_try_on) / COUNT (*) as 'home_try_on_pct', 
SUM (is_purchase) as 'num_purchase', 
1.0 * SUM (is_purchase) / SUM (is_home_try_on) as 'purchase_pct',
1.0 * SUM (is_purchase) / COUNT (*) as 'overall_purchase_pct'
FROM conversions;


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 ),
total_numbers AS (
  SELECT COUNT (*) as 'num_quiz_takers', SUM(is_home_try_on) as 'num_home_try_on', 
SUM (is_purchase) as 'num_purchase'
FROM conversions
  )
SELECT *
FROM total_numbers; 


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 WHERE number_of_pairs LIKE '3 pairs'
)
SELECT COUNT (*) as 'num_quiz_takers', SUM(is_home_try_on) as 'num_home_try_on', 
1.0 * SUM (is_home_try_on) / COUNT (*) as 'home_try_on_pct', 
SUM (is_purchase) as 'num_purchase', 
1.0 * SUM (is_purchase) / SUM (is_home_try_on) as 'purchase_pct',
1.0 * SUM (is_purchase) / COUNT (*) as 'overall_purchase_pct'
FROM conversions;


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 WHERE number_of_pairs LIKE '5 pairs'
)
SELECT COUNT (*) as 'num_quiz_takers', SUM(is_home_try_on) as 'num_home_try_on', 
1.0 * SUM (is_home_try_on) / COUNT (*) as 'home_try_on_pct', 
SUM (is_purchase) as 'num_purchase', 
1.0 * SUM (is_purchase) / SUM (is_home_try_on) as 'purchase_pct',
1.0 * SUM (is_purchase) / COUNT (*) as 'overall_purchase_pct'
FROM conversions;


WITH null_pair_conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_null_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 WHERE number_of_pairs IS NULL
)
SELECT COUNT (*) as 'num_quiz_takers', SUM(is_null_home_try_on) as 'null_num_home_try_on', 
1.0 * SUM (is_null_home_try_on) / COUNT (*) as 'null_home_try_on_pct', 
SUM (is_purchase) as 'null_num_purchase', 
1.0 * SUM (is_purchase) / SUM (is_null_home_try_on) as 'null_try_on_purchase_pct',
1.0 * SUM (is_purchase) / COUNT (*) as 'overall_null_try_on_purchase_pct'
FROM null_pair_conversions;


WITH conversions AS
(SELECT DISTINCT (q.user_id), 
 h.user_id IS NOT NULL as 'is_home_try_on', 
 h.number_of_pairs, 
 p.user_id IS NOT NULL as 'is_purchase'
FROM quiz as 'q'
LEFT JOIN home_try_on as 'h'
ON q.user_id = h.user_id
LEFT JOIN purchase as 'p'
ON h.user_id = p.user_id
 )
SELECT count (*), 
SUM (is_home_try_on) as 'num_home_try_on', 
SUM (is_purchase) as 'num_purchase'
FROM conversions
WHERE number_of_pairs IS NULL;

____________________
select style, fit, shape, color, COUNT (user_id) 
from quiz
GROUP BY style;

SELECT color, COUNT ( 
  CASE 
   WHEN shape = 'No Preference' THEN user_id
   WHEN shape = 'Rectangular' THEN user_id
  WHEN shape = 'Round' THEN user_id
  WHEN shape = 'Square' THEN user_id
  END 
  ) AS shape_options, 
 COUNT (
  CASE 
   WHEN fit = 'Medium' THEN user_id
   WHEN fit = 'Narrow' THEN user_id
   WHEN fit = 'Wide' THEN user_id
   ELSE NULL 
  END
 ) AS fit_options 
FROM quiz
GROUP BY 1;
______________________

SELECT product_id, *, COUNT (user_id)
FROM purchase
GROUP BY product_id
ORDER BY COUNT (product_id) DESC;



