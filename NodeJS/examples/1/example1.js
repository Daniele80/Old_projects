const util = require('util');

var f = function () {
    console.log('Boo');
}
f.boo = 1;
f(); //outputs Boo
console.log(f.boo); //outputs 1

var convertNum = function (num) {
return num + 10;
}
var processNum = function (num, fn) {
return fn(num);
}
convertNum.test=10;
console.log(processNum(10, convertNum));


console.log(util.inspect(convertNum));