var express = require('express')  
var app = express()  
app.set('view engine', 'pug')

app.get('/', function (req, res) {  
    res.render(
        'index',
        { title: 'Pug Example', message: 'Pug Example page'})
})

app.listen(3000, function () {  
    console.log('Example app listening on port 3000!')
})