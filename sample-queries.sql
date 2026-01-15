-- ===============================
# 📖 SQL Queries Reference Guide

Complete documentation of all 20+ queries with explanations, code, and learning outcomes.

---

## Query Index

| # | Query Name | Category | Complexity |
|---|-----------|----------|-----------|
| 1 | Top 5 Frequent Customers | Customer | Medium |
| 2 | Popular Time Slots | Time Analysis | Medium |
| 3 | Average Order Value | Customer | Easy |
| 4 | High-Value Customers | Customer | Easy |
| 5 | Order Frequency | Customer | Easy |
| 6 | Data Quality Check | Validation | Easy |
| 7 | Data Consistency | Validation | Easy |
| 8 | Customer Churn | Customer | Medium |
| 9 | Cancellation Rates | Delivery | Medium |
| 10 | Rider Delivery Time | Rider | Hard |
| 11 | Monthly Growth Ratio | Revenue | Hard |
| 12 | Customer Segmentation | Customer | Medium |
| 13 | Rider Earnings | Rider | Medium |
| 14 | Rider Star Rating | Rider | Medium |
| 15 | Order by Day of Week | Time | Medium |
| 16 | Customer Lifetime Value | Customer | Hard |
| 17 | Monthly Sales Trends | Revenue | Hard |
| 18 | Rider Efficiency Ranking | Rider | Hard |
| 19 | Seasonal Demand | Time | Hard |
| 20 | City Revenue Ranking | Revenue | Hard |

---

## 📊 QUERY 1: Top 5 Frequent Customers

**Business Problem:** Which customers have placed the most orders?

**Complexity:** 🟡 MEDIUM

**Techniques:** CTE, DENSE_RANK, Window Functions
```sql
WITH recent_orders AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) as order_count,
        MAX(o.order_date) as last_order_date
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    order_count,
    last_order_date,
    DENSE_RANK() OVER (ORDER BY order_count DESC) as frequency_rank
FROM recent_orders
WHERE DENSE_RANK() OVER (ORDER BY order_count DESC) <= 5
ORDER BY frequency_rank;
```

**What This Shows:** Your ability to use CTEs, DENSE_RANK, and identify loyal customers.

**Sample Output:**
```
customer_id | customer_name    | order_count | frequency_rank
1          | Priya Sharma    | 125        | 1
5          | Rahul Kumar     | 118        | 2
12         | Amit Patel      | 115        | 3
```

---

## ⏰ QUERY 2: Popular Time Slots

**Business Problem:** When do customers order the most?

**Complexity:** 🟡 MEDIUM

**Techniques:** CASE Statement, EXTRACT, Percentage Calculation
```sql
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_time) >= 12 AND EXTRACT(HOUR FROM order_time) < 14 THEN '12 PM - 2 PM (Lunch)'
        WHEN EXTRACT(HOUR FROM order_time) >= 19 AND EXTRACT(HOUR FROM order_time) < 21 THEN '7 PM - 9 PM (Dinner)'
        ELSE 'Other Hours'
    END as time_slot,
    COUNT(o.order_id) as order_count,
    ROUND(COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER(), 2) as percentage
FROM orders o
GROUP BY time_slot
ORDER BY order_count DESC;
```

**What This Shows:** Time analysis, business insights, conditional logic.

---

## 💰 QUERY 3: Average Order Value

**Business Problem:** What is AOV for customers with 50+ orders?

**Complexity:** 🟢 EASY
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 50
ORDER BY avg_order_value DESC;
```

---

## 💎 QUERY 4: High-Value Customers

**Business Problem:** Who spent >₹10,000 total?

**Complexity:** 🟢 EASY
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as order_count,
    ROUND(SUM(o.total_amount), 2) as lifetime_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 10000
ORDER BY lifetime_value DESC;
```

---

## 📊 QUERY 5: Customer Order Frequency

**Complexity:** 🟡 MEDIUM
```sql
WITH customer_orders AS (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) as order_count
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    CASE 
        WHEN order_count = 0 THEN 'No Orders'
        WHEN order_count BETWEEN 1 AND 10 THEN '1-10 Orders'
        WHEN order_count BETWEEN 11 AND 50 THEN '11-50 Orders'
        WHEN order_count > 50 THEN '50+ Orders'
    END as frequency_bucket,
    COUNT(*) as customer_count
FROM customer_orders
GROUP BY frequency_bucket;
```

---

## 🚫 QUERY 6: Data Quality Check

**Purpose:** Validate no null values in critical fields.

**Complexity:** 🟢 EASY
```sql
SELECT 
    'customers' as table_name,
    COUNT(*) as total_records,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as null_count
FROM customers;
```

---

## 🤔 QUERY 7: Data Consistency

**Purpose:** Check for orphan records.

**Complexity:** 🟢 EASY
```sql
SELECT 
    'Orphan Orders' as issue,
    COUNT(*) as count
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

---

## 👥 QUERY 8: Customer Churn

**Business Problem:** Who hasn't ordered in 3 months?

**Complexity:** 🟡 MEDIUM
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) as last_order_date,
    ROUND((CURRENT_DATE - MAX(o.order_date))::numeric / 30, 1) as months_since_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING MAX(o.order_date) < CURRENT_DATE - INTERVAL '3 months'
ORDER BY last_order_date DESC;
```

---

## ❌ QUERY 9: Cancellation Rates

**Business Problem:** Which riders have highest cancellation rates?

**Complexity:** 🟡 MEDIUM
```sql
SELECT 
    r.rider_id,
    r.rider_name,
    COUNT(d.delivery_id) as total_deliveries,
    SUM(CASE WHEN d.delivery_status = 'Cancelled' THEN 1 ELSE 0 END) as cancelled,
    ROUND(SUM(CASE WHEN d.delivery_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(d.delivery_id), 2) as cancellation_rate
FROM riders r
LEFT JOIN deliveries d ON r.rider_id = d.rider_id
GROUP BY r.rider_id, r.rider_name
ORDER BY cancellation_rate DESC;
```

---

## ⏱️ QUERY 10: Rider Delivery Time

**Business Problem:** Average delivery time per rider?

**Complexity:** 🔴 HARD

**Techniques:** EPOCH, Time Calculations, Window Functions
```sql
SELECT 
    r.rider_id,
    r.rider_name,
    COUNT(d.delivery_id) as deliveries,
    ROUND(AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time)) / 60), 2) as avg_minutes,
    RANK() OVER (ORDER BY AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time))) ASC) as efficiency_rank
FROM riders r
INNER JOIN deliveries d ON r.rider_id = d.rider_id
INNER JOIN orders o ON d.order_id = o.order_id
WHERE d.delivery_status = 'Completed'
GROUP BY r.rider_id, r.rider_name
ORDER BY avg_minutes ASC;
```

**What This Shows:** Advanced time calculations, window functions, ranking.

---

## 📈 QUERY 11: Monthly Growth Ratio

**Business Problem:** Month-over-month sales growth?

**Complexity:** 🔴 HARD

**Techniques:** LAG Window Function, Growth Percentage
```sql
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', o.order_date)::DATE as month,
        SUM(o.total_amount) as total_revenue
    FROM orders o
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) as prev_month,
    ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY month)) * 100.0 / LAG(total_revenue) OVER (ORDER BY month), 2) as growth_percentage
FROM monthly_sales
ORDER BY month DESC;
```

---

## 🎯 QUERY 12: Customer Segmentation

**Business Problem:** Tier customers as Gold/Silver/Bronze?

**Complexity:** 🟡 MEDIUM
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as order_count,
    ROUND(SUM(o.total_amount), 2) as total_spent,
    CASE 
        WHEN SUM(o.total_amount) > 10000 THEN 'Gold'
        WHEN SUM(o.total_amount) > 5000 THEN 'Silver'
        ELSE 'Bronze'
    END as customer_tier
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
```

---

## 💸 QUERY 13: Rider Earnings

**Business Problem:** Monthly earnings with 8% commission?

**Complexity:** 🟡 MEDIUM
```sql
SELECT 
    r.rider_id,
    r.rider_name,
    TO_CHAR(o.order_date, 'YYYY-MM') as month,
    COUNT(d.delivery_id) as deliveries,
    ROUND(SUM(o.total_amount) * 0.08, 2) as rider_commission
FROM riders r
INNER JOIN deliveries d ON r.rider_id = d.rider_id
INNER JOIN orders o ON d.order_id = o.order_id
WHERE d.delivery_status = 'Completed'
GROUP BY r.rider_id, r.rider_name, TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY rider_commission DESC;
```

---

## ⭐ QUERY 14: Rider Star Rating

**Business Problem:** Rate riders: <15min=5⭐, 15-20min=4⭐, >20min=3⭐

**Complexity:** 🟡 MEDIUM
```sql
WITH rider_performance AS (
    SELECT 
        r.rider_id,
        r.rider_name,
        ROUND(AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time)) / 60), 2) as avg_minutes
    FROM riders r
    INNER JOIN deliveries d ON r.rider_id = d.rider_id
    INNER JOIN orders o ON d.order_id = o.order_id
    WHERE d.delivery_status = 'Completed'
    GROUP BY r.rider_id, r.rider_name
)
SELECT 
    rider_id,
    rider_name,
    avg_minutes,
    CASE 
        WHEN avg_minutes < 15 THEN '⭐⭐⭐⭐⭐ (5 stars)'
        WHEN avg_minutes BETWEEN 15 AND 20 THEN '⭐⭐⭐⭐ (4 stars)'
        ELSE '⭐⭐⭐ (3 stars)'
    END as rating
FROM rider_performance
ORDER BY avg_minutes ASC;
```

---

## 📅 QUERY 15: Order Frequency by Day

**Business Problem:** Which day has most orders?

**Complexity:** 🟡 MEDIUM
```sql
SELECT 
    TO_CHAR(o.order_date, 'Day') as day_of_week,
    COUNT(o.order_id) as order_count,
    ROUND(SUM(o.total_amount), 2) as daily_revenue
FROM orders o
GROUP BY TO_CHAR(o.order_date, 'Day')
ORDER BY order_count DESC;
```

---

## 💎 QUERY 16: Customer Lifetime Value

**Business Problem:** Total revenue per customer?

**Complexity:** 🔴 HARD
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    ROUND(SUM(o.total_amount), 2) as lifetime_value,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) as value_rank
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY lifetime_value DESC;
```

---

## 📊 QUERY 17: Monthly Sales Trends

**Business Problem:** Show month-over-month trends?

**Complexity:** 🔴 HARD
```sql
WITH monthly_metrics AS (
    SELECT 
        DATE_TRUNC('month', o.order_date)::DATE as month,
        COUNT(o.order_id) as order_count,
        SUM(o.total_amount) as total_revenue
    FROM orders o
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT 
    month,
    order_count,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) as prev_month,
    ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY month)) * 100.0 / LAG(total_revenue) OVER (ORDER BY month), 2) as growth_percentage
FROM monthly_metrics
ORDER BY month DESC;
```

---

## 🏍️ QUERY 18: Rider Efficiency Ranking

**Business Problem:** Rank riders best to worst?

**Complexity:** 🔴 HARD
```sql
WITH rider_stats AS (
    SELECT 
        r.rider_id,
        r.rider_name,
        COUNT(d.delivery_id) as total_deliveries,
        ROUND(AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time)) / 60), 2) as avg_time
    FROM riders r
    LEFT JOIN deliveries d ON r.rider_id = d.rider_id
    LEFT JOIN orders o ON d.order_id = o.order_id
    GROUP BY r.rider_id, r.rider_name
)
SELECT 
    rider_id,
    rider_name,
    total_deliveries,
    avg_time,
    RANK() OVER (ORDER BY avg_time ASC) as best_rank,
    RANK() OVER (ORDER BY avg_time DESC) as worst_rank
FROM rider_stats
ORDER BY avg_time ASC;
```

---

## 🌍 QUERY 19: Seasonal Demand

**Business Problem:** Most popular items by season?

**Complexity:** 🔴 HARD
```sql
WITH seasonal AS (
    SELECT 
        order_item,
        CASE 
            WHEN EXTRACT(MONTH FROM order_date) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM order_date) IN (3,4,5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM order_date) IN (6,7,8) THEN 'Summer'
            ELSE 'Autumn'
        END as season,
        COUNT(order_id) as count
    FROM orders
    GROUP BY order_item, season
)
SELECT 
    season,
    order_item,
    count,
    RANK() OVER (PARTITION BY season ORDER BY count DESC) as rank
FROM seasonal
WHERE RANK() OVER (PARTITION BY season ORDER BY count DESC) <= 5
ORDER BY season, rank;
```

---

## 🏙️ QUERY 20: City Revenue Ranking

**Business Problem:** City revenue rankings?

**Complexity:** 🔴 HARD
```sql
WITH city_revenue AS (
    SELECT 
        r.city,
        COUNT(o.order_id) as orders,
        SUM(o.total_amount) as revenue
    FROM orders o
    INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
    GROUP BY r.city
)
SELECT 
    city,
    orders,
    ROUND(revenue, 2) as revenue,
    RANK() OVER (ORDER BY revenue DESC) as revenue_rank
FROM city_revenue
ORDER BY revenue DESC;
```

---

## 🎓 Skills Demonstrated

✓ SQL Fundamentals
✓ Joins (INNER, LEFT, FULL)
✓ Aggregations (COUNT, SUM, AVG)
✓ Window Functions
✓ CTEs (Common Table Expressions)
✓ CASE Statements
✓ Date/Time Functions
✓ Business Analysis
✓ Data Modeling

---

## 🚀 How to Use

1. Copy any query
2. Run in PostgreSQL
3. Modify WHERE/GROUP BY as needed
4. Experiment and learn!

---

**Happy SQL Learning!** 🎉
