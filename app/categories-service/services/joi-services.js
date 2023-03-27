const Joi = require('joi')


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
    createCategorySchema,
    editCategorySchema,
    deleteCategorySchema, 
    getCategoryByIdSchema,
    getCategoryByNameSchema,
    getCategoriesSchema
}