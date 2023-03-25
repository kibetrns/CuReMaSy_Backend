/* Dropping stored procedures - users */

DROP PROCEDURE IF EXISTS sp_CreateUser;
DROP PROCEDURE IF EXISTS sp_EditUser;
DROP PROCEDURE IF EXISTS sp_DeleteUser;
DROP PROCEDURE IF EXISTS sp_GetUserByID;
DROP PROCEDURE IF EXISTS sp_GetUserByEmail;
DROP PROCEDURE IF EXISTS sp_GetAllUsers;
DROP PROCEDURE IF EXISTS sp_GetUser;

/* Dropping stored procedures - products */
DROP PROCEDURE IF EXISTS sp_InsertProduct;
DROP PROCEDURE IF EXISTS sp_UpdateProduct;
DROP PROCEDURE IF EXISTS sp_DeleteProduct;
DROP PROCEDURE IF EXISTS sp_GetProducts;
DROP PROCEDURE IF EXISTS sp_GetProductByID;
DROP PROCEDURE IF EXISTS sp_GetProductByName

/* Dropping stored procedures - categories */
DROP PROCEDURE IF EXISTS sp_InsertCategory;
DROP PROCEDURE IF EXISTS sp_UpdateCategory;
DROP PROCEDURE IF EXISTS sp_DeleteCategory;
DROP PROCEDURE IF EXISTS sp_GetCategoryByID
DROP PROCEDURE IF EXISTS sp_GetCategoryByName;


/* Dropping stored procedures - sales */
DROP PROCEDURE IF EXISTS sp_DeleteSale
DROP PROCEDURE IF EXISTS sp_AddProductToSale
DROP PROCEDURE IF EXISTS sp_DeleteSaleProduct
DROP PROCEDURE IF EXISTS sp_UpdateSaleProduct
DROP PROCEDURE IF EXISTS sp_createSale
DROP PROCEDURE IF EXISTS sp_DeleteSale
DROP PROCEDURE IF EXISTS sp_EditSale
DROP PROCEDURE IF EXISTS sp_GetSaleDetails
DROP PROCEDURE IF EXISTS sp_GetSales

/* Dropping stored procedures - sales_and_users */
DROP PROCEDURE IF EXISTS sp_GetUserSales

/* Dropping stored procedures - reports */
DROP PROCEDURE IF EXISTS sp_GetWeeklySalesSummary
DROP PROCEDURE IF EXISTS GetSalesByStateAndDayOfWeek
DROP PROCEDURE IF EXISTS sp_CalculateMonthlySales
DROP PROCEDURE IF EXISTS sp_GetMonthlySalesSummary
DROP PROCEDURE IF EXISTS sp_CalculateQuarterlySales
DROP PROCEDURE IF EXISTS sp_GetQuarterlySalesSummary
DROP PROCEDURE IF EXISTS sp_CalculateSalesYearly
DROP PROCEDURE IF EXISTS sp_GetYearlySalesSummary