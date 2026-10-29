
CREATE DATABASE sales_analysis_db;
USE sales_analysis_db;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);
SHOW TABLES;

USE sales_analysis_db;
INSERT INTO customers
(customer_id, customer_name, email, city)
VALUES
(1, 'Aarav Sharma', 'aarav@gmail.com', 'Mumbai'),
(2, 'Priya Patel', 'priya@gmail.com', 'Pune'),
(3, 'Rahul Desai', 'rahul@gmail.com', 'Nashik'),
(4, 'Sneha Joshi', 'sneha@gmail.com', 'Mumbai'),
(5, 'Aditya More', 'aditya@gmail.com', 'Thane');

SELECT * FROM customers;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

SHOW TABLES;


INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Wireless Mouse', 'Accessories', 800.00),
(103, 'Keyboard', 'Accessories', 1500.00),
(104, 'Monitor', 'Electronics', 12000.00),
(105, 'Headphones', 'Accessories', 2500.00);
SELECT * FROM products;


USE sales_analysis_db;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
SHOW TABLES;


INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Wireless Mouse', 'Accessories', 800.00),
(103, 'Keyboard', 'Accessories', 1500.00),
(104, 'Monitor', 'Electronics', 12000.00),
(105, 'Headphones', 'Accessories', 2500.00);




INSERT INTO orders
(order_id, customer_id, order_date, status)
VALUES
(1001, 1, '2026-01-05', 'Completed'),
(1002, 2, '2026-01-12', 'Completed'),
(1003, 3, '2026-01-20', 'Cancelled'),
(1004, 4, '2026-02-03', 'Completed'),
(1005, 1, '2026-02-15', 'Pending');

select * from products;
SELECT * FROM orders;


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

SHOW TABLES;


INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 1001, 101, 1, 55000.00),
(2, 1001, 102, 2, 800.00),
(3, 1002, 106, 1, 25000.00),
(4, 1002, 105, 1, 2500.00),
(5, 1003, 104, 1, 12000.00),
(6, 1004, 104, 2, 12000.00),
(7, 1004, 103, 2, 1500.00),
(8, 1005, 105, 2, 2500.00);
SELECT * FROM products;
INSERT INTO products
(product_id, product_name, category, price)
VALUES
(106, 'Smartphone', 'Electronics', 25000.00);

SELECT * FROM order_items;


SELECT
    order_id,
    SUM(quantity * unit_price) AS total_amount
FROM order_items
GROUP BY order_id;


SELECT
    o.order_id,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS total_amount
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.order_id, o.status;

SELECT
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

SELECT
    product_id,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * unit_price) AS total_sales
FROM order_items
GROUP BY product_id;

SELECT
    product_id,
    SUM(quantity * unit_price) AS total_sales
FROM order_items
GROUP BY product_id
ORDER BY total_sales DESC;

SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

SELECT
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.city
ORDER BY total_sales DESC;

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;

SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status;

SELECT
    product_name,
    category,
    price
FROM products
ORDER BY price DESC
LIMIT 1;

SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_sales DESC;

SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price) AS total_amount
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    c.customer_name,
    o.order_date,
    o.status
ORDER BY o.order_date;

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN o.status = 'Completed'
        THEN o.order_id
    END) AS completed_orders,
    SUM(CASE
        WHEN o.status = 'Completed'
        THEN oi.quantity * oi.unit_price
        ELSE 0
    END) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
    
    USE sales_analysis_db;

SHOW TABLES;




INSERT INTO sales_analysis_db.customers
(customer_id, customer_name, email, city)
WITH RECURSIVE nums AS (
    SELECT 6 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < 105
)
SELECT
    n,
    CONCAT('Customer ', n),
    CONCAT('customer', n, '@gmail.com'),
    CASE MOD(n, 5)
        WHEN 0 THEN 'Mumbai'
        WHEN 1 THEN 'Pune'
        WHEN 2 THEN 'Nashik'
        WHEN 3 THEN 'Kolhapur'
        ELSE 'Nagpur'
    END
FROM nums;





INSERT INTO sales_analysis_db.orders
(order_id, customer_id, order_date, status)
WITH RECURSIVE nums AS (
    SELECT 1006 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < 1105
)
SELECT
    n,
    MOD(n - 1001, 100) + 1,
    DATE_ADD('2026-01-01', INTERVAL MOD(n, 300) DAY),
    CASE MOD(n, 3)
        WHEN 0 THEN 'Completed'
        WHEN 1 THEN 'Pending'
        ELSE 'Cancelled'
    END
FROM nums;





INSERT INTO sales_analysis_db.order_items
(order_item_id, order_id, product_id, quantity, unit_price)
WITH RECURSIVE nums AS (
    SELECT 9 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < 208
)
SELECT
    n,
    1001 + MOD(n - 9, 105),
    101 + MOD(n, 6),
    1 + MOD(n, 5),
    CASE MOD(n, 6)
        WHEN 0 THEN 55000
        WHEN 1 THEN 800
        WHEN 2 THEN 1500
        WHEN 3 THEN 12000
        WHEN 4 THEN 2500
        ELSE 25000
    END
FROM nums;



SELECT COUNT(*) AS total_customers
FROM sales_analysis_db.customers;

SELECT COUNT(*) AS total_orders
FROM sales_analysis_db.orders;

SELECT COUNT(*) AS total_products
FROM sales_analysis_db.products;

SELECT COUNT(*) AS total_order_items
FROM sales_analysis_db.order_items;