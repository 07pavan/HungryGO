package com.hungrygo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet controller for order success page, extracting details from session and routing safely.
 */
@WebServlet(name = "SuccessServlet", urlPatterns = {"/success"})
public class SuccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("HTTP GET: SuccessServlet intercepting path.");
        
        HttpSession session = request.getSession();
        String orderId = (String) session.getAttribute("lastOrderId");
        String total = (String) session.getAttribute("lastOrderTotal");
        
        if (orderId == null) {
            // No order recently placed, redirect to home
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Remove attributes to prevent showing success page again on page refresh
        session.removeAttribute("lastOrderId");
        session.removeAttribute("lastOrderTotal");
        
        request.setAttribute("orderId", orderId);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("/jsp/success.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
