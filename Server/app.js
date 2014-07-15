var express = require('express');
var app = express();
var path = require('path');
var logger = require('morgan');
var morgan = require('morgan');
var methodOverride = require('method-override');
var debug = require('debug')('my-application');

// view engine setup
app.set('view engine', 'ejs');
app.use(morgan('dev'));
app.use(methodOverride());
app.use(require('stylus').middleware(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public/stylesheets')));


app.get('/getJapanTrip', function(req, res){
      res.sendfile('./public/getJapanTrip.json');
});

app.get('/JapanTrip', function(req, res){
      res.sendfile('./public/japanMap.html');
});

app.get('/', function(req, res){
      res.sendfile('./public/japanMap.html');
});

// Server Configure
app.set('port', process.env.PORT || 8080);

var server = app.listen(app.get('port'), function() {
	console.log("Server is listening on port:" + server.address().port);
});


