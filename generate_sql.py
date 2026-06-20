# Programmatic Menu Generator for HungryGO
# Generates 2250 unique menu items (45 dishes for each of the 50 restaurants)

import random

output_file = 'f:\\HungryGO\\massive_menu_seed.sql'

# 50 Restaurants with their primary cuisine category mapping
restaurant_cuisines = {
    1: 'BURGER', 2: 'PIZZA', 3: 'ASIAN', 4: 'SALAD',
    5: 'SOUTH_INDIAN', 6: 'BIRYANI', 7: 'PIZZA', 8: 'DESSERT', 9: 'Kebab',
    10: 'BURGER', 11: 'SOUTH_INDIAN', 12: 'Kebab', 13: 'BIRYANI', 14: 'DESSERT',
    15: 'MIXED', 16: 'SOUTH_INDIAN', 17: 'DESSERT', 18: 'MIXED', 19: 'PIZZA',
    20: 'ASIAN', 21: 'SEAFOOD', 22: 'NORTH_INDIAN', 23: 'MIXED', 24: 'CHINESE',
    25: 'MIXED', 26: 'ASIAN', 27: 'BURGER', 28: 'SOUTH_INDIAN', 29: 'MIXED',
    30: 'CHINESE', 31: 'SOUTH_INDIAN', 32: 'PIZZA', 33: 'Kebab', 34: 'SOUTH_INDIAN',
    35: 'DESSERT', 36: 'PIZZA', 37: 'BIRYANI', 38: 'CHINESE', 39: 'SOUTH_INDIAN',
    40: 'SOUTH_INDIAN', 41: 'NORTH_INDIAN', 42: 'BURGER', 43: 'DESSERT', 44: 'DESSERT',
    45: 'CHINESE', 46: 'NORTH_INDIAN', 47: 'SALAD', 48: 'MIXED', 49: 'BIRYANI', 50: 'SOUTH_INDIAN'
}

# Image pools for high-quality visuals
images = {
    'BURGER': [
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1513156844825-8324f8c7976e?auto=format&fit=crop&w=150&q=80'
    ],
    'PIZZA': [
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1571066811602-716837d681de?auto=format&fit=crop&w=150&q=80'
    ],
    'ASIAN': [
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1583623025817-d180a2221d0a?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=150&q=80'
    ],
    'SOUTH_INDIAN': [
        'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&w=150&q=80'
    ],
    'BIRYANI': [
        'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?auto=format&fit=crop&w=150&q=80'
    ],
    'DESSERT': [
        'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=150&q=80'
    ],
    'SALAD': [
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=150&q=80'
    ]
}

# General backup pool for mixed menus
images['MIXED'] = images['BURGER'] + images['PIZZA'] + images['ASIAN'] + images['SOUTH_INDIAN']
images['NORTH_INDIAN'] = images['BIRYANI'] + images['SOUTH_INDIAN']
images['SEAFOOD'] = images['ASIAN']
images['CHINESE'] = images['ASIAN']
images['Kebab'] = images['BIRYANI']

# Vocabulary lists to generate dynamic names
adj = ['Gourmet', 'Spicy', 'Crispy', 'Classic', 'Delicious', 'Signature', 'House Special', 'Toasted', 'Smoked', 'Hot', 'Fresh', 'Premium', 'Traditional', 'Authentic']
fillings_veg = ['Cottage Cheese', 'Mushroom', 'Paneer', 'Avocado', 'Potato', 'Vegetable', 'Sweet Corn', 'Cheese', 'Garlic', 'Tofu']
fillings_nonveg = ['Chicken', 'Egg', 'Mutton', 'Pepperoni', 'Seafood', 'Fish', 'Beef', 'Prawn', 'Sausage', 'Bacon']
types = {
    'BURGER': ['Burger', 'Slider', 'Wrap', 'Sandwich', 'Panini', 'Sub', 'Melt'],
    'PIZZA': ['Pizza', 'Flatbread', 'Calzone', 'Garlic Bread', 'Pasta', 'Fettuccine', 'Lasagna'],
    'SOUTH_INDIAN': ['Dosa', 'Idli', 'Vada', 'Uttapam', 'Pongal', 'Akki Roti', 'Parotta', 'Meals'],
    'BIRYANI': ['Dum Biryani', 'Kabab', 'Tikka', 'Ghee Rice', 'Pulao', 'Curry', 'Gravy'],
    'NORTH_INDIAN': ['Curry', 'Tandoori Tikka', 'Masala', 'Korma', 'Roti', 'Naan', 'Kachori', 'Thali'],
    'Kebab': ['Kabab', 'Tikka', 'Shawarma Roll', 'Grilled Platter', 'Skewers'],
    'DESSERT': ['Sundae', 'Ice Cream Scoop', 'Brownie Slice', 'Cheesecakes', 'Milkshake', 'Lassi', 'Halwa', 'Mysore Pak'],
    'SALAD': ['Salad Bowl', 'Veggie Platter', 'Quinoa Bowl', 'Healthy Mix', 'Greens'],
    'CHINESE': ['Hakka Noodles', 'Fried Rice', 'Dim Sums', 'Manchurian', 'Spring Rolls'],
    'SEAFOOD': ['Fish Fry', 'Prawn Curry', 'Crab Cakes', 'Seafood Platter'],
    'ASIAN': ['Ramen Bowl', 'Maki Sushi Roll', 'Dumplings', 'Noodle Soup', 'Stir Fry'],
    'MIXED': ['Burger', 'Pizza', 'Noodles', 'Biryani', 'Dessert', 'Wrap', 'Salad']
}

with open(output_file, 'w', encoding='utf-8') as f:
    f.write("-- Programmatically Generated Massive Menu Items Seed Script\n")
    f.write("USE hungrygo_db;\n\n")
    f.write("SET FOREIGN_KEY_CHECKS = 0;\n")
    f.write("TRUNCATE TABLE menu_items;\n")
    f.write("SET FOREIGN_KEY_CHECKS = 1;\n\n")
    
    item_count = 0
    for rest_id, cuisine in restaurant_cuisines.items():
        used_names = set()
        f.write(f"-- Menu items for Restaurant {rest_id} ({cuisine})\n")
        
        for i in range(1, 46): # Generate exactly 45 menu items per restaurant
            # Determine vegetarian or non-vegetarian randomly (or force veg for salad/dessert/south indian mostly)
            is_veg = 1
            if cuisine in ['BIRYANI', 'Kebab', 'SEAFOOD']:
                is_veg = random.choice([0, 0, 1]) # mostly non-veg
            elif cuisine in ['SOUTH_INDIAN', 'SALAD', 'DESSERT']:
                is_veg = 1 # always veg
            else:
                is_veg = random.choice([0, 1])
                
            # Construct a name
            name = ""
            while True:
                a = random.choice(adj)
                f_list = fillings_veg if is_veg == 1 else fillings_nonveg
                fil = random.choice(f_list)
                t = random.choice(types.get(cuisine, types['MIXED']))
                
                # Format dessert sweet names nicely
                if cuisine == 'DESSERT':
                    name = f"{a} {fil} {t}" if random.choice([True, False]) else f"{fil} {t}"
                else:
                    name = f"{a} {fil} {t}"
                
                if name not in used_names:
                    used_names.add(name)
                    break
            
            # Category
            category = t
            
            # Price
            price = round(random.uniform(1.50, 15.00), 2)
            
            # Image URL
            img_pool = images.get(cuisine, images['MIXED'])
            img = random.choice(img_pool)
            
            # Description
            desc = f"Freshly prepared {name.lower()} cooked using premium ingredients, signature herbs, and spices."
            
            # Write query
            # Escape strings
            name_esc = name.replace("'", "''")
            desc_esc = desc.replace("'", "''")
            category_esc = category.replace("'", "''")
            
            query = f"INSERT INTO menu_items (restaurant_id, name, description, price, image_url, category, is_vegetarian, is_available) VALUES ({rest_id}, '{name_esc}', '{desc_esc}', {price}, '{img}', '{category_esc}', {is_veg}, 1);\n"
            f.write(query)
            item_count += 1
            
        f.write("\n")
        
print(f"SQL file written successfully. Total menu items: {item_count}")
