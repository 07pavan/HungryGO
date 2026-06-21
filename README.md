# HungryGO — Real-Time Food Delivery Web Application

HungryGO is a premium, full-stack Java EE (Jakarta Servlet/JSP) food delivery web application deployed on Apache Tomcat 11, configured with a MySQL database. It features responsive layouts, micro-animations, asynchronous shopping cart operations, and authentic localized dining experiences.

---

## 🚀 Key Achievements & Features Implemented

### 1. Robust Java Web Infrastructure
* **Jakarta Servlet Configurations**: Completely rewrote the web deployment descriptor (`web.xml`) to explicitly declare and map all 10 controllers, bypass annotation conflicts, and optimize load-on-startup behaviors.
* **Security & Auth Filter**: Designed a central `AuthenticationFilter` to guard private user resources (like Profile, Cart, and Checkout) while permitting access to public assets. Added smart AJAX-aware checks to return `401 Unauthorized` JSON redirect signals for guest checkout attempts.
* **Eclipse/JNDI Compilation Conflict Resolved**: Cleaned compile-time modulepath conflicts by configuring libraries directly on the classpath, ensuring clean compilation under Java 17.

### 2. Asynchronous Shopping Cart & Floating Indicator
* **AJAX Cart Operations**: Re-engineered `CartServlet` to detect asynchronous HTTP requests and reply with dynamic JSON data containing success statuses and cart sizes, avoiding disruptive page redirects.
* **Form Action Property Collision Fix**: Identified and resolved a critical DOM API bug where `form.action` collided with internal inputs named `"action"`. Resolved by switching references to `form.getAttribute('action')`.
* **Interactive Floating Bottom Bar**: Added a responsive bottom bar in `navbar.jsp` that slides up showing selected items and provides a direct CTA to order. Automatically hides on checkout, cart, and authentication pages.

### 3. Localization to Indian Rupees (INR)
* **Centralized Pricing Registry**: Created `PricingConfig.java` in the `com.hungrygo.util` package to establish a single source of truth for fee structures, including:
  * **Delivery Fee**: ₹40.00 flat
  * **Convenience & Taxes**: ₹20.00 flat
  * **Promo Code (QKBITE20)**: Flat ₹100.00 off
* **Dynamic Cart Totals**: Updated pages like `cart.jsp` to display coupon values dynamically using JSTL tags.

### 4. Seeding 50 Bengaluru Restaurants & 400 Dishes
* **Bengaluru Seeding Database**: Programmed a Python SQL generator script `generate_schema_inr.py` and wrote a Java re-seeder class `DbReseeder.java` to initialize MySQL database with 50 iconic Bengaluru restaurants (such as *Vidyarthi Bhavan*, *CTR*, *Meghana Foods*, *Toit*, *Koshy's*) and 400 menu items.
* **Indian Rupee Valuation**: Calibrated all dishes between ₹120.00 and ₹480.00 with realistic descriptions and veg/non-veg tags.
* **Smart Category Substring Matching**: Upgraded `RestaurantServlet` and the client-side JavaScript in `restaurants.jsp` to perform case-insensitive substring checks (`includes()`) and map synonyms (e.g., matching a "Thali" category query to any thali, meal, or Indian outlet).

---

## 🛠️ Technology Stack
* **Backend**: Java 17, Jakarta Servlet 6.0, JSTL 3.0 (Jakarta Core & Functions)
* **Frontend**: HTML5, Vanilla CSS3 (style.css), Bootstrap 5.3, Bootstrap Icons
* **Database**: MySQL 8.0+
* **Application Server**: Apache Tomcat 11.0
* **Build / Compiler**: Java Compiler CLI (`javac --release 17`)

---

## 📂 Project Architecture
```
HungryGO/
├── database/
│   ├── generate_schema_inr.py      # Python schema & seed SQL generator
│   └── bangalore_seed.sql          # Sample SQL seeds
├── src/
│   └── main/
│       ├── java/
│       │   └── com/hungrygo/
│       │       ├── controller/     # Servlets (Cart, Login, Menu, Order, etc.)
│       │       ├── filter/         # Authentication security filters
│       │       ├── model/          # Entities & DAO data access interfaces
│       │       └── util/           # Connection utilities & PricingConfig
│       └── webapp/
│           ├── WEB-INF/            # web.xml deployment descriptor
│           └── jsp/                # JSP Presentation templates (cart, index, menu)
└── schema.sql                      # Complete MySQL database creation & seeds
```

---

## 🎯 Running & Seeding the App

### 1. Database Setup
Ensure MySQL is running on `localhost:3306` with username `root` and password `root`.
Generate and load the database:
```bash
# 1. Run Python generator script to create the schema.sql file
python database/generate_schema_inr.py

# 2. Compile the DBReseeder Java utility
javac -cp "src/main/webapp/WEB-INF/lib/*" -d bin src/main/java/com/hungrygo/util/DbReseeder.java

# 3. Run DBReseeder to initialize tables and seed all 50 restaurants
java -cp "bin;src/main/webapp/WEB-INF/lib/mysql-connector-j-9.7.0.jar" com.hungrygo.util.DbReseeder
```

### 2. Application Seeding Verification
To verify the database counts, run the test class:
```bash
java -cp "src/main/webapp/WEB-INF/classes;src/main/webapp/WEB-INF/lib/mysql-connector-j-9.7.0.jar" com.hungrygo.util.TestDB
```
Expected output:
```
Database Connected Successfully
Restaurants count: 50
Menu items count: 400
```

### 3. Deploying to Tomcat
Build and compile all Java classes to target `WEB-INF/classes` and start the Apache Tomcat application container to access:
`http://localhost:8081/HungryGO/`
