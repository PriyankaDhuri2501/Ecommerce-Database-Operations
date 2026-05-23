


CREATE TABLE orders (
order_id TEXT,
customer_id TEXT,
order_status TEXT,
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);

TRUNCATE TABLE orders;

SELECT * FROM orders
LIMIT 10;

SELECT * FROM orders where order_status='delivered';

SELECT * FROM order_payments
order by payment_value DESC;


CREATE TABLE customers(
customer_id TEXT,
customer_unique_id TEXT,
customer_zip_code_prefix INT,
customer_city VARCHAR(50),
customer_state VARCHAR(5)
)

SELECT * FROM customers
LIMIT 10;

--city wise order tracking 
SELECT o.order_id, c.customer_city
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

--city wise revenue 
SELECT c.customer_city, SUM(p.payment_value) AS revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC;

-- Total orders by month
SELECT DATE_TRUNC('month',order_purchase_timestamp) AS month,
COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- Ranking customers based on payment 
SELECT
o.customer_id,
p.payment_value,
RANK() OVER (ORDER BY payment_value DESC) 
FROM order_payments p
JOIN orders o
ON o.order_id = p.order_id;

-- Revenue generated above 1000
WITH revenue AS (
SELECT o.customer_id , SUM(payment_value) Total
FROM order_payments p
JOIN orders o
ON o.order_id = p.order_id
GROUP BY o.customer_id
)
Select * from revenue WHERE Total>1000
ORDER BY Total DESC;

-- Distinct customer cities
SELECT DISTINCT customer_city 
FROM customers;

-- Orders after specific date
SELECT *
FROM orders
WHERE order_purchase_timestamp > '2018-01-01';

-- Average payment value
SELECT AVG(payment_value)
FROM order_payments;

-- Total orders by status
SELECT COUNT(*) 
FROM orders 
WHERE order_status = 'invoiced';

-- DENSE RANK over payment values
SELECT payment_value,
DENSE_RANK() OVER (ORDER BY payment_value DESC)
FROM order_payments
GROUP BY payment_value;