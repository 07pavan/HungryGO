package com.hungrygo.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;

/**
 * DB re-seeder utility class to execute the schema.sql file and initialize database with INR pricing.
 */
public class DbReseeder {
    public static void main(String[] args) {
        String schemaPath = "f:\\HungryGO\\schema.sql";
        System.out.println("DbReseeder: Starting to read schema.sql from " + schemaPath);
        
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(schemaPath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Ignore comments
                if (line.trim().startsWith("--") || line.trim().startsWith("#")) {
                    continue;
                }
                sb.append(line).append("\n");
            }
        } catch (Exception e) {
            System.err.println("DbReseeder: Failed to read schema.sql: " + e.getMessage());
            e.printStackTrace();
            return;
        }
        
        // Split by statement delimiters (;)
        String[] statements = sb.toString().split(";");
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
             
             System.out.println("DbReseeder: Connected to database. Executing " + statements.length + " statements...");
             
             for (int i = 0; i < statements.length; i++) {
                 String sql = statements[i].trim();
                 if (sql.isEmpty()) {
                     continue;
                 }
                 String snippet = sql.length() > 50 ? sql.substring(0, 50).replace("\n", " ") + "..." : sql.replace("\n", " ");
                 System.out.println("Executing statement [" + i + "]: " + snippet);
                 try {
                     stmt.execute(sql);
                 } catch (Exception ex) {
                     System.err.println("DbReseeder: Error executing statement [" + i + "]: " + ex.getMessage());
                 }
             }
             System.out.println("DbReseeder: Seeding completed successfully!");
        } catch (Exception e) {
             System.err.println("DbReseeder: Connection/Execution error: " + e.getMessage());
             e.printStackTrace();
        }
    }
}
