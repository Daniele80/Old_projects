function action(v) {
 console.log(v);
 }

 function execute(value, callback) {
 callback(value);
 }
 execute("Hallo Node", action);