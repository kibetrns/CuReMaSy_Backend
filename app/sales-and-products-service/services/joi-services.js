const { string } = require('joi')
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

module.exports = {
    createProductSchema,
    editProductSchema,
    getProductsSchema,
    deleteProductSchema
}