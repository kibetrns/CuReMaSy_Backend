const productRouter = require('express').Router();

const { SchemaValidateMiddleWare } = require('./../middlewares/schema-validate')
const { 
    createProductSchema,
    editProductSchema,
    deleteProductSchema
} = require('../services/joi-services')

const { 
    createProduct,
    editProduct,
    deleteProduct
} = require('../controllers/products-controller')


productRouter.post(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, createProductSchema, "body"),
    createProduct
)

productRouter.patch(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, editProductSchema, "body"),
    editProduct
)

productRouter.delete(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, deleteProductSchema, "body"),
    deleteProduct
)







module.exports = productRouter