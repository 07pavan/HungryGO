package com.hungrygo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Utility class for managing database connections.
 * Supports JNDI connection pools first (recommended for Apache Tomcat)
 * and falls back to manual JDBC driver registration for standalone/Docker testing.
 */
public class DBConnectionUtil {

    // Fallback connection settings if JNDI connection pool is not available
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hungrygo_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "root";

    static {
        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver error: Class 'com.mysql.cj.jdbc.Driver' not found.");
            e.printStackTrace();
        }
    }

    /**
     * Gets a connection to the database.
     * Tries JNDI lookup for Tomcat connection pooling first, then falls back to direct JDBC.
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Try fetching from connection pool
            InitialContext context = new InitialContext();
            DataSource dataSource = (DataSource) context.lookup("java:comp/env/jdbc/HungryGoDS");
            if (dataSource != null) {
                return dataSource.getConnection();
            }
        } catch (NamingException e) {
            // Log fallback when lookup fails
            System.out.println("Tomcat JNDI lookup failed. Using fallback direct JDBC connection...");
        }

        // Standard direct connection
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }

    /**
     * Helper to close standard database result sets, statements and connections safely.
     */
    public static void closeResources(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception e) {
                    System.err.println("Exception closing JDBC resource: " + e.getMessage());
                }
            }
        }
    }
}
