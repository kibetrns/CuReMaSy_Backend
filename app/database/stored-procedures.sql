USE CuReMaSy_DB
GO

/*****************************************************************************USERS*****************************************************************************************/

/**Procedure  for creating user **/
CREATE PROCEDURE sp_CreateUser
    @user_type VARCHAR(42),
    @user_name VARCHAR(42),
    @email VARCHAR(99),
    @password VARCHAR(99),
    @full_name VARCHAR(99),
    @phone_number VARCHAR(20),
    @date_of_birth DATE,
    @profile_picture VARBINARY(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO users (user_type, user_name, email, [password], full_name, phone_number, date_of_birth,
                       account_creation_date, is_account_deleted, profile_picture)
    VALUES (@user_type, @user_name, @email, @password, @full_name, @phone_number, @date_of_birth, 
            GETUTCDATE(), 0, @profile_picture);

END;
GO

/** Procedure to for updating user **/
CREATE PROCEDURE sp_EditUser
(
    @user_id INT,
    @user_type VARCHAR(42),
    @user_name VARCHAR(42),
    @email VARCHAR(99),
    @password VARCHAR(99),
    @full_name VARCHAR(99),
    @phone_number VARCHAR(20),
    @date_of_birth DATE,
    @is_account_deleted BIT,
    @profile_picture VARBINARY(MAX)
)
AS
BEGIN
    UPDATE users
    SET user_type = @user_type,
        user_name = @user_name,
        email = @email,
        [password] = @password,
        full_name = @full_name,
        phone_number = @phone_number,
        date_of_birth = @date_of_birth,
        is_account_deleted = @is_account_deleted,
        profile_picture = @profile_picture
    WHERE user_id = @user_id;
END
GO

/** Procudure for deleting a user **/
CREATE PROCEDURE sp_DeleteUser
    @user_id INT
AS
BEGIN

    IF EXISTS(SELECT 1 FROM users WHERE user_id = @user_id AND user_type = 'Staff')
    BEGIN
        RAISERROR('A user of type ''Staff'' is not allowed to delete other users.', 16, 1)
        RETURN
    END
    
    DELETE FROM users WHERE user_id = @user_id

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('The user with ID %d does not exist.', 16, 1, @user_id)
        RETURN
    END

    DELETE FROM notifications WHERE user_id = @user_id
END
GO

/** Procudure for getting a user by userID **/
CREATE PROCEDURE sp_GetUserByID
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM users WHERE user_id = @user_id;
END
GO
/** Procedure for getting a user by email **/
CREATE PROCEDURE sp_GetUserByEmail
    @user_email VARCHAR(99)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM users WHERE email LIKE '%' + @user_email + '%';
END
GO



/**Procedure for fetching users*/
CREATE PROCEDURE sp_GetUsers
    @pageNumber INT,
    @pageSize INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id,
        user_type,
        user_name,
        email,
        full_name,
        phone_number,
        date_of_birth,
        account_creation_date,
        is_account_deleted,
        profile_picture
    FROM 
        users
    ORDER BY 
        user_id
    OFFSET (@pageNumber - 1) * @pageSize ROWS 
    FETCH NEXT @pageSize ROWS ONLY;
END
GO


/*****************************************************************************PRODUCTS************************************************************************************/

/**Procedure for inserting product*/
CREATE PROCEDURE sp_InsertProduct 
    @category_id UNIQUEIDENTIFIER,
    @product_name VARCHAR(99),
    @product_description VARCHAR(MAX),
    @product_price DECIMAL(10, 2),
    @user_id INT
AS
BEGIN
    DECLARE @user_type VARCHAR(42)
    SELECT @user_type = user_type FROM users WHERE user_id = @user_id

    DECLARE @is_approved BIT
    IF @user_type IN ('Admin', 'SUPER ADMIN')
        SET @is_approved = 1
    ELSE
        SET @is_approved = 0
    
    INSERT INTO products (category_id, product_name, product_description, product_price, is_approved, date_modified)
    VALUES (@category_id, @product_name, @product_description, @product_price, @is_approved, GETDATE())

    -- Check if product needs approval
    IF @is_approved = 0
    BEGIN
        -- Notify Admin or SUPER ADMIN
        DECLARE @notification_data VARCHAR(MAX)
        SET @notification_data = 'A new product has been added and is pending your approval'
        
        INSERT INTO notifications (user_id, notification_date, notification_type, notification_data)
        SELECT user_id, GETDATE(), 'Product_Added', @notification_data
        FROM users WHERE user_type IN ('Admin', 'SUPER ADMIN')
    END
END
GO

/**Procedure for updating product*/
CREATE PROCEDURE sp_UpdateProduct
    @product_id UNIQUEIDENTIFIER,
    @category_id UNIQUEIDENTIFIER,
    @product_name VARCHAR(99),
    @product_description VARCHAR(MAX),
    @product_price DECIMAL(10, 2),
    @user_id INT
AS
BEGIN

    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id = @user_id AND user_type IN ('SUPER ADMIN', 'Admin'))
    BEGIN
        RAISERROR('User is not authorized to update products.', 16, 1)
        RETURN
    END

    UPDATE products
    SET 
        category_id = @category_id,
        product_name = @product_name,
        product_description = @product_description,
        product_price = @product_price,
        is_approved = CASE WHEN (SELECT user_type FROM users WHERE user_id = @user_id) IN ('SUPER ADMIN', 'Admin') THEN 1 ELSE 0 END,
        date_modified = GETDATE()
    WHERE product_id = @product_id

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Product with ID  does not exist.', 16, 1)
        RETURN
    END
END
GO


/**Procedure for Deleting product*/
CREATE PROCEDURE sp_DeleteProduct
    @product_id UNIQUEIDENTIFIER,
    @user_id INT
AS
BEGIN

    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id = @user_id AND user_type IN ('SUPER ADMIN', 'Admin'))
    BEGIN
        RAISERROR('Only the SUPER ADMIN and Admin can delete a product.', 16, 1)
        RETURN
    END

    IF NOT EXISTS(SELECT 1 FROM products WHERE product_id = @product_id)
    BEGIN
        RAISERROR('The product with ID  does not exist.', 16, 1)
        RETURN
    END
    
    DELETE FROM products WHERE product_id = @product_id

    SELECT 'Product deleted successfully.' AS message
END
GO


/**Procedure for fetching products*/
CREATE PROCEDURE sp_GetProducts
    @pageSize INT = 10,
    @pageNumber INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY product_name) AS RowNumber
    FROM 
        products
    ORDER BY 
        product_name
    OFFSET 
        (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT 
        @pageSize ROWS ONLY;
END
GO

/**Procedure for fetching approved products*/
CREATE PROCEDURE sp_GetApprovedProducts
(
    @PageNumber INT = 1, 
    @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalCount INT;

    SELECT @TotalCount = COUNT(*) 
    FROM products 
    WHERE is_approved = 1;

    SELECT 
        products.product_id,
        categories.category_name,
        products.product_name,
        products.product_description,
        products.product_price,
        products.is_approved,
        products.date_modified
    FROM products
    INNER JOIN categories ON products.category_id = categories.category_id
    WHERE products.is_approved = 1
    ORDER BY products.date_modified DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT @TotalCount AS TotalCount;
END;
GO

/**Procedure for fetching NOT approved products*/
CREATE PROCEDURE sp_GetNotApprovedProducts
(
    @PageNumber INT = 1, 
    @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalCount INT;

    SELECT @TotalCount = COUNT(*) 
    FROM products 
    WHERE is_approved = 0;

    SELECT 
        products.product_id,
        categories.category_name,
        products.product_name,
        products.product_description,
        products.product_price,
        products.is_approved,
        products.date_modified
    FROM products
    INNER JOIN categories ON products.category_id = categories.category_id
    WHERE products.is_approved = 1
    ORDER BY products.date_modified DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT @TotalCount AS TotalCount;
END;
GO

/**Procedure for fetching a product by product id*/
CREATE PROCEDURE sp_GetProductByID
    @productID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        product_id,
        category_id,
        product_name,
        product_description,
        product_price,
        is_approved,
        date_modified
    FROM 
        products 
    WHERE 
        product_id = @productID;
END
GO

/**Procedure for fetching a product by product name*/
CREATE PROCEDURE sp_GetProductByName
    @productName VARCHAR(99)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        product_id,
        category_id,
        product_name,
        product_description,
        product_price,
        is_approved,
        date_modified
    FROM 
        products 
    WHERE 
        product_name LIKE '%' + @productName + '%';
END
GO





/*****************************************************************************CATEGORIES***********************************************************************************/

/**Procedure for inserting category*/
CREATE PROCEDURE sp_InsertCategory 
    @category_name VARCHAR(42),
    @category_description VARCHAR(max),
    @user_id INT
AS
BEGIN
    DECLARE @user_type VARCHAR(42)
    SELECT @user_type = user_type FROM users WHERE user_id = @user_id

    DECLARE @is_approved BIT
    IF @user_type IN ('Admin', 'SUPER ADMIN')
        SET @is_approved = 1
    ELSE
        SET @is_approved = 0
    
    INSERT INTO categories (category_name, category_description, date_modified)
    VALUES (@category_name, @category_description, GETUTCDATE());

    -- Check if product needs approval
    IF @is_approved = 0
    BEGIN
        -- Notify Admin or SUPER ADMIN
        DECLARE @notification_data VARCHAR(MAX)
        SET @notification_data = 'A new category has been added and is pending your approval'
        
        INSERT INTO notifications (user_id, notification_date, notification_type, notification_data)
        SELECT user_id, GETDATE(), 'Category_Added', @notification_data
        FROM users WHERE user_type IN ('Admin', 'SUPER ADMIN')
    END
END
GO

/**Procedure for updating Category*/
CREATE PROCEDURE sp_UpdateCategory
    @category_id UNIQUEIDENTIFIER,
    @category_name VARCHAR(42),
    @category_description VARCHAR(max),
    @user_id INT
AS
BEGIN

    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id = @user_id AND user_type IN ('SUPER ADMIN', 'Admin'))
    BEGIN
        RAISERROR('User is not authorized to update categories.', 16, 1)
        RETURN
    END

    UPDATE categories
    SET 
        category_id = @category_id,
        category_name = @category_name,
        category_description = @category_description,
        is_approved = CASE WHEN (SELECT user_type FROM users WHERE user_id = @user_id) IN ('SUPER ADMIN', 'Admin') THEN 1 ELSE 0 END,
        date_modified = GETDATE()
    WHERE category_id = @category_id

    IF @@ROWCOUNT = 0
    BEGIN
            RAISERROR('Category with ID does not exist.', 16, 1)
        RETURN
    END
END
GO


/**Procedure for Deleting category*/
CREATE PROCEDURE sp_DeleteCategory
    @category_id UNIQUEIDENTIFIER,
    @user_id INT
AS
BEGIN

    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id = @user_id AND user_type IN ('SUPER ADMIN', 'Admin'))
    BEGIN
        RAISERROR('Only the SUPER ADMIN and Admin can delete a category.', 16, 1)
        RETURN
    END

    IF NOT EXISTS(SELECT 1 FROM categories WHERE category_id = @category_id)
    BEGIN
        RAISERROR('The category with ID  does not exist.', 16, 1)
        RETURN
    END
    
    DELETE FROM categories WHERE category_id = @category_id
    SELECT 'Category with ID ' + CAST(@category_id AS VARCHAR(36)) + ' deleted successfully.' AS message

END
GO


/**Procedure for fetching a category by category id*/
CREATE PROCEDURE sp_GetCategoryByID
    @categoryId UNIQUEIDENTIFIER
AS
BEGIN

    SELECT *
    FROM categories
    WHERE category_id = @categoryId;
END;
GO


/**Procedure for fetching a category by category name*/
CREATE PROCEDURE sp_GetCategoryByName
    @categoryName VARCHAR(42)
AS
BEGIN
    SELECT *
    FROM categories
    WHERE category_name LIKE '%' + @categoryName + '%'
END
GO

/**Procedure for fetching all categories*/

CREATE PROCEDURE sp_GetCategories
(
    @PageNumber INT = 1,
    @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY date_modified DESC) AS RowNum,
               category_id,
               category_name,
               category_description,
               is_approved,
               date_modified
        FROM categories
    ) AS CategoriesWithRowNum
    WHERE RowNum BETWEEN ((@PageNumber - 1) * @PageSize + 1) AND (@PageNumber * @PageSize)
    ORDER BY date_modified DESC;
END
GO

/**Procedure for fetching all APPROVED categories*/

CREATE PROCEDURE sp_GetApprovedCategories
    @PageSize INT,
    @PageNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT category_id, category_name, category_description, is_approved, date_modified
    FROM categories
    WHERE is_approved = 1
    ORDER BY date_modified DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

/**Procedure for fetching all NOT approved categories*/

CREATE PROCEDURE sp_GetNotApprovedCategories
    @PageSize INT,
    @PageNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT category_id, category_name, category_description, is_approved, date_modified
    FROM categories
    WHERE is_approved = 0
    ORDER BY date_modified DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO



/*********************************************************************************SALES************************************************************************************/

--Procedure for deleting a sale
CREATE PROCEDURE sp_DeleteSale
    @sale_id INT,
    @user_id INT
AS
BEGIN

    IF NOT EXISTS(SELECT 1 FROM users WHERE user_id = @user_id AND user_type IN ('Admin', 'SUPER ADMIN', 'Staff'))
    BEGIN
        RAISERROR('User is not authorized to delete sales.', 16, 1)
        RETURN
    END

    DELETE FROM sales WHERE sale_id = @sale_id

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Sale with ID does not exist.', 16, 1)
        RETURN
    END
END
GO

--Procedure for adding a product to a sale
CREATE PROCEDURE sp_AddProductToSale 
    @sale_id INT,
    @product_id UNIQUEIDENTIFIER,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM sales WHERE sale_id = @sale_id)
    BEGIN
        RAISERROR('Sale with id does not exist', 16, 1);
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM products WHERE product_id = @product_id)
    BEGIN
        RAISERROR('Product with id does not exist', 16, 1);
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM sale_products WHERE sale_id = @sale_id AND product_id = @product_id)
    BEGIN
        RAISERROR('Product with id has already been added to sale id', 16, 1);
        RETURN;
    END
    
    INSERT INTO sale_products (sale_id, product_id, quantity) 
    VALUES (@sale_id, @product_id, @quantity);
    
    UPDATE s 
    SET s.total_amount = (SELECT SUM(p.product_price * sp.quantity) FROM sale_products sp INNER JOIN products p ON sp.product_id = p.product_id WHERE sp.sale_id = @sale_id), 
        s.date_modified = GETDATE() 
    FROM sales s
    WHERE s.sale_id = @sale_id;
END
GO



/*Procedure for deleting a product from a sale*/
CREATE PROCEDURE sp_DeleteSaleProduct
    @sale_id INT,
    @product_id UNIQUEIDENTIFIER
AS
BEGIN
    DELETE FROM sale_products
    WHERE sale_id = @sale_id AND product_id = @product_id
END
GO


/**Procedure for updating a product in a sale**/
CREATE PROCEDURE sp_UpdateSaleProduct 
    @sale_id INT,
    @product_id UNIQUEIDENTIFIER,
    @quantity INT
AS
BEGIN
    UPDATE sale_products
    SET quantity = @quantity
    WHERE sale_id = @sale_id AND product_id = @product_id;
    
    UPDATE sales
    SET date_modified = GETDATE()
    WHERE sale_id = @sale_id;
END
GO



CREATE PROCEDURE sp_createSale
    @seller_id INT,
    @customer_id INT,
    @sale_date DATETIME2,
    @sale_state VARCHAR(42),
    @loyalty_points INT,
    @total_amount DECIMAL(10, 2),
    @product_ids VARCHAR(MAX),
    @quantities VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into the sales table
    INSERT INTO sales (seller_id, customer_id, sale_date, sale_state, loyalty_points, total_amount, date_modified)
    VALUES (@seller_id, @customer_id, @sale_date, @sale_state, @loyalty_points, @total_amount, GETDATE());

    -- Retrieve the newly created sale_id
    DECLARE @sale_id INT = SCOPE_IDENTITY();

    -- Insert into the sale_products table
    DECLARE @num_rows INT = (SELECT COUNT(*) FROM STRING_SPLIT(@product_ids, ','));
    DECLARE @counter INT = 1;

    WHILE @counter <= @num_rows
    BEGIN
        DECLARE @product_id UNIQUEIDENTIFIER = (SELECT value FROM (SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn FROM STRING_SPLIT(@product_ids, ',')) AS split WHERE rn = @counter);
        DECLARE @quantity INT = (SELECT value FROM (SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn FROM STRING_SPLIT(@quantities, ',')) AS split WHERE rn = @counter);
    
        INSERT INTO sale_products (sale_id, product_id, quantity)
        VALUES (@sale_id, @product_id, @quantity);

        SET @counter += 1;
    END

    -- Return the sale_id
    SELECT @sale_id AS sale_id;
END
GO





/**Procedure for deleting a sale **/
CREATE PROCEDURE sp_DeleteSale
    @sale_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Delete the sale from the sales table
    DELETE FROM sales WHERE sale_id = @sale_id;

    -- Delete any associated records in the sale_products table
    DELETE FROM sale_products WHERE sale_id = @sale_id;

    -- Print a message indicating success
    PRINT 'Sale deleted successfully.'
END
GO

/*Procedure for editing a sale*/
CREATE PROCEDURE sp_EditSale
    @sale_id INT,
    @seller_id INT,
    @customer_id INT,
    @sale_date DATETIME2,
    @sale_state VARCHAR(42),
    @loyalty_points INT,
    @total_amount DECIMAL(10, 2)
AS
BEGIN
    UPDATE sales
    SET seller_id = @seller_id,
        customer_id = @customer_id,
        sale_date = @sale_date,
        sale_state = @sale_state,
        loyalty_points = @loyalty_points,
        total_amount = @total_amount,
        date_modified = GETDATE()
    WHERE sale_id = @sale_id
END
GO

-- Procedure to get the sale details
CREATE PROCEDURE sp_GetSaleDetails
    @sale_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        s.sale_id,
        s.sale_date,
        s.total_amount,
        u.full_name AS customer_name,
        p.product_name,
        sp.quantity,
        p.product_price
    FROM
        sales s
        INNER JOIN users u ON s.customer_id = u.user_id
        INNER JOIN sale_products sp ON s.sale_id = sp.sale_id
        INNER JOIN products p ON sp.product_id = p.product_id
    WHERE
        s.sale_id = @sale_id;
END
GO

/**Procedure for fetching sales*/
CREATE PROCEDURE sp_GetSales
    @pageSize INT,
    @pageNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        s.sale_id,
        u.user_name AS seller_name,
        u1.user_name AS customer_name,
        s.sale_date,
        s.sale_state,
        s.loyalty_points,
        s.total_amount,
        ROW_NUMBER() OVER (ORDER BY s.sale_date DESC) AS row_number
    FROM 
        sales s
        INNER JOIN users u ON s.seller_id = u.user_id
        INNER JOIN users u1 ON s.customer_id = u1.user_id
    ORDER BY s.sale_date DESC
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO

/******************************************************************************USERS_AND_SALES************************************************************************************/


/**Procedure for fetching  a user's sales*/
CREATE PROCEDURE sp_GetUserSales
    @user_id INT,
    @page_number INT,
    @page_size INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT COUNT(*) AS total_sales
    FROM sales
    WHERE customer_id = @user_id;

    SELECT
        s.sale_id,
        s.sale_date,
        s.sale_state,
        s.loyalty_points,
        s.total_amount,
        p.product_name,
        sp.quantity
    FROM
        sales s
        INNER JOIN sale_products sp ON s.sale_id = sp.sale_id
        INNER JOIN products p ON sp.product_id = p.product_id
    WHERE
        s.customer_id = @user_id
    ORDER BY
        s.sale_date DESC
    OFFSET (@page_number - 1) * @page_size ROWS
    FETCH NEXT @page_size ROWS ONLY;
END
GO

/******************************************************************************REPORTS************************************************************************************/

--Weekly Reports
CREATE PROCEDURE sp_GetWeeklySalesSummary
    @weekStartDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @weekEndDate DATE = DATEADD(WEEK, 1, @weekStartDate);

    SELECT 
        COUNT(DISTINCT CASE WHEN u.user_type = 'Customers' THEN u.user_id END) AS customer_count,
        COUNT(DISTINCT s.sale_id) AS sale_count,
        COUNT(sp.product_id) AS product_count,
        SUM(s.total_amount) AS total_sales_amount
    FROM 
        users u
        INNER JOIN sales s ON s.customer_id = u.user_id
        INNER JOIN sale_products sp ON s.sale_id = sp.sale_id
    WHERE 
        s.sale_date >= @weekStartDate AND s.sale_date < @weekEndDate;
END
GO


--Weekly Reports By Sale State
CREATE PROCEDURE GetSalesByStateAndDayOfWeek
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    WITH CTE AS (
        SELECT 
            DATEPART(WEEKDAY, sale_date) AS day_of_week, 
            sale_state,
            SUM(total_amount) AS total_sales
        FROM 
            sales
        WHERE 
            sale_date BETWEEN @start_date AND @end_date
        GROUP BY 
            DATEPART(WEEKDAY, sale_date), 
            sale_state
    )
    SELECT 
        day_of_week,
        SUM(CASE WHEN sale_state = 'Completed' THEN total_sales ELSE 0 END) AS completed_sales_total,
        SUM(CASE WHEN sale_state = 'Refunded' THEN total_sales ELSE 0 END) AS refunded_sales_total
    FROM 
        CTE
    GROUP BY 
        day_of_week
    ORDER BY 
        day_of_week
END
GO

--Monthly Reports By Sale State
CREATE PROCEDURE sp_CalculateMonthlySales
    @year INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DATEPART(MONTH, s.sale_date) AS Month,
        SUM(CASE WHEN s.sale_state = 'Completed' THEN s.total_amount ELSE 0 END) AS CompletedSalesAmount,
        SUM(CASE WHEN s.sale_state = 'Refunded' THEN s.total_amount ELSE 0 END) AS RefundedSalesAmount
    FROM 
        sales s
    WHERE 
        YEAR(s.sale_date) = @year
    GROUP BY 
        DATEPART(MONTH, s.sale_date)
    ORDER BY 
        Month ASC;
END
GO

--Monthly Reports
CREATE PROCEDURE sp_GetMonthlySalesSummary
    @monthStartDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @monthEndDate DATE = DATEADD(MONTH, 1, @monthStartDate);

    SELECT 
        COUNT(DISTINCT CASE WHEN u.user_type = 'Customers' THEN u.user_id END) AS customer_count,
        COUNT(DISTINCT s.sale_id) AS sale_count,
        COUNT(sp.product_id) AS product_count,
        SUM(s.total_amount) AS total_sales_amount,
        DATEPART(DAY, s.sale_date) AS sale_day,
        s.sale_state
    FROM 
        users u
        INNER JOIN sales s ON s.customer_id = u.user_id
        INNER JOIN sale_products sp ON s.sale_id = sp.sale_id
    WHERE 
        s.sale_date >= @monthStartDate AND s.sale_date < @monthEndDate
    GROUP BY 
        DATEPART(DAY, s.sale_date),
        s.sale_state;
END
GO


--Quarterly Reports By Sale State
CREATE PROCEDURE sp_CalculateQuarterlySales
AS
BEGIN
    SELECT 
        DATEPART(QUARTER, s.sale_date) AS Quarter,
        SUM(CASE WHEN s.sale_state = 'Completed' THEN s.total_amount ELSE 0 END) AS CompletedSalesAmount,
        SUM(CASE WHEN s.sale_state = 'Refunded' THEN s.total_amount ELSE 0 END) AS RefundedSalesAmount
    FROM 
        sales s
    WHERE 
        YEAR(s.sale_date) = YEAR(GETDATE())
    GROUP BY 
        DATEPART(QUARTER, s.sale_date)
END
GO

--Quarterly Reports
CREATE PROCEDURE sp_GetQuarterlySalesSummary
    @year INT,
    @quarter INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @startDate DATE, @endDate DATE;
    IF @quarter = 1
    BEGIN
        SET @startDate = DATEFROMPARTS(@year, 1, 1);
        SET @endDate = DATEFROMPARTS(@year, 4, 1);
    END
    ELSE IF @quarter = 2
    BEGIN
        SET @startDate = DATEFROMPARTS(@year, 4, 1);
        SET @endDate = DATEFROMPARTS(@year, 7, 1);
    END
    ELSE IF @quarter = 3
    BEGIN
        SET @startDate = DATEFROMPARTS(@year, 7, 1);
        SET @endDate = DATEFROMPARTS(@year, 10, 1);
    END
    ELSE IF @quarter = 4
    BEGIN
        SET @startDate = DATEFROMPARTS(@year, 10, 1);
        SET @endDate = DATEFROMPARTS(@year + 1, 1, 1);
    END
    ELSE
    BEGIN
        RAISERROR('Invalid quarter number', 16, 1);
        RETURN;
    END;

    SELECT 
        COUNT(DISTINCT CASE WHEN u.user_type = 'Customers' THEN u.user_id END) AS customer_count,
        COUNT(DISTINCT s.sale_id) AS sale_count,
        COUNT(sp.product_id) AS product_count,
        SUM(s.total_amount) AS total_sales_amount
    FROM 
        users u
        INNER JOIN sales s ON s.customer_id = u.user_id
        INNER JOIN sale_products sp ON s.sale_id = sp.sale_id
    WHERE 
        s.sale_date >= @startDate AND s.sale_date < @endDate;
END
GO


--Yearly Reports By Sale State
CREATE PROCEDURE sp_CalculateSalesYearly
AS
BEGIN
    SELECT
        YEAR(s.sale_date) AS 'Year',
        SUM(CASE WHEN s.sale_state = 'Completed' THEN s.total_amount ELSE 0 END) AS 'Completed Sales Total',
        COUNT(DISTINCT CASE WHEN u.user_type = 'Customers' THEN s.customer_id END) AS 'Number of Customers',
        COUNT(DISTINCT s.sale_id) AS 'Number of Sales',
        COUNT(DISTINCT sp.product_id) AS 'Number of Products Sold',
        SUM(CASE WHEN s.sale_state = 'Refunded' THEN s.total_amount ELSE 0 END) AS 'Refunded Sales Total'
    FROM 
        sales s
        JOIN sale_products sp ON s.sale_id = sp.sale_id
        JOIN users u ON s.customer_id = u.user_id
    GROUP BY 
        YEAR(s.sale_date)
END
GO

--Yearly Reports
CREATE PROCEDURE sp_GetYearlySalesSummary
    @year INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @startDate DATE = DATEFROMPARTS(@year, 1, 1);
    DECLARE @endDate DATE = DATEFROMPARTS(@year + 1, 1, 1);

    SELECT 
        COUNT(DISTINCT CASE WHEN u.user_type = 'Customers' THEN u.user_id END) AS customer_count,
        COUNT(DISTINCT s.sale_id) AS sale_count,
        COUNT(sp.product_id) AS product_count,
        SUM(s.total_amount) AS total_sales_amount,
        DATEPART(QUARTER, s.sale_date) AS quarter,
        s.sale_state,
        DATENAME(MONTH, s.sale_date) AS month_name
    FROM 
        users u
        INNER JOIN sales s ON s.customer_id = u.user_id
        INNER JOIN sale_products sp ON s.sale_id = sp.sale_id
    WHERE 
        s.sale_date >= @startDate AND s.sale_date < @endDate
    GROUP BY
        s.sale_state,
        DATEPART(QUARTER, s.sale_date),
        DATENAME(MONTH, s.sale_date);
END
GO

/*************************************************************************NOTIFICATIONS************************************************************************************/


