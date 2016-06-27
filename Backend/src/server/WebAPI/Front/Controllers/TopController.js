var express = require('express');
var router = express.Router();
var bodyParser = require("body-parser");
var path = require('path');
var _ = require('lodash');
var async = require('async');

var Const = require("../../../lib/consts");
var Config = require("../../../lib/init");
var BaseController = require("./FrontBaseController");

var TopController = function(){
}

// extends from basecontroller
_.extend(TopController.prototype,BaseController.prototype);

TopController.prototype.init = function(app) {
    
    var self = this;

    router.get('/', function(request, response) {

        self.render(request, response, '/top');

    });

    return router;
}

module["exports"] = new TopController();