const sql = require('mssql')
const { json } = require('express');

const { config } = require('../sql-config')

const createValidator = require('../services/validators')

const {
    createProductSchema,
    editProductSchema,
    getProductsSchema,
    deleteProductSchema
} = require('../services/joi-services')

const pool = new sql.ConnectionPool(config)


module.exports = {

    createProduct: async (req, res) => {

        const validateBody = createValidator(createProductSchema);

        try {
            if (validateBody) {
                try {
                    const {
                        categoryId: validatedCategoryId,
                        productName: validatedProductName,
                        productDescription: validatedProductDescription,
                        productPrice: validatedProductPrice,
                        userId: validatedProductTDId,
                    } = validateBody(req.body);

                    await pool.connect();

                    console.log(validatedProductDescription)
                    console.log(validatedProductName)


                    const request = pool.request()
                        .input('category_id', sql.UniqueIdentifier, validatedCategoryId)
                        .input('product_name', sql.VarChar(99), validatedProductName)
                        .input('product_description', sql.VarChar(sql.MAX), validatedProductDescription)
                        .input('product_price', sql.Decimal(10, 2), validatedProductPrice)
                        .input('user_id', sql.Int, validatedProductTDId)

                    const result = await request.execute('sp_InsertProduct')
                    console.log(result)

                    await pool.close();

                    if (result.rowsAffected.length > 0) {
                        res.status(200).json({ message: "Product created successfully" });
                    } else {
                        res.json({ message: "No Product Created" });
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

    editProduct: async (req, res) => {

        const validateBody = createValidator(editProductSchema);

        try {
            if (validateBody) {
                try {
                    const {
                        productId: validatedProductId,
                        categoryId: validatedCategoryId,
                        productName: validatedProductName,
                        ProductDescription: validatedProductDescription,
                        productPrice: validatedProductPrice,
                        userId: validatedProductTDId,
                    } = validateBody(req.body);

                    await pool.connect();

                    const request = pool.request()
                        .input('product_id', sql.UniqueIdentifier, validatedProductId)
                        .input('category_id', sql.UniqueIdentifier, validatedCategoryId)
                        .input('product_name', sql.VarChar(99), validatedProductName)
                        .input('product_description', sql.VarChar(sql.MAX), validatedProductDescription)
                        .input('product_price', sql.Decimal(10, 2), validatedProductPrice)
                        .input('user_id', sql.Int, validatedProductTDId)

                    const result = await request.execute('sp_UpdateProduct')
                    console.log(result)

                    await pool.close();

                    if (result.rowsAffected.length > 0) {
                        res.status(200).json({ message: "Product edited successfully" });
                    } else {
                        res.json({ message: "No edit done" });
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

    getProducts: async (req, res) => {
        const validateQueries = createValidator(getProductsSchema);

        try {
            if (validateQueries) {
                try {
                    const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                        pageNumber: req.query.pageNumber,
                        pageSize: req.query.pageSize
                    });



                    await pool.connect();

                    const request = pool.request()
                        .input('pageNumber', sql.Int, validatedPageNumber)
                        .input('pageSize', sql.Int, validatedPageSize)


                    const result = await request.execute('sp_GetProducts')
                    console.log(result)

                    const products = result.recordset;


                    await pool.close();

                    if (products) {
                        res.status(200).json(products);
                    } else {
                        res.json({ message: "No Product Fetched" });
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

    getApprovedProducts: async (req, res) => {
        const validateQueries = createValidator(getProductsSchema);

        try {
            if (validateQueries) {
                try {
                    const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                        pageNumber: req.query.pageNumber,
                        pageSize: req.query.pageSize
                    });



                    await pool.connect();

                    const request = pool.request()
                        .input('pageNumber', sql.Int, validatedPageNumber)
                        .input('pageSize', sql.Int, validatedPageSize)


                    const result = await request.execute('sp_GetApprovedProducts')
                    console.log(result)

                    const products = result.recordset;


                    await pool.close();

                    if (products) {
                        res.status(200).json(products);
                    } else {
                        res.json({ message: "No Product Fetched" });
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


    getNotApprovedProducts: async (req, res) => {
        const validateQueries = createValidator(getProductsSchema);

        try {
            if (validateQueries) {
                try {
                    const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                        pageNumber: req.query.pageNumber,
                        pageSize: req.query.pageSize
                    });



                    await pool.connect();

                    const request = pool.request()
                        .input('pageNumber', sql.Int, validatedPageNumber)
                        .input('pageSize', sql.Int, validatedPageSize)

                    const result = await request.execute('sp_GetNotApprovedProducts')
                    console.log(result)

                    const products = result.recordset;


                    await pool.close();

                    if (products) {
                        res.status(200).json(products);
                    } else {
                        res.json({ message: "No Product Fetched" });
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

    deleteProduct: async (req, res) => {
        const validateBody = createValidator(deleteProductSchema);


        try {
            if (validateBody) {
                try {
                    const { 
                        productId: validatedProductId, 
                        userId: validatedUserId 
                    } = validateBody({
                        productId: req.body.productId,
                        userId: req.body.userId
                    });

                    console.log(validatedProductId)


                    await pool.connect();

                    const request = pool.request()
                        .input('product_id', sql.UniqueIdentifier, validatedProductId)
                        .input('user_id', sql.Int, validatedUserId)


                    const result = await request.execute('sp_DeleteProduct')
                    console.log(result)

                    const user = result.recordset[0];


                    await pool.close();


                    if (user) {
                        res.status(200).json(user);
                    } else {
                        res.status(404).json({
                            error: "Not Found",
                            message: "Product not found"
                        });
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

    }
}

