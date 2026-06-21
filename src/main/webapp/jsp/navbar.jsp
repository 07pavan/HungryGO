<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
    NAVBAR COMPONENT
    MVC: reads from sessionScope ONLY — no DB access, no DAO, no scriptlets.
    All links use contextPath-relative servlet URLs.
    Included via <jsp:include> from every JSP page.
--%>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top py-2" id="main-navbar">
    <div class="container">
        <!-- Logo → HomeServlet /index -->
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-decoration-none"
           href="${pageContext.request.contextPath}/index" id="nav-brand-logo">
            <div class="logo-box d-flex align-items-center justify-content-center text-white rounded-3 shadow-sm bg-orange"
                 style="width: 38px; height: 38px;">
                <i class="bi bi-lightning-charge-fill fs-5"></i>
            </div>
            <span class="fs-4 tracking-tight text-dark">Hungry<span class="text-orange">GO</span></span>
        </a>

        <!-- Delivery Address from session -->
        <div class="d-none d-md-flex align-items-center ms-4 text-truncate"
             style="max-width: 250px;" id="nav-location-selector">
            <i class="bi bi-geo-alt-fill text-orange me-2"></i>
            <span class="text-muted small fw-medium">Deliver to: </span>
            <span class="ms-1 text-dark small fw-bold text-truncate" id="current-delivery-address">
                <c:choose>
                    <c:when test="${not empty sessionScope.address}">
                        <c:out value="${sessionScope.address}" />
                    </c:when>
                    <c:otherwise>Select Location...</c:otherwise>
                </c:choose>
            </span>
        </div>

        <button class="navbar-toggler border-0 shadow-none" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false"
                aria-label="Toggle navigation" id="navbar-hamburger-btn">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav ms-auto align-items-center gap-lg-3 mt-3 mt-lg-0">

                <!-- Search → RestaurantServlet -->
                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-2 px-3 py-2 rounded-2 fw-medium text-dark hover-orange"
                       href="${pageContext.request.contextPath}/restaurants" id="nav-link-search">
                        <i class="bi bi-search fs-5"></i>
                        <span>Search</span>
                    </a>
                </li>

                <!-- Offers → RestaurantServlet with filter param -->
                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-2 px-3 py-2 rounded-2 fw-medium text-dark hover-orange"
                       href="${pageContext.request.contextPath}/restaurants?filter=offers" id="nav-link-offers">
                        <i class="bi bi-percent fs-5"></i>
                        <span>Offers</span>
                    </a>
                </li>

                <!-- Orders → OrderServlet -->
                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-2 px-3 py-2 rounded-2 fw-medium text-dark hover-orange"
                       href="${pageContext.request.contextPath}/orders" id="nav-link-orders">
                        <i class="bi bi-journal-text fs-5"></i>
                        <span>Orders</span>
                    </a>
                </li>

                <!-- Logged-in user dropdown OR Sign In link -->
                <c:choose>
                    <c:when test="${not empty sessionScope.username}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 px-3 py-2 rounded-2 fw-medium text-dark"
                               href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-5 text-orange"></i>
                                <span class="text-truncate" style="max-width: 100px;">
                                    <c:out value="${sessionScope.username}" />
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg p-2 rounded-3"
                                aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item rounded-2 py-2"
                                       href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2 text-muted"></i>My Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item rounded-2 py-2"
                                       href="${pageContext.request.contextPath}/orders">
                                        <i class="bi bi-bag-check me-2 text-muted"></i>My Orders
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item rounded-2 py-2 text-danger"
                                       href="${pageContext.request.contextPath}/login?action=logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Sign Out
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link d-flex align-items-center gap-2 px-3 py-2 rounded-2 fw-medium text-dark hover-orange"
                               href="${pageContext.request.contextPath}/login" id="nav-link-signin">
                                <i class="bi bi-person fs-5"></i>
                                <span>Sign In</span>
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <!-- Cart Button → CartServlet, badge from session -->
                <li class="nav-item ms-lg-2">
                    <a class="btn btn-orange d-flex align-items-center gap-2 px-4 py-2 rounded-3 text-white fw-semibold position-relative shadow-sm hover-up"
                       href="${pageContext.request.contextPath}/cart" id="nav-link-cart">
                        <i class="bi bi-cart3 fs-5"></i>
                        <span>Cart</span>
                        <span class="badge bg-white text-orange rounded-pill font-mono fs-7 px-2 py-1" id="nav-cart-badge">
                            <c:out value="${not empty sessionScope.cartSize ? sessionScope.cartSize : 0}" />
                        </span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Floating Bottom Cart Bar -->
<c:set var="cartSize" value="${not empty sessionScope.cartSize ? sessionScope.cartSize : 0}" />
<div id="floating-cart-bar" class="floating-cart-bar ${cartSize > 0 ? 'show' : 'd-none'}">
    <div class="floating-cart-content">
        <div class="floating-cart-info">
            <span class="cart-icon-wrapper"><i class="bi bi-cart3"></i></span>
            <span id="floating-cart-text" class="fw-bold">
                <span id="floating-cart-qty">${cartSize}</span> ${cartSize == 1 ? 'Item' : 'Items'} Selected
            </span>
        </div>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-orange btn-order rounded-pill fw-bold" id="floating-cart-order-btn">
            Order Now <i class="bi bi-arrow-right-short ms-1"></i>
        </a>
    </div>
</div>

<script>
/* ============================================================
   GLOBAL CART UI HELPERS — available to every page
   ============================================================ */
(function() {
    var path = window.location.pathname;
    var hidePages = ['/cart', '/checkout', '/success', '/login', '/register'];
    var shouldHide = hidePages.some(function(p) { return path.indexOf(p) !== -1; });

    var bottomBar = document.getElementById('floating-cart-bar');

    /* Hide bar on checkout / auth pages immediately */
    if (shouldHide && bottomBar) {
        bottomBar.style.setProperty('display', 'none', 'important');
    }

    /* ----------------------------------------------------------
       updateCartUI(cartSize)
       Called after a successful AJAX add — updates badge + bar
    ---------------------------------------------------------- */
    window.updateCartUI = function(cartSize) {
        /* 1. Navbar badge */
        var badge = document.getElementById('nav-cart-badge');
        if (badge) {
            badge.innerText = cartSize;
            badge.classList.remove('pulse-animation');
            void badge.offsetWidth;          /* reflow trick to restart animation */
            badge.classList.add('pulse-animation');
        }

        /* 2. Floating bar */
        var bar = document.getElementById('floating-cart-bar');
        if (bar && !shouldHide) {
            var textSpan = document.getElementById('floating-cart-text');
            if (textSpan) {
                textSpan.innerHTML =
                    '<span id="floating-cart-qty" class="font-mono">' + cartSize + '</span> ' +
                    (cartSize === 1 ? 'Item' : 'Items') + ' Selected';
            }
            if (cartSize > 0) {
                bar.classList.remove('d-none');
                setTimeout(function() { bar.classList.add('show'); }, 10);
            } else {
                bar.classList.remove('show');
                setTimeout(function() { bar.classList.add('d-none'); }, 400);
            }
        }
    };

    /* ----------------------------------------------------------
       initCartForms()
       Call this at the BOTTOM of any page that has Add-to-cart
       forms (menu.jsp, burger-detail.jsp, index.jsp …).
       It scans for forms with action="/cart" + input[name=action]=add
       and wires up the AJAX intercept on each one.
    ---------------------------------------------------------- */
    window.initCartForms = function() {
        var forms = Array.from(document.querySelectorAll('form')).filter(function(f) {
            var action = f.getAttribute('action') || '';
            var ai = f.querySelector('input[name="action"]');
            return action.indexOf('/cart') !== -1 && ai && ai.value === 'add';
        });

        forms.forEach(function(form) {
            /* Guard: don't attach twice */
            if (form.dataset.ajaxBound === '1') return;
            form.dataset.ajaxBound = '1';

            form.addEventListener('submit', function(e) {
                e.preventDefault();

                var btn = form.querySelector('button[type="submit"]');
                var origHtml = btn ? btn.innerHTML : '';
                var isOutline = btn ? btn.classList.contains('btn-outline-orange') : false;

                /* Show loading state */
                if (btn) {
                    btn.disabled = true;
                    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span> Adding...';
                }

                var params = new URLSearchParams(new FormData(form));

                fetch(form.getAttribute('action'), {
                    method: 'POST',
                    body: params,
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json',
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(function(response) {
                    if (response.status === 401) {
                        return response.json().then(function(d) {
                            window.location.href = d.redirect || '${pageContext.request.contextPath}/login?msg=auth_required';
                            throw new Error('auth');
                        });
                    }
                    return response.json();
                })
                .then(function(data) {
                    if (data && data.success) {
                        /* Green checkmark state on button */
                        if (btn) {
                            btn.classList.remove('btn-outline-orange', 'btn-orange');
                            btn.classList.add('btn-success');
                            btn.innerHTML = '<i class="bi bi-check-lg"></i> Added!';
                            setTimeout(function() {
                                btn.disabled = false;
                                btn.innerHTML = origHtml;
                                btn.classList.remove('btn-success');
                                btn.classList.add(isOutline ? 'btn-outline-orange' : 'btn-orange');
                            }, 1600);
                        }
                        window.updateCartUI(data.cartSize);
                    } else if (data && data.redirect) {
                        window.location.href = data.redirect;
                    }
                })
                .catch(function(err) {
                    if (err.message !== 'auth') {
                        console.error('Cart error:', err);
                        if (btn) {
                            btn.disabled = false;
                            btn.innerHTML = origHtml;
                        }
                    }
                });
            });
        });
    };
}());
</script>
