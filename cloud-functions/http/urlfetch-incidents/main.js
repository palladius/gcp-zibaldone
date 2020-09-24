// main.js
// https://stackoverflow.com/questions/44277175/how-to-send-a-http-request-from-google-cloud-functions-nodejs

const request = require('request');

exports.helloWorld = function helloWorld(req, res) {
  // Example input: {"message": "Hello!"}
  if (req.body.message === undefined) {
    // This is an error case, as "message" is required.
    res.status(400).send('No message defined!');
  } else {
    // Everything is okay.
    console.log(req.body.message);

    request.get('https://maker.ifttt.com/trigger/arrival/with/key/xxxx', function (error, response, body) {
      console.log('error:', error); // Print the error if one occurred 
      console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received 
      console.log('body:', body); //Prints the response of the request. 
    });
    res.status(200).send("Success");
  }
};

/*
var request = require('request');
request.get('https://maker.ifttt.com/trigger/arrive/with/key/xxxx', function (error, response, body) {
  console.log('error:', error); // Print the error if one occurred 
  console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received 
  console.log('body:', body); //Prints the response of the request. 
});
*/