var _ = require('lodash');
var mongoose = require('mongoose');

var Const = require("../lib/consts");
var Config = require("../lib/init");
var DatabaseManager = require('../lib/DatabaseManager');
var Utils = require("../lib/utils");

var BaseModel = require('./BaseModel');
var Rate = function(){};

_.extend(Rate.prototype,BaseModel.prototype);

Rate.prototype.init = function(mongoose){
    
    this.schema = new mongoose.Schema({
        userId: { type: String, index: true },
        rate: Number
    });

    this.model = mongoose.model(Config.dbCollectionPrefix + "Rate", this.schema);

}

Rate.get = function(){
    
    return DatabaseManager.getModel('Rate').model;
    
}

module["exports"] = Rate;
