<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en" id="root-html-login">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Sign in to HungryGO and order food from the best restaurants near you.">
    <title>Sign In | HungryGO — Food Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/jsp/style.css" rel="stylesheet">
    <style>
        /* Smooth fade-in for the alert banners */
        .auth-alert { animation: fadeSlideDown 0.4s ease both; }
        @keyframes fadeSlideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100 bg-light" id="body-login">

    <%-- Navbar component (shows Sign In link for guests) --%>
    <jsp:include page="navbar.jsp" />

    <main class="container my-auto py-5" id="login-main-section">
        <div class="auth-container">

            <%-- Back to home link --%>
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/index"
                   class="text-decoration-none text-muted small">
                    <i class="bi bi-arrow-left me-1"></i> Back to Home
                </a>
            </div>

            <div class="card auth-card shadow-lg border-0 p-4" id="login-card">
                <div class="card-body">

                    <%-- HungryGO logo icon --%>
                    <div class="d-flex justify-content-center mb-4">
                        <div class="bg-orange text-white d-flex align-items-center justify-content-center rounded-3 shadow-sm"
                             style="width:48px;height:48px;">
                            <i class="bi bi-lightning-charge-fill fs-4"></i>
                        </div>
                    </div>

                    <h1 class="h3 text-center fw-bold text-dark mb-1 font-display">Welcome Back!</h1>
                    <p class="text-center text-muted small mb-4">
                        Sign in and discover great food from top restaurants
                    </p>

                    <%-- ============================================================
                         NOTIFICATION BANNERS (only one shows at a time)
                         ============================================================ --%>

                    <%-- 1. SUCCESS — came straight from a fresh registration --%>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success auth-alert px-3 py-2 small rounded-3
                                    d-flex align-items-center gap-2 mb-3" role="alert"
                             id="login-registered-alert">
                            <i class="bi bi-check-circle-fill flex-shrink-0"></i>
                            <div><c:out value="${sessionScope.successMessage}" /></div>
                        </div>
                        <%-- One-time flash — remove after rendering --%>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>

                    <%-- 2. WARNING — user tried to access a protected page while logged out --%>
                    <c:if test="${param.msg eq 'auth_required'}">
                        <div class="alert alert-warning auth-alert px-3 py-2 small rounded-3
                                    d-flex align-items-center gap-2 mb-3" role="alert"
                             id="login-auth-required-alert">
                            <i class="bi bi-lock-fill flex-shrink-0"></i>
                            <div>
                                <strong>Sign in required.</strong>
                                Please sign in or create a free account to continue.
                            </div>
                        </div>
                    </c:if>

                    <%-- 3. INFO — user just signed out --%>
                    <c:if test="${param.msg eq 'logged_out'}">
                        <div class="alert alert-info auth-alert px-3 py-2 small rounded-3
                                    d-flex align-items-center gap-2 mb-3" role="alert"
                             id="login-signout-alert">
                            <i class="bi bi-info-circle-fill flex-shrink-0"></i>
                            <div>You have been signed out successfully. See you again soon!</div>
                        </div>
                    </c:if>

                    <%-- 4. ERROR — bad credentials or server-side validation failure --%>
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger auth-alert px-3 py-2 small rounded-3
                                    d-flex align-items-center gap-2 mb-3" role="alert"
                             id="login-error-alert">
                            <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                            <div><c:out value="${requestScope.error}" /></div>
                        </div>
                    </c:if>

                    <%-- ============================================================
                         LOGIN FORM  →  POST /login  →  LoginServlet.doPost()
                         ============================================================ --%>
                    <form action="${pageContext.request.contextPath}/login"
                          method="POST" id="login-form" novalidate>

                        <div class="form-floating mb-3">
                            <input type="email" name="email"
                                   class="form-control rounded-3"
                                   id="login-email-input"
                                   placeholder="name@example.com"
                                   required autocomplete="email">
                            <label for="login-email-input">
                                <i class="bi bi-envelope me-2 text-muted"></i>Email address
                            </label>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="password" name="password"
                                   class="form-control rounded-3"
                                   id="login-password-input"
                                   placeholder="Password"
                                   required autocomplete="current-password">
                            <label for="login-password-input">
                                <i class="bi bi-lock me-2 text-muted"></i>Password
                            </label>
                        </div>

                        <div class="d-flex align-items-center justify-content-between mb-4 fs-7">
                            <div class="form-check">
                                <input class="form-check-input accent-orange" type="checkbox"
                                       name="remember" id="login-remember-me">
                                <label class="form-check-label text-muted" for="login-remember-me">
                                    Remember me
                                </label>
                            </div>
                            <a href="#" class="text-orange text-decoration-none fw-semibold">
                                Forgot Password?
                            </a>
                        </div>

                        <button type="submit"
                                class="btn btn-orange w-100 py-3 rounded-3 fw-bold fs-6 mb-3 shadow-sm hover-up"
                                id="login-submit-btn">
                            Sign In <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </form>

                    <%-- Divider --%>
                    <div class="d-flex align-items-center my-4">
                        <hr class="flex-grow-1 border-muted opacity-25">
                        <span class="px-2 text-muted-light small">Or continue with</span>
                        <hr class="flex-grow-1 border-muted opacity-25">
                    </div>

                    <%-- Social login placeholders --%>
                    <div class="row g-2 mb-4" id="social-login-grid">
                        <div class="col-6">
                            <button type="button"
                                    class="btn btn-outline-light border text-dark w-100 py-2 rounded-3 small
                                           d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-google text-danger fs-6"></i> Google
                            </button>
                        </div>
                        <div class="col-6">
                            <button type="button"
                                    class="btn btn-outline-light border text-dark w-100 py-2 rounded-3 small
                                           d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-facebook text-primary fs-6"></i> Facebook
                            </button>
                        </div>
                    </div>

                    <%-- Registration link --%>
                    <p class="text-center fs-7 text-muted mb-0">
                        New to HungryGO?
                        <a href="${pageContext.request.contextPath}/register"
                           class="text-orange text-decoration-none fw-bold">
                            Create a free account
                        </a>
                    </p>

                </div>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
