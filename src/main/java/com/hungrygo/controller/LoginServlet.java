package com.hungrygo.controller;

import com.hungrygo.dao.UserDAO;
import com.hungrygo.dao.impl.UserDAOImpl;
import com.hungrygo.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servlet controller handling database-driven user authentication, secure session management,
 * and standard logout operations.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // User data access layer
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equalsIgnoreCase(action)) {
            // Invalidate the current session
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("user_id");
                session.removeAttribute("username");
                session.removeAttribute("email");
                session.removeAttribute("phone");
                session.removeAttribute("address");
                session.invalidate();
                System.out.println("HungryGO session invalidated cleanly.");
            }

            // Expire cookies
            expireCookie(response, "username");
            expireCookie(response, "email");
            expireCookie(response, "phone");
            expireCookie(response, "address");
            expireCookie(response, "cartCount");

            // Redirect back to home page
            response.sendRedirect("index.jsp?msg=logged_out");
            return;
        }

        // If user is already logged in, redirect to restaurants page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            response.sendRedirect("restaurants.jsp");
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Processing login request for: " + email);

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please provide both email address and password.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            return;
        }

        // Validate user credentials
        User authenticatedUser = userDAO.validateUser(email.trim().toLowerCase(), password);

        if (authenticatedUser != null) {
            // Create a new session and save user info
            HttpSession session = request.getSession(true);
            session.setAttribute("user_id", authenticatedUser.getId());
            session.setAttribute("username", authenticatedUser.getName());
            session.setAttribute("email", authenticatedUser.getEmail());
            session.setAttribute("phone", authenticatedUser.getPhone());
            session.setAttribute("address", authenticatedUser.getAddress());
            session.setAttribute("cartSize", 1); // default active item count

            // Set cookies for frontend sync
            addStateCookie(response, "username", authenticatedUser.getName());
            addStateCookie(response, "email", authenticatedUser.getEmail());
            addStateCookie(response, "phone", authenticatedUser.getPhone());
            addStateCookie(response, "address", authenticatedUser.getAddress());
            addStateCookie(response, "cartCount", "2");

            System.out.println("Login successful. Redirecting to restaurants.jsp...");
            
            // Redirect to restaurants
            response.sendRedirect("restaurants.jsp");
        } else {
            System.out.println("Login failed for user " + email);
            request.setAttribute("error", "Incorrect email address or password. Please try again!");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }

    /**
     * Helper to set a state cookie for frontend sync
     */
    private void addStateCookie(HttpServletResponse response, String name, String value) {
        if (value == null) return;
        try {
            String encodedValue = URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
            Cookie cookie = new Cookie(name, encodedValue);
            cookie.setPath("/");
            cookie.setMaxAge(60 * 60 * 24); // 1 day
            response.addCookie(cookie);
        } catch (Exception e) {
            System.err.println("Cookie setup exception: " + e.getMessage());
        }
    }

    /**
     * Helper to expire a state cookie
     */
    private void expireCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }
}
