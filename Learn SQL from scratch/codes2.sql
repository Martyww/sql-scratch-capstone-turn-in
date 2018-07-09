/* assigment one: How many campaigns and sources does CoolTShirts use? Which source is used for each campaign? */

/* First Query shows the number of distinct campaigns */ 

SELECT COUNT(distinct utm_campaign)as 'campaign count'
FROM page_visits;

/* second Query shows the number of distinct sources */ 

SELECT COUNT(distinct utm_source) as 'Source count'
FROM page_visits;

/* last Query shows the relationship between utm_campaign and utm_source */ 

SELECT distinct utm_campaign as 'Campaign', 
		utm_source as 'Source'
FROM page_visits;





/* assigment two: What pages are on their website? */
SELECT DISTINCT page_name
FROM page_visits;




/* assigment three: How first touches is each campaign responsible for?*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT  ft_attr.utm_source,       				
				ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 2
ORDER BY 3 DESC;




/* assigment four: How many last touches is each campaign responsible for?*/

/* Temp table that selects last timestamp per user ID*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
    /* ft_attr ads source and campaign to lasst_touch
Joins on user ID and last touch - timestamp */
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
/* select and counts rows where last touch is associated
with source and campaign*/
SELECT  lt_attr.utm_source AS 'Source',       				
				lt_attr.utm_campaign 'Count',
       COUNT(*)
FROM lt_attr
GROUP BY 2
ORDER BY 3 DESC;




/* assigment five: How many visitors make a purchase?*/

/* counts visitors who made a purchase */

SELECT page_name,
	COUNT (DISTINCT user_id) AS 'Number users that purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

/* query to count users that viseted each page  */
SELECT page_name,
	COUNT (DISTINCT user_id) AS 'Number of users who visit page'
FROM page_visits
GROUP BY 1;




/* assigment six: How many last touches on the purchase page is each campaign responsible for?*/

/* Temp table that selects last timestamp per user ID*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  /* adds a 'where' clause */
  	WHERE page_name = '4 - purchase' 
    GROUP BY user_id),
/* ft_attr ads source and campaign to lasst_touch
Joins on user ID and last touch - timestamp */
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
/* select and counts rows where last touch is associated
with source and campaign*/
SELECT  lt_attr.utm_source AS 'Source',       				
				lt_attr.utm_campaign AS 'Campaign',
       COUNT(*)
FROM lt_attr
GROUP BY 2
ORDER BY 3 DESC;