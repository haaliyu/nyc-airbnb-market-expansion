SELECT *
FROM airbnb_market_expansion.ab_nyc_2019;

-- CHECK FOR DUPLICATES

SELECT *, row_number() over(partition by id, name, host_id, host_name, neighbourhood_group, neighbourhood, latitude, longitude, room_type, price,
minimum_nights, number_of_reviews, last_review, reviews_per_month, calculated_host_listings_count, availability_365) Row_num
FROM airbnb_market_expansion.ab_nyc_2019;


WITH dup_CTE AS 
(
SELECT *, row_number() over(partition by id, name, host_id, host_name, neighbourhood_group, neighbourhood, latitude, longitude, room_type, price,
minimum_nights, number_of_reviews, last_review, reviews_per_month, calculated_host_listings_count, availability_365) Row_num
FROM airbnb_market_expansion.ab_nyc_2019
)
SELECT *
FROM dup_CTE
WHERE Row_num > 1;

-- CREATE DUPLICATE TABLE

CREATE TABLE ab_nyc_2019_duplicate
LIKE ab_nyc_2019;

-- INSERT DATA

INSERT ab_nyc_2019_duplicate
SELECT *
FROM ab_nyc_2019;

SELECT *
FROM airbnb_market_expansion.ab_nyc_2019_duplicate;

-- CLEAN DATA AND UPDATE TABLE

SELECT name, TRIM(BOTH '*' FROM name)
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
;

SELECT name,
concat(
UPPER(LEFT(name, 1)), 
LOWER(SUBSTRING(name, 2))
) 
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
;

SELECT name,
concat(
UPPER(LEFT(TRIM(BOTH '*' FROM name), 1)), 
LOWER(SUBSTRING(TRIM(BOTH '*' FROM name), 2))
) Name
FROM airbnb_market_expansion.ab_nyc_2019_duplicate 

;

UPDATE ab_nyc_2019_duplicate 
SET name = 
concat(
UPPER(LEFT(TRIM(BOTH '*' FROM name), 1)), 
LOWER(SUBSTRING(TRIM(BOTH '*' FROM name), 2))
) 

;

SELECT name, TRIM(name)
FROM airbnb_market_expansion.ab_nyc_2019_duplicate;

UPDATE ab_nyc_2019_duplicate 
SET name = TRIM(name);

SELECT name,
concat(
UPPER(LEFT(name, 1)),
LOWER(SUBSTRING(name, 2))
) Name
FROM ab_nyc_2019_duplicate 
;

UPDATE ab_nyc_2019_duplicate 
SET name = concat(
UPPER(LEFT(name, 1)),
LOWER(SUBSTRING(name, 2))
);

-- REPLACING EMPTY SPACES WITH ZERO

SELECT *
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
WHERE last_review = ''
AND reviews_per_month = '';


SELECT name, last_review, reviews_per_month,
CASE
WHEN last_review = '' THEN 0
ELSE last_review
END AS Cleaned_last_reviews ,

CASE
WHEN reviews_per_month = '' THEN 0
ELSE reviews_per_month
END AS Cleaned_reviews_per_month

FROM airbnb_market_expansion.ab_nyc_2019_duplicate

WHERE last_review = ''
AND reviews_per_month = '';

UPDATE ab_nyc_2019_duplicate 
SET last_review = 
CASE
WHEN last_review = '' THEN 0
ELSE last_review
END,
reviews_per_month =
CASE
WHEN reviews_per_month = '' THEN 0
ELSE reviews_per_month
END
WHERE last_review = ''
OR reviews_per_month = '';

UPDATE ab_nyc_2019_duplicate 
SET last_review = NULL
WHERE last_review = 0;


SELECT *
FROM airbnb_market_expansion.ab_nyc_2019_duplicate;

-- EXPLORATORY ANALYSIS

-- Listing
SELECT neighbourhood_group, neighbourhood, COUNT(*) Total_listings
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
GROUP BY neighbourhood_group, neighbourhood
ORDER BY Total_listings DESC ;

-- Pricing
SELECT neighbourhood_group, neighbourhood, price,
AVG(price) OVER(PARTITION BY neighbourhood) Avg_neighbourhood_pricing,
COUNT(*) OVER(PARTITION BY neighbourhood) neighbourhood_listing
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
ORDER BY  Avg_neighbourhood_pricing DESC ;

-- Demand (reviews)
SELECT neighbourhood_group, neighbourhood,
reviews_per_month,
AVG(reviews_per_month) OVER(PARTITION BY neighbourhood) Avg_neighbourhood_review
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
ORDER BY  Avg_neighbourhood_review DESC ;

-- High demand plus low listing(Supply)
SELECT neighbourhood_group, neighbourhood, COUNT(*) Total_listings, AVG(reviews_per_month) Avg_review
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
GROUP BY neighbourhood_group, neighbourhood
HAVING Total_listings < 10 AND Avg_review > 2
ORDER BY Total_listings ASC, Avg_review DESC ;

-- High demand plus low listing with individual average price (Target expansion opportunities)
SELECT neighbourhood_group Borough, neighbourhood, COUNT(*) Total_listings, AVG(reviews_per_month) Avg_review, AVG(price) Avg_nightly_price
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
GROUP BY neighbourhood_group, neighbourhood
HAVING Total_listings < 10 AND Avg_review > 2
ORDER BY Total_listings ASC, Avg_review DESC ;
 
 -- Borough summary overview
SELECT neighbourhood_group Borough, COUNT(*) Total_listings, ROUND(AVG(price)) Avg_price, ROUND(AVG(reviews_per_month)) Avg_review
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
GROUP BY neighbourhood_group
ORDER BY Total_listings DESC ;

-- High supply/saturated markets (The basline benchmark) 
SELECT neighbourhood_group Borough, neighbourhood, COUNT(*) Total_listings, ROUND(AVG(price)) Avg_price, ROUND(AVG(reviews_per_month)) Avg_review
FROM airbnb_market_expansion.ab_nyc_2019_duplicate
GROUP BY neighbourhood_group, neighbourhood
ORDER BY Total_listings DESC 

;


