import express from 'express';
import fs from 'fs';
import path from 'path';
import cookieParser from 'cookie-parser';
import ejs from 'ejs';

const app = express();
const PORT = 3000;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());

// Static CSS and asset serving
app.get('/style.css', (req, res) => {
    res.sendFile(path.join(process.cwd(), 'jsp', 'style.css'));
});

// Clean Up and convert Java JSP syntax to JavaScript-friendly EJS blocks
function jspToEjsCompiler(filePath: string): string {
    let content = fs.readFileSync(filePath, 'utf-8');

    // 1. Resolve Includes <%@ include file="..." %> recursively
    const includeRegex = /<%\s*@\s*include\s+file="([^"]+)"\s*%>/g;
    while (includeRegex.test(content)) {
        content = content.replace(includeRegex, (match, includedFileName) => {
            const includePath = path.join(path.dirname(filePath), includedFileName);
            if (fs.existsSync(includePath)) {
                return jspToEjsCompiler(includePath);
            }
            return `<!-- Error resolve include: ${includedFileName} -->`;
        });
    }

    // 2. Strip page and taglib directives <%@ page ... %> and <%@ taglib ... %>
    content = content.replace(/<%\s*@\s*page[^%]+%>/g, '');
    content = content.replace(/<%\s*@\s*taglib[^%]+%>/g, '');

    // 3. Strip direct Java sql-loading scriptlets
    content = content.replace(/<%\s*List<Restaurant>[\s\S]*?request\.setAttribute\("restaurants"[\s\S]*?%>/g, '');
    content = content.replace(/<%\s*String\s+restIdStr[\s\S]*?coverImg\s*=[\s\S]*?%>/g, `
        <%
            let restId = locals.restaurant ? restaurant.id : "1";
            let restName = locals.restaurant ? restaurant.name : "Burger Palace";
            let cuisines = locals.restaurant ? restaurant.cuisineType : "American, Burgers, Fast Food";
            let rating = locals.restaurant ? restaurant.rating : 4.5;
            let deliveryTime = locals.restaurant ? (restaurant.deliveryTimeMins + " mins") : "20 mins";
            let costForTwo = locals.restaurant ? ("$" + restaurant.costForTwo + " for two") : "$8 for two";
            let address = "Shop 12, Ground Floor, Carter Road, Bandra West, Mumbai";
            if (locals.restaurant && restaurant.id === 2) address = "Level 2, High Street Phoenix, Lower Parel, Mumbai";
            if (locals.restaurant && restaurant.id === 3) address = "Ground Floor, Opp Metro Station, Andheri West, Mumbai";
            if (locals.restaurant && restaurant.id === 4) address = "Food Court, Phoenix Marketcity, Kurla West, Mumbai";
            let coverImg = locals.restaurant ? restaurant.imageUrl : "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80";
        %>
    `);

    // 4. Translate JSTL c:forEach loops
    content = content.replace(
        /<c:forEach\s+var="([^"]+)"\s+items="\${([^}]+)}"\s*>/g,
        '<% if (locals.$2 && $2.length > 0) { $2.forEach(function($1) { %>'
    );
    content = content.replace(/<\/c:forEach>/g, '<% }); } %>');

    // 5. Translate JSTL c:if tests
    content = content.replace(
        /<c:if\s+test="\${([^}]+)}"\s*>/g,
        '<% if ($1) { %>'
    );
    content = content.replace(/<\/c:if>/g, '<% } %>');

    // 6. Translate JSTL EL variables ${restaurant.rating} -> <%= restaurant.rating %>
    content = content.replace(/\${([^}]+)}/g, (match, expr) => {
        let cleanExpr = expr.trim()
            .replace(/\s+==\s+/g, ' === ')
            .replace(/\s+!=\s+/g, ' !== ')
            .replace(/\s+>=\s+/g, ' >= ')
            .replace(/\s+<=\s+/g, ' <= ');
        return '<%= ' + cleanExpr + ' %>';
    });

    // 7. Clean standard Java declarations in scriptlets to JS equivalents
    content = content.replace(
        /String\s+username\s*=\s*\(String\)\s*session\.getAttribute\("username"\);/g,
        'let username = session.username || null;'
    );
    content = content.replace(
        /Integer\s+cartSize\s*=\s*\(Integer\)\s*session\.getAttribute\("cartSize"\);/g,
        'let cartSize = parseInt(session.cartSize || 0);'
    );
    content = content.replace(
        /String\s+email\s*=\s*\(String\)\s*session\.getAttribute\("email"\);/g,
        'let email = session.email || null;'
    );
    content = content.replace(
        /String\s+phone\s*=\s*\(String\)\s*session\.getAttribute\("phone"\);/g,
        'let phone = session.phone || null;'
    );
    content = content.replace(
        /String\s+address\s*=\s*\(String\)\s*session\.getAttribute\("address"\);/g,
        'let address = session.address || null;'
    );

    // Clean request attributes
    content = content.replace(
        /String\s+errorMsg\s*=\s*\(String\)\s*request\.getAttribute\("error"\);/g,
        'let errorMsg = request.error || null;'
    );
    content = content.replace(
        /String\s+successMsg\s*=\s*\(String\)\s*request\.getAttribute\("success"\);/g,
        'let successMsg = request.success || null;'
    );

    // Clean request query-params
    content = content.replace(
        /String\s+restId\s*=\s*request\.getParameter\("id"\);/g,
        'let restId = request.id || "1";'
    );
    content = content.replace(
        /String\s+orderId\s*=\s*request\.getParameter\("orderId"\);/g,
        'let orderId = request.orderId || "QKB-983104";'
    );
    content = content.replace(
        /String\s+totalVal\s*=\s*request\.getParameter\("total"\);/g,
        'let totalVal = request.total || "11.00";'
    );

    // Clean dynamic Java conditional checks in <%= ... %> output blocks
    content = content.replace(
        /\(session\.getAttribute\("address"\)\s*!=\s*null\)\s*\?\s*session\.getAttribute\("address"\)\s*:\s*"([^"]+)"/g,
        'session.address ? session.address : "$1"'
    );
    content = content.replace(
        /\(session\.getAttribute\("username"\)\s*!=\s*null\)\s*\?\s*session\.getAttribute\("username"\)\s*:\s*"([^"]+)"/g,
        'session.username ? session.username : "$1"'
    );

    // Clean if null check expressions
    content = content.replace(/if\s*\(([^)]*)\s*!=\s*null\)/g, 'if ($1)');

    return content;
}

// Handler serving compiler assets
function handleJspRender(filePath: string, req: any, res: any, requestData: any = {}) {
    if (!fs.existsSync(filePath)) {
        return res.status(404).send(`<h1>JSP File Not Found</h1><p>Requested path resource: ${filePath}</p>`);
    }

    try {
        const compiledEjs = jspToEjsCompiler(filePath);
        
        // Setup session state using cookies and dynamic cart data
        let cartData = [];
        if (req.cookies.cartData) {
            try {
                cartData = JSON.parse(req.cookies.cartData);
            } catch (e) {
                cartData = [];
            }
        } else {
            // Seed cart with initial defaults matching client preview state
            cartData = [
                { id: '1', name: 'Classic Cheddar Beef Burger', price: 8.50, qty: 1, img: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=150&q=80' },
                { id: '4', name: 'Thick Oreo Vanilla Cream Shake', price: 3.50, qty: 1, img: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80' }
            ];
            res.cookie('cartData', JSON.stringify(cartData), { path: '/' });
            res.cookie('cartCount', 2, { path: '/' });
        }

        const cartSizeVal = cartData.reduce((acc: number, cur: any) => acc + (cur.qty || 0), 0);

        const jvmCartItemsMap: any = {};
        cartData.forEach((item: any) => {
            jvmCartItemsMap[item.id] = {
                menuItem: {
                    id: item.id,
                    name: item.name,
                    price: item.price,
                    imageUrl: item.img || ""
                },
                quantity: item.qty || 1,
                subtotal: (item.price * (item.qty || 1)).toFixed(2)
            };
        });

        const jvmCart = {
            getItems: function() { return jvmCartItemsMap; },
            getCartSize: function() { return cartSizeVal; },
            getTotalPrice: function() {
                return (Object.values(jvmCartItemsMap) as any[]).reduce((acc: number, cur: any) => acc + (cur.menuItem.price * cur.quantity), 0).toFixed(2);
            }
        };

        const sessionState = {
            username: req.cookies.username || null,
            email: req.cookies.email || null,
            phone: req.cookies.phone || null,
            address: req.cookies.address || null,
            cartSize: cartSizeVal
        };

        // Prepare fully-dynamic simulated database list of restaurants (exact replica of MySQL records)
        let mockRestaurants = [
            {
                id: 1,
                name: 'The Burger Lab',
                cuisineType: 'Gourmet Burgers',
                rating: 4.80,
                deliveryTimeMins: 25,
                costForTwo: 25.00,
                imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80',
                isActive: true
            },
            {
                id: 2,
                name: 'Mamma Mia Pizza',
                cuisineType: 'Italian Pizza',
                rating: 4.50,
                deliveryTimeMins: 30,
                costForTwo: 40.00,
                imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80',
                isActive: true
            },
            {
                id: 3,
                name: 'Sushi Zen Garden',
                cuisineType: 'Japanese',
                rating: 4.90,
                deliveryTimeMins: 35,
                costForTwo: 60.00,
                imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=80',
                isActive: true
            },
            {
                id: 4,
                name: 'Green Bowl Co.',
                cuisineType: 'Healthy Salads',
                rating: 4.20,
                deliveryTimeMins: 20,
                costForTwo: 30.00,
                imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80',
                isActive: true
            }
        ];

        // Process filters over express request context instantly
        const search = (req.query.search || "").toString().toLowerCase().trim();
        const category = (req.query.category || req.query.cuisine || "").toString().toLowerCase().trim();
        const filterVal = (req.query.filter || "").toString().toLowerCase().trim();

        if (search) {
            mockRestaurants = mockRestaurants.filter(r => 
                r.name.toLowerCase().includes(search) || 
                r.cuisineType.toLowerCase().includes(search)
            );
        } else if (category) {
            mockRestaurants = mockRestaurants.filter(r => 
                r.cuisineType.toLowerCase().includes(category)
            );
        }

        if (filterVal === 'top') {
            mockRestaurants = mockRestaurants.filter(r => r.rating >= 4.5);
        } else if (filterVal === 'fast') {
            mockRestaurants = mockRestaurants.filter(r => r.deliveryTimeMins <= 25);
        }

        const mockMenuItems = [
            { id: 1, restaurantId: 1, name: 'Classic Cheddar Beef Burger', description: 'Juicy grilled beef patty with melt-in-mouth Irish cheddar cheese, raw onions, and custom dynamic house sauce.', price: 8.50, imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=150&q=80', category: 'Burger', vegetarian: false, available: true },
            { id: 2, restaurantId: 1, name: 'Crispy Portobello Mushroom Burger', description: 'Golden-fried crispy panko-coated mushroom cap stuffed with cheese, crunchy lettuce, and spicy chipotle mayo.', price: 7.00, imageUrl: 'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?auto=format&fit=crop&w=150&q=80', category: 'Burger', vegetarian: true, available: true },
            { id: 3, restaurantId: 1, name: 'Crispy Southern fried Chicken Slider', description: 'Hand-breaded buttermilk fried chicken slider layered with house pickles and fresh coleslaw.', price: 4.00, imageUrl: 'https://images.unsplash.com/photo-1513156844825-8324f8c7976e?auto=format&fit=crop&w=150&q=80', category: 'Burger', vegetarian: false, available: true },
            { id: 4, restaurantId: 1, name: 'Thick Oreo Vanilla Cream Shake', description: 'Premium vanilla bean ice cream spun with crushed cream oreo cookies and fresh heavy cream toppers.', price: 3.50, imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=150&q=80', category: 'Shakes', vegetarian: true, available: true },
            { id: 5, restaurantId: 2, name: 'Double Pepperoni Supreme Pizza', description: 'Thick layers of spicy beef pepperoni covered in extra mozzarella cheese over signature Italian san marzano tomato base.', price: 10.50, imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=150&q=80', category: 'Pizza', vegetarian: false, available: true },
            { id: 6, restaurantId: 2, name: 'Margherita Basil Delight Pizza', description: 'Fresh organic bocconcini mozzarella, virgin olive oil, and sweet garden basil leaves over thin hand-stretched dough crust.', price: 9.00, imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=150&q=80', category: 'Pizza', vegetarian: true, available: true },
            { id: 7, restaurantId: 2, name: 'Garlic Parmesan Crust Knots', description: 'Soft wood-fired bread crust dough knots brushed heavily in garlic compound compound herb butter and grated aged parmigiano-reggiano.', price: 4.50, imageUrl: 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?auto=format&fit=crop&w=150&q=80', category: 'Appetizer', vegetarian: true, available: true },
            { id: 8, restaurantId: 3, name: 'Signature Spicy Tuna Roll', description: 'Yellowfin spicy minced tuna, spicy dynamic sriracha mayonnaise, toasted white sesame seeds, and fresh cucumber strips wrapped in seaweed.', price: 12.00, imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=150&q=80', category: 'Sushi', vegetarian: false, available: true },
            { id: 9, restaurantId: 3, name: 'California Crabcake Tempura Roll', description: 'Aged snow crab, hand-sliced avocado pulp, cucumber logs, rolled tightly and fried crispy in airy tempura wash coating.', price: 11.50, imageUrl: 'https://images.unsplash.com/photo-1583623025817-d180a2221d0a?auto=format&fit=crop&w=150&q=80', category: 'Sushi', vegetarian: false, available: true },
            { id: 10, restaurantId: 4, name: 'Avocado Quinoa Power Salad', description: 'Tri-colored power quinoa grains, organic sliced avocado, sweet cherry tomatoes, and cucumber flakes in lemon vinaigrette drizzle.', price: 8.00, imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=150&q=80', category: 'Salads', vegetarian: true, available: true },
            { id: 11, restaurantId: 4, name: 'Chilled Sesame Tofu Crunchy Bowl', description: 'Delectable blocks of premium organic soy tofu over steamed purple grain rice and pickled carrots, tossed with savory oil sesame glazing.', price: 9.50, imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=150&q=80', category: 'Salads', vegetarian: true, available: true }
        ];

        const restaurantIdParam = parseInt((req.query.id || req.body.id || '1').toString(), 10);
        const selectedRestaurant = mockRestaurants.find(r => r.id === restaurantIdParam) || mockRestaurants[0];
        const selectedMenuItems = mockMenuItems.filter(item => item.restaurantId === selectedRestaurant.id);

        const renderContext = {
            session: sessionState,
            restaurants: mockRestaurants,
            restaurant: selectedRestaurant,
            menuItems: selectedMenuItems,
            cart: jvmCart,
            cartItems: Object.values(jvmCartItemsMap),
            request: {
                id: req.query.id || req.body.id || '1',
                orderId: req.query.orderId || req.body.orderId || 'QKB-' + Math.floor(100000 + Math.random()*900000),
                total: jvmCart.getTotalPrice(),
                error: requestData.error || null,
                success: requestData.success || null
            }
        };

        const renderedHtml = ejs.render(compiledEjs, renderContext);
        res.send(renderedHtml);
    } catch (err: any) {
        console.error("Compilation error in JSP to EJS translator: ", err);
        res.status(500).send(`
            <div style="font-family: system-ui, sans-serif; padding: 2rem;">
                <h1 style="color: #e44d3a;">JSP Compilation Exception</h1>
                <p>The JSP template could not be loaded down appropriately in Node runtime:</p>
                <pre style="background: #f4f6fa; padding: 1rem; border-radius: 8px; border: 1px solid #ddd; overflow: auto;">${err.message}</pre>
                <hr>
                <small>HungryGO JSP-to-EJS Compiler Engine 1.0.1</small>
            </div>
        `);
    }
}

// Redirect primary slash to index.jsp
app.get('/', (req, res) => {
    res.redirect('/index.jsp');
});

// Dynamic checkouts redirection routes
app.all('/:jspFile.jsp', (req, res) => {
    const fileName = req.params.jspFile + '.jsp';
    const filePath = path.join(process.cwd(), 'jsp', fileName);

    // Handle logout action
    if (fileName === 'login.jsp' && req.query.action === 'logout') {
        res.clearCookie('username');
        res.clearCookie('email');
        res.clearCookie('phone');
        res.clearCookie('address');
        res.clearCookie('cartCount');
        return res.redirect('index.jsp');
    }

    // Handles user logins (POST action)
    if (req.method === 'POST' && fileName === 'login.jsp') {
        const { email, password } = req.body;
        if (email === 'pavanhegade1232@gmail.com' && password === 'pavan123') {
            res.cookie('username', 'Pavan Hegade', { path: '/' });
            res.cookie('email', 'pavanhegade1232@gmail.com', { path: '/' });
            res.cookie('phone', '+91 98765 43210', { path: '/' });
            res.cookie('address', 'Flat 402, Sunset Heights, Bandra West, Mumbai', { path: '/' });
            res.cookie('cartCount', 2, { path: '/' });
            return res.redirect('index.jsp');
        } else {
            return handleJspRender(filePath, req, res, { error: 'Invalid login email or password!' });
        }
    }

    // Handles user registration (POST action)
    if (req.method === 'POST' && fileName === 'register.jsp') {
        const { name, email, phone, address } = req.body;
        res.cookie('username', name, { path: '/' });
        res.cookie('email', email, { path: '/' });
        res.cookie('phone', phone, { path: '/' });
        res.cookie('address', address, { path: '/' });
        res.cookie('cartCount', 0, { path: '/' }); // empty cart on new profile registration
        return res.redirect('index.jsp');
    }

    // Handles profile dynamic updates
    if (req.method === 'POST' && fileName === 'profile.jsp') {
        const { action, name, phone, address } = req.body;
        if (action === 'updateProfile') {
            res.cookie('username', name, { path: '/' });
            res.cookie('phone', phone, { path: '/' });
            res.cookie('address', address, { path: '/' });
            
            // Wait, to update cookies instantly for the render in this thread:
            req.cookies.username = name;
            req.cookies.phone = phone;
            req.cookies.address = address;

            return handleJspRender(filePath, req, res, { success: 'Profile database updated successfully!' });
        } else if (action === 'changePassword') {
            return handleJspRender(filePath, req, res, { success: 'Your alphanumeric pass-lock renewed securely!' });
        }
    }

    // Route /cart to /cart.jsp matching Java mappings
    if (fileName === 'cart.jsp' && req.method === 'GET' && req.path === '/cart') {
        return res.redirect('cart.jsp');
    }

    // Handle generic dynamic cart posts re-evaluation
    if (req.method === 'POST' && fileName === 'cart.jsp') {
        const action = req.body.action || req.query.action || 'add';
        const id = req.body.id || req.body.menuItemId;
        
        let cartData = [];
        if (req.cookies.cartData) {
            try {
                cartData = JSON.parse(req.cookies.cartData);
            } catch (e) {
                cartData = [];
            }
        }
        
        if (action === 'add') {
            const name = req.body.name || 'Delicious Dish';
            const price = parseFloat(req.body.price || '0');
            const img = req.body.img || '';
            const qty = parseInt(req.body.quantity || '1', 10);
            
            let found = false;
            for (let i = 0; i < cartData.length; i++) {
                if (cartData[i].id == id) {
                    cartData[i].qty += qty;
                    found = true;
                    break;
                }
            }
            if (!found) {
                cartData.push({ id, name, price, qty, img });
            }
        } else if (action === 'update') {
            const qty = parseInt(req.body.quantity || '1', 10);
            for (let i = 0; i < cartData.length; i++) {
                if (cartData[i].id == id) {
                    cartData[i].qty = qty;
                    break;
                }
            }
            cartData = cartData.filter((item: any) => item.qty > 0);
        } else if (action === 'remove') {
            cartData = cartData.filter((item: any) => item.id != id);
        } else if (action === 'clear') {
            cartData = [];
        }
        
        const totalItems = cartData.reduce((acc: number, cur: any) => acc + cur.qty, 0);
        res.cookie('cartData', JSON.stringify(cartData), { path: '/' });
        res.cookie('cartCount', totalItems, { path: '/' });
        
        // Wait, to update cookies instantly for the render in this thread:
        req.cookies.cartData = JSON.stringify(cartData);
        req.cookies.cartCount = totalItems;

        const returnUrl = req.body.returnUrl || req.query.returnUrl || 'cart.jsp';
        return res.redirect(returnUrl);
    }

    handleJspRender(filePath, req, res);
});

// Alias for /cart mapping directly to cart.jsp
app.all('/cart', (req, res) => {
    // Forward /cart request to /cart.jsp handler directly
    const filePath = (typeof process !== 'undefined') ? path.join(process.cwd(), 'jsp', 'cart.jsp') : path.join(__dirname, 'jsp', 'cart.jsp');
    const actualFilePath = fs.existsSync(filePath) ? filePath : path.join(process.cwd(), 'jsp', 'cart.jsp');
    req.params = { jspFile: 'cart' };
    
    if (req.method === 'POST') {
        const action = req.body.action || req.query.action || 'add';
        const id = req.body.id || req.body.menuItemId;
        
        let cartData = [];
        if (req.cookies.cartData) {
            try {
                cartData = JSON.parse(req.cookies.cartData);
            } catch (e) {
                cartData = [];
            }
        }
        
        if (action === 'add') {
            const name = req.body.name || 'Delicious Dish';
            const price = parseFloat(req.body.price || '0');
            const img = req.body.img || '';
            const qty = parseInt(req.body.quantity || '1', 10);
            
            let found = false;
            for (let i = 0; i < cartData.length; i++) {
                if (cartData[i].id == id) {
                    cartData[i].qty += qty;
                    found = true;
                    break;
                }
            }
            if (!found) {
                cartData.push({ id, name, price, qty, img });
            }
        } else if (action === 'update') {
            const qty = parseInt(req.body.quantity || '1', 10);
            for (let i = 0; i < cartData.length; i++) {
                if (cartData[i].id == id) {
                    cartData[i].qty = qty;
                    break;
                }
            }
            cartData = cartData.filter((item: any) => item.qty > 0);
        } else if (action === 'remove') {
            cartData = cartData.filter((item: any) => item.id != id);
        } else if (action === 'clear') {
            cartData = [];
        }
        
        const totalItems = cartData.reduce((acc: number, cur: any) => acc + cur.qty, 0);
        res.cookie('cartData', JSON.stringify(cartData), { path: '/' });
        res.cookie('cartCount', totalItems, { path: '/' });
        
        // Wait, to update cookies instantly for the render in this thread:
        req.cookies.cartData = JSON.stringify(cartData);
        req.cookies.cartCount = totalItems;

        const returnUrl = req.body.returnUrl || req.query.returnUrl || 'cart.jsp';
        return res.redirect(returnUrl);
    }
    
    handleJspRender(actualFilePath, req, res);
});

// Alias for /profile mapping directly to profile.jsp
app.all('/profile', (req, res) => {
    const filePath = path.join(process.cwd(), 'jsp', 'profile.jsp');
    req.params = { jspFile: 'profile' };
    
    if (req.method === 'POST') {
        const { action, name, phone, address } = req.body;
        if (action === 'updateProfile') {
            res.cookie('username', name, { path: '/' });
            res.cookie('phone', phone, { path: '/' });
            res.cookie('address', address, { path: '/' });
            
            // Wait, to update cookies instantly for the render in this thread:
            req.cookies.username = name;
            req.cookies.phone = phone;
            req.cookies.address = address;

            return handleJspRender(filePath, req, res, { success: 'Profile updated successfully!' });
        } else if (action === 'changePassword') {
            return handleJspRender(filePath, req, res, { success: 'Password updated successfully!' });
        }
    }
    
    handleJspRender(filePath, req, res);
});

// Alias for /orders mapping directly to orders.jsp
app.all('/orders', (req, res) => {
    const filePath = path.join(process.cwd(), 'jsp', 'orders.jsp');
    req.params = { jspFile: 'orders' };
    handleJspRender(filePath, req, res);
});

// Alias for /login mapping directly to login.jsp
app.all('/login', (req, res) => {
    const filePath = path.join(process.cwd(), 'jsp', 'login.jsp');
    req.params = { jspFile: 'login' };
    if (req.method === 'POST') {
        const { email, password } = req.body;
        if (email === 'pavanhegade1232@gmail.com' && password === 'pavan123') {
            res.cookie('username', 'Pavan Hegade', { path: '/' });
            res.cookie('email', 'pavanhegade1232@gmail.com', { path: '/' });
            res.cookie('phone', '+91 98765 43210', { path: '/' });
            res.cookie('address', 'Flat 402, Sunset Heights, Bandra West, Mumbai', { path: '/' });
            res.cookie('cartCount', 2, { path: '/' });
            return res.redirect('index.jsp');
        } else {
            return handleJspRender(filePath, req, res, { error: 'Invalid login email or password!' });
        }
    }
    handleJspRender(filePath, req, res);
});

// Alias for /register mapping directly to register.jsp
app.all('/register', (req, res) => {
    const filePath = path.join(process.cwd(), 'jsp', 'register.jsp');
    req.params = { jspFile: 'register' };
    if (req.method === 'POST') {
        const { name, email, phone, address } = req.body;
        res.cookie('username', name, { path: '/' });
        res.cookie('email', email, { path: '/' });
        res.cookie('phone', phone, { path: '/' });
        res.cookie('address', address, { path: '/' });
        res.cookie('cartCount', 0, { path: '/' }); // empty cart on new profile registration
        return res.redirect('index.jsp');
    }
    handleJspRender(filePath, req, res);
});

// Alias for /checkout mapping directly to checkout.jsp
app.all('/checkout', (req, res) => {
    const filePath = path.join(process.cwd(), 'jsp', 'checkout.jsp');
    req.params = { jspFile: 'checkout' };
    handleJspRender(filePath, req, res);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Dynamic JSP Interactive Server running cleanly on port ${PORT}`);
});
