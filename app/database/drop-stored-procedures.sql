/* Dropping stored procedures - users */

DROP PROCEDURE IF EXISTS sp_CreateUser
GO

DROP PROCEDURE IF EXISTS sp_EditUser
GO

DROP PROCEDURE IF EXISTS sp_DeleteUser
GO

DROP PROCEDURE IF EXISTS sp_SoftDeleteUser
GO

DROP PROCEDURE IF EXISTS sp_GetUserByID
GO

DROP PROCEDURE IF EXISTS sp_GetUserByEmail
GO  

DROP PROCEDURE IF EXISTS sp_GetUsers
GO

/* Dropping stored procedures - products */
DROP PROCEDURE IF EXISTS sp_InsertProduct
GO

DROP PROCEDURE IF EXISTS sp_UpdateProduct
GO

DROP PROCEDURE IF EXISTS sp_DeleteProduct
GO

DROP PROCEDURE IF EXISTS sp_GetProducts
GO

DROP PROCEDURE IF EXISTS sp_GetProductByID
GO

DROP PROCEDURE IF EXISTS sp_GetProductByName
GO

DROP PROCEDURE IF EXISTS sp_GetApprovedProducts
GO

DROP PROCEDURE IF EXISTS sp_GetNotApprovedProducts
GO

/* Dropping stored procedures - categories */
DROP PROCEDURE IF EXISTS sp_InsertCategory
GO

DROP PROCEDURE IF EXISTS sp_UpdateCategory
GO

DROP PROCEDURE IF EXISTS sp_DeleteCategory
GO

DROP PROCEDURE IF EXISTS sp_GetCategoryByID
GO

DROP PROCEDURE IF EXISTS sp_GetCategoryByName
GO

DROP PROCEDURE IF EXISTS sp_GetCategories
GO

DROP PROCEDURE IF EXISTS sp_GetApprovedCategories
GO

DROP PROCEDURE IF EXISTS sp_GetNotApprovedCategories
GO


/* Dropping stored procedures - sales */
DROP PROCEDURE IF EXISTS sp_DeleteSale
GO

DROP PROCEDURE IF EXISTS sp_AddProductToSale
GO

DROP PROCEDURE IF EXISTS sp_DeleteSaleProduct
GO

DROP PROCEDURE IF EXISTS sp_UpdateSaleProduct
GO

DROP PROCEDURE IF EXISTS sp_createSale
GO

DROP PROCEDURE IF EXISTS sp_DeleteSale
GO

DROP PROCEDURE IF EXISTS sp_EditSale
GO

DROP PROCEDURE IF EXISTS sp_GetSaleDetails
GO

DROP PROCEDURE IF EXISTS sp_GetSales
GO

/* Dropping stored procedures - sales_and_users */
DROP PROCEDURE IF EXISTS sp_GetUserSales
GO

/* Dropping stored procedures - reports */
DROP PROCEDURE IF EXISTS sp_GetWeeklySalesSummary
GO

DROP PROCEDURE IF EXISTS GetSalesByStateAndDayOfWeek
GO

DROP PROCEDURE IF EXISTS sp_CalculateMonthlySales
GO

DROP PROCEDURE IF EXISTS sp_GetMonthlySalesSummary
GO

DROP PROCEDURE IF EXISTS sp_CalculateQuarterlySales
GO

DROP PROCEDURE IF EXISTS sp_GetQuarterlySalesSummary
GO

DROP PROCEDURE IF EXISTS sp_CalculateSalesYearly
GO

DROP PROCEDURE IF EXISTS sp_GetYearlySalesSummary
GO