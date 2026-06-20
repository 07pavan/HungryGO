-- Final Seeding Script: 16 New Restaurants to reach 50 total & 32 Menu Items
USE hungrygo_db;

-- 1. Insert 16 Restaurants (IDs 35 to 50)
INSERT INTO restaurants (id, name, cuisine_type, rating, delivery_time_mins, cost_for_two, image_url, is_active) VALUES
(35, 'Bhartiya Jalpan', 'North Indian Sweets & Chaat', 4.40, 20, 12.00, 'https://images.unsplash.com/photo-1589135306090-e177fc33f920?auto=format&fit=crop&w=500&q=80', 1),
(36, 'Onesta', 'Unlimited Pizzas & Pasta', 4.30, 30, 20.00, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80', 1),
(37, 'Mani\'s Dum Biryani', 'Classic Dum Biryani Hub', 4.50, 25, 15.00, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=500&q=80', 1),
(38, 'Shanghai Times', 'Authentic Chinese & Dim Sums', 4.20, 25, 22.00, 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=500&q=80', 1),
(39, 'Kota Kachori', 'Rajasthani Sweets & Chaat', 4.50, 15, 8.00, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=500&q=80', 1),
(40, 'Hallimane', 'Traditional Karnataka Rural Cuisine', 4.60, 25, 10.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=500&q=80', 1),
(41, 'Pind Balluchi', 'Punjabi Dhaba & Rich Gravies', 4.30, 30, 25.00, 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&w=500&q=80', 1),
(42, 'Chili\'s Grill & Bar', 'Tex-Mex, Ribs & Burgers', 4.50, 35, 38.00, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=500&q=80', 1),
(43, 'Keventers', 'Legendary Milkshakes & Desserts', 4.40, 15, 10.00, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=500&q=80', 1),
(44, 'Asha Sweet Center', 'Traditional Indian Sweets & Snacks', 4.70, 15, 12.00, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=500&q=80', 1),
(45, 'Beijing Bites', 'Indo-Chinese Noodles & Appetizers', 4.10, 25, 16.00, 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?auto=format&fit=crop&w=500&q=80', 1),
(46, 'Rajdhani Thali', 'Unlimited Rajasthani & Gujarati Thali', 4.60, 30, 30.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=500&q=80', 1),
(47, 'Sante Spa Cuisine', 'Healthy, Vegan & Organic Salads', 4.70, 30, 28.00, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=500&q=80', 1),
(48, 'Smoke House Deli', 'European Panini & Pancakes', 4.60, 30, 35.00, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=500&q=80', 1),
(49, 'Biryani by Kilo', 'Slow-cooked Handi Biryani', 4.40, 35, 25.00, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=500&q=80', 1),
(50, 'Imperial Restaurant KBR', 'Kerala Style Parotta & Beef Fry', 4.20, 25, 18.00, 'https://images.unsplash.com/photo-1604152135912-04a022e23696?auto=format&fit=crop&w=500&q=80', 1);


-- 2. Insert 32 Menu Items (2 items per restaurant)
-- Bhartiya Jalpan (35)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(35, 'Classic Chola Bhatura', 'Fluffy deep-fried leavened sourdough bread served with spicy chickpea curry and pickles.', 3.00, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1),
(35, 'Sweet Kesar Rasmalai (2 Pcs)', 'Soft paneer dumplings soaked in sweet, saffron-infused milk syrup.', 2.00, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=150&q=80', 'Dessert', 1, 1);

-- Onesta (36)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(36, 'Gourmet Paneer Tikka Pizza', 'Thin wood-fired crust loaded with paneer tikka cubes, green capsicum, and mozzarella.', 8.50, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=150&q=80', 'Pizza', 1, 1),
(36, 'Creamy Basil Pesto Pasta', 'Penne pasta tossed in olive oil, fresh sweet basil pesto sauce, and parmesan.', 6.50, 'https://images.unsplash.com/photo-1546549032-9571cd6b27df?auto=format&fit=crop&w=150&q=80', 'Pasta', 1, 1);

-- Mani\'s Dum Biryani (37)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(37, 'Mani Classic Chicken Dum Biryani', 'Aromatic spiced basmati rice slow-cooked in handi pot with tender chicken pieces.', 7.00, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=150&q=80', 'Biryani', 0, 1),
(37, 'Egg Dum Biryani', 'Layered basmati rice cooked with whole boiled eggs and dynamic spices.', 6.00, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=150&q=80', 'Biryani', 0, 1);

-- Shanghai Times (38)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(38, 'Steamed Chicken Dim Sum (6 Pcs)', 'Delicate wheat parcels stuffed with seasoned minced chicken, steamed soft.', 5.00, 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=150&q=80', 'Appetizer', 0, 1),
(38, 'Schezwan Chilli Paneer Dry', 'Cottage cheese chunks tossed with bell peppers and fiery Schezwan sauce.', 5.50, 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?auto=format&fit=crop&w=150&q=80', 'Appetizer', 1, 1);

-- Kota Kachori (39)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(39, 'Kota Pyaz Kachori (2 Pcs)', 'Crispy flaky deep-fried pastry loaded with spiced onion-lentil stuffing.', 1.50, 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=150&q=80', 'South Indian', 1, 1),
(39, 'Sweet Kesar Lassi', 'Chilled sweet churned yogurt drink topped with saffron strands and malai cream.', 1.80, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80', 'Beverages', 1, 1);

-- Hallimane (40)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(40, 'Ragi Mudde with Soppu Saaru', 'Traditional steam-cooked finger millet ball served with local greens lentil curry.', 3.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1),
(40, 'Special Akki Roti', 'Rice flour flatbread mixed with chopped dill, onions, and chillies, roasted on tawa.', 2.00, 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=150&q=80', 'South Indian', 1, 1);

-- Pind Balluchi (41)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(41, 'Sarson Ka Saag with Makki Roti', 'Traditional Punjabi mustard greens curry served with two yellow maize flatbreads.', 4.50, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1),
(41, 'Dhaba Chicken Curry', 'Robust and spicy chicken bone-in chunks cooked in dhaba-style onion gravy.', 6.50, 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=150&q=80', 'Meals', 0, 1);

-- Chili\'s Grill & Bar (42)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(42, 'Classic Fajita Quesadilla Chicken', 'Grilled flour tortillas stuffed with chicken, bell peppers, onions, and melted cheese.', 8.50, 'https://images.unsplash.com/photo-1618047601542-79f18c655718?auto=format&fit=crop&w=150&q=80', 'Appetizer', 0, 1),
(42, 'Chili Smoked Burger', 'Grilled beef patty topped with smoked bacon strips, cheddar cheese, and BBQ glaze.', 7.50, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=150&q=80', 'Burger', 0, 1);

-- Keventers (43)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(43, 'Keventers Chocolate Oreo Milkshake', 'Thick blended milkshake loaded with crushed cream oreo cookies and cocoa ice cream.', 3.50, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80', 'Beverages', 1, 1),
(43, 'Classic Kesar Pista Shake', 'Rich cardamom flavored milkshake with ground almonds, pistachios, and saffron.', 3.80, 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80', 'Beverages', 1, 1);

-- Asha Sweet Center (44)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(44, 'Special Mysore Pak (4 Pcs)', 'Heritage ghee-roasted gram flour sweet fudge that melts instantly in the mouth.', 2.50, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=150&q=80', 'Dessert', 1, 1),
(44, 'Spicy Kaju Katli (250g)', 'Diamond-shaped cashew nut fudge decorated with edible silver leaf.', 6.00, 'https://images.unsplash.com/photo-1589135306090-e177fc33f920?auto=format&fit=crop&w=150&q=80', 'Dessert', 1, 1);

-- Beijing Bites (45)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(45, 'Chicken Hakka Noodles', 'Egg wheat noodles stir-fried in a wok with julienne vegetables and chicken strips.', 5.50, 'https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=150&q=80', 'Meals', 0, 1),
(45, 'Crispy Spring Rolls Veg (4 Pcs)', 'Fried wrapper rolls stuffed with seasoned cabbage, carrots, and glass noodles.', 3.50, 'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=150&q=80', 'Appetizer', 1, 1);

-- Rajdhani Thali (46)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(46, 'Dal Baati Churma Special', 'Traditional Rajasthani baked wheat dough balls (baati) soaked in ghee, served with rich dal and churma.', 5.00, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1),
(46, 'Rajdhani Veg Thali Pack', 'Compact box meal with two subjis, dal, rasam, 4 rotis, rice, pickle, and dynamic sweet.', 6.50, 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1);

-- Sante Spa Cuisine (47)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(47, 'Avocado Cucumber Salad Bowl', 'Organic sliced Haas avocado, cucumber ribbons, cherry tomatoes, tossed in lemon zest vinaigrette.', 6.00, 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=150&q=80', 'Salads', 1, 1),
(47, 'Vegan Quinoa Power Meal', 'Steamed red quinoa, roasted sweet potatoes, broccoli florets, and organic tahini dressing.', 7.00, 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=150&q=80', 'Salads', 1, 1);

-- Smoke House Deli (48)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(48, 'Smoke House Fluffy Pancakes', 'Three buttermilk pancakes topped with fresh strawberries, maple syrup, and whipped cream.', 5.00, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=150&q=80', 'Dessert', 1, 1),
(48, 'Grilled Veg & Mozzarella Panini', 'Toasted Italian bread filled with grilled bell peppers, zucchini, pesto, and melted cheese.', 6.00, 'https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&w=150&q=80', 'Appetizer', 1, 1);

-- Biryani by Kilo (49)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(49, 'Mutton Handi Dum Biryani', 'Aromatic basmati rice slow-cooked in clay handi pot with tender spice-infused mutton chunks.', 8.50, 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=150&q=80', 'Biryani', 0, 1),
(49, 'Slow-cooked Paneer Handi Biryani', 'Fragrant basmati rice layered with Guntur spiced cottage cheese chunks in clay pot.', 7.00, 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=150&q=80', 'Biryani', 1, 1);

-- Imperial Restaurant KBR (50)
INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES
(50, 'Kerala Malabar Parotta (2 Pcs)', 'Super flaky, layered flatbread made with refined flour and roasted on cast-iron tawa.', 2.00, 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=150&q=80', 'Meals', 1, 1),
(50, 'Kerala Spicy Beef Fry (Ularthiyathu)', 'Slow-roasted beef chunks tossed heavily in coconut slices, curry leaves, and black pepper.', 5.50, 'https://images.unsplash.com/photo-1604152135912-04a022e23696?auto=format&fit=crop&w=150&q=80', 'Appetizer', 0, 1);
