var bodyParser = require("body-parser");
var express = require('express');
var exphbs  = require('express-handlebars');
var bodyParser = require("body-parser");
var session = require('express-session')
var fs = require('fs');
var _ = require('lodash');

var init = require('../lib/init.js');
var Const = require('../lib/consts.js');
var auth = require('../lib/auth.js');
var Utils = require('../lib/utils');

var router = express.Router();

var WebAPIMain = {

    init: function(app) {

        var self = this;

        // Initialize template engine
        app.set('views', 'src/server/WebAPI');

        var hbs = exphbs.create({
            // Specify helpers which are only registered on this instance.
            helpers: require('../lib/viewHelpers'),
            layoutsDir: 'src/server/WebAPI',
            extname: '.hbs',
            partialsDir: [
                'src/server/WebAPI/SuperAdmin/Views/Partials'
            ]
        });

        app.engine('.hbs', hbs.engine);
        app.set('view engine', '.hbs');

        app.use('/',express.static(__dirname + '/../../../public'));
        app.use(bodyParser.json());
		app.use(bodyParser.urlencoded({
		  extended: true
		}));
        
        app.use(session({
            genid: function(req) {
                return Utils.getRandomString(32)
            },
            secret: Const.sessionsalt,
            resave: true,
            saveUninitialized: true,
            cookie: { path: '/', httpOnly: false, secure: false, maxAge: null }
        }));

        app.all('*', function(request, response, next) {
            
            // write here for general logic for all requests
            next();

        });

        app.all('/', function(request, response, next) {
              
            next();
        });

        app.all('/admin', function(request, response){
            response.redirect('/admin/home');          
        });

        router.use("/", require("./Front/FrontMain").init(app));
        //router.use("/admin", require("./OrganizationAdmin/OrganizationAdminMain").init(app));
        router.use("/api/v1", require("./Backend/BackendMain").init(app));

        app.use(init.urlPrefix, router);

    }
}

module["exports"] = WebAPIMain;
