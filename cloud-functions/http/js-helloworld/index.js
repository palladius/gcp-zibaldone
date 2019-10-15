/* HTTP Cloud Function.
*
* @param {Object} req Cloud Function request context.
* @param {Object} res Cloud Function response context.
*/
exports.jsHelloworld = (req, res) => {
  version = "1.0";
  res.send('Hello from Cloud Functions - v'+version+'!');
};


// v2: https://rominirani.com/google-cloud-functions-tutorial-using-gcloud-tool-ccf3127fdf1a
exports.jsHelloGreeting = (req, res) => {
   console.log(req.body);
   // Example input: {“name”: “GCF”}
   if (req.body.name === undefined) { 
     // This is an error case, as “name” is required.
     res.status(400).send('No name defined!');
   } else {
     console.log(req.body.name);
     res.status(200).send('Hello - name: ' + req.body.name);
   }
};