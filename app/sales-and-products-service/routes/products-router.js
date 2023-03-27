const productsRouter = require('express').Router();

const { SchemaValidateMiddleWare } = require('./../middlewares/schema-validate')
const { 
   
    getProductsSchema
} = require('../services/joi-services')

const { 
    getProducts,
    getApprovedProducts,
    getNotApprovedProducts
    
} = require('../controllers/products-controller')


productsRouter.get(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, getProductsSchema, "query"),
    getApprovedProducts
)

module.exports = productsRouter