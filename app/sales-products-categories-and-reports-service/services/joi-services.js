const Joi = require('joi')

const createProductSchema = Joi.object({

    categoryId: Joi
        .string()
        .required(),

    productName: Joi
        .string()
        .required()
        .max(99),

    productDescription: Joi
        .string()
        .required(),

    productPrice: Joi
        .number()
        .precision(2),

    userId: Joi
        .number()
        .integer()
        .required()
})

const editProductSchema = Joi.object({

    productId: Joi
        .string()
        .required(),

    categoryId: Joi
        .string()
        .required(),

    productName: Joi
        .string()
        .required()
        .max(99),

    productDescription: Joi
        .string()
        .required(),

    productPrice: Joi
        .number()
        .precision(2),

    userId: Joi
        .number()
        .integer()
        .required()

})

const getProductsSchema = Joi.object({
    pageSize: Joi
        .number()
        .integer()
        .required(),
    
    pageNumber: Joi
        .number()
        .integer()
        .required()
})

const deleteProductSchema = Joi.object({
    productId: Joi
        .string()
        .required(),
        
    userId: Joi
        .number()
        .integer()
})

const createCategorySchema = Joi.object({
    categoryName: Joi.string()
        .required(),

    categoryDescription: Joi.string()
        .required(),
        
    userId: Joi.number()
        .integer()
        .required()
})

const editCategorySchema = Joi.object({
    categoryId: Joi.string()
        .required(),
    categoryName: Joi.string(),
    categoryDescription: Joi.string(),        
    userId: Joi.number()
        .integer()
        .required()
}).or("categoryId", "categoryName", "categoryDescription", "userId" )

const deleteCategorySchema = Joi.object({
    categoryId: Joi.string()
        .required(),
    userId: Joi.number()
        .integer()
        .required()
})
const getCategoryByIdSchema = Joi.object({
    categoryId: Joi.string().guid({ version: ['uuidv4'] }).required(),
  });
  
  const getCategoryByNameSchema = Joi.object({
    categoryName: Joi.string().required(),
  });
  

const getCategoriesSchema = Joi.object({
    pageNumber: Joi.number()
        .required(),
    pageSize: Joi.number()
        .required()
})

module.exports = {
    createProductSchema,
    editProductSchema,
    getProductsSchema,
    deleteProductSchema,

    
    createCategorySchema,
    editCategorySchema,
    deleteCategorySchema, 
    getCategoryByIdSchema,
    getCategoryByNameSchema,
    getCategoriesSchema
}