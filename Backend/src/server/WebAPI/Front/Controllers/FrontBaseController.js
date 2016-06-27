var bodyParser = require("body-parser");
var path = require('path');
var _ = require('lodash');
var JSON = require('JSON2');

var Const = require("../../../lib/consts");
var Config = require("../../../lib/init");
var DatabaseManager = require('../../../lib/DatabaseManager');
var BaseController = require("../../BaseController");

var FrontBaseController = function(){
    
}

_.extend(FrontBaseController.prototype,BaseController.prototype);
FrontBaseController.prototype.loginUser = null;

FrontBaseController.prototype.ViewTop = "Front/Views";

FrontBaseController.prototype.render = function(request,response,template,params){
        
    var defaultParameters = {
        Config: Config,
        AssetURL: "/assets",
        layout: this.ViewTop + "/FrontLayout",
    };
    
    var templateParams = _.assign(defaultParameters, params);
    
	response.render(this.ViewTop + template, templateParams);
    
}

module["exports"] = FrontBaseController;