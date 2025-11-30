-- Migration script to add SKU system and item_master table
-- Run this if you have an existing database

-- Create item_master table first (if it doesn't exist)
CREATE TABLE IF NOT EXISTS item_master (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  item_type ENUM('box','packing','other') DEFAULT 'box',
  rate DECIMAL(10,2) NOT NULL DEFAULT 0,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_sku (sku),
  INDEX idx_item_type (item_type),
  INDEX idx_is_active (is_active)
);

-- Add SKU column to products (if it doesn't exist)
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS sku VARCHAR(100) UNIQUE;

-- Add box_sku column to products (if it doesn't exist)
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS box_sku VARCHAR(100);

-- Add index for box_sku
CREATE INDEX IF NOT EXISTS idx_box_sku ON products(box_sku);

-- Add foreign key constraint (if not exists)
-- Note: MySQL doesn't support IF NOT EXISTS for foreign keys, so check manually
-- ALTER TABLE products 
-- ADD CONSTRAINT fk_box_sku FOREIGN KEY (box_sku) REFERENCES item_master(sku) ON DELETE SET NULL;

