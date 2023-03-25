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

    userTypeSchema: Joi
        .string()
        .valid('SUPER ADMIN', 'Admin', 'Staff')
        .required(),       
})

const editUserSchema = Joi.object({

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
    
    userTypeSchema: Joi
    .string()
    .valid('SUPER ADMIN', 'Admin', 'Staff', 'Customer'),
})

module.exports = {
    createUserSchema,
    editUserSchema,
    loginUserSchema, 
}