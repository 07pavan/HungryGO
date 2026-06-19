package com.hungrygo.controller;

import com.hungrygo.model.dao.UserDAO;
import com.hungrygo.model.dao.impl.UserDAOImpl;
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
 * Servlet controller handling new customer registration and profile bootstrap.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String pincode = request.getParameter("pincode");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate form input parameters
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "All registration fields are required!");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        // Validate password length and match
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long!");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        // Clean email address
        email = email.trim().toLowerCase();

        // Check if email already exists
        if (userDAO.getUserByEmail(email) != null) {
            request.setAttribute("error", "An account with this email address already exists! Use Sign In.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        // Combine address and pincode
        String fullAddress = address.trim();
        if (pincode != null && !pincode.trim().isEmpty()) {
            fullAddress += " - " + pincode.trim();
        }

        // Create new User entity
        User newUser = new User(0, name.trim(), email, password, phone.trim(), fullAddress, "CUSTOMER");

        // Save user to database
        boolean registrationSuccess = userDAO.registerUser(newUser);

        if (registrationSuccess) {
            // Get the saved user ID (needed since DB auto-increments it)
            User registeredUser = userDAO.getUserByEmail(email);
            int userId = (registeredUser != null) ? registeredUser.getId() : 0;

            // Start authenticated session
            HttpSession session = request.getSession(true);
            session.setAttribute("user_id", userId);
            session.setAttribute("username", newUser.getName());
            session.setAttribute("email", newUser.getEmail());
            session.setAttribute("phone", newUser.getPhone());
            session.setAttribute("address", newUser.getAddress());
            session.setAttribute("cartSize", 0);

            // Sync session cookies for local Node server
            addStateCookie(response, "username", newUser.getName());
            addStateCookie(response, "email", newUser.getEmail());
            addStateCookie(response, "phone", newUser.getPhone());
            addStateCookie(response, "address", newUser.getAddress());
            addStateCookie(response, "cartCount", "0");

            // Redirect to home page with success message
            session.setAttribute("successMessage", "Registration completed successfully! Welcome to HungryGO.");
            
            response.sendRedirect(request.getContextPath() + "/jsp/index.jsp");
        } else {
            request.setAttribute("error", "Registration transaction failed due to a database/SQL exception.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }

    /**
     * Helper to add a state cookie for frontend sync
     */
    private void addStateCookie(HttpServletResponse response, String name, String value) {
        if (value == null) return;
        try {
            String encodedValue = URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
            Cookie cookie = new Cookie(name, encodedValue);
            cookie.setPath("/");
            cookie.setMaxAge(60 * 60 * 24 * 7); // 7 days
            response.addCookie(cookie);
        } catch (Exception e) {
            System.err.println("Cookie sync exception: " + e.getMessage());
        }
    }
}
