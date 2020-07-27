const functions = require('firebase-functions');

exports.sayHello = functions.https.onCall((data, response) => {
    return console.log('hello test');

});