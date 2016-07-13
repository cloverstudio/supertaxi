var _ = require('lodash');
var mongoose = require('mongoose');

var Const = require("../lib/consts");
var Config = require("../lib/init");
var DatabaseManager = require('../lib/DatabaseManager');
var Utils = require("../lib/utils");

var BaseModel = require('./BaseModel');
var Order = function(){};

_.extend(Order.prototype,BaseModel.prototype);

Order.prototype.init = function(mongoose){
    
    this.schema = new mongoose.Schema({
        userId: { type: String, index: true },
        driver: {
            id: { type: String, index: true },
            lat: Number,
            lon: Number
        },
        from: {
            lat: Number,
            lon: Number,
            address: String
        },
        to: {
            lat: Number,
            lon: Number,
            address: String
        },
        createOrderTs: Number,
        acceptOrderTs: Number,
        arriveToStartLocationTs: Number,
        startTripTs: Number,
        finishTripTs: Number,
        cancelOrderOrTrip: {
            userTs: Number, // if user canceled
            driverTs: Number, // if driver canceled
            reason: String
        },
        crewNum: Number
    });

    this.model = mongoose.model(Config.dbCollectionPrefix + "Order", this.schema);

}

Order.get = function(){
    
    return DatabaseManager.getModel('Order').model;
    
}

module["exports"] = Order;
