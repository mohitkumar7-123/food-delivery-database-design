-- ===============================
-- BUSINESS ANALYSIS SQL QUERIES
-- ===============================

-- 1. Monthly Sales Trend
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS total_sales,
    LAG(SUM(total_amount)) OVER (
        ORDER BY DATE_TRUNC('month', order_date)
    ) AS previous_month_sales
FROM orders
GROUP BY 1
ORDER BY 1;


-- 2. Rider Efficiency (Average Delivery Time)
SELECT
    r.rider_name,
    AVG(d.delivery_time) AS avg_delivery_time
FROM deliveries d
JOIN riders r
    ON d.rider_id = r.rider_id
GROUP BY r.rider_name
ORDER BY avg_delivery_time;


-- 3. City-wise Revenue Ranking
SELECT
    c.city,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(o.total_amount) DESC
    ) AS city_rank
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.city;


-- 4. Most Popular Order Items
SELECT
    order_item,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_item
ORDER BY total_orders DESC;


-- 5. Completed vs Pending Deliveries
SELECT
    delivery_status,
    COUNT(*) AS total_deliveries
FROM deliveries
GROUP BY delivery_status;
