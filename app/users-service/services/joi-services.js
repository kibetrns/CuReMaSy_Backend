const Joi = require('joi')

const createUserSchema = Joi.object({

    email: Joi
        .string()
        .email({minDomainSegments: 2})
        .required(),

    password: Joi
        .string()
        .min(8)
        .required(),

    userName: Joi
        .string()
        .min(4)
        .max(42),

    fullName: Joi
        .string()
        .required(),
    
    phoneNumber: Joi
        .string()
        .pattern(/^\+\d{1,3}?\d{9}$/),
    
    dateOfBirth: Joi
        .date()
        .max("now"),
    
    userType: Joi
        .string()
        .valid('SUPER ADMIN', 'Admin', 'Staff', 'Customer')
        .required(),

    profilePicture: Joi
        .binary()
        .max(15728640)
        .optional()
})

const loginUserSchema = Joi.object({

    email: Joi
        .string()
        .email({minDomainSegments: 2})
        .required(),

    password: Joi
        .string()
        .min(8)
        .required(),

    userType: Joi
        .string()
        .valid('SUPER ADMIN', 'Admin', 'Staff')
        .required(),       
})

const editUserSchema = Joi.object({


    userId: Joi
        .number()
        .integer()
        .required(),

    email: Joi
        .string()
        .email({minDomainSegments: 2})
        .required(),

    password: Joi
        .string()
        .min(8),

    userName: Joi
        .string()
        .min(4)
        .max(42), 

    fullName: Joi
        .string(),
    
    phoneNumber: Joi
        .string()
        .pattern(/^\+\d{1,3}?\d{9}$/),
    
    dateOfBirth: Joi
        .date()
        .max("now"),
    
    userType: Joi
    .string()
    .valid('SUPER ADMIN', 'Admin', 'Staff', 'Customer'),

    profilePicture: Joi
        .binary()
        .max(15728640)
        .optional(),

    isAccountDeleted: Joi
        .valid(0,1)  
})

const deleteUserSchema = Joi.object({
    userId: Joi
        .number()
        .integer()
        .required()
})

const getUserByIdSchema = Joi.object({
    userId: Joi
        .number()
        .integer()
        .required()
})

const getUserByEmailSchema = Joi.object({
    email: Joi
        .string()
        .max(99)
})

const getUsersSchema = Joi.object({
    pageNumber: Joi
        .number()
        .integer()
        .required(),
    pageSize: Joi
        .number()
        .integer()
        .required()
})

module.exports = {
    createUserSchema,
    editUserSchema,
    loginUserSchema, 
    deleteUserSchema,
    getUserByIdSchema,
    getUserByEmailSchema,
    getUsersSchema
}