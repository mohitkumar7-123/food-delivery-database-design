# 🍕 Food Delivery Database Design (PostgreSQL)

## 📋 Project Overview

A **real-world relational database & analytics project** designed for a food delivery platform (Zomato/Swiggy style).

This project demonstrates **data modeling, SQL querying, and business analysis skills** expected from a professional Data Analyst.

**Live Analytics:** 880,500+ records | 20+ SQL queries | 5 interconnected tables

---

## 🎯 Project Objective

To design a scalable and analytics-ready database that enables:

- ## 🎯 Key Highlights of This Project

This project demonstrates a structured analytical approach following industry best practices:

### 📊 Business Problem
- Design a scalable database for food delivery analytics
- Enable real-time insights into customer behavior, revenue trends, and operational efficiency
- Support data-driven decision making for business growth

### 🔍 EDA Methodology
- **Exploratory Data Analysis** of 450,000+ order records
- Data quality validation and consistency checks
- Relationship mapping between customers, restaurants, riders, and deliveries
- Trend analysis across multiple dimensions (time, location, customer segments)

### 💡 Insight Generation
This project extracts **20+ actionable insights**:
- Customer segmentation (Gold/Silver/Bronze tiers)
- Peak ordering times and seasonal patterns
- Rider performance metrics and efficiency rankings
- City-wise revenue distribution
- Monthly growth trends and MoM comparisons
- Customer churn identification and retention opportunities

### 📈 Conclusion & Recommendations
**Key Findings:**
- Peak orders occur at 12-2 PM (Lunch) and 7-9 PM (Dinner) - allocate resources accordingly
- Top 5% of customers (Gold tier) generate 40% of revenue - focus retention efforts
- Rider efficiency varies 15-45 minutes - identify best practices from top performers
- Weekend orders are 30-40% higher - plan inventory and staffing accordingly
- Mumbai, Bangalore, Delhi contribute 85% of total revenue

**Recommendations:**
- Implement dynamic pricing during peak hours
- Create loyalty programs for Gold tier customers
- Share best practices from top riders to improve overall delivery speed
- Expand operations in high-revenue cities
- Launch seasonal campaigns based on demand patterns


## 📂 Database Entities

| Table | Records | Purpose |
|-------|---------|---------|
| **customers** | 10,000 | Customer details, registration date, location |
| **restaurants** | 1,000 | Restaurant info, opening hours, onboarding date |
| **orders** | 450,000 | Order transactions, items, amounts, status |
| **riders** | 2,000 | Delivery partner information |
| **deliveries** | 418,500 | Delivery status, timing, performance metrics |


## 🛠️ Tech Stack

- **Database:** PostgreSQL (Relational Database)
- **Language:** SQL (Advanced)
- **Techniques:** 
  - Window Functions (RANK, DENSE_RANK, LAG, ROW_NUMBER)
  - Common Table Expressions (CTEs)
  - Complex Joins (INNER, LEFT, FULL)
  - Aggregations & GROUP BY
  - Date/Time Functions
  - Subqueries & Nested Queries
  - CASE Statements
  - Performance Optimization

---

## 📊 Business Questions Solved

This project answers **20+ analytical questions:**

### Customer Analysis
1. Top 5 most frequent customers in last year
2. Average Order Value for customers with 50+ orders
3. High-value customers (>₹10K lifetime spend)
4. Customer segmentation (Gold/Silver tiers)
5. Customer lifetime value analysis
6. Customer churn analysis

### Order & Time Analysis
7. Popular time slots for ordering
8. Order frequency by day of week
9. Monthly sales trends (Month-over-Month growth)
10. Peak ordering hours
11. Seasonal demand patterns

### Restaurant & Revenue
12. Restaurant monthly growth ratios
13. City-wise revenue ranking
14. Top performing restaurants

### Rider & Delivery
15. Rider average delivery time
16. Rider efficiency ranking (fastest to slowest)
17. Delivery cancellation rates
18. Rider monthly earnings (8% commission)
19. Rider performance star rating system
20. Delivery completion vs pending analysis

---

## 📁 Repository Contents
```
food-delivery-database-design/
├── README.md                      # This file - Project overview
├── QUERIES.md                     # Detailed query explanations (20+ queries)
├── schema.sql                     # Database schema & table definitions
├── sample-queries.sql             # All analytical SQL queries
├── er-diagram.png                 # ER diagram visualization
└── LICENSE                        # MIT License
```

---

## 🔍 How to Explore This Project

### Option 1: View Database Schema
- Click [schema.sql](./schema.sql)
- See how tables are structured
- Understand primary/foreign keys

### Option 2: View All Queries
- Click [sample-queries.sql](./sample-queries.sql)
- Browse 20+ SQL queries
- Copy any query to run locally

### Option 3: Read Detailed Explanations
- Click [QUERIES.md](./QUERIES.md)
- See every query explained
- Understand business logic
- Learn SQL techniques

### Option 4: See ER Diagram
- Click [er-diagram.png](./er-diagram.png)
- Visual representation of tables
- Understand relationships

---

## 📈 Key Insights Discovered

### Revenue Metrics
- 💰 **Total Orders:** 450,000+
- 📊 **Total Revenue:** Multi-city analysis with city-wise breakdown
- 📍 **Peak Cities:** Mumbai, Bangalore, Delhi (top revenue generators)

### Customer Metrics
- 👥 **Total Customers:** 10,000
- 🎯 **Gold Customers:** (>₹10K spend) - High-value segment
- 📊 **Average Order Value:** ₹500+

### Delivery Metrics
- 🏍️ **Total Riders:** 2,000
- ⏱️ **Average Delivery Time:** 15-45 minutes (location dependent)
- ✅ **Delivery Success Rate:** 85%+

### Time Patterns
- 🕐 **Peak Ordering:** Lunch (12-2 PM) & Dinner (7-9 PM)
- 📅 **Weekend Surge:** 30-40% more orders
- 🌍 **Seasonal Trends:** Higher during festivals

---

## 💡 SQL Techniques Demonstrated

### Basic Skills
✓ SELECT statements
✓ WHERE, ORDER BY, GROUP BY clauses
✓ Simple JOINs (INNER, LEFT)
✓ Basic aggregations (COUNT, SUM, AVG)

### Intermediate Skills
✓ Multiple JOINs on complex relationships
✓ Subqueries & nested queries
✓ CASE statements for conditional logic
✓ Date/Time manipulation (EXTRACT, DATE_TRUNC)
✓ String functions & formatting

### Advanced Skills
✓ Window Functions (RANK, DENSE_RANK, ROW_NUMBER, LAG)
✓ Common Table Expressions (CTEs/WITH clauses)
✓ Complex aggregations with HAVING
✓ Partition BY for grouped window functions
✓ Performance optimization
✓ Time calculations & intervals

---

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 12+ installed
- SQL client (pgAdmin, DBeaver, or psql)

### Setup Steps

1. **Create Database**
```bash
createdb food_delivery_db
```

2. **Load Schema**
```bash
psql -U your_username -d food_delivery_db -f schema.sql
```

3. **Run Queries**
```bash
psql -U your_username -d food_delivery_db
\i sample-queries.sql
```

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Total Records | 880,500+ |
| SQL Queries | 20+ |
| Database Tables | 5 |
| Relationships | 4 (Foreign Keys) |
| Complexity Level | Beginner to Advanced |
| Time Period Covered | 2023-2026 |

---

## 🎓 Learning Outcomes

By studying this project, you'll learn:

✅ **Data Modeling** - How to design efficient relational databases
✅ **Advanced SQL** - Window functions, CTEs, complex joins
✅ **Business Analysis** - Converting business questions into SQL
✅ **Performance Optimization** - Writing efficient queries
✅ **Database Design** - Proper normalization and constraints

---

## 📚 Query Documentation

For **detailed explanations** of all 20+ queries:
👉 **[Read QUERIES.md](./QUERIES.md)**

Each query includes:
- Business problem it solves
- Full SQL code
- Sample output
- SQL techniques used
- Learning outcomes

---

## 🤝 How to Use This Repository

### For Learning SQL
1. Start with basic queries (1-5)
2. Progress to intermediate (6-15)
3. Challenge yourself with advanced (16-20)
4. Modify queries for your own analysis

### For Portfolio Building
1. Clone this repository
2. Add your own analysis queries
3. Document your findings
4. Share with potential employers

### For Business Analysis
1. Load the data into your database
2. Run queries to get insights
3. Create visualizations from results
4. Present findings

---

## ⚡ Quick Query Examples

### Example 1: Top Customers
```sql
SELECT customer_id, customer_name, COUNT(*) as orders
FROM orders
GROUP BY customer_id, customer_name
ORDER BY orders DESC
LIMIT 5;
```

### Example 2: Revenue by City
```sql
SELECT r.city, SUM(o.total_amount) as revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.city
ORDER BY revenue DESC;
```

### Example 3: Rider Performance
```sql
SELECT r.rider_id, r.rider_name,
       AVG(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time))/60) as avg_minutes
FROM riders r
JOIN deliveries d ON r.rider_id = d.rider_id
JOIN orders o ON d.order_id = o.order_id
GROUP BY r.rider_id, r.rider_name
ORDER BY avg_minutes ASC;
```

**See [QUERIES.md](./QUERIES.md) for all 20+ queries with full explanations!**


Feel free to:
- ⭐ **Star** this repository if you find it helpful
- 🍴 **Fork** it for your own use
- 💬 **Discuss** insights and improvements
- 📧 **Reach out** for collaboration

---

## 📄 License

This project is open source and available under the MIT License.
Free to use for learning and portfolio purposes.

---

## 🙏 Acknowledgments

- Built as a portfolio project
- Inspired by real food delivery platforms
- Created for demonstrating SQL expertise

---

**Last Updated:** January 2026  
**Status:** Active & Maintained  
**Difficulty Level:** Beginner to Advanced  

---

⭐ **If you found this project useful, please star it!**

Happy analyzing! 🚀📊
