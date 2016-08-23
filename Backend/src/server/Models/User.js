var _ = require('lodash');
var mongoose = require('mongoose');

var Const = require("../lib/consts");
var Config = require("../lib/init");
var DatabaseManager = require('../lib/DatabaseManager');
var Utils = require("../lib/utils");

var BaseModel = require('./BaseModel');
var User = function(){};

_.extend(User.prototype,BaseModel.prototype);

User.prototype.init = function(mongoose){
    
    this.schema = new mongoose.Schema({
        email: String,
        password: String,
        user: {
            name : String,
            age : Number,
            note : String
        },
        driver: {
            name : String,
            car_type : String,
            car_registration : String,
            fee_start : Number,
            fee_km : Number,
            status: Number // 1: available, 2: busy
        },
        avatar: {
            fileid:String,
            thumbfileid:String
        },
        token: String,
        token_generated: Number,
        pushToken: String,
        created: Number,
        telNum: String,
        currentLocation: { type: [ Number ], index: '2dsphere' },   // [ longitude, latitude ]
        averageRate: Number
    });

    this.model = mongoose.model(Config.dbCollectionPrefix + "User", this.schema);

}

User.get = function(){
    
    return DatabaseManager.getModel('User').model;
    
}

module["exports"] = User;
