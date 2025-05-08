/*
 * MunMO - Modern Library Management System
 * SQL Script for MySQL
 * Author: Morgan Munene
 * GitHub: https://github.com/Morganwolfsbane
 * License: MIT
 * Version: 1.0.0
 */

-- =============================================
-- Database Creation with Morgan's Configuration
-- =============================================
DROP DATABASE IF EXISTS munmo_library;
CREATE DATABASE munmo_library 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci
    COMMENT 'MunMO Library Database by Morgan Munene';
USE munmo_library;

-- =============================================
-- Table: munmo_members - Patron Management
-- =============================================
CREATE TABLE munmo_members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    library_card_number VARCHAR(20) UNIQUE NOT NULL COMMENT 'Morgan-designed card format',
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    join_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_expiry DATE NOT NULL,
    status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    created_by VARCHAR(50) DEFAULT 'Morgan Munene',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT mw_chk_email CHECK (email LIKE '%@%.%'),
    CONSTRAINT mw_chk_expiry CHECK (membership_expiry >= join_date)
) COMMENT 'Library patron system by Morgan Munene';

-- =============================================
-- Table: munmo_authors - Author Database
-- =============================================
CREATE TABLE munmo_authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    biography TEXT,
    added_by VARCHAR(50) DEFAULT 'Morgan Munene',
    CONSTRAINT mw_chk_dates CHECK (death_date IS NULL OR death_date > birth_date)
) COMMENT 'Author database component by Morgan';

-- =============================================
-- Table: munmo_publishers - Publisher Reference
-- =============================================
CREATE TABLE munmo_publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_code VARCHAR(10) UNIQUE NOT NULL COMMENT 'Morgan-coded publisher IDs',
    name VARCHAR(100) NOT NULL,
    headquarters VARCHAR(100),
    founded_year INT,
    website VARCHAR(255),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT mw_chk_founded_year CHECK (founded_year BETWEEN 1400 AND YEAR(CURRENT_DATE))
) COMMENT 'Publisher reference system by Morgan Munene';

-- [Rest of the tables follow the same pattern with Morgan's signature...]

-- =============================================
-- Table: munmo_audit_log - Comprehensive Tracking
-- =============================================
CREATE TABLE munmo_audit_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id VARCHAR(50) NOT NULL,
    table_affected VARCHAR(50) NOT NULL,
    record_id VARCHAR(50) NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON,
    new_values JSON,
    client_ip VARCHAR(50),
    application_name VARCHAR(50) DEFAULT 'MunMO by Morgan',
    CONSTRAINT mw_chk_audit_values CHECK (JSON_VALID(old_values) AND JSON_VALID(new_values))
) COMMENT 'Comprehensive audit system designed by Morgan Munene';

-- =============================================
-- Morgan's Signature Indexes
-- =============================================
CREATE INDEX mw_idx_member_email ON munmo_members(email);
CREATE INDEX mw_idx_book_title ON munmo_books(title);
CREATE INDEX mw_idx_loan_dates ON munmo_loans(loan_date, due_date);

-- =============================================
-- Initial Admin Data (Morgan's Admin Account)
-- =============================================
INSERT INTO munmo_staff (
    employee_id, first_name, last_name, email, 
    position, department, hire_date
) VALUES (
    'MM001', 'Morgan', 'Munene', 'morgan@munmo.lib',
    'Admin', 'System', CURRENT_DATE
);
