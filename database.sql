-- DATABASE SCHEMA FOR SONAURA

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  role ENUM('user','admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(100) UNIQUE,
  name VARCHAR(150),
  description TEXT,
  category VARCHAR(50),
  price DECIMAL(10,2),
  weight DECIMAL(10,2),
  image_url VARCHAR(255),
  metal_type ENUM('gold','silver'),
  purity VARCHAR(10),
  stock INT DEFAULT 0,
  margin_percent DECIMAL(5,2) DEFAULT 0,
  making_charges_type ENUM('percentage','fixed','per_gram') DEFAULT 'fixed',
  making_charges_value DECIMAL(10,2) DEFAULT 0,
  box_sku VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_sku (sku),
  INDEX idx_box_sku (box_sku),
  FOREIGN KEY (box_sku) REFERENCES item_master(sku) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS product_images (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_id (product_id),
  INDEX idx_display_order (display_order)
);

CREATE TABLE IF NOT EXISTS website_images (
  id INT AUTO_INCREMENT PRIMARY KEY,
  section VARCHAR(100) NOT NULL, -- 'hero', 'gallery', 'category', 'featured', etc.
  image_url VARCHAR(500) NOT NULL,
  title VARCHAR(255),
  description TEXT,
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_section (section),
  INDEX idx_display_order (display_order),
  INDEX idx_is_active (is_active)
);

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  quantity INT,
  total_price DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS wishlist (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  product_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS metal_prices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  metal VARCHAR(50), -- 'gold_24k', 'gold_22k', 'silver'
  rate_per_gram DECIMAL(10,2),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Minimal seed data
INSERT INTO products (name, description, category, price, weight, image_url, metal_type, stock)
VALUES
('22K Gold Chain', 'Elegant handcrafted gold chain', 'Chains', 0.00, 20.50, 'https://placehold.co/600x600', 'gold', 10),
('Silver Coin 20g', '999 purity silver coin', 'Coins', 0.00, 20.00, 'https://placehold.co/600x600', 'silver', 50);


