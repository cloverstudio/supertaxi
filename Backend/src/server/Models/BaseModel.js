var _ = require('lodash');
var mongoose = require('mongoose');

var Const = require("../lib/consts");
var Config = require("../lib/init");

var BaseModel = function(){};

BaseModel.prototype.model = null;
BaseModel.prototype.schema = null;
BaseModel.prototype.init = function(){};

module["exports"] = BaseModel;