package com.hungrygo.controller;

import com.hungrygo.dao.OrderDAO;
import com.hungrygo.dao.impl.OrderDAOImpl;
import com.hungrygo.model.Cart;
import com.hungrygo.model.CartItem;
import com.hungrygo.model.Order;
import com.hungrygo.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * Servlet controller for checkout verification, address processing, and placing actual database transactions.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("HTTP GET: CheckoutServlet verification of user authentication constraints.");
        
        // Check if user is logged in
        if (request.getSession().getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("HTTP POST: Processing Checkout form submission.");

        HttpSession session = request.getSession();
        if (session.getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }

        String address = request.getParameter("address");
        String payment = request.getParameter("payment");
        
        if (address == null || address.trim().isEmpty()) {
            address = (String) session.getAttribute("address");
            if (address == null || address.trim().isEmpty()) {
                address = "Flat 402, Sunset Heights, Bandra West, Mumbai";
            }
        }
        
        if (payment == null || payment.trim().isEmpty()) {
            payment = "UPI";
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        Integer userIdObj = (Integer) session.getAttribute("user_id");
        int userId = (userIdObj != null) ? userIdObj : 1;

        // Calculate order totals on the server side
        BigDecimal subtotal = cart.getTotalPrice();
        BigDecimal discount = BigDecimal.ZERO;
        
        boolean promoApplied = false;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("promoApplied") && c.getValue().equals("true")) {
                    promoApplied = true;
                    break;
                }
            }
        }
        
        if (promoApplied && subtotal.compareTo(BigDecimal.ZERO) > 0) {
            discount = new BigDecimal("2.00");
            if (subtotal.compareTo(discount) < 0) {
                discount = subtotal;
            }
        }
        
        BigDecimal deliveryFee = subtotal.compareTo(BigDecimal.ZERO) > 0 ? new BigDecimal("1.50") : BigDecimal.ZERO;
        BigDecimal taxFee = subtotal.compareTo(BigDecimal.ZERO) > 0 ? new BigDecimal("0.50") : BigDecimal.ZERO;
        BigDecimal grandTotal = subtotal.subtract(discount).add(deliveryFee).add(taxFee);

        // Convert cart items to order entities
        Order order = new Order();
        String orderId = "HG-" + (int)(100000 + Math.random() * 900000);
        
        order.setOrderId(orderId);
        order.setUserId(userId);
        order.setDeliveryAddress(address);
        order.setPaymentMethod(payment);
        order.setPaymentStatus(payment.equalsIgnoreCase("COD") ? "Pending" : "Paid");
        order.setOrderStatus("Preparing");
        order.setTotalAmount(grandTotal);

        for (CartItem cartItem : cart.getItems().values()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setMenuItemId(cartItem.getMenuItem().getId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPriceAtPurchase(cartItem.getMenuItem().getPrice());
            order.addOrderItem(orderItem);
        }

        boolean success = orderDAO.placeOrder(order);

        if (success) {
            // Empty the cart after successful checkout
            cart.clear();
            session.setAttribute("cart", cart);
            session.setAttribute("cartSize", 0);

            // Update cookies for the frontend
            Cookie countCookie = new Cookie("cartCount", "0");
            countCookie.setPath("/");
            response.addCookie(countCookie);

            Cookie cartDataCookie = new Cookie("cartData", "[]");
            cartDataCookie.setPath("/");
            response.addCookie(cartDataCookie);

            // Redirect to the order confirmation page
            response.sendRedirect("success.jsp?orderId=" + orderId + "&total=" + grandTotal.setScale(2, BigDecimal.ROUND_HALF_UP).toString());
        } else {
            response.sendRedirect("checkout?error=failed");
        }
    }
}
