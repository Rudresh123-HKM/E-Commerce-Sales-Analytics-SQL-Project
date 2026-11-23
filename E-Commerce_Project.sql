create database E_Commerce;

CREATE TABLE IF NOT EXISTS customer_master (
    customer_id VARCHAR(11) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_age SMALLINT NOT NULL CHECK (customer_age >= 0),
    gender VARCHAR(20) NOT NULL,
    customer_segment VARCHAR(30) NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state VARCHAR(100) NOT NULL,
    customer_country VARCHAR(100) NOT NULL,
    region VARCHAR(30) NOT NULL,
    customer_postal_code VARCHAR(20) NOT NULL,
    customer_acquisition_cost NUMERIC(10,2) NOT NULL CHECK (customer_acquisition_cost >= 0)
);

copy customer_master (customer_id, customer_name, customer_age, gender, customer_segment, customer_city, customer_state, customer_country, region, customer_postal_code, customer_acquisition_cost) 
FROM 'D:\Data Analyst\Projects\4. E-coomerce\customer_master.csv' 
CSV HEADER;


CREATE TABLE dataset_statistics (
    total_transactions INT,
    total_columns INT,
    total_customers INT,
    total_products_used INT,
    date_range VARCHAR(50),
    total_revenue VARCHAR(30),
    total_profit VARCHAR(30),
    average_order_value VARCHAR(20),
    average_rating NUMERIC(3,2),
    return_rate VARCHAR(10),
    cancellation_rate VARCHAR(10)
);

COPY dataset_statistics
FROM 'D:\Data Analyst\Projects\4. E-coomerce\dataset_statistics.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE ecommerce_sales (
    order_id                    VARCHAR(20),
    order_date                  DATE,
    order_time                  TIME,
    order_status                VARCHAR(20),
    sales_channel               VARCHAR(30),

    customer_id                 VARCHAR(20),
    customer_name               VARCHAR(100),
    customer_age                INTEGER,
    gender                      VARCHAR(20),
    customer_segment            VARCHAR(30),
    customer_type               VARCHAR(30),
    customer_city               VARCHAR(100),
    customer_state              VARCHAR(100),
    customer_country            VARCHAR(50),
    region                      VARCHAR(30),
    customer_postal_code        VARCHAR(20),

    payment_method              VARCHAR(30),
    payment_status              VARCHAR(20),
    currency                    VARCHAR(10),

    shipping_method             VARCHAR(30),
    warehouse                   VARCHAR(20),
    delivery_days               NUMERIC(6,2),
    estimated_delivery_days     NUMERIC(6,2),
    delivery_status             VARCHAR(30),

    return_status               VARCHAR(30),
    return_reason               VARCHAR(100),

    customer_rating             NUMERIC(3,1),
    review_sentiment            VARCHAR(30),
    customer_review             TEXT,

    marketing_channel           VARCHAR(50),
    campaign_name               VARCHAR(100),
    coupon_code                 VARCHAR(30),

    loyalty_points_earned       INTEGER,
    loyalty_points_redeemed     INTEGER,
    quantity                    INTEGER,

    gross_sales                 NUMERIC(15,2),
    discount_amount             NUMERIC(15,2),
    tax_amount                  NUMERIC(15,2),
    shipping_cost               NUMERIC(15,2),
    net_sales                   NUMERIC(15,2),
    product_cost                NUMERIC(15,2),
    profit                      NUMERIC(15,2),
    profit_margin_percentage    NUMERIC(10,2),
    customer_lifetime_value     NUMERIC(15,2),

    is_repeat_customer          BOOLEAN,
    customer_order_count        INTEGER
);

COPY ecommerce_sales (
order_id,
order_date,
order_time,
order_status,
sales_channel,
customer_id,
customer_name,
customer_age,
gender,
customer_segment,
customer_type,
customer_city,
customer_state,
customer_country,
region,
customer_postal_code,
payment_method,
payment_status,
currency,
shipping_method,
warehouse,
delivery_days,
estimated_delivery_days,
delivery_status,
return_status,
return_reason,
customer_rating,
review_sentiment,
customer_review,
marketing_channel,
campaign_name,
coupon_code,
loyalty_points_earned,
loyalty_points_redeemed,
quantity,
gross_sales,
discount_amount,
tax_amount,
shipping_cost,
net_sales,
product_cost,
profit,
profit_margin_percentage,
customer_lifetime_value,
is_repeat_customer,
customer_order_count
)
FROM 'D:\Data Analyst\Projects\4. E-coomerce\ecommerce_sales_customer_analytics_150k.csv'
WITH (
FORMAT CSV,
HEADER TRUE,
DELIMITER ',',
QUOTE '"',
ESCAPE '"',
NULL '',
ENCODING 'UTF8'
);

CREATE TABLE order_items (
    order_item_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id               VARCHAR(20) NOT NULL,
    product_id             VARCHAR(20) NOT NULL,
    quantity               INTEGER NOT NULL,
    unit_price             NUMERIC(12, 2) NOT NULL,
    discount_percentage    NUMERIC(12, 10) NOT NULL,
    discount_amount        NUMERIC(12, 2) NOT NULL,
    gross_sales            NUMERIC(12, 2) NOT NULL,
    tax_amount             NUMERIC(12, 2) NOT NULL,
    shipping_cost          NUMERIC(12, 2) NOT NULL,
    net_sales              NUMERIC(12, 2) NOT NULL,
    product_cost           NUMERIC(12, 2) NOT NULL,
    profit                 NUMERIC(12, 2) NOT NULL
);

COPY order_items (
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percentage,
    discount_amount,
    gross_sales,
    tax_amount,
    shipping_cost,
    net_sales,
    product_cost,
    profit
)
FROM 'D:\Data Analyst\Projects\4. E-coomerce\order_items.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '"',
    ENCODING 'UTF8'
);

CREATE TABLE product_catalog (
    product_id           VARCHAR(20) PRIMARY KEY,
    product_name         VARCHAR(255) NOT NULL,
    product_category     VARCHAR(100) NOT NULL,
    product_subcategory  VARCHAR(100) NOT NULL,
    brand                VARCHAR(100) NOT NULL,
    supplier             VARCHAR(100) NOT NULL,
    unit_price           NUMERIC(10,2) NOT NULL,
    product_cost         NUMERIC(10,2) NOT NULL,
    product_rating       NUMERIC(2,1) NOT NULL
);

COPY product_catalog (
    product_id,
    product_name,
    product_category,
    product_subcategory,
    brand,
    supplier,
    unit_price,
    product_cost,
    product_rating
)
FROM 'D:\Data Analyst\Projects\4. E-coomerce\Product_catalogg.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '"',
    ENCODING 'UTF8'
);

select*from customer_master;
select*from dataset_statistics;
select*from ecommerce_sales;
select*from order_items;
select*from product_catalog;


--Data Quality Checks

--Duplicate Customers
select customer_id, count(*) from customer_master 
group by customer_id
having count(*) >1;

--Check Missing Products
select*from order_items oi
join product_catalog pc
on oi.product_id = pc.product_id
where pc.product_id is null;

--(1) top ten customer by revenue
select cm.customer_name, sum(es.net_sales) as revenue
from customer_master cm
join ecommerce_sales es
on cm.customer_id = es.customer_id
group by cm.customer_name
order by revenue desc
limit 10;

--(2) Top Product Categories
select pc.product_name, sum(o.net_sales) as revenue
from product_catalog pc
join order_items o
on o.product_id = pc.product_id
group by pc.product_name
order by revenue desc;

--(3) Monthly Revenue Trend
SELECT
    DATE_TRUNC('month',order_date) AS month,
    SUM(net_sales) revenue
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

--(4) Customer Retention
SELECT
    is_repeat_customer,
    COUNT(*) customers
FROM ecommerce_sales
GROUP BY is_repeat_customer;

--(1) What is the total revenue generated by the business?      Business KPI: Total Revenue
select sum(net_sales)as revenue from ecommerce_sales;

--(2) How many customers have placed orders?                    Business KPI: Active Customers
select count(distinct customer_id) as customers_placed_orders 
from ecommerce_sales
where order_status = 'completed';

--(3) Which top 10 customers generated the highest revenue?     Business KPI: High-Value Customers
select customer_id,customer_name, sum(net_sales) as revenue
from ecommerce_sales
group by customer_id,customer_name
order by revenue desc limit 10;

--(4) Which states generate the most sales?                     Business KPI: Geographic Performance
select customer_state, sum(net_sales) as total_sales
from ecommerce_sales
group by customer_state
order by total_sales desc;

--(5) Which payment method is used most frequently?            Business KPI: Customer Preferences
select payment_method, 
count(payment_method) as most_freq_payment
from ecommerce_sales
group by payment_method
order by  most_freq_payment desc;

--(6) What are the top 10 selling products by quantity?        Business KPI: Product Demand
select product_id, sum(quantity) as product_sold
from order_items 
group by product_id
order by product_sold desc;

SELECT
    pc.product_id,
    pc.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
GROUP BY pc.product_id, pc.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

--(7) Which product categories generate the highest revenue?
SELECT
    pc.product_category,
    SUM(oi.net_sales) AS revenue
FROM order_items oi
JOIN product_catalog pc
    ON oi.product_id = pc.product_id
GROUP BY pc.product_category
ORDER BY revenue DESC
LIMIT 10;

--(8) What is the average order value (AOV)?
select sum(net_sales)/count(distinct order_id) as AOV
from ecommerce_sales;

--(11) What is the monthly revenue trend?
SELECT
    DATE_TRUNC('month',order_date) AS month,
    SUM(net_sales) revenue
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

--(12) What is the month-over-month revenue growth percentage?
with monthly_revenue as
(select date_trunc('month', order_date) as month,
sum(net_sales) as revenue 
from ecommerce_sales
group by month)

select month, revenue, lag(revenue) over(order by month) as previous_revenue,
   ROUND(
        (
            revenue - LAG(revenue) OVER (ORDER BY month)
        ) * 100.0
        / LAG(revenue) OVER (ORDER BY month),
        2
    ) AS mom_growth_percentage
from monthly_revenue
order by month;

--(13)What percentage of customers are repeat customers?
WITH repeat_customers AS (
    SELECT DISTINCT customer_id
    FROM ecommerce_sales
    WHERE is_repeat_customer = 'true'
)
SELECT
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT customer_id)
         FROM ecommerce_sales),
        2
    ) AS repeat_customer_percentage
FROM repeat_customers;

--(14) Which customer segments generate the highest profit?
select customer_segment, sum(profit) as total_profit
from ecommerce_sales
group by customer_segment
order by total_profit desc ;

--(15) Which marketing channels bring the highest revenue?
select marketing_channel, sum(net_sales) as total_sales
from ecommerce_sales
group by marketing_channel
order by total_sales desc;

--(16) Highest Revenue Campaigns
SELECT
    campaign_name,
    SUM(net_sales) AS total_revenue
FROM ecommerce_sales
GROUP BY campaign_name
ORDER BY total_revenue DESC;

select*from customer_master;
select*from dataset_statistics;
select*from ecommerce_sales;
select*from order_items;
select*from product_catalog;

--(17) Which products have the highest profit margin?
select p.product_name, avg(e.profit_margin_percentage) as profit_margin
from order_items o
join product_catalog p on o.product_id = p.product_id
join ecommerce_sales e on e.order_id = o.order_id
group by p.product_name
order by profit_margin desc;

--(18) Which shipping method delivers fastest?
select shipping_method,
avg(delivery_days) as avg_delivery_days
from ecommerce_sales
group by shipping_method
order by avg_delivery_days;

--(21) Create Customer RFM Segmentation
WITH rfm_base AS (
    SELECT
        customer_id,
        CURRENT_DATE - MAX(order_date) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(net_sales) AS monetary
    FROM ecommerce_sales
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm_base
)
SELECT
    customer_id,
    r_score,
    f_score,
    m_score,

    CASE
        WHEN r_score >= 4
         AND f_score >= 4
         AND m_score >= 4
        THEN 'Champions'

        WHEN r_score >= 3
         AND f_score >= 3
         AND m_score >= 3
        THEN 'Loyal Customers'

        WHEN r_score >= 4
         AND f_score <= 2
        THEN 'Potential Loyalists'

        WHEN r_score <= 2
         AND f_score >= 3
        THEN 'At Risk'

        ELSE 'Others'
    END AS customer_segment
FROM rfm_scores;

--(22) Calculate Customer Lifetime Value (CLV)
SELECT
    customer_id,
    customer_name,
    SUM(net_sales) AS customer_lifetime_value
FROM ecommerce_sales
GROUP BY customer_id, customer_name
ORDER BY customer_lifetime_value DESC;

--(23) Find Customers Likely to Churn 
--(Find their latest order date.Calculate days since their latest order.If days > 90 → likely to churn.)
with CTE as
(select customer_id, customer_name,
max(order_date) as last_order,
current_date - max(order_date) as days_since_last_ordered
from ecommerce_sales
group by customer_id, customer_name
)
select customer_id, customer_name, last_order, days_since_last_ordered
from CTE
where days_since_last_ordered > 90
order by days_since_last_ordered ;

--(25) Analyze Discount Effectiveness
--Analysis 1: Revenue by Discount Level
SELECT
    discount_percentage,
    SUM(net_sales) AS total_revenue
FROM order_items
GROUP BY discount_percentage
ORDER BY discount_percentage;

--Analysis 2: Profit by Discount Level
SELECT
    discount_percentage,
    SUM(profit) AS total_profit
FROM order_items
GROUP BY discount_percentage
ORDER BY discount_percentage;

--(26) Identify Underperforming Products
--1. Products with Lowest Revenue
SELECT
    p.product_id,
    p.product_name,
    SUM(o.net_sales) AS total_revenue
FROM order_items o
JOIN product_catalog p
    ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue ASC;

--2. Products with Lowest Profit
SELECT
    p.product_id,
    p.product_name,
    SUM(o.profit) AS total_profit
FROM order_items o
JOIN product_catalog p
    ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit ASC;

--3. Products with Low Sales Volume
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity) AS total_quantity_sold
FROM order_items o
JOIN product_catalog p
    ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold ASC;

--4. Products with Negative or Very Low Profit Margin
SELECT
    p.product_id,
    p.product_name,
    ROUND(
        SUM(o.profit) * 100.0 /
        SUM(o.net_sales),
        2
    ) AS profit_margin
FROM order_items o
JOIN product_catalog p
    ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY profit_margin ASC;