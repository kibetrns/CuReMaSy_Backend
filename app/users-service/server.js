const express = require('express')
require('dotenv').config();
const adminRouter = require('./routes/admin-routes')
const usersRouter = require('./routes/users-routes')

const app = express()

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE,PATCH');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});


app.get('/', (req, res) => {
    res.json({ message: 'Touched down on users-service' })
})


app.use('/user', adminRouter);
app.use('/users', usersRouter)


const port = process.env.PORT
app.listen(port, () => { console.log(`User-Service Server running on port ${port}`) })