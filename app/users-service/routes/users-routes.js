const usersRouter = require('express').Router();

const { SchemaValidateMiddleWare } = require('./../middlewares/schema-validate')
const { 
    createUserSchema,
    editUserSchema,
    deleteUserSchema,
    getUserByIdSchema,
    getUserByEmailSchema,
    getUsersSchema
} = require('../services/joi-services')

const { 
    getUsers 
} = require('../controllers/user-controllers')


usersRouter.get(
    '/',
    (req, res, next) => SchemaValidateMiddleWare(req, res, next, getUsersSchema, "query"),
    getUsers
)


module.exports = usersRouter