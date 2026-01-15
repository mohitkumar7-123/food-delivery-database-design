-- INSERT data 

INSERT INTO customers (customer_name, reg_date, city)
SELECT
    'Customer_' || gs,
    DATE '2023-01-01' + (random() * 1460)::INT,
    (ARRAY['Mumbai','Delhi','Bengaluru','Hyderabad','Pune',
           'Chennai','Kolkata','Ahmedabad','Jaipur','Chandigarh'])
           [FLOOR(random()*10)+1]
FROM generate_series(1,10000) gs;


INSERT INTO restaurants (restaurant_name, city, opening_hours, join_date)
SELECT
    'Restaurant_' || gs,
    (ARRAY['Mumbai','Delhi','Bengaluru','Hyderabad','Pune',
           'Chennai','Kolkata','Ahmedabad','Jaipur','Chandigarh'])
           [FLOOR(random()*10)+1],
    '10AM-11PM',
    DATE '2022-01-01' + (random() * 1825)::INT
FROM generate_series(1,1000) gs;


INSERT INTO riders (rider_name, sign_up_date, city)
SELECT
    'Rider_' || gs,
    DATE '2022-01-01' + (random() * 1825)::INT,
    (ARRAY['Mumbai','Delhi','Bengaluru','Hyderabad','Pune',
           'Chennai','Kolkata','Ahmedabad','Jaipur','Chandigarh'])
           [FLOOR(random()*10)+1]
FROM generate_series(1,2000) gs;


INSERT INTO orders (
    customer_id,
    restaurant_id,
    order_item,
    order_date,
    order_time,
    order_status,
    total_amount
)
SELECT
    (random() * 9999 + 1)::INT AS customer_id,
    (random() * 999 + 1)::INT AS restaurant_id,

    -- restaurant-specific menu
    'Restaurant_' || r_id || '_Item_' || (random()*5 + 1)::INT AS order_item,

    -- order date between 2023 and 2026
    DATE '2023-01-01' + (random() * 1460)::INT AS order_date,

    -- peak-hour biased order time
    CASE
        WHEN random() < 0.5 THEN
            TIME '12:00' + (random() * INTERVAL '3 hours')   -- lunch
        WHEN random() < 0.85 THEN
            TIME '19:00' + (random() * INTERVAL '3 hours')   -- dinner
        ELSE
            TIME '09:00' + (random() * INTERVAL '12 hours')  -- off-peak
    END AS order_time,

    -- order status distribution
    CASE
        WHEN random() < 0.78 THEN 'completed'
        WHEN random() < 0.90 THEN 'cancelled'
        ELSE 'pending'
    END AS order_status,

    -- realistic order value
    ROUND(150 + random() * 850, 2) AS total_amount

FROM (
    SELECT generate_series(1,450000) AS gs,
           (random() * 999 + 1)::INT AS r_id
) t;


INSERT INTO deliveries (
    order_id,
    delivery_status,
    delivery_time,
    rider_id
)
SELECT
    o.order_id,

    CASE
        WHEN random() < 0.85 THEN 'delivered'
        WHEN random() < 0.95 THEN 'delayed'
        ELSE 'not_assigned'
    END AS delivery_status,

    -- delivery time (15–45 mins typical)
    o.order_time +
    CASE
        WHEN random() < 0.6 THEN INTERVAL '15 minutes'
        WHEN random() < 0.9 THEN INTERVAL '25 minutes'
        ELSE INTERVAL '45 minutes'
    END AS delivery_time,

    (random() * 1999 + 1)::INT AS rider_id

FROM orders o
WHERE o.order_status IN ('completed', 'cancelled')
AND random() < 0.93;   -- some orders never reach delivery stage


SELECT * FROM customers
SELECT * FROM deliveries
SELECT * FROM orders 
SELECT * FROM restarurants
SELECT * FROM riders

--Identify inactive restaurants:
SELECT r.restaurant_id, r.restaurant_name
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
AND o.order_date >= CURRENT_DATE - INTERVAL '1 year'
WHERE o.order_id IS NULL;


--Delivery before order
SELECT *
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
WHERE d.delivery_time < o.order_time;


--Fix NULL rider for delivered orders:
UPDATE deliveries
SET rider_id = (
    SELECT rider_id FROM riders ORDER BY random() LIMIT 1
)
WHERE rider_id IS NULL
AND delivery_status = 'delivered';


--FINDING NULL
SELECT COUNT(*) 
FROM customers
WHERE customer_name IS NULL
or 
reg_date IS NULL


SELECT COUNT(*)
FORM rest
WHERE customer_name IS NULL
 OR 
 reg_date is null
 


WITH innvalid_date AS 
(SELECT *,
CASE
    WHEN sign_up_date > CURRENT_DATE THEN 'FUTURE_DATE'
    WHEN sign_up_date < DATE '2000-01-01' THEN 'INVALID_OLD_DATE'
    ELSE 'VALID'
END AS date_quality
FROM riders)
SELECT * FROM innvalid_date
WHERE date_quality = 'FUTURE_DATE'
OR date_quality = 'INVALID_OLD_DATE';



SELECT sign_up_date,
CASE
    WHEN sign_up_date::TEXT ~ '^\d{4}-\d{2}-\d{2}$' THEN 'YYYY-MM-DD'
    WHEN sign_up_date::TEXT ~ '^\d{2}-\d{2}-\d{4}$' THEN 'DD-MM-YYYY'
    WHEN sign_up_date::TEXT ~ '^\d{4}/\d{2}/\d{2}$' THEN 'YYYY/MM/DD'
    ELSE 'INVALID_DATE'
END AS date_format
FROM riders;


-- Write a query to fnd the top 5 most frequent ordered 
-- dished by customer called "Customer_8063" in the last 1 year

SELECT * FROM customers
SELECT * FROM orders 


SELECT c.customer_name,c.customer_id,o.order_item,
COUNT(*) AS order_frequency
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id 
WHERE o.order_status = 'completed'
GROUP BY 1,2,3
ORDER BY  order_frequency DESC;


WITH customer_frequency AS(
SELECT c.customer_name,c.customer_id,
o.order_item,
COUNT(*) as order_frequency,
DENSE_RANK () OVER (ORDER BY COUNT(*) DESC) AS rank 
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id 
WHERE o.order_date>= CURRENT_DATE - INTERVAL '1 year'
AND c.customer_name = 'Customer_8063'
GROUP BY c.customer_name,c.customer_id,
o.order_item
)
SELECT * FROM 
customer_frequency
WHERE rank = 1
LIMIT 5;

/*2.Popular Time Slop Question : 
Identify the time slots during which the most orders are placed based on 2 hour intervals 
-- do the same how to thing to how to approach*/

--Approach 1 

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00 - 04:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00 - 06:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00 - 08:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00 - 10:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00 - 16:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
        ELSE '22:00 - 24:00'
    END AS time_slot,
    COUNT(*) AS total_orders
FROM orders
GROUP BY time_slot
ORDER BY total_orders DESC;

--Approach 2 

WITH time_slots AS (
    SELECT
        FLOOR(EXTRACT(HOUR FROM order_time) / 2) * 2 AS slot_start_hour
    FROM orders
)
SELECT
    slot_start_hour || ':00 - ' || (slot_start_hour + 2) || ':00' AS time_slot,
    COUNT(*) AS total_orders,
	DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM time_slots
GROUP BY slot_start_hour
ORDER BY total_orders DESC;


--3.Order Value Analysis 
-- Question: Find the average order value per customer who has placed more than 65 orders.
-- Return customer_name,and aov (average order value)

SELECT * FROM orders

SELECT c.customer_name,
ROUND(AVG(o.total_amount),1) as avo
from orders o 
join customers c ON c.customer_id = o.customer_id 
WHERE o.order_status = 'completed'
GROUP BY 1
HAVING  COUNT (order_id) > 50
ORDER BY avo DESC

-- finding the maximunm order by the particular customer 
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(*) as total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC;


-- 4.High-Value Customers 
--  Question : Lists the customers who have spent more than 10000 in total on food orders 
--  return cutomer_name, and customer_id:


 SELECT c.customer_id, c.customer_name,
 ROUND(SUM(o.total_amount),0) AS total_spending,
 COUNT(*) AS total_count
 FROM orders o
 JOIN customers c ON o.customer_id = c.customer_id 
 WHERE order_status = 'completed'
 GROUP BY 1,2
 HAVING ROUND(SUM(o.total_amount),0) > 30000
 ORDER BY total_spending DESC;

 -- 5.ORDER WITHOUT DELIVERY 
 -- QUESTION : WRITE A QUERY TO FIND ORDERS THAT WERE PALCED BUT NOT DELIVERD 
 -- RETURN EACH RESTURANT NAME, CITY AND NUMBER OF NOT DELIVERED ORDERS 

SELECT * FROM restaurants 
SELECT * FROM orders
SELECT * FROM deliveries
WHERE order_id IS NULL;

SELECT r.restaurant_name,r.city, 
 COUNT(o.order_id) AS not_delivered_orders
  FROM restaurants r
  JOIN orders o
  ON o.restaurant_id = r.restaurant_id
  LEFT JOIN deliveries d 
  ON d.order_id = o.order_id
  WHERE d.order_id IS NULL
  GROUP BY r.restaurant_name,r.city
  ORDER BY not_delivered_orders DESC;


-- Q.6 
-- Resturant Revenue Ranking 
-- Rank resturant by their total_revenue from the last year, including their name,
-- total revenue,and rank within their city

SELECT * FROM restaurants 
SELECT * FROM orders

WITH rest_rank AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        r.city,
        SUM(o.total_amount) AS total_revenue,
        DENSE_RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) as rank_in_city
    FROM restaurants r
    JOIN orders o ON r.restaurant_id = o.restaurant_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY r.restaurant_id, r.restaurant_name, r.city
)
SELECT * FROM rest_rank
ORDER BY city, rank_in_city ASC;


--  Q7
--  Most Popular Dish by City 
--  Identitfy the most popular dish in each city based on the number of orders 
SELECT * FROM restaurants 
SELECT * FROM orders

WITH rank_1 AS (
    SELECT 
        r.city,
        o.order_item,  
        COUNT(o.order_time) AS best_dish,
        RANK() OVER (PARTITION BY r.city ORDER BY COUNT(o.order_time) DESC) AS ranks
    FROM orders o
    JOIN restaurants r ON r.restaurant_id = o.restaurant_id
    GROUP BY r.city, o.order_item
)
SELECT *
FROM rank_1
WHERE ranks = 1;

-

-- Q.8 Customer Churn 
-- Find customers who haven't placed an order in 2024 but did not place order in 2025 -- how to approach this 

SELECT DISTINCT(customer_id) 
FROM orders
WHERE EXTRACT(YEAR FROM order_date) =2024
 AND customer_id NOT IN (
SELECT DISTINCT customer_id 
FROM orders 
WHERE EXTRACT(YEAR FROM order_date) = 2025 
)



-- Q9. Cancellation Rate Comparision
-- Calculate and compare the order cancellationn rate for each resturant between the 
-- current year and the previous year

WITH cancel_ratio_2024 AS (
 SELECT o.restaurant_id,
 COUNT (o.order_id) as total_order,
 COUNT (CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
 FROM orders o 
 LEFT JOIN 
 deliveries as d 
 ON o.order_id = d.order_id 
 WHERE EXTRACT(YEAR FROM o.order_date) = 2024
 GROUP BY 1
 ),
 last_year_data AS (
 SELECT
 restaurant_id, total_order, not_delivered,
 ROUND(not_delivered ::numeric /total_order::numeric * 100,1) as ratio
 FROM cancel_ratio_2024
 ),
 cancel_ratio_2025 AS (
 SELECT o.restaurant_id,
 COUNT (o.order_id) as total_order,
 COUNT (CASE WHEN d.delivery_id IS NULL THEN 1 END) not_delivered
 FROM orders o 
 LEFT JOIN 
 deliveries as d 
 ON o.order_id = d.order_id 
 WHERE EXTRACT(YEAR FROM o.order_date) = 2025
 GROUP BY 1
 )
 SELECT
 restaurant_id, total_order, not_delivered,
 ROUND(not_delivered ::numeric /total_order ::numeric * 100,1) AS cancel_ratio
 FROM cancel_ratio_2025

-- Q 10 Rider Average Delivery Time
-- Determine each rider's average delivery time.

select * from riders 
select * from deliveries
select * from orders

SELECT r.rider_id, r.rider_name,
COUNT(*) AS total_deliveries,
ROUND(AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time)) / 60), 2) as avg_delivery_time_minutes
FROM riders r 
JOIN deliveries d ON d.rider_id = r.rider_id 
JOIN orders o ON o.order_id = d.order_id 
GROUP BY r.rider_id, r.rider_name
ORDER BY avg_delivery_time_minutes ASC;

--Q 11 Monthly Resturant Growth Ratio:
--Calculate each resturant's growth ratio based on the total number of delivered orders since its joining 

WITH growth_ratio AS
(
    SELECT
        o.restaurant_id,
        TO_CHAR(o.order_date, 'mm-yy') as month,
        COUNT(o.order_id) as cr_month_orders,
        LAG(COUNT(o.order_id), 1) OVER (PARTITION BY o.restaurant_id ORDER BY TO_CHAR(o.order_date, 'mm-yy')) AS prev_month_orders
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    WHERE d.delivery_status = 'delivered'
    GROUP BY 1, 2
    ORDER BY 1, 2
)
SELECT restaurant_id,
    month,
    prev_month_orders,
    cr_month_orders,
    ROUND(((cr_month_orders::numeric - prev_month_orders::numeric) / prev_month_orders::numeric) * 100,1) as growth_rate
FROM growth_ratio;


-- 12 Customer Segmentation 
-- Customers Segmenntation: Segment customers into 'Gold' or 'Silver' groups based on their total spending 
-- Compared to the average order value (AOV), IF a customer's total spending exceeds the AOV 
-- label them as 'GOLD'; otherwise, label them as 'Silver'. Write an SQL  query to determine each segment's 
-- total number of orders and total revenue 

WITH customer_spending AS (
    SELECT  
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spending,
        CASE 
            WHEN SUM(total_amount) > (SELECT AVG(customer_total) FROM (
                SELECT SUM(total_amount) as customer_total 
                FROM orders 
                GROUP BY customer_id
            ) subq) THEN 'Gold'
            ELSE 'Silver'
        END AS cus_category 
    FROM orders 
    GROUP BY customer_id
)
SELECT 
    cus_category,
    SUM(total_spending) AS total_spent,
    COUNT(customer_id) as total_customers
FROM customer_spending
GROUP BY cus_category
ORDER BY total_spent DESC;

-- Calculate the rider Monthly Earning 
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.

-- select * from riders 

-- select * from  orders 

-- select * from deliveries 
SELECT
    d.rider_id,
    TO_CHAR(o.order_date, 'MM-YYYY') AS month,
    SUM(o.total_amount) AS total_revenue,
    ROUND(SUM(o.total_amount) * 0.08, 2) AS rider_monthly_earning
FROM orders o
JOIN deliveries d 
    ON d.order_id = o.order_id
GROUP BY d.rider_id, month
ORDER BY d.rider_id, month;

 -- Q14. Rider Rating Analysis 
 -- Find the number of 5- star, 4-star, and 3 star rating each rider has 
 -- riders receive this rating based on delivery time.
 -- if orders are delivered less than 15 min of orderes recived time the rider get 5 star rating
 -- if the deliver 15 -20 min they get 4 star  rating 
 -- if they deliver after 20 min they get 3 star rating.

 -- SELECT * FROM deliveries 
 -- SELECT * FROM orders 

WITH delivery_minutes_cte AS (
    SELECT
        d.rider_id,
        EXTRACT(
            EPOCH FROM (
                d.delivery_time - o.order_time +
                CASE 
                    WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day'
                    ELSE INTERVAL '0 day'
                END
            )
        ) / 60 AS delivery_minutes
    FROM orders o
    JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'delivered'
)
SELECT
    rider_id,
    CASE 
        WHEN delivery_minutes < 15 THEN '5 star'
        WHEN delivery_minutes BETWEEN 15 AND 20 THEN '4 star'
        ELSE '3 star'
    END AS stars,
    COUNT(*) AS total_stars
FROM delivery_minutes_cte
GROUP BY
    rider_id,
    stars
ORDER BY
    rider_id,
    stars DESC;

--  Q 15 Order Frequency by Day 
-- Analysis orders frequency per day of the week and identify the peak day for each restaurant 

SELECT *
FROM (
    SELECT
        r.restaurant_name,
        TO_CHAR(o.order_date, 'Day') AS day_name,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER (
            PARTITION BY r.restaurant_name
            ORDER BY COUNT(o.order_id) DESC
        ) AS rank
    FROM orders o
    JOIN restaurants r
        ON r.restaurant_id = o.restaurant_id
    GROUP BY
        r.restaurant_name,
        day_name
) t1
WHERE rank = 1
ORDER BY restaurant_name;


-- Q 16 Customer Lifetime Value (CLV)
--  Calculate the total revenue generated by each customer over  all their orders 

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS clv
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    clv DESC;

-- Q 17 Monthly Sales Trends 
-- indentify sales trends by comparing each month's total sales to the previous months

WITH monthly_sales AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(total_amount) AS total_amount
    FROM orders
    GROUP BY 1, 2
)
SELECT
    year,
    month,
    total_amount,
    LAG(total_amount, 1) OVER (ORDER BY year, month) AS prev_month_sales
FROM monthly_sales
ORDER BY year, month;



-- Q.18 Rider Efficiency 
-- Evaluate the rider efficient by determining average delivery times and identifying those with the lowest and higest average

WITH delivery_minutes_cte AS (
    SELECT
        d.rider_id,
        EXTRACT(
            EPOCH FROM (
                d.delivery_time - o.order_time +
                CASE 
                    WHEN d.delivery_time < o.order_time THEN INTERVAL '1 day'
                    ELSE INTERVAL '0 day'
                END
            )
        ) / 60 AS delivery_minutes
    FROM orders o
    JOIN deliveries d
        ON o.order_id = d.order_id
    WHERE d.delivery_status = 'delivered'
),
avg_delivery AS (
    SELECT
        rider_id,
        ROUND(AVG(delivery_minutes), 2) AS avg_delivery_minutes
    FROM delivery_minutes_cte
    GROUP BY rider_id
)
SELECT
    rider_id,
    avg_delivery_minutes,
    RANK() OVER (ORDER BY avg_delivery_minutes ASC)  AS best_rank,
    RANK() OVER (ORDER BY avg_delivery_minutes DESC) AS worst_rank
FROM avg_delivery
ORDER BY avg_delivery_minutes;


-- Q.19 ORDER ITEM Popularity:
-- Track the popularity of specific order items over time and identify seasonal emand sikes

WITH item_monthly_orders AS (
    SELECT
        o.order_item,
        DATE_TRUNC('month', o.order_date) AS month,
        COUNT(o.order_id) AS total_orders
    FROM orders o
    WHERE o.order_status = 'completed'
    GROUP BY o.order_item, DATE_TRUNC('month', o.order_date)
),
item_seasonal_orders AS (
    SELECT
        order_item,
        month,
        total_orders,
        CASE
            WHEN EXTRACT(MONTH FROM month) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM month) IN (3, 4, 5) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM month) IN (6, 7, 8) THEN 'Monsoon'
            ELSE 'Festive'
        END AS season
    FROM item_monthly_orders
)
SELECT
    order_item,
    season,
    SUM(total_orders) AS seasonal_orders,
    RANK() OVER (
        PARTITION BY season
        ORDER BY SUM(total_orders) DESC
    ) AS popularity_rank
FROM item_seasonal_orders
GROUP BY order_item, season
ORDER BY season, popularity_rank;




-- Q.20 Rank each city based on the total revenue for last year 2024
 WITH city_revenue AS (
    SELECT
        r.city,
        SUM(o.total_amount) AS total_revenue
    FROM orders o
    JOIN restaurants r
        ON r.restaurant_id = o.restaurant_id
    WHERE o.order_status = 'completed'
      AND EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY r.city
)
SELECT
    city,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS city_rank
FROM city_revenue
ORDER BY city_rank;

  







