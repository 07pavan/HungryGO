package com.hungrygo.model.dao;

import com.hungrygo.model.Order;
import java.util.List;

/**
 * Data Access Object (DAO) interface for executing food orders and transactional inserts.
 */
public interface OrderDAO {
    
    // Create (Insert Order + OrderItems in a transactional atomic operation)
    boolean placeOrder(Order order);
    
    // Read
    Order getOrderById(int id);
    Order getOrderByStringId(String orderId);
    List<Order> getOrdersByUser(int userId);
    List<Order> getAllOrders();
    
    // Update
    boolean updateOrderStatus(int id, String newStatus);
    boolean updatePaymentStatus(int id, String newPaymentStatus);
    
    // Delete/Cancel Order
    boolean cancelOrder(int id);
}
