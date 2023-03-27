const sql = require('mssql')
const { json } = require('express');



const { config } = require('../sql-config')
const createValidator = require('./../services/validators')
const { 
    createCategorySchema,
    editCategorySchema,
    deleteCategorySchema ,
    getCategoryByNameSchema,
    getCategoryByIdSchema,
    getCategoriesSchema
    } = require('../services/joi-services');
const e = require('express');

const pool = new sql.ConnectionPool(config)


module.exports = {
    createCategory: async (req, res) => {

        const validateBody = createValidator(createCategorySchema);

        try {
            if (validateBody) {
                try {
                    const {
                        categoryName: validatedCategoryName,
                        categoryDescription: validatedCategoryDescription,
                        userId: validatedUserId,
                      } = validateBody(req.body);

                      await pool.connect();

                      const request =  pool.request()
                      .input('category_name', sql.VarChar(42),validatedCategoryName )
                      .input('category_description', sql.VarChar(sql.MAX),validatedCategoryDescription )
                      .input('user_id', sql.Int ,validatedUserId )                  

                    const result = await request.execute('sp_InsertCategory')
                    
                    await pool.close();

                    console.log(result );

                    if (result.rowsAffected[0] > 0) {
                        res.status(200).json({ message: "Category created successfully" });
                      } else {
                        res.json({ message: "No Creation Done" });
                      }   
                } catch (error) {
                    console.error(error);
                    res.status(400).json({
                        error: "Bad Request",
                        message: error.message
                    });
                }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }
    },

    editCategory: async (req, res) => { 

        const validateBody = createValidator(editCategorySchema);

        try {
            if (validateBody) {
                try {
                    const {
                        categoryName: validatedCategoryName,
                        categoryDescription: validatedCategoryDescription,
                        categoryId: validatedCategoryId,
                        userId: validatedUserId,
                      } = validateBody(req.body);

                      await pool.connect();

                      const request =  pool.request()
                      .input('category_id', sql.UniqueIdentifier,validatedCategoryId )
                      .input('category_name', sql.VarChar(42),validatedCategoryName )
                      .input('category_description', sql.VarChar(sql.MAX),validatedCategoryDescription )
                      .input('user_id', sql.Int ,validatedUserId )                  

                    const result = await request.execute('sp_UpdateCategory')
                    
                    await pool.close();

                    console.log(result );

                    if (result.rowsAffected[0] > 0) {
                        res.status(200).json({ message: "Category Edited successfully" });
                      } else {
                        res.json({ message: "No Editing Done" });
                      }   
                } catch (error) {
                    console.error(error);
                    res.status(400).json({
                        error: "Bad Request",
                        message: error.message
                    });
                }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }

    },

  

    deleteCategory: async (req, res) => { 

        const validateBody = createValidator(deleteCategorySchema);

        try {
            if (validateBody) {
                try {
                    const {
                        categoryId: validatedCategoryId,
                        userId: validatedUserId,
                      } = validateBody(req.body);

                      await pool.connect();

                      const request =  pool.request()
                      .input('category_id', sql.UniqueIdentifier, validatedCategoryId)
                      .input('user_id', sql.Int ,validatedUserId )                  

                    const result = await request.execute('sp_DeleteCategory')

                    await pool.close()


                    console.log(result );

                    if (result.rowsAffected[0] > 0) {
                        res.status(200).json({ message: "Category Deleted successfully" });
                      } else {
                        res.json({ message: "No Deletion Done" });
                      }   
                } catch (error) {
                    console.error(error);
                    res.status(400).json({
                        error: "Bad Request",
                        message: error.message
                    });
                }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }

    },

    getCategoryById: async (req, res) => {
        const validateParams = createValidator(getCategoryByIdSchema);
    
        try {
            const validatedCategoryId = validateParams({
                categoryId: req.params.categoryId
            }).categoryId;
    
            await pool.connect()
    
            const request = pool.request();
            request.input("CategoryId", sql.UniqueIdentifier, validatedCategoryId);
    
            const result = await request.execute("sp_GetCategoryById");
            const category = result.recordset[0];
    
            await pool.close();
    
            if (category) {
                res.status(200).json(category);
            } else {
                res.status(404).json({
                    error: "Not Found",
                    message: "Category not found"
                });
            }
        } catch (error) {
            console.error(error);
            if (error.name === "ValidationError") {
                res.status(400).json({
                    error: "Bad Request",
                    message: error.message
                });
            } else {
                console.error(error);
                res.status(500).json({
                    message: "It's not you its us :)",
                    error: error.message
                });
            }
        }
    },
    

    getCategoryByName: async (req, res) => {
        const validateQueries = createValidator(getCategoryByNameSchema);
    
        try {
            if (validateQueries) {
                const { categoryName: validatedCategoryName } = validateQueries({
                    categoryName: req.query.categoryName,
                });
    
                await pool.connect()
    
                const request = pool.request();
                request.input("CategoryName", sql.VarChar(42), validatedCategoryName);
    
                const result = await request.execute("sp_GetCategoryByName");
                const category = result.recordset[0];
    
                await pool.close();
    
                if (category) {
                    res.status(200).json(category);
                } else {
                    res.status(404).json({
                        error: "Not Found",
                        message: "Category not found"
                    });
                }
            }
        } catch (error) {
            console.error(error);
            if (error.name === "ValidationError") {
                res.status(400).json({
                    error: "Bad Request",
                    message: error.message
                });
            } else {
                console.error(error);
                res.status(500).json({
                    message: "It's not you its us :)",
                    error: ""
                });
            }
        }
    },

    getCategories: async (req, res) => {
        const validateQueries = createValidator(getCategoriesSchema);
    
        try {
            if (validateQueries) {
                const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                    pageNumber: req.query.pageNumber,
                    pageSize: req.query.pageSize
                  });
                  

                console.log(`${validatedPageNumber}, ${validatedPageSize}`)
    
                await pool.connect();
    
                const request = pool.request();
                request.input("PageNumber", sql.Int, validatedPageNumber);
                request.input("PageSize", sql.Int, validatedPageSize);
    
                const result = await request.execute("sp_GetCategories");
                const categories = result.recordset;
    
                await pool.close();
    
                res.status(200).json(categories);
            }
        } catch (error) {
            console.error(error);
            if (error.name === "ValidationError") {
                res.status(400).json({
                    error: "Bad Request",
                    message: error.message
                });
            } else {
                console.error(error);
                res.status(500).json({
                    message: "It's not you its us :)",
                    error: ""
                });
            }
        }
    },
    getApprovedCategories: async (req, res) => {
        const validateQueries = createValidator(getCategoriesSchema);
    
        try {
            if (validateQueries) {
                const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                    pageNumber: req.query.pageNumber,
                    pageSize: req.query.pageSize
                  });
                  

                console.log(`${validatedPageNumber}, ${validatedPageSize}`)
    
                await pool.connect()
    
                const request = pool.request();
                request.input("PageNumber", sql.Int, validatedPageNumber);
                request.input("PageSize", sql.Int, validatedPageSize);
    
                const result = await request.execute("sp_GetApprovedCategories");
                const categories = result.recordset;
    
                await pool.close();
    
                res.status(200).json(categories);
            }
        } catch (error) {
            console.error(error);
            if (error.name === "ValidationError") {
                res.status(400).json({
                    error: "Bad Request",
                    message: error.message
                });
            } else {
                console.error(error);
                res.status(500).json({
                    message: "It's not you its us :)",
                    error: ""
                });
            }
        }
    },
    getNotApprovedCategories: async (req, res) => {
        const validateQueries = createValidator(getCategoriesSchema);
    
        try {
            if (validateQueries) {
                const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                    pageNumber: req.query.pageNumber,
                    pageSize: req.query.pageSize
                  });
                  

                console.log(`${validatedPageNumber}, ${validatedPageSize}`)
    
                await pool.connect()
    
                const request = pool.request();
                request.input("PageNumber", sql.Int, validatedPageNumber);
                request.input("PageSize", sql.Int, validatedPageSize);
    
                const result = await request.execute("sp_GetNotApprovedCategories");
                const categories = result.recordset;
    
                await pool.close();
    
                res.status(200).json(categories);
            }
        } catch (error) {
            console.error(error);
            if (error.name === "ValidationError") {
                res.status(400).json({
                    error: "Bad Request",
                    message: error.message
                });
            } else {
                console.error(error);
                res.status(500).json({
                    message: "It's not you its us :)",
                    error: ""
                });
            }
        }
    }
    
}