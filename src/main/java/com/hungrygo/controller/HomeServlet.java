package com.hungrygo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.hungrygo.model.dao.RestaurantDAO;
import com.hungrygo.model.dao.impl.RestaurantDAOImpl;
import com.hungrygo.model.Restaurant;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet controller managing the home page actions, retrieving top-rated restaurants,
 * and forwarding requests to index.jsp.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("HTTP GET: HomeServlet intercepting path.");
        
        RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
        List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
        
        // Filter top-rated (rating >= 4.4) and sort by rating descending, limit to 4
        List<Restaurant> featuredList = allRestaurants.stream()
                .filter(r -> r.getRating() != null && r.getRating().doubleValue() >= 4.4)
                .sorted((r1, r2) -> r2.getRating().compareTo(r1.getRating()))
                .limit(4)
                .collect(Collectors.toList());

        request.setAttribute("featuredRestaurants", featuredList);

        // Forward to the JSP presentation interface
        request.getRequestDispatcher("/jsp/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
