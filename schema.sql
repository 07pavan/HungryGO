-- HungryGO Complete Database Schema Design
-- Target RDBMS: MySQL 8.0+
-- Prepared by Senior Java Full Stack Developer

CREATE DATABASE IF NOT EXISTS hungrygo_db;
USE hungrygo_db;

-- Drop tables if they exist in reverse order of dependencies
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS users;

-- 1. Users Table (Handles user credentials, roles & addresses)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Stored hashed password
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'CUSTOMER', -- Options: CUSTOMER, RIDER, ADMIN
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Restaurants Table (Holds restaurant master records)
CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    cuisine_type VARCHAR(100) NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0.00,
    delivery_time_mins INT NOT NULL,
    cost_for_two DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255) DEFAULT NULL,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Menu Items Table (Dishes belonging to a specific restaurant)
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255) DEFAULT NULL,
    category VARCHAR(50) NOT NULL, -- Pizza, Burger, Shakes, Appetizer, etc.
    is_vegetarian TINYINT(1) DEFAULT 0,
    is_available TINYINT(1) DEFAULT 1,
    CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Cart Table (Persists active shopping baskets across sessions)
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_item FOREIGN KEY (menu_item_id) 
        REFERENCES menu_items(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_item UNIQUE (user_id, menu_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Orders Table (Summary details of completed transactions)
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL UNIQUE, -- Human-readable unique order identifier (e.g., 'HG-452109')
    user_id INT NOT NULL,
    delivery_address TEXT NOT NULL,
    payment_method VARCHAR(50) NOT NULL, -- Card Payment, Cash on Delivery
    payment_status VARCHAR(50) DEFAULT 'PENDING', -- PENDING, COMPLETED, FAILED
    order_status VARCHAR(50) DEFAULT 'Food is Preparing', -- Food is Preparing, Out For Delivery, Delivered Successfully
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Order Items Table (Granular items purchased inside an order - relational junction)
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_at_purchase DECIMAL(10,2) NOT NULL, -- Freeze price snapshot historically
    CONSTRAINT fk_item_order FOREIGN KEY (order_id) 
        REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_menu FOREIGN KEY (menu_item_id) 
        REFERENCES menu_items(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optimized indexes for fast read lookups
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_restaurant_cuisine ON restaurants(cuisine_type);
CREATE INDEX idx_menu_restaurant ON menu_items(restaurant_id);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_order_user ON orders(user_id);


-- =========================================================================
-- SAMPLE TEST DATA SEEDING
-- =========================================================================

-- 1. Insert Users (Default Password is 'pavan123')
INSERT INTO users (id, name, email, password, phone, address, role) VALUES
(1, 'Pavan Hegade', 'pavanhegade1232@gmail.com', 'pavan123', '+91 98765 43210', 'Flat 402, Sunset Heights, Bandra West, Mumbai', 'CUSTOMER'),
(2, 'Admin Manager', 'admin@hungrygo.com', 'admin123', '+91 99999 88888', 'Admin Office, BKC, Mumbai', 'ADMIN');

-- 2. Insert Restaurants
INSERT INTO restaurants (id, name, cuisine_type, rating, delivery_time_mins, cost_for_two, image_url, is_active) VALUES
(1, 'The Burger Lab', 'Gourmet Burgers', 4.80, 25, 25.00, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80', 1),
(2, 'Mamma Mia Pizza', 'Italian Pizza', 4.50, 30, 40.00, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80', 1),
(3, 'Sushi Zen Garden', 'Japanese', 4.90, 35, 60.00, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=80', 1),
(4, 'Green Bowl Co.', 'Healthy Salads', 4.20, 20, 30.00, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80', 1);

-- 3. Insert Menu Items
-- The Burger Lab items
INSERT INTO menu_items (id, restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(1, 1, 'Classic Cheddar Beef Burger', 'Juicy grilled beef patty with melt-in-mouth Irish cheddar cheese, raw onions, and custom dynamic house sauce.', 8.50, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=150&q=80', 'Burger', 0, 1),
(2, 1, 'Crispy Portobello Mushroom Burger', 'Golden-fried crispy panko-coated mushroom cap stuffed with cheese, crunchy lettuce, and spicy chipotle mayo.', 7.00, 'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?auto=format&fit=crop&w=150&q=80', 'Burger', 1, 1),
(3, 1, 'Crispy Southern fried Chicken Slider', 'Hand-breaded buttermilk fried chicken slider layered with house pickles and fresh coleslaw.', 4.00, 'https://images.unsplash.com/photo-1513156844825-8324f8c7976e?auto=format&fit=crop&w=150&q=80', 'Burger', 0, 1),
(4, 1, 'Thick Oreo Vanilla Cream Shake', 'Premium vanilla bean ice cream spun with crushed cream oreo cookies and fresh heavy cream toppers.', 3.50, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80', 'Shakes', 1, 1);

-- Mamma Mia Pizza items
INSERT INTO menu_items (id, restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(5, 2, 'Double Pepperoni Supreme Pizza', 'Thick layers of spicy beef pepperoni covered in extra mozzarella cheese over signature Italian san marzano tomato base.', 10.50, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=150&q=80', 'Pizza', 0, 1),
(6, 2, 'Margherita Basil Delight Pizza', 'Fresh organic bocconcini mozzarella, virgin olive oil, and sweet garden basil leaves over thin hand-stretched dough crust.', 9.00, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=150&q=80', 'Pizza', 1, 1),
(7, 2, 'Garlic Parmesan Crust Knots', 'Soft wood-fired bread crust dough knots brushed heavily in garlic compound herb butter and grated aged parmigiano-reggiano.', 4.50, 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?auto=format&fit=crop&w=150&q=80', 'Appetizer', 1, 1);

-- Sushi Zen Garden items
INSERT INTO menu_items (id, restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(8, 3, 'Signature Spicy Tuna Roll', 'Yellowfin spicy minced tuna, spicy dynamic sriracha mayonnaise, toasted white sesame seeds, and fresh cucumber strips wrapped in seaweed.', 12.00, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=150&q=80', 'Sushi', 0, 1),
(9, 3, 'California Crabcake Tempura Roll', 'Aged snow crab, hand-sliced avocado pulp, cucumber logs, rolled tightly and fried crispy in airy tempura wash coating.', 11.50, 'https://images.unsplash.com/photo-1583623025817-d180a2221d0a?auto=format&fit=crop&w=150&q=80', 'Sushi', 0, 1);

-- Green Bowl Co. items
INSERT INTO menu_items (id, restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(10, 4, 'Avocado Quinoa Power Salad', 'Tri-colored power quinoa grains, organic sliced avocado, sweet cherry tomatoes, and cucumber flakes in lemon vinaigrette drizzle.', 8.00, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=150&q=80', 'Salads', 1, 1),
(11, 4, 'Chilled Sesame Tofu Crunchy Bowl', 'Delectable blocks of premium organic soy tofu over steamed purple grain rice and pickled carrots, tossed with savory oil sesame glazing.', 9.50, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=150&q=80', 'Salads', 1, 1);


-- 4. Insert Cart Items (Pre-populating Pavan's active checkout basket)
INSERT INTO cart (user_id, menu_item_id, quantity) VALUES
(1, 1, 1), -- 1 x Classic Cheddar Beef Burger
(1, 4, 1); -- 1 x Thick Oreo Vanilla Cream Shake


-- 5. Insert Orders (Past History for Pavan Hegade)
INSERT INTO orders (id, order_id, user_id, delivery_address, payment_method, payment_status, order_status, total_amount, created_at) VALUES
(1, 'QKB-452109', 1, 'Flat 402, Sunset Heights, Bandra West, Mumbai', 'Card Payment', 'COMPLETED', 'Delivered Successfully', 14.00, '2026-06-18 14:30:00'),
(2, 'QKB-219504', 1, 'Flat 402, Sunset Heights, Bandra West, Mumbai', 'Cash on Delivery', 'PENDING', 'Delivered Successfully', 8.00, '2026-05-30 20:00:00');

-- 6. Insert Order Items History
INSERT INTO order_items (order_id, menu_item_id, quantity, price_at_purchase) VALUES
(1, 5, 1, 10.50), -- Pizza
(1, 4, 1, 3.50),  -- Shake
(2, 3, 2, 4.00);  -- Sliders (Qty 2)
