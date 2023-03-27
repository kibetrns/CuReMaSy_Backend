const sql = require('mssql')
const { json } = require('express');



const { config } = require('../sql-config')
const createValidator = require('./../services/validators')
const { 
    createUserSchema,
    editUserSchema,
    loginUserSchema,
    deleteUserSchema,
    getUserByIdSchema,
    getUserByEmailSchema,
    getUsersSchema
} = require('../services/joi-services')

const pool = new sql.ConnectionPool(config)


module.exports = {

    createUser: async (req, res) => {

     const validateBody = createValidator(createUserSchema);

        try {
            if (validateBody) {
                try {
                    const {
                        email: validatedEmail,
                        password: validatedPassword,
                        userName: validatedUserName,
                        fullName: validatedFullName,
                        phoneNumber: validatedPhoneNumber,
                        dateOfBirth: validatedDateOfBirth,
                        userType: validateUserType,
                        profilePicture: validatedProfilePicture,
                      } = validateBody(req.body);

                      await pool.connect();

                      const request =  pool.request()
                      .input('user_type', sql.VarChar(42),validateUserType )
                      .input('user_name', sql.VarChar(42),validatedUserName )
                      .input('email', sql.VarChar(99) ,validatedEmail )                  
                      .input('password',sql.VarChar(99) , validatedPassword)
                      .input('full_name', sql.VarChar(99) ,validatedFullName )                  
                      .input('phone_number', sql.VarChar(20) ,validatedPhoneNumber )                  
                      .input('date_of_birth', sql.DateTime2 ,validatedDateOfBirth )                  
                      .input('profile_picture', sql.VarBinary(sql.MAX) ,validatedProfilePicture )                  

                      const result = await request.execute('sp_CreateUser')
                      console.log(result)
                    
                      await pool.close();
    
                      if (result.recordset.length > 0) {   
                         res.status(200).json({ message: "User created successfully" });
                        } else {
                          res.json({ message: "No User Done" });
                        }   
                  } catch (error) {
                      console.error(error);
                      res.status(400).json({
                          error: "Bad Request",
                          message: error.message
                      });
                  }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }
    },

    editUser: async (req, res) => {

            const validateBody = createValidator(editUserSchema);

       
               try {
                   if (validateBody) {
                       try {
                           const {
                               email: validatedEmail,
                               userId: validatedUserId,
                               password: validatedPassword,
                               userName: validatedUserName,
                               fullName: validatedFullName,
                               phoneNumber: validatedPhoneNumber,
                               dateOfBirth: validatedDateOfBirth,
                               userType: validateUserType,
                               isAccountDeleted: validatedIsAccountDeleted,
                               profilePicture: validatedProfilePicture,
                             } = validateBody(req.body);
       
                             await pool.connect();
       
                             const request =  pool.request()
                             .input('user_id', sql.Int,validatedUserId )
                             .input('is_account_deleted', sql.Bit,validatedIsAccountDeleted )
                             .input('user_type', sql.VarChar(42),validateUserType )
                             .input('user_name', sql.VarChar(42),validatedUserName )
                             .input('email', sql.VarChar(99) ,validatedEmail )                  
                             .input('password',sql.VarChar(99) , validatedPassword)
                             .input('full_name', sql.VarChar(99) ,validatedFullName )                  
                             .input('phone_number', sql.VarChar(20) ,validatedPhoneNumber )                  
                             .input('date_of_birth', sql.DateTime2 ,validatedDateOfBirth )                  
                             .input('profile_picture', sql.VarBinary(sql.MAX) ,validatedProfilePicture )                  
       
                             const result = await request.execute('sp_EditUser')
                             console.log(result)
                           
                             await pool.close();
           
                             if (result.rowsAffected[0] > 0) {   
                                res.status(200).json({ message: "Edit made successfully" });
                               } else {
                                 res.json({ message: "No User Edited" });
                               }   
                         } catch (error) {
                             console.error(error);
                             res.status(400).json({
                                 error: "Bad Request",
                                 message: error.message
                             });
                         }
                   }
                   
               } catch (error) {
                   console.error(error);
                   res.status(500).json({
                       message: "It's not you its us :)",
                       error: ""
                   });
               }

    },

    deleteUser: async (req, res) => { 

        const validateParams = createValidator(deleteUserSchema);


        try {
            if (validateParams) {
                try {
                    const validatedUserId = validateParams({
                        userId: req.params.userId
                    }).userId;


                      await pool.connect();

                      const request =  pool.request()
                      .input('user_id', sql.Int,validatedUserId )                 

                      const result = await request.execute('sp_DeleteUser')
                      console.log(result)


                    
                      await pool.close();


                      if (result.rowsAffected.length > 0) {   
                         res.status(200).json(user);
                        } else {
                            res.status(404).json({
                                error: "Not Found",
                                message: "User not found"
                            });
                        }   
                  } catch (error) {
                      console.error(error);
                      res.status(400).json({
                          error: "Bad Request",
                          message: error.message
                      });
                  }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }

    },

    getUserById: async (req, res) => { 

        const validateParams = createValidator(getUserByIdSchema);



        try {
            if (validateParams) {
                try {
                    const {userId: validatedUserId} = validateParams({
                        userId: req.params.userId
                    });


                      await pool.connect();

                      const request =  pool.request()
                      .input('user_id', sql.Int,validatedUserId )                 

                      const result = await request.execute('sp_GetUserByID')
                      console.log(result)
                    
                      const user = result.recordset[0];
                      
                      await pool.close();
    
                      if (user) {   
                         res.status(200).json(user);
                        } else {
                          res.json({ message: "No User Fetched" });
                        }   
                  } catch (error) {
                      console.error(error);
                      res.status(400).json({
                          error: "Bad Request",
                          message: error.message
                      });
                  }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }
    },

    getUserByEmail: async (req, res) => { 

        const validateQueries = createValidator(getUserByEmailSchema);

        try {
            if (validateQueries) {
                try {
                    const validatedEmail = validateQueries({
                        email: req.query.email
                    }).email;


                      await pool.connect();

                      const request =  pool.request()
                      .input('user_email', sql.VarChar(99),validatedEmail )                 

                      const result = await request.execute('sp_GetUserByEmail')
                      console.log(result)

                      const user = result.recordset[0];

                    
                      await pool.close();
    
                      if (user) {   
                        res.status(200).json(user);
                        } else {
                          res.json({ message: "No User Fetched" });
                        }   
                  } catch (error) {
                      console.error(error);
                      res.status(400).json({
                          error: "Bad Request",
                          message: error.message
                      });
                  }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }

    },

    getUsers:  async (req, res) => { 

        const validateQueries = createValidator(getUsersSchema);

        try {
            if (validateQueries) {
                try {
                    const { pageNumber: validatedPageNumber, pageSize: validatedPageSize } = validateQueries({
                        pageNumber: req.query.pageNumber,
                        pageSize: req.query.pageSize
                    });



                      await pool.connect();

                      const request =  pool.request()
                      .input('PageNumber', sql.Int,validatedPageNumber )   
                      .input('PageSize', sql.Int,validatedPageSize )                 
              

                      const result = await request.execute('sp_GetUsers')
                      console.log(result)

                      const users = result.recordset;

                    
                      await pool.close();
    
                      if (users) {   
                        res.status(200).json(users);
                        } else {
                          res.json({ message: "No User Fetched" });
                        }   
                  } catch (error) {
                      console.error(error);
                      res.status(400).json({
                          error: "Bad Request",
                          message: error.message
                      });
                  }
            }
            
        } catch (error) {
            console.error(error);
            res.status(500).json({
                message: "It's not you its us :)",
                error: ""
            });
        }

    }



 }