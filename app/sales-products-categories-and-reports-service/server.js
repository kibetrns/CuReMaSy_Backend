const express = require('express')
require('dotenv').config();

const productRouter = require('./routes/product-routes')
const productsRouter = require('./routes/products-router')

const categoryRouter = require('./routes/category-routes')
const categoriesRouter = require('./routes/categories-routes')


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
    res.json({ message: 'sales-products-categories-and-reports-service' })
})


app.use('/product', productRouter);
app.use('/products', productsRouter);

app.use('/category', categoryRouter);
app.use('/categories', categoriesRouter);




const port = process.env.PORT
app.listen(port, () => { console.log(`sales-products-categories-and-reports-service Server running on port ${port}`) })