-- Migration script to add missing columns to products table
-- Run this in your MySQL/MariaDB client if you get "Unknown column 'making_charges_value' in 'field list'" error

-- Add making_charges_type column
-- If you get "Duplicate column name" error, skip this line as the column already exists
ALTER TABLE products 
ADD COLUMN making_charges_type ENUM('percentage','fixed','per_gram') DEFAULT 'fixed';

-- Add making_charges_value column
-- If you get "Duplicate column name" error, skip this line as the column already exists
ALTER TABLE products 
ADD COLUMN making_charges_value DECIMAL(10,2) DEFAULT 0;

-- Add margin_percent column
-- If you get "Duplicate column name" error, skip this line as the column already exists
ALTER TABLE products 
ADD COLUMN margin_percent DECIMAL(5,2) DEFAULT 0;
