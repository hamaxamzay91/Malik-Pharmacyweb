-- =====================================================
-- MALIK PHARMACY - Complete Database Schema
-- MySQL 9 | UTF8MB4 | InnoDB
-- Version: 1.0.0
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS malik_pharmacy
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE malik_pharmacy;

-- =====================================================
-- ROLES & PERMISSIONS
-- =====================================================
CREATE TABLE roles (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permissions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  display_name VARCHAR(150) NOT NULL,
  module VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE role_permissions (
  role_id INT UNSIGNED NOT NULL,
  permission_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- USERS (Customers)
-- =====================================================
CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE DEFAULT (UUID()),
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  avatar VARCHAR(500),
  gender ENUM('male','female','other') DEFAULT NULL,
  date_of_birth DATE DEFAULT NULL,
  is_verified TINYINT(1) DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  email_verified_at TIMESTAMP NULL,
  phone_verified_at TIMESTAMP NULL,
  last_login_at TIMESTAMP NULL,
  login_count INT UNSIGNED DEFAULT 0,
  preferred_language ENUM('ku','en','ar') DEFAULT 'ku',
  preferred_theme ENUM('dark','light') DEFAULT 'dark',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  INDEX idx_email (email),
  INDEX idx_phone (phone),
  INDEX idx_uuid (uuid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_addresses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  title VARCHAR(50) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  city VARCHAR(100) NOT NULL,
  district VARCHAR(100),
  street TEXT NOT NULL,
  landmark TEXT,
  is_default TINYINT(1) DEFAULT 0,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- EMPLOYEES & ADMINS
-- =====================================================
CREATE TABLE employees (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE DEFAULT (UUID()),
  role_id INT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  avatar VARCHAR(500),
  position VARCHAR(100),
  department VARCHAR(100),
  salary DECIMAL(12,2),
  hire_date DATE,
  is_active TINYINT(1) DEFAULT 1,
  last_login_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id),
  INDEX idx_email (email),
  INDEX idx_role (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CATEGORIES
-- =====================================================
CREATE TABLE categories (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  parent_id INT UNSIGNED DEFAULT NULL,
  slug VARCHAR(200) NOT NULL UNIQUE,
  icon VARCHAR(100),
  image VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  meta_title_ku VARCHAR(255),
  meta_title_en VARCHAR(255),
  meta_title_ar VARCHAR(255),
  name_ku VARCHAR(255) NOT NULL,
  name_en VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255) NOT NULL,
  description_ku TEXT,
  description_en TEXT,
  description_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
  INDEX idx_slug (slug),
  INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- BRANDS
-- =====================================================
CREATE TABLE brands (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(200) NOT NULL UNIQUE,
  logo VARCHAR(500),
  website VARCHAR(500),
  country VARCHAR(100),
  is_active TINYINT(1) DEFAULT 1,
  name_ku VARCHAR(255) NOT NULL,
  name_en VARCHAR(255) NOT NULL,
  name_ar VARCHAR(255) NOT NULL,
  description_ku TEXT,
  description_en TEXT,
  description_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- MEDICINES / PRODUCTS
-- =====================================================
CREATE TABLE medicines (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE DEFAULT (UUID()),
  category_id INT UNSIGNED NOT NULL,
  brand_id INT UNSIGNED,
  sku VARCHAR(100) NOT NULL UNIQUE,
  barcode VARCHAR(100),
  slug VARCHAR(300) NOT NULL UNIQUE,
  main_image VARCHAR(500) NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  sale_price DECIMAL(12,2) DEFAULT NULL,
  cost_price DECIMAL(12,2),
  stock_quantity INT DEFAULT 0,
  min_stock_alert INT DEFAULT 10,
  unit VARCHAR(50) DEFAULT 'box',
  weight DECIMAL(8,2),
  requires_prescription TINYINT(1) DEFAULT 0,
  is_featured TINYINT(1) DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  expiry_date DATE,
  manufacturer_country VARCHAR(100),
  sort_order INT DEFAULT 0,
  view_count INT UNSIGNED DEFAULT 0,
  sales_count INT UNSIGNED DEFAULT 0,
  rating_avg DECIMAL(3,2) DEFAULT 0.00,
  rating_count INT UNSIGNED DEFAULT 0,
  -- Multi-language fields
  name_ku VARCHAR(300) NOT NULL,
  name_en VARCHAR(300) NOT NULL,
  name_ar VARCHAR(300) NOT NULL,
  description_ku LONGTEXT,
  description_en LONGTEXT,
  description_ar LONGTEXT,
  short_desc_ku TEXT,
  short_desc_en TEXT,
  short_desc_ar TEXT,
  usage_ku TEXT,
  usage_en TEXT,
  usage_ar TEXT,
  ingredients_ku TEXT,
  ingredients_en TEXT,
  ingredients_ar TEXT,
  side_effects_ku TEXT,
  side_effects_en TEXT,
  side_effects_ar TEXT,
  -- SEO
  meta_title_ku VARCHAR(255),
  meta_title_en VARCHAR(255),
  meta_title_ar VARCHAR(255),
  meta_desc_ku TEXT,
  meta_desc_en TEXT,
  meta_desc_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL,
  INDEX idx_slug (slug),
  INDEX idx_sku (sku),
  INDEX idx_category (category_id),
  INDEX idx_brand (brand_id),
  INDEX idx_price (price),
  INDEX idx_featured (is_featured),
  INDEX idx_active (is_active),
  FULLTEXT idx_search (name_ku, name_en, name_ar)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE medicine_images (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  medicine_id INT UNSIGNED NOT NULL,
  image_path VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
  INDEX idx_medicine (medicine_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE medicine_tags (
  medicine_id INT UNSIGNED NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (medicine_id, tag),
  FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- COUPONS & DISCOUNTS
-- =====================================================
CREATE TABLE coupons (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  type ENUM('percentage','fixed','free_shipping') NOT NULL,
  value DECIMAL(10,2) NOT NULL,
  min_order_amount DECIMAL(12,2) DEFAULT 0,
  max_discount_amount DECIMAL(12,2) DEFAULT NULL,
  usage_limit INT DEFAULT NULL,
  used_count INT DEFAULT 0,
  per_user_limit INT DEFAULT 1,
  applicable_to ENUM('all','categories','products') DEFAULT 'all',
  starts_at TIMESTAMP NULL,
  expires_at TIMESTAMP NULL,
  is_active TINYINT(1) DEFAULT 1,
  description_ku TEXT,
  description_en TEXT,
  description_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_code (code),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE coupon_usage (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  coupon_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  order_id INT UNSIGNED,
  used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coupon_id) REFERENCES coupons(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_coupon_user (coupon_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CART
-- =====================================================
CREATE TABLE carts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED,
  session_id VARCHAR(255),
  medicine_id INT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  price_at_add DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_session (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- PRESCRIPTIONS
-- =====================================================
CREATE TABLE prescriptions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE DEFAULT (UUID()),
  user_id INT UNSIGNED NOT NULL,
  image_path VARCHAR(500) NOT NULL,
  notes TEXT,
  status ENUM('pending','reviewing','approved','rejected') DEFAULT 'pending',
  reviewed_by INT UNSIGNED,
  reviewed_at TIMESTAMP NULL,
  review_notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (reviewed_by) REFERENCES employees(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ORDERS
-- =====================================================
CREATE TABLE orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uuid CHAR(36) NOT NULL UNIQUE DEFAULT (UUID()),
  order_number VARCHAR(30) NOT NULL UNIQUE,
  user_id INT UNSIGNED NOT NULL,
  prescription_id INT UNSIGNED,
  coupon_id INT UNSIGNED,
  address_id INT UNSIGNED,
  status ENUM('pending','confirmed','processing','shipped','delivered','cancelled','refunded') DEFAULT 'pending',
  payment_method ENUM('cash_on_delivery','bank_transfer','online') DEFAULT 'cash_on_delivery',
  payment_status ENUM('pending','paid','failed','refunded') DEFAULT 'pending',
  subtotal DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) DEFAULT 0,
  shipping_fee DECIMAL(12,2) DEFAULT 0,
  tax_amount DECIMAL(12,2) DEFAULT 0,
  total DECIMAL(12,2) NOT NULL,
  currency VARCHAR(10) DEFAULT 'IQD',
  notes TEXT,
  shipping_notes TEXT,
  delivered_at TIMESTAMP NULL,
  cancelled_at TIMESTAMP NULL,
  cancellation_reason TEXT,
  assigned_employee INT UNSIGNED,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE SET NULL,
  FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE SET NULL,
  FOREIGN KEY (address_id) REFERENCES user_addresses(id) ON DELETE SET NULL,
  FOREIGN KEY (assigned_employee) REFERENCES employees(id) ON DELETE SET NULL,
  INDEX idx_order_number (order_number),
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL,
  medicine_id INT UNSIGNED NOT NULL,
  medicine_name VARCHAR(300) NOT NULL,
  medicine_sku VARCHAR(100),
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  total_price DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE RESTRICT,
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_status_history (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id INT UNSIGNED NOT NULL,
  status ENUM('pending','confirmed','processing','shipped','delivered','cancelled','refunded') NOT NULL,
  note TEXT,
  changed_by INT UNSIGNED,
  changed_by_type ENUM('user','employee','system') DEFAULT 'system',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- WISHLISTS
-- =====================================================
CREATE TABLE wishlists (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  medicine_id INT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_wishlist (user_id, medicine_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- REVIEWS
-- =====================================================
CREATE TABLE reviews (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  medicine_id INT UNSIGNED NOT NULL,
  order_id INT UNSIGNED,
  rating TINYINT UNSIGNED NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title VARCHAR(255),
  comment TEXT,
  is_verified_purchase TINYINT(1) DEFAULT 0,
  is_approved TINYINT(1) DEFAULT 0,
  approved_by INT UNSIGNED,
  approved_at TIMESTAMP NULL,
  helpful_count INT UNSIGNED DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_review (user_id, medicine_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  FOREIGN KEY (approved_by) REFERENCES employees(id) ON DELETE SET NULL,
  INDEX idx_medicine (medicine_id),
  INDEX idx_rating (rating),
  INDEX idx_approved (is_approved)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- BLOG
-- =====================================================
CREATE TABLE blogs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  author_id INT UNSIGNED NOT NULL,
  slug VARCHAR(300) NOT NULL UNIQUE,
  featured_image VARCHAR(500),
  status ENUM('draft','published','archived') DEFAULT 'draft',
  published_at TIMESTAMP NULL,
  view_count INT UNSIGNED DEFAULT 0,
  reading_time INT UNSIGNED DEFAULT 0,
  -- Multi-language
  title_ku VARCHAR(300) NOT NULL,
  title_en VARCHAR(300) NOT NULL,
  title_ar VARCHAR(300) NOT NULL,
  excerpt_ku TEXT,
  excerpt_en TEXT,
  excerpt_ar TEXT,
  content_ku LONGTEXT,
  content_en LONGTEXT,
  content_ar LONGTEXT,
  meta_title_ku VARCHAR(255),
  meta_title_en VARCHAR(255),
  meta_title_ar VARCHAR(255),
  meta_desc_ku TEXT,
  meta_desc_en TEXT,
  meta_desc_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (author_id) REFERENCES employees(id),
  INDEX idx_slug (slug),
  INDEX idx_status (status),
  INDEX idx_published (published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE blog_tags (
  blog_id INT UNSIGNED NOT NULL,
  tag VARCHAR(100) NOT NULL,
  PRIMARY KEY (blog_id, tag),
  FOREIGN KEY (blog_id) REFERENCES blogs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- NOTIFICATIONS
-- =====================================================
CREATE TABLE notifications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED,
  employee_id INT UNSIGNED,
  type VARCHAR(100) NOT NULL,
  title_ku VARCHAR(255) NOT NULL,
  title_en VARCHAR(255) NOT NULL,
  title_ar VARCHAR(255) NOT NULL,
  body_ku TEXT,
  body_en TEXT,
  body_ar TEXT,
  data JSON,
  is_read TINYINT(1) DEFAULT 0,
  read_at TIMESTAMP NULL,
  channel ENUM('web','email','sms','push') DEFAULT 'web',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_employee (employee_id),
  INDEX idx_read (is_read),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CONTACTS / MESSAGES
-- =====================================================
CREATE TABLE contacts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150),
  phone VARCHAR(20),
  subject VARCHAR(255),
  message TEXT NOT NULL,
  is_read TINYINT(1) DEFAULT 0,
  replied_at TIMESTAMP NULL,
  reply_text TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- BANNERS & GALLERY
-- =====================================================
CREATE TABLE banners (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  position VARCHAR(100) NOT NULL,
  image VARCHAR(500) NOT NULL,
  link VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  starts_at TIMESTAMP NULL,
  ends_at TIMESTAMP NULL,
  title_ku VARCHAR(255),
  title_en VARCHAR(255),
  title_ar VARCHAR(255),
  subtitle_ku TEXT,
  subtitle_en TEXT,
  subtitle_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_position (position),
  INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE gallery (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  image VARCHAR(500) NOT NULL,
  caption_ku VARCHAR(255),
  caption_en VARCHAR(255),
  caption_ar VARCHAR(255),
  sort_order INT DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- SETTINGS
-- =====================================================
CREATE TABLE settings (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  key_name VARCHAR(100) NOT NULL UNIQUE,
  value LONGTEXT,
  type ENUM('text','number','boolean','json','image') DEFAULT 'text',
  group_name VARCHAR(50) DEFAULT 'general',
  is_public TINYINT(1) DEFAULT 0,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_key (key_name),
  INDEX idx_group (group_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ACTIVITY LOGS
-- =====================================================
CREATE TABLE activity_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED,
  employee_id INT UNSIGNED,
  action VARCHAR(100) NOT NULL,
  model_type VARCHAR(100),
  model_id INT UNSIGNED,
  old_values JSON,
  new_values JSON,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL,
  INDEX idx_user (user_id),
  INDEX idx_employee (employee_id),
  INDEX idx_model (model_type, model_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TOKEN BLACKLIST (JWT Logout)
-- =====================================================
CREATE TABLE token_blacklist (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  token_hash VARCHAR(64) NOT NULL UNIQUE,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_token (token_hash),
  INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- PASSWORD RESETS
-- =====================================================
CREATE TABLE password_resets (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(150) NOT NULL,
  token VARCHAR(64) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  used_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CAREERS
-- =====================================================
CREATE TABLE careers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  department VARCHAR(100),
  location VARCHAR(100),
  type ENUM('full_time','part_time','contract','internship') DEFAULT 'full_time',
  is_active TINYINT(1) DEFAULT 1,
  deadline DATE,
  title_ku VARCHAR(255) NOT NULL,
  title_en VARCHAR(255) NOT NULL,
  title_ar VARCHAR(255) NOT NULL,
  description_ku LONGTEXT,
  description_en LONGTEXT,
  description_ar LONGTEXT,
  requirements_ku TEXT,
  requirements_en TEXT,
  requirements_ar TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE career_applications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  career_id INT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  phone VARCHAR(20),
  cv_path VARCHAR(500) NOT NULL,
  cover_letter TEXT,
  status ENUM('pending','reviewing','shortlisted','rejected','hired') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (career_id) REFERENCES careers(id),
  INDEX idx_career (career_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- FAQ
-- =====================================================
CREATE TABLE faqs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(100),
  sort_order INT DEFAULT 0,
  is_active TINYINT(1) DEFAULT 1,
  question_ku TEXT NOT NULL,
  question_en TEXT NOT NULL,
  question_ar TEXT NOT NULL,
  answer_ku LONGTEXT NOT NULL,
  answer_en LONGTEXT NOT NULL,
  answer_ar LONGTEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- DEFAULT DATA
-- =====================================================
INSERT INTO roles (name, display_name, description) VALUES
('admin', 'Administrator', 'Full system access'),
('manager', 'Manager', 'Manage products and orders'),
('pharmacist', 'Pharmacist', 'Handle prescriptions and orders'),
('customer', 'Customer', 'Regular customer');

INSERT INTO permissions (name, display_name, module) VALUES
('products.view', 'View Products', 'products'),
('products.create', 'Create Products', 'products'),
('products.edit', 'Edit Products', 'products'),
('products.delete', 'Delete Products', 'products'),
('orders.view', 'View Orders', 'orders'),
('orders.manage', 'Manage Orders', 'orders'),
('users.view', 'View Users', 'users'),
('users.manage', 'Manage Users', 'users'),
('analytics.view', 'View Analytics', 'analytics'),
('settings.manage', 'Manage Settings', 'settings');

INSERT INTO settings (key_name, value, type, group_name, is_public) VALUES
('site_name', 'Malik Pharmacy', 'text', 'general', 1),
('site_name_ku', 'دەرمانخانەی مەلیک', 'text', 'general', 1),
('site_name_ar', 'صيدلية مالك', 'text', 'general', 1),
('site_email', 'info@malikpharmacy.com', 'text', 'general', 1),
('site_phone', '+964 750 000 0000', 'text', 'general', 1),
('site_address_ku', 'هەولێر، کوردستان', 'text', 'general', 1),
('currency', 'IQD', 'text', 'general', 1),
('currency_symbol', 'د.ع', 'text', 'general', 1),
('shipping_fee', '3000', 'number', 'shipping', 1),
('free_shipping_min', '50000', 'number', 'shipping', 1),
('tax_rate', '0', 'number', 'general', 0),
('maintenance_mode', '0', 'boolean', 'general', 0),
('google_maps_key', '', 'text', 'integrations', 0),
('recaptcha_key', '', 'text', 'integrations', 0),
('whatsapp_number', '+964750000000', 'text', 'social', 1),
('facebook_url', '', 'text', 'social', 1),
('instagram_url', '', 'text', 'social', 1),
('tiktok_url', '', 'text', 'social', 1);
