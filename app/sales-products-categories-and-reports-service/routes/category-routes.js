const categoryRouter = require('express').Router();

const { SchemaValidateMiddleWare } = require('../middlewares/schema-validate')
const { 
    createCategorySchema,
    editCategorySchema,
    deleteCategorySchema ,
    getCategoryByIdSchema,
    getCategoryByNameSchema,
} = require('./../services/joi-services')

const { 
    createCategory ,
    editCategory,
    deleteCategory,
    getCategoryByName,
    getCategoryById,

} = require('./../controllers/categories-controllers')


categoryRouter.post(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, createCategorySchema, "body"),
    createCategory
)
categoryRouter.patch(
    '/',
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, editCategorySchema, "body"), 
    editCategory
)
categoryRouter.put(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, editCategorySchema, "body"),
    editCategory
)
categoryRouter.delete(
    '/', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, deleteCategorySchema, "body"),
     deleteCategory
)
categoryRouter.get(
    '/',
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, getCategoryByNameSchema, "query"),
    getCategoryByName
 )
 categoryRouter.get(
    '/:categoryId', 
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, getCategoryByIdSchema, "params"),
    getCategoryById
)



module.exports = categoryRouter