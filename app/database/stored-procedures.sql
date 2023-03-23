

-- Procedure to insert a new user into the users table
CREATE PROCEDURE sp_InsertUser
(
    @user_type VARCHAR(42),
    @user_name VARCHAR(42),
    @password VARCHAR(99),
    @full_name VARCHAR(99),
    @phone_number VARCHAR(20),
    @date_of_birth DATE,
    @account_creation_date DATETIME2
)
AS
BEGIN
    INSERT INTO users (user_type, user_name, [password], full_name, phone_number, date_of_birth, account_creation_date, is_account_deleted)
    VALUES (@user_type, @user_name, @password, @full_name, @phone_number, @date_of_birth, @account_creation_date, 0)
END
GO

-- Procedure to update a  user in the users table
CREATE PROCEDURE sp_UpdateUser
(
    @user_id INT,
    @user_type VARCHAR(42),
    @user_name VARCHAR(42),
    @password VARCHAR(99),
    @full_name VARCHAR(99),
    @phone_number VARCHAR(20),
    @date_of_birth DATE
)
AS
BEGIN
    UPDATE users
    SET user_type = @user_type,
        user_name = @user_name,
        [password] = @password,
        full_name = @full_name,
        phone_number = @phone_number,
        date_of_birth = @date_of_birth
    WHERE user_id = @user_id
END
GO

-- Procedure to delete a  user in the users table
CREATE PROCEDURE sp_DeleteUser
(
    @user_id INT
)
AS
BEGIN
    DELETE FROM users
    WHERE user_id = @user_id
END
GO

-- Procedure to get all  users in the users table
CREATE PROCEDURE sp_GetUsers
AS
BEGIN
    SELECT *
    FROM users
END
GO

-- Procedure to insert a new product into the products table
CREATE PROCEDURE sp_InsertProduct
(
    @category_id UNIQUEIDENTIFIER,
    @product_name VARCHAR(99),
    @product_description VARCHAR(max),
    @product_price DECIMAL(10, 2)
)
AS
BEGIN
    INSERT INTO products (category_id, product_name, product_description, product_price, is_approved, date_modified)
    VALUES (@category_id, @product_name, @product_description, @product_price, 0, GETDATE())
END
GO

-- Procedure to update a  product  the products table
CREATE PROCEDURE sp_UpdateProduct
(
    @product_id UNIQUEIDENTIFIER,
    @category_id UNIQUEIDENTIFIER,
    @product_name VARCHAR(99),
    @product_description VARCHAR(max),
    @product_price DECIMAL(10, 2),
    @is_approved BIT
)
AS
BEGIN
    UPDATE products
    SET category_id = @category_id,
        product_name = @product_name,
        product_description = @product_description,
        product_price = @product_price,
        is_approved = @is_approved,
        date_modified = GETDATE()
    WHERE product_id = @product_id
END
GO

-- Procedure to delete a  product  the products table
CREATE PROCEDURE sp_DeleteProduct
(
    @product_id UNIQUEIDENTIFIER
)
AS
BEGIN
    DELETE FROM products
    WHERE product_id = @product_id
END
GO

-- Procedure to get all  products in  the products table
CREATE PROCEDURE sp_GetProducts
AS
BEGIN
    SELECT *
    FROM products
END
GO

-- Procedure to insert a new category into the categories table
CREATE PROCEDURE sp_InsertCategory
(
    @category_name VARCHAR(42),
    @category_description VARCHAR(max)
)
AS
BEGIN
    INSERT INTO categories (category_name, category_description, date_modified)
    VALUES (@category_name, @category_description, GETDATE())
END
GO

-- Procedure to update an existing category in the categories table
CREATE PROCEDURE sp_UpdateCategory
(
    @category_id UNIQUEIDENTIFIER,
    @category_name VARCHAR(42),
    @category_description VARCHAR(max)
)
AS
BEGIN
    UPDATE categories
    SET category_name = @category_name,
        category_description = @category_description,
        date_modified = GETDATE()
    WHERE category_id = @category_id
END
GO

-- Procedure to delete a category from the categories table
CREATE PROCEDURE sp_DeleteCategory
(
    @category_id UNIQUEIDENTIFIER
)
AS
BEGIN
    DELETE FROM categories
    WHERE category_id = @category_id
END
GO

-- Procedure to retrieve all categories from the categories table
CREATE PROCEDURE sp_GetCategories
AS
BEGIN
    SELECT *
    FROM categories
END
GO

-- Procedure to insert a new sale into the sales table
CREATE PROCEDURE sp_InsertSale
(
@customer_id INT,
@sale_date DATETIME2,
@sale_state VARCHAR(42),
@loyalty_points INT,
@total_amount DECIMAL(10, 2)
)
AS
BEGIN
INSERT INTO sales (customer_id, sale_date, sale_state, loyalty_points, total_amount, date_modified)
VALUES (@customer_id, @sale_date, @sale_state, @loyalty_points, @total_amount, GETDATE())
END
GO

-- Procedure to update an existing sale in the sales table
CREATE PROCEDURE sp_UpdateSale
(
@sale_id UNIQUEIDENTIFIER,
@customer_id INT,
@sale_date DATETIME2,
@sale_state VARCHAR(42),
@loyalty_points INT,
@total_amount DECIMAL(10, 2)
)
AS
BEGIN
UPDATE sales
SET customer_id = @customer_id,
sale_date = @sale_date,
sale_state = @sale_state,
loyalty_points = @loyalty_points,
total_amount = @total_amount,
date_modified = GETDATE()
WHERE sale_id = @sale_id
END
GO

-- Procedure to delete a sale from the sales table
CREATE PROCEDURE sp_DeleteSale
(
@sale_id UNIQUEIDENTIFIER
)
AS
BEGIN
DELETE FROM sales
WHERE sale_id = @sale_id
END
GO

-- Procedure to retrieve all sales from the sales table
CREATE PROCEDURE sp_GetSales
AS
BEGIN
SELECT *
FROM sales
END
GO

-- Procedure to insert a new notification into the notifications table
CREATE PROCEDURE sp_InsertNotification
(
@user_id INT,
@notification_date DATETIME2,
@notification_type VARCHAR(42),
@notification_data VARCHAR(max)
)
AS
BEGIN
INSERT INTO notifications (user_id, notification_date, notification_type, notification_data)
VALUES (@user_id, @notification_date, @notification_type, @notification_data)
END
GO

-- Procedure to update an existing notification in the notifications table
CREATE PROCEDURE sp_UpdateNotification
(
@notification_id UNIQUEIDENTIFIER,
@user_id INT,
@notification_date DATETIME2,
@notification_type VARCHAR(42),
@notification_data VARCHAR(max)
)
AS
BEGIN
UPDATE notifications
SET user_id = @user_id,
notification_date = @notification_date,
notification_type = @notification_type,
notification_data = @notification_data
WHERE notification_id = @notification_id
END
GO

-- Procedure to delete a notification from the notifications table
CREATE PROCEDURE sp_DeleteNotification
(
@notification_id UNIQUEIDENTIFIER
)
AS
BEGIN
DELETE FROM notifications
WHERE notification_id = @notification_id
END
GO

-- Procedure to retrieve all notifications from the notifications table
CREATE PROCEDURE sp_GetNotifications
AS
BEGIN
SELECT *
FROM notifications
END
GO
 
 
