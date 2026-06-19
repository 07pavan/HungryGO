package com.hungrygo.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Model class representing a user's session-based Shopping Cart.
 */
public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    private final Map<Integer, CartItem> items;

    public Cart() {
        this.items = new HashMap<>();
    }

    /**
     * Get the items present in the cart.
     * key: MenuItem ID, value: CartItem representing MenuItem and quantity.
     */
    public Map<Integer, CartItem> getItems() {
        return items;
    }

    /**
     * Adds an item to the cart or increments its quantity if it already exists.
     */
    public void addItem(MenuItem menuItem, int quantity) {
        if (menuItem == null || quantity <= 0) return;
        
        int itemId = menuItem.getId();
        if (items.containsKey(itemId)) {
            CartItem existing = items.get(itemId);
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            items.put(itemId, new CartItem(menuItem, quantity));
        }
    }

    /**
     * Updates the quantity of a specific item in the cart.
     * If quantity is <= 0, the item is removed from the cart.
     */
    public void updateQuantity(int menuItemId, int quantity) {
        if (quantity <= 0) {
            removeItem(menuItemId);
        } else if (items.containsKey(menuItemId)) {
            items.get(menuItemId).setQuantity(quantity);
        }
    }

    /**
     * Removes an item from the cart.
     */
    public void removeItem(int menuItemId) {
        items.remove(menuItemId);
    }

    /**
     * Clears all items in the cart.
     */
    public void clear() {
        items.clear();
    }

    /**
     * Gets the total number of individual items in the cart.
     */
    public int getCartSize() {
        int total = 0;
        for (CartItem item : items.values()) {
            total += item.getQuantity();
        }
        return total;
    }

    /**
     * Returns the dynamic total price of all items in the cart.
     */
    public BigDecimal getTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : items.values()) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }
}
