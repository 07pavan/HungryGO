package com.hungrygo.dao.impl;

import com.hungrygo.dao.OrderDAO;
import com.hungrygo.model.Order;
import com.hungrygo.model.OrderItem;
import com.hungrygo.model.MenuItem;
import com.hungrygo.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object Implementation for carrying out transactional inserts of Orders and their respective OrderItems.
 */
public class OrderDAOImpl implements OrderDAO {

    private static final String INSERT_ORDER = "INSERT INTO orders (order_id, user_id, delivery_address, payment_method, payment_status, order_status, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?);";
    private static final String INSERT_ORDER_ITEM = "INSERT INTO order_items (order_id, menu_item_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?);";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM orders WHERE id = ?;";
    private static final String SELECT_ORDER_BY_STRING_ID = "SELECT * FROM orders WHERE order_id = ?;";
    private static final String SELECT_ORDERS_BY_USER = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC;";
    private static final String SELECT_ITEMS_BY_ORDER = "SELECT * FROM order_items WHERE order_id = ?;";
    private static final String SELECT_ALL_ORDERS = "SELECT * FROM orders ORDER BY created_at DESC;";
    private static final String UPDATE_ORDER_STATUS = "UPDATE orders SET order_status = ? WHERE id = ?;";
    private static final String UPDATE_PAYMENT_STATUS = "UPDATE orders SET payment_status = ? WHERE id = ?;";
    private static final String DELETE_ORDER = "DELETE FROM orders WHERE id = ?;";

    @Override
    public boolean placeOrder(Order order) {
        if (order == null) return false;
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet rsKeys = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // atomic transaction

            psOrder = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getOrderId());
            psOrder.setInt(2, order.getUserId());
            psOrder.setString(3, order.getDeliveryAddress());
            psOrder.setString(4, order.getPaymentMethod());
            psOrder.setString(5, order.getPaymentStatus());
            psOrder.setString(6, order.getOrderStatus());
            psOrder.setBigDecimal(7, order.getTotalAmount());

            int count = psOrder.executeUpdate();
            if (count == 0) {
                conn.rollback();
                return false;
            }

            rsKeys = psOrder.getGeneratedKeys();
            int generatedId = 0;
            if (rsKeys.next()) {
                generatedId = rsKeys.getInt(1);
                order.setId(generatedId);
            } else {
                conn.rollback();
                return false;
            }

            psItem = conn.prepareStatement(INSERT_ORDER_ITEM);
            for (OrderItem item : order.getOrderItems()) {
                psItem.setInt(1, generatedId);
                psItem.setInt(2, item.getMenuItemId());
                psItem.setInt(3, item.getQuantity());
                psItem.setBigDecimal(4, item.getPriceAtPurchase());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("JDBC placeOrder error: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            DBConnection.closeResources(rsKeys, psOrder, psItem, conn);
        }
    }

    @Override
    public Order getOrderById(int id) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItems = null;
        ResultSet rsOrder = null;
        ResultSet rsItems = null;
        Order order = null;
        try {
            conn = DBConnection.getConnection();
            psOrder = conn.prepareStatement(SELECT_ORDER_BY_ID);
            psOrder.setInt(1, id);
            rsOrder = psOrder.executeQuery();
            if (rsOrder.next()) {
                order = extractOrderFromResultSet(rsOrder);
                
                // Fetch associated items
                psItems = conn.prepareStatement(SELECT_ITEMS_BY_ORDER);
                psItems.setInt(1, id);
                rsItems = psItems.executeQuery();
                while (rsItems.next()) {
                    OrderItem item = extractOrderItemFromResultSet(rsItems);
                    item.setMenuItem(getMenuItemForOrderItem(conn, item.getMenuItemId()));
                    order.addOrderItem(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("JDBC getOrderById error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(rsItems, psItems, rsOrder, psOrder, conn);
        }
        return order;
    }

    @Override
    public Order getOrderByStringId(String orderId) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItems = null;
        ResultSet rsOrder = null;
        ResultSet rsItems = null;
        Order order = null;
        try {
            conn = DBConnection.getConnection();
            psOrder = conn.prepareStatement(SELECT_ORDER_BY_STRING_ID);
            psOrder.setString(1, orderId);
            rsOrder = psOrder.executeQuery();
            if (rsOrder.next()) {
                order = extractOrderFromResultSet(rsOrder);
                
                // Fetch associated items
                psItems = conn.prepareStatement(SELECT_ITEMS_BY_ORDER);
                psItems.setInt(1, order.getId());
                rsItems = psItems.executeQuery();
                while (rsItems.next()) {
                    OrderItem item = extractOrderItemFromResultSet(rsItems);
                    item.setMenuItem(getMenuItemForOrderItem(conn, item.getMenuItemId()));
                    order.addOrderItem(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("JDBC getByStringId error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(rsItems, psItems, rsOrder, psOrder, conn);
        }
        return order;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement psOrders = null;
        PreparedStatement psItems = null;
        ResultSet rsOrders = null;
        ResultSet rsItems = null;
        try {
            conn = DBConnection.getConnection();
            psOrders = conn.prepareStatement(SELECT_ORDERS_BY_USER);
            psOrders.setInt(1, userId);
            rsOrders = psOrders.executeQuery();
            while (rsOrders.next()) {
                Order order = extractOrderFromResultSet(rsOrders);
                list.add(order);
            }
            
            // For each order, fetch items
            for (Order order : list) {
                psItems = conn.prepareStatement(SELECT_ITEMS_BY_ORDER);
                psItems.setInt(1, order.getId());
                rsItems = psItems.executeQuery();
                while (rsItems.next()) {
                    OrderItem item = extractOrderItemFromResultSet(rsItems);
                    item.setMenuItem(getMenuItemForOrderItem(conn, item.getMenuItemId()));
                    order.addOrderItem(item);
                }
                DBConnection.closeResources(rsItems, psItems);
            }
        } catch (SQLException e) {
            System.err.println("JDBC getOrdersByUser error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(rsOrders, psOrders, conn);
        }
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement psOrders = null;
        PreparedStatement psItems = null;
        ResultSet rsOrders = null;
        ResultSet rsItems = null;
        try {
            conn = DBConnection.getConnection();
            psOrders = conn.prepareStatement(SELECT_ALL_ORDERS);
            rsOrders = psOrders.executeQuery();
            while (rsOrders.next()) {
                Order order = extractOrderFromResultSet(rsOrders);
                list.add(order);
            }
            
            // Fetch items
            for (Order order : list) {
                psItems = conn.prepareStatement(SELECT_ITEMS_BY_ORDER);
                psItems.setInt(1, order.getId());
                rsItems = psItems.executeQuery();
                while (rsItems.next()) {
                    OrderItem item = extractOrderItemFromResultSet(rsItems);
                    item.setMenuItem(getMenuItemForOrderItem(conn, item.getMenuItemId()));
                    order.addOrderItem(item);
                }
                DBConnection.closeResources(rsItems, psItems);
            }
        } catch (SQLException e) {
            System.err.println("JDBC getAllOrders error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeResources(rsOrders, psOrders, conn);
        }
        return list;
    }

    @Override
    public boolean updateOrderStatus(int id, String newStatus) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(UPDATE_ORDER_STATUS);
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("JDBC updateOrderStatus error: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeResources(ps, conn);
        }
    }

    @Override
    public boolean updatePaymentStatus(int id, String newPaymentStatus) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(UPDATE_PAYMENT_STATUS);
            ps.setString(1, newPaymentStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("JDBC updatePaymentStatus error: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeResources(ps, conn);
        }
    }

    @Override
    public boolean cancelOrder(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(DELETE_ORDER);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("JDBC cancelOrder error: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeResources(ps, conn);
        }
    }

    private MenuItem getMenuItemForOrderItem(Connection conn, int menuItemId) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement("SELECT * FROM menu_items WHERE id = ?;");
            ps.setInt(1, menuItemId);
            rs = ps.executeQuery();
            if (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("id"));
                item.setRestaurantId(rs.getInt("restaurant_id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setImageUrl(rs.getString("image_url"));
                item.setCategory(rs.getString("category"));
                item.setVegetarian(rs.getBoolean("is_vegetarian"));
                item.setAvailable(rs.getBoolean("is_available"));
                return item;
            }
        } catch (SQLException e) {
            System.err.println("JDBC getMenuItemForOrderItem error: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, ps);
        }
        return null;
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderId(rs.getString("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        return order;
    }

    private OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setMenuItemId(rs.getInt("menu_item_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));
        return item;
    }
}
