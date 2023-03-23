USE master
GO 

CREATE DATABASE CuReMaSy_DB
GO

USE CuReMaSy
GO

CREATE TABLE users(
    user_id INT PRIMARY KEY IDENTITY (101, 1),
    user_type VARCHAR(42) CONSTRAINT chk_user_type CHECK(user_type IN ('SUPER ADMIN', 'Admin', 'Staff', 'Customers')),
    user_name VARCHAR(42) UNIQUE, 
    email VARCHAR(99) UNIQUE,
    [password] VARCHAR(99),
    full_name VARCHAR(99),
    phone_number VARCHAR(20),
    date_of_birth DATE,
    account_creation_date DATETIME2,
    is_account_deleted BIT,
    profile_picture VARBINARY(MAX)
)
GO


CREATE TABLE categories(
    category_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT(NEWID()),
    category_name VARCHAR(42),
    category_description VARCHAR(max),
    date_modified DATETIME2
)
GO

CREATE TABLE products(
    product_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT(NEWID()),
    category_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES categories(category_id),
    product_name VARCHAR(99),
    product_description VARCHAR(max),
    product_price DECIMAL(10, 2),
    is_approved BIT,
    date_modified DATETIME2
)
GO

CREATE TABLE sales(
    sale_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT(NEWID()),
    customer_id INT FOREIGN KEY REFERENCES users(user_id),
    sale_date DATETIME2,
    sale_state VARCHAR(42) CONSTRAINT chk_sale_state CHECK(sale_state IN ('Completed', 'Refunded')),
    loyalty_points INT,
    total_amount DECIMAL(10, 2),
    date_modified DATETIME2
)
GO



CREATE TABLE sale_products (
    sale_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES sales(sale_id),
    product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(product_id),
    quantity INT,
    PRIMARY KEY (sale_id, product_id)
)
GO



CREATE TABLE notifications(
    notification_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT(NEWID()),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    notification_date DATETIME2,
    notification_type VARCHAR(42) CONSTRAINT chk_notification_type CHECK(notification_type IN ('Customer_Added', 'Purchase_Made', 'Weekly_Report')),
    notification_data VARCHAR(max)
)
GO 
