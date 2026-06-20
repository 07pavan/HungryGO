-- Bangalore Restaurants & Menu Items Seeding Script
USE hungrygo_db;

-- 1. Insert Bangalore Restaurants (Starting IDs from 5 to avoid conflicts)
INSERT INTO restaurants (id, name, cuisine_type, rating, delivery_time_mins, cost_for_two, image_url, is_active) VALUES
(5, 'Vidyarthi Bhavan', 'South Indian Breakfast', 4.80, 20, 10.00, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=500&q=80', 1),
(6, 'Nagarjuna Restaurant', 'Andhra Spice & Biryani', 4.60, 30, 25.00, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=500&q=80', 1),
(7, 'Toit Microbrewery', 'Woodfired Pizzas & Pub Grub', 4.70, 35, 40.00, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80', 1),
(8, 'Corner House Ice Cream', 'Iconic Desserts', 4.90, 15, 15.00, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=500&q=80', 1),
(9, 'Empire Restaurant', 'Late Night Mughlai & Kebabs', 4.30, 25, 20.00, 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?auto=format&fit=crop&w=500&q=80', 1);

-- 2. Insert Menu Items for Vidyarthi Bhavan (id = 5)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(5, 'Ghee Special Masala Dosa', 'Crispy golden dosa roasted in pure ghee, stuffed with spiced potato mash, served with signature coconut chutney.', 1.80, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=150&q=80', 'South Indian', 1, 1),
(5, 'Idli Vada Combo', 'Soft steamed rice cakes and a crispy deep-fried black gram donut, served with hot sambar and fresh chutney.', 1.20, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=150&q=80', 'South Indian', 1, 1),
(5, 'Traditional Filter Coffee', 'Strong, aromatic chicory-blended coffee frothed dynamically in a traditional brass tumbler and cup.', 0.80, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=150&q=80', 'Beverages', 1, 1);

-- 3. Insert Menu Items for Nagarjuna (id = 6)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(6, 'Andhra Chicken Biryani', 'Spicy and aromatic long-grain basmati rice layered with tender marinated chicken and traditional Guntur spices.', 7.50, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=150&q=80', 'Biryani', 0, 1),
(6, 'Spicy Guntur Chicken Dry', 'Fiery boneless chicken pieces tossed with curry leaves, red Guntur chillies, and ginger-garlic paste.', 6.00, 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?auto=format&fit=crop&w=150&q=80', 'Appetizer', 0, 1),
(6, 'Andhra Banana Leaf Veg Meals', 'Steamed rice, pappu (dal), dry subji, rasam, sambar, gongura pickle, papad, and curd served on a banana leaf.', 5.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1);

-- 4. Insert Menu Items for Toit (id = 7)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(7, 'Toit Spicy Pepperoni Pizza', 'Wood-fired sourdough crust topped with spicy pork pepperoni slices, marinara sauce, and buffalo mozzarella.', 12.00, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=150&q=80', 'Pizza', 0, 1),
(7, 'Classic Garlic Bread with Cheese', 'Wood-fired sourdough baguette slices slathered with herb garlic butter and loaded with melted mozzarella.', 4.50, 'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?auto=format&fit=crop&w=150&q=80', 'Appetizer', 1, 1),
(7, 'Baked Loaded Potato Skins', 'Crispy potato skins stuffed with dynamic melted cheddar cheese, chives, sour cream, and crispy chicken bits.', 5.50, 'https://images.unsplash.com/photo-1518047601542-79f18c655718?auto=format&fit=crop&w=150&q=80', 'Appetizer', 0, 1);

-- 5. Insert Menu Items for Corner House (id = 8)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(8, 'Death by Chocolate (DBC)', 'Legendary dessert with vanilla ice cream, hot chocolate fudge, fresh eggless brownie cake, and toasted peanuts.', 6.50, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=150&q=80', 'Dessert', 1, 1),
(8, 'Hot Fudge Walnut Brownie', 'Warm walnut chocolate brownie topped with a scoop of vanilla bean ice cream and rich chocolate fudge glaze.', 4.50, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=150&q=80', 'Dessert', 1, 1),
(8, 'Alphonso Mango Shake', 'Creamy shake blended with premium fresh Alphonso mango pulp, whole milk, and vanilla ice cream.', 3.50, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80', 'Beverages', 1, 1);

-- 6. Insert Menu Items for Empire (id = 9)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(9, 'Empire Special Chicken Kabab', 'Crispy deep-fried chicken chunks marinated in yogurt, ginger-garlic paste, and traditional secret Empire spices.', 5.00, 'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?auto=format&fit=crop&w=150&q=80', 'Appetizer', 0, 1),
(9, 'Coin Parotta with Ghee Rice', 'Two layered, crispy, flaky wheat parottas served with aromatic ghee-roasted basmati rice and rich veg salna.', 4.00, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1),
(9, 'Grilled Chicken Shawarma Roll', 'Spit-roasted chicken shavings wrapped in soft rumali bread with shredded pickles and garlic eggless mayonnaise.', 3.50, 'https://images.unsplash.com/photo-1561651823-34fed022540e?auto=format&fit=crop&w=150&q=80', 'Rolls', 0, 1);
