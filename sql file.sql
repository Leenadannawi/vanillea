-- DROP OLD TABLES IF THEY EXIST
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- CREATE TABLES
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    category_id INT REFERENCES categories(category_id)
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    role VARCHAR(50),
    failed_login_attempts INT DEFAULT 0 -- Profile for tracking failed login attempts
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    order_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT
);
-- Insert sample orders for testing
INSERT INTO orders (user_id, order_date) VALUES
(1, '2025-11-10'), -- admin
(2, '2025-11-11'), -- writer
(3, '2025-11-12'); -- reader

-- INSERT SAMPLE DATA FOR CATEGORIES
INSERT INTO categories (name) VALUES
('Perfumes'),
('Mists'),
('Body Care')
'giftSet'),
('Lotions'),
('Hair care');

-- INSERT SAMPLE DATA FOR PRODUCTS
INSERT INTO products (name, price, category_id) VALUES
('Vanilla Silk Perfume', 59.99, 1),
('Brown Sugar Mist', 24.99, 2),
('Creamy Body Lotion', 19.99, 3);

-- INSERT SAMPLE USERS FOR LOGIN
INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'admin'),
('writer', 'writer123', 'writer'),
('reader', 'reader123', 'reader');

-- CREATE VIEWS

-- Create the view for Products
CREATE OR REPLACE VIEW view_products AS
SELECT product_id, name, price, category_id
FROM products;

-- Create the view for User Orders (including user info)
CREATE OR REPLACE VIEW view_user_orders AS
SELECT o.order_id, u.username, o.order_date
FROM orders o
JOIN users u ON o.user_id = u.user_id;

-- Create the view for Admin Summary (number of orders per user)
CREATE OR REPLACE VIEW view_admin_summary AS
SELECT u.username, COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.username;

-- GRANT PERMISSIONS

-- Admin can access everything
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;

-- Writer can read and insert on categories, products, and orders
GRANT SELECT, INSERT, UPDATE ON categories, products, orders, order_items TO writer;

-- Reader can only view data (select)
GRANT SELECT ON categories, products, orders, order_items TO reader;

ALTER TABLE users ADD COLUMN failed_login_attempts INT DEFAULT 0;
SELECT user_id, username, failed_login_attempts FROM users;

