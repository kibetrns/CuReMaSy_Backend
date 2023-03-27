const express = require('express')
require('dotenv').config();

const productRouter = require('./routes/product-routes')
const productsRouter = require('./routes/products-router')


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
    res.json({ message: 'Touched down on sales-and-products-service' })
})


app.use('/product', productRouter);
app.use('/products', productsRouter);



const port = process.env.PORT
app.listen(port, () => { console.log(`User-Service Server running on port ${port}`) })