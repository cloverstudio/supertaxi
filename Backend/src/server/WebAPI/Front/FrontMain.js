var express = require('express');
var router = express.Router();
var fs = require('fs')

var bodyParser = require("body-parser");
var _ = require('lodash');

var init = require('../../lib/init.js');

var SignupMain = {

    init: function(app) {

        var self = this;
          
        router.use("/", require("./Controllers/TopController").init(app));  
        
        return router;
    }
}

module["exports"] = SignupMain;
