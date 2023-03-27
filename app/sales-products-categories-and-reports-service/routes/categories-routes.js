const categoriesRouter = require('express').Router();

const { SchemaValidateMiddleWare } = require('../middlewares/schema-validate')
const { getCategoriesSchema } = require('../services/joi-services')

const { getCategories } = require('../controllers/categories-controllers')

categoriesRouter.get(
    '/',
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, getCategoriesSchema, "query" ),
    getCategories
)


module.exports = categoriesRouter