CREATE TABLE product_metadata (
id SERIAL PRIMARY KEY,
details JSONB
);

INSERT INTO product_metadata(details)
VALUES (
'{
"color":"black",
"warranty":"2 years"
}'
);

Select * FROM product_metadata;

--returns json format
SELECT details->'color'
FROM product_metadata;

--converts json to text
SELECT details->>'color'
FROM product_metadata;

--nested json
SELECT details->'specs'->>'ram'
FROM product_metadata;

create table sales(
id SERIAL PRIMARY KEY,
order_date DATE
);

INSERT INTO sales(order_date)
VALUES ('2026-01-10'),
('2026-01-15'),
('2026-02-01'),
('2026-02-20');

CREATE MATERIALIZED VIEW monthly_sales AS
SELECT 
DATE_TRUNC('month', order_date) AS month,
COUNT(*) AS total_orders
FROM sales
GROUP BY month;

SELECT * FROM monthly_sales;

INSERT INTO sales(order_date)
VALUES ('2026-03-28');

REFRESH MATERIALIZED VIEW monthly_sales;

ALTER TABLE sales 
ADD amount INT;

INSERT INTO sales(amount)
VALUES (400),
(200),
(100);

CREATE FUNCTION total_sales()
RETURNS INT
LANGUAGE SQL
AS 
$$
SELECT SUM(amount)
FROM SALES;
$$;

SELECT total_sales();

CREATE FUNCTION sales_trigger_function()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
RAISE NOTICE 'New sale added';
RETURN NEW;
END;


CREATE TRIGGER sales_trigger
AFTER INSERT 
ON sales 
FOR EACH ROW 
EXECUTE FUNCTION sales_trigger_function();

INSERT INTO sales(amount)
VALUES (700);

CREATE PROCEDURE add_sale()
LANGUAGE SQL
AS
$$
INSERT INTO sales(amount) VALUES (300);
$$;

call add_sale()
select * FROM sales;

UPDATE sales
set order_date='2026-06-15' 
where amount=300;

ALTER TABLE sales 
ADD EMAIL VARCHAR(40);

ALTER TABLE sales 
DROP email;

UPDATE sales
set order_date='2026-06-15' 
where amount=500;

CREATE TABLE order1 (
order_id INT,
sales_id INT,
FOREIGN KEY(sales_id)
REFERENCES sales(id)
);

DROP TABLE order1;

DELETE FROM sales 
WHERE id = 2;

SELECT NOW();

ALTER TABLE sales 
DROP CONSTRAINT sales_pkey;

SELECT * FROM customers
WHERE customer_city LIKE 's%'
LIMIT 5 ;

