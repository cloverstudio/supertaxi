var _ = require('lodash');
var async = require('async');

var Const = require("./consts");
var Config = require("./init");
var DatabaseManager = require('./DatabaseManager');
var Utils = require('./utils');

var userModel = require('../Models/User').get();

function checkToken(request, response, next) {
    
    var token = request.headers['access-token'];
    
    if(_.isEmpty(token)){

        response.json({
            code : Const.responsecodeTokenInvalid
        });
        
        return;
    }

    userModel.findOne({
        "token":token
    },function(err,findResult){
        
        if(_.isEmpty(findResult)){

            response.json({
                code : Const.responsecodeTokenInvalid
            });
        
            return;
        }
        
        var tokenGenerated = findResult.token_generated;
        
        var diff = Utils.now() - tokenGenerated;

        if(diff > Const.tokenValidInteval){

            response.json({
                code : Const.responsecodeTokenInvalid
            });
        
            return;
            
        }
        
        request.user = findResult;
        
        next();
        
    });
    
}

module.exports = checkToken;