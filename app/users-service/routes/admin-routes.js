    const adminRouter = require('express').Router();

    const { SchemaValidateMiddleWare } = require('./../middlewares/schema-validate')
    const { 
        createUserSchema,
    } = require('../services/joi-services')

    const { 
        createUser ,
    } = require('../controllers/user-controllers')


    adminRouter.post(
        '/', 
        (req, res, next) => SchemaValidateMiddleWare(req, res, next, createUserSchema, "body"),
        createUser
    )

    module.exports = adminRouter