'use strict';

const express = require('express')
    , app = express();

app.set('port', process.env.PORT || 8080)

// // Required to trust GCP proxy for the
// x-forwarded-by heading
//app.set('trust proxy', true) 

// Constants
const HOST = '0.0.0.0';


app.get('/', function(req, res) {
  res.send('Hello world\n');
});

app.listen(app.get('port'), HOST);

//console.log("Running hello nodejs");
