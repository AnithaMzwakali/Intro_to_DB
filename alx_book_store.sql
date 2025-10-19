-- alx_book_store.sql
-- STEP-BY-STEP: Build the alx_book_store MySQL database from scratch
-- ALL SQL KEYWORDS ARE UPPERCASE
-- Purpose: stores Books, Authors, Customers, Orders, and Order_Details

/*
STEP 0 - PREPARATION (what to run on your machine)
- Open a MySQL client (mysql CLI, MySQL Workbench, or phpMyAdmin).
- Make sure you have privileges to CREATE/DROP databases and CREATE TABLES.
- This file executes safely from a clean state by dropping the database first.

To run from the command line:
$ mysql -u <username> -p < alx_book_store.sql

*/

-- STEP 1: DROP DATABASE (clean slate)
DROP DATABASE IF EXISTS `alx_book_store`;

-- STEP 2: CREATE DATABASE with UTF8MB4 (supports emojis and wide unicode)
CREATE DATABASE `alx_book_store` CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- STEP 3: SWITCH TO THE DATABASE
USE `alx_book_store`;

-- STEP 4: CREATE AUTHORS TABLE
-- Rationale: Authors referenced by Books. Primary key is an AUTO_INCREMENT integer.
CREATE TABLE `Authors` (
  `author_id` INT NOT NULL AUTO_INCREMENT,
  `author_name` VARCHAR(215) NOT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB;

-- STEP 5: CREATE BOOKS TABLE
-- Rationale: Books reference Authors. Use DECIMAL for price to avoid floating-point rounding issues.
CREATE TABLE `Books` (
  `book_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(130) NOT NULL,
  `author_id` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `publication_date` DATE DEFAULT NULL,
  PRIMARY KEY (`book_id`),
  INDEX `idx_books_author_id` (`author_id`),
  CONSTRAINT `fk_books_author` FOREIGN KEY (`author_id`) REFERENCES `Authors` (`author_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- STEP 6: CREATE CUSTOMERS TABLE
CREATE TABLE `Customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(215) NOT NULL,
  `email` VARCHAR(215) NOT NULL UNIQUE,
  `address` TEXT,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB;

-- STEP 7: CREATE ORDERS TABLE
-- Rationale: Each order belongs to a customer. Use DATE or DATETIME depending on needs; here DATE as requested.
CREATE TABLE `Orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `order_date` DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`order_id`),
  INDEX `idx_orders_customer_id` (`customer_id`),
  CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `Customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- STEP 8: CREATE ORDER_DETAILS TABLE
-- Rationale: Each row links an order to a book and stores the quantity purchased.
CREATE TABLE `Order_Details` (
  `orderdetailid` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `book_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`orderdetailid`),
  INDEX `idx_od_order_id` (`order_id`),
  INDEX `idx_od_book_id` (`book_id`),
  CONSTRAINT `fk_od_order` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_od_book` FOREIGN KEY (`book_id`) REFERENCES `Books` (`book_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

/*
STEP 9: OPTIONAL - SAMPLE DATA (uncomment to run quick tests)
Note: sample data below follows the created schema. Uncomment and execute if you want to test queries.

INSERT INTO `Authors` (`author_name`) VALUES
  ('Jane Austen'),
  ('George Orwell'),
  ('J.K. Rowling');

INSERT INTO `Books` (`title`, `author_id`, `price`, `publication_date`) VALUES
  ('Pride and Prejudice', 1, 9.99, '1813-01-28'),
  ('1984', 2, 12.50, '1949-06-08'),
  ('Harry Potter and the Philosopher''s Stone', 3, 14.99, '1997-06-26');

INSERT INTO `Customers` (`customer_name`, `email`, `address`) VALUES
  ('Alice Smith', 'alice@example.com', '123 Main St, Johannesburg'),
  ('Bob Jones', 'bob@example.com', '456 Oak Ave, Cape Town');

INSERT INTO `Orders` (`customer_id`, `order_date`) VALUES
  (1, '2025-10-18'),
  (2, '2025-10-19');

INSERT INTO `Order_Details` (`order_id`, `book_id`, `quantity`) VALUES
  (1, 1, 1),
  (1, 2, 2),
  (2, 3, 1);

*/

-- STEP 10: EXAMPLE QUERIES (useful to verify schema and join data)
-- 1) List books with their authors and prices
-- SELECT b.title, a.author_name, b.price FROM `Books` b JOIN `Authors` a ON b.author_id = a.author_id;

-- 2) Show orders with customer names
-- SELECT o.order_id, c.customer_name, o.order_date FROM `Orders` o JOIN `Customers` c ON o.customer_id = c.customer_id;

-- 3) Show full order details (what each order contains)
-- SELECT o.order_id, c.customer_name, b.title, od.quantity, b.price
-- FROM `Order_Details` od
-- JOIN `Orders` o ON od.order_id = o.order_id
-- JOIN `Books` b ON od.book_id = b.book_id
-- JOIN `Customers` c ON o.customer_id = c.customer_id;

-- STEP 11: INDEX & PERFORMANCE NOTES
-- - Foreign key columns were indexed to speed up joins.
-- - Use DECIMAL for money (we used DECIMAL(10,2)).
-- - Quantity is an INT because fractional books don't make sense.

-- STEP 12: MIGRATION / PRODUCTION CONSIDERATIONS
-- - Add created_at/updated_at TIMESTAMP columns if you need auditing.
-- - Consider separating address into lines / city / postal_code for normalization.
-- - Add UNIQUE constraints (e.g. ISBN on Books) when you have those attributes.

-- END OF STEP-BY-STEP BUILD
