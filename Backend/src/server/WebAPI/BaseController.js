var bodyParser = require("body-parser");
var path = require('path');
var _ = require('lodash');

var Const = require("../lib/consts");
var Config = require("../lib/init");
var DatabaseManager = require('../lib/DatabaseManager');
var LocalizationManager = require("../lib/LocalizationManager");
var fs = require('fs');

var BaseController = function(){
    
}

BaseController.prototype.l10n = function(baseString){
    
    return LocalizationManager.localize(baseString);
    
}

BaseController.prototype.checkUploadPath = function() {

    try {    

        fs.accessSync(Config.uploadPath);

    } catch (err) {

        return err;

    }
    
}

module["exports"] = BaseController;