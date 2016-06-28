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
        name: String,
        sortName: String,
        description: String,
        userid: String,
        password: String,
        created: Number,
        token: [],
        pushToken: [],
        organizationId: { type: String, index: true },
        status: Number, // 1: Enabled, 0: Disabled
        avatar: {
            picture: { 
                originalName: String, 
                size: Number, 
                mimeType: String,
                nameOnServer: String
            },
            thumbnail: { 
                originalName: String, 
                size: Number, 
                mimeType: String,
                nameOnServer: String
            }
        },
        groups: [ String ],
        permission: Number, // 1: user (za web client), 2: organizatinAdmin, 3: subAdmin,
        isGuest: Number
    });

    this.model = mongoose.model(Config.dbCollectionPrefix + "User", this.schema);

}

User.get = function(){
    
    return DatabaseManager.getModel('User').model;
    
}


User.getUsersById = function(userIds,callBack){
    
    var model = DatabaseManager.getModel('User').model;

    model.find({ _id: { "$in" : userIds } },function (err, result) {

        if (err) throw err;
                             
        if(callBack)
            callBack(result);    
    
    });
    
};

User.getUserById = function(userId,callBack){
    
    var model = DatabaseManager.getModel('User').model;

    model.findOne({ _id: userId },function (err, result) {

        if (err) throw err;
                             
        if(callBack)
            callBack(result);    
    
    });
    
};

module["exports"] = User;
