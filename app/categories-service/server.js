const express = require('express')
require('dotenv').config();
const categoryRouter = require('./routes/category-routes')
const categoriesRouter = require('./routes/categories-routes');

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
    res.json({ message: 'Touched down on categories-service' })
})

app.use('/categories', categoriesRouter);

app.use('/category', categoryRouter);



const port = process.env.PORT;
app.listen(port, () => { console.log(`Categories-Service Server running on port ${port}`) })