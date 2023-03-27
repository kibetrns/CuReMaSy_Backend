    const adminRouter = require('express').Router();

    const { SchemaValidateMiddleWare } = require('./../middlewares/schema-validate')
    const { 
        createUserSchema,
        editUserSchema,
        deleteUserSchema,
        getUserByIdSchema,
        getUserByEmailSchema
    } = require('../services/joi-services')

    const { 
        createUser, 
        editUser, 
        deleteUser,
        getUserById,
        getUserByEmail
    } = require('../controllers/user-controllers')


    adminRouter.post(
        '/', 
        (req, res, next) => SchemaValidateMiddleWare(req, res, next, createUserSchema, "body"),
        createUser
    )

    adminRouter.patch(
        '/',
        (req, res, next) => SchemaValidateMiddleWare(req, res, next, editUserSchema, "body"),
        editUser
    )

    adminRouter.delete(
        '/:userId',
        (req, res, next) => SchemaValidateMiddleWare(req, res, next, deleteUserSchema, "params"),
        deleteUser
    )

    adminRouter.get(
        '/:userId',
        (req, res, next) => SchemaValidateMiddleWare(req, res, next, getUserByIdSchema, "params"),
        getUserById
    )

    adminRouter.get(
        '/',
        (req, res, next) => SchemaValidateMiddleWare(req, res, next, getUserByEmailSchema, "query"),
        getUserByEmail
    )


    module.exports = adminRouter