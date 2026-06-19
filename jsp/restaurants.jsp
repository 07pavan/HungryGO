<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.hungrygo.dao.RestaurantDAO" %>
<%@ page import="com.hungrygo.dao.impl.RestaurantDAOImpl" %>
<%@ page import="com.hungrygo.model.Restaurant" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    if (restaurants == null) {
        RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
        String cuisine = request.getParameter("cuisine");
        String category = request.getParameter("category");
        String search = request.getParameter("search");
        
        if (search != null && !search.trim().isEmpty()) {
            restaurants = restaurantDAO.searchRestaurants(search);
        } else if (cuisine != null && !cuisine.trim().isEmpty()) {
            restaurants = restaurantDAO.getRestaurantsByCuisine(cuisine);
        } else if (category != null && !category.trim().isEmpty()) {
            restaurants = restaurantDAO.getRestaurantsByCuisine(category);
        } else {
            restaurants = restaurantDAO.getAllRestaurants();
        }
        request.setAttribute("restaurants", restaurants);
    }
%>
<!DOCTYPE html>
<html lang="en" id="root-html-restaurants">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Restaurants | HungryGO Delivery</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="style.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100 bg-light" id="body-restaurants">

    <!-- Header Navigation Include -->
    <%@ include file="navbar.jsp" %>

    <!-- Search and Filters Banner -->
    <div class="bg-white border-bottom py-4" id="filters-banner">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-2 fs-7">
                    <li class="breadcrumb-item"><a href="index.jsp" class="text-orange text-decoration-none">Home</a></li>
                    <li class="breadcrumb-item active" aria-current="page">All Restaurants</li>
                </ol>
            </nav>
            
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <h2 class="fw-bold mb-1 font-display">Discover Tasty Delights</h2>
                    <p class="text-muted small mb-0 fs-7" id="restaurants-count-txt">Showing top culinary destinations near you</p>
                </div>
                
                <!-- Quick Search within Restaurants -->
                <div class="d-flex gap-2" style="max-width: 400px; width: 100%;">
                    <div class="input-group border rounded-3 bg-light px-2 py-1 align-items-center flex-grow-1">
                        <i class="bi bi-search text-muted ms-1 me-2"></i>
                        <input type="text" id="live-search-input" class="form-control border-0 bg-transparent shadow-none form-control-sm" placeholder="Search dish, restaurant or cuisine..." onkeyup="filterRestaurants()">
                    </div>
                </div>
            </div>

            <!-- Swiggy-like Horizontal Filter Controls -->
            <div class="d-flex align-items-center gap-2 mt-4 flex-wrap" id="filter-controls-group">
                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3 active-filter" id="filter-all" onclick="setFilter('all')">All Outlets</button>
                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" id="filter-top" onclick="setFilter('top')"><i class="bi bi-star-fill text-warning me-1"></i>Ratings 4.5+</button>
                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" id="filter-fast" onclick="setFilter('fast')"><i class="bi bi-clock me-1"></i>Fast Delivery (&lt; 25m)</button>
                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" id="filter-veg" onclick="setFilter('veg')"><span class="veg-badge me-1" style="transform: scale(0.85); margin-right: 0;"></span>Pure Veg</button>
                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" id="filter-offers" onclick="setFilter('offers')"><i class="bi bi-percent text-danger me-1"></i>Offers</button>
            </div>
        </div>
    </div>

    <!-- Main Restaurants Grid Container -->
    <main class="container py-5" id="restaurants-list-container">
        <!-- Restaurants Grid -->
        <div class="row g-4" id="restaurants-grid">
            <c:forEach var="restaurant" items="${restaurants}">
                <div class="col-lg-3 col-md-6 restaurant-item-card" 
                     data-rating="${restaurant.rating}" 
                     data-time="${restaurant.deliveryTimeMins}" 
                     data-veg="${restaurant.cuisineType == 'Pure Veg' || restaurant.cuisineType == 'South Indian' || restaurant.cuisineType == 'Healthy Salads'}" 
                     data-offer="true" 
                     data-category="${restaurant.cuisineType}" 
                     data-title="${restaurant.name}">
                    <div class="card restaurant-card hover-up h-100 p-0 border">
                        <div class="restaurant-img-container">
                            <c:if test="${restaurant.rating >= 4.5}">
                                <span class="badge bg-orange text-white position-absolute top-3 left-3 z-3 shadow-sm px-2 py-1 fs-8 fw-bold">PROMOTED</span>
                            </c:if>
                            <div class="discount-badge">Flat 20% Off</div>
                            <img src="${restaurant.imageUrl}" alt="${restaurant.name}">
                        </div>
                        <div class="card-body p-3">
                            <h5 class="card-title text-truncate mb-1 fw-bold text-dark">
                                <a href="menu.jsp?id=${restaurant.id}" class="text-decoration-none text-dark">${restaurant.name}</a>
                            </h5>
                            <p class="text-muted small text-truncate mb-2">${restaurant.cuisineType}</p>
                            <div class="d-flex align-items-center justify-content-between mt-3 pt-2 border-top">
                                <div class="badge bg-success d-flex align-items-center gap-1">
                                    <i class="bi bi-star-fill text-white fs-8"></i> ${restaurant.rating}
                                </div>
                                <span class="fs-8 text-muted fw-bold">• ${restaurant.deliveryTimeMins} MIN</span>
                                <span class="fs-8 text-dark fw-bold">$${restaurant.costForTwo} For Two</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- No Results Msg Placeholder -->
        <div class="text-center py-5 d-none" id="no-results-msg">
            <i class="bi bi-emoji-frown text-muted display-1 mb-3"></i>
            <h3>No Restaurants Found</h3>
            <p class="text-muted">Try adjusting your filters or search terms.</p>
            <button class="btn btn-orange px-4 py-2 mt-2 rounded-3 fw-bold" onclick="resetFilters()">Reset All Filters</button>
        </div>
    </main>

    <!-- Footer Included Reusable component -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Frontend Interactive Filtering -->
    <script>
        let currentFilter = 'all';

        // Read query parameters on load
        window.addEventListener('DOMContentLoaded', () => {
            const params = new URLSearchParams(window.location.search);
            const searchVal = params.get('search');
            const categoryVal = params.get('category');
            const filterVal = params.get('filter');

            if (searchVal) {
                document.getElementById('live-search-input').value = searchVal;
                filterRestaurants();
            } else if (categoryVal) {
                filterByCategory(categoryVal);
            } else if (filterVal) {
                setFilter(filterVal);
            }
        });

        function setFilter(filterType) {
            currentFilter = filterType;
            
            // Toggle active classes on buttons
            document.querySelectorAll('#filter-controls-group button').forEach(btn => {
                btn.classList.remove('btn-orange', 'text-white', 'active-filter');
                btn.classList.add('btn-outline-secondary');
            });
            
            const activeBtn = document.getElementById('filter-' + filterType);
            if (activeBtn) {
                activeBtn.classList.remove('btn-outline-secondary');
                activeBtn.classList.add('btn-orange', 'text-white', 'active-filter');
            }
            
            filterRestaurants();
        }

        function filterByCategory(category) {
            const cards = document.querySelectorAll('.restaurant-item-card');
            let matched = 0;
            
            cards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                if (cardCategory.toLowerCase() === category.toLowerCase()) {
                    card.classList.remove('d-none');
                    matched++;
                } else {
                    card.classList.add('d-none');
                }
            });

            document.getElementById('restaurants-count-txt').innerText = `Displaying ${matched} premium ${category} venues`;
            toggleNoResults(matched === 0);
        }

        function filterRestaurants() {
            const searchKeyword = document.getElementById('live-search-input').value.toLowerCase();
            const cards = document.querySelectorAll('.restaurant-item-card');
            let matched = 0;

            cards.forEach(card => {
                const title = card.getAttribute('data-title').toLowerCase();
                const category = card.getAttribute('data-category').toLowerCase();
                const rating = parseFloat(card.getAttribute('data-rating'));
                const time = parseInt(card.getAttribute('data-time'));
                const isVeg = card.getAttribute('data-veg') === 'true';
                const hasOffer = card.getAttribute('data-offer') === 'true';

                let matchesSearch = !searchKeyword || title.includes(searchKeyword) || category.includes(searchKeyword);
                let matchesFilter = true;

                if (currentFilter === 'top' && rating < 4.5) matchesFilter = false;
                if (currentFilter === 'fast' && time > 25) matchesFilter = false;
                if (currentFilter === 'veg' && !isVeg) matchesFilter = false;
                if (currentFilter === 'offers' && !hasOffer) matchesFilter = false;

                if (matchesSearch && matchesFilter) {
                    card.classList.remove('d-none');
                    matched++;
                } else {
                    card.classList.add('d-none');
                }
            });

            document.getElementById('restaurants-count-txt').innerText = `Displaying ${matched} restaurants matching your preferences`;
            toggleNoResults(matched === 0);
        }

        function resetFilters() {
            document.getElementById('live-search-input').value = '';
            setFilter('all');
        }

        function toggleNoResults(show) {
            const grid = document.getElementById('restaurants-grid');
            const msg = document.getElementById('no-results-msg');
            if (show) {
                grid.classList.add('d-none');
                msg.classList.remove('d-none');
            } else {
                grid.classList.remove('d-none');
                msg.classList.add('d-none');
            }
        }
    </script>
</body>
</html>
