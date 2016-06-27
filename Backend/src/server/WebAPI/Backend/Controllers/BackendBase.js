var _ = require('lodash');
var async = require('async');

var pathTop = "../../../";

var Const = require( pathTop + "lib/consts");
var Config = require( pathTop + "lib/init");
var DatabaseManager = require( pathTop + 'lib/DatabaseManager');
var Utils = require( pathTop + 'lib/utils');

var BackendBase = function(){
    
}

var Base = require('../../BaseController');

_.extend(BackendBase.prototype,Base.prototype);

BackendBase.prototype.errorResponse = function(
        response,
        httpCode){

    response.status(httpCode);
    response.send("");
    
}

BackendBase.prototype.successResponse = function(response,code,data){
    
    response.status(Const.httpCodeSucceed);

    if(code != Const.responsecodeSucceed){
        response.json({
            code : code,
            time : Utils.now()
        });
        
    } else {

        Utils.stripPrivateData(data);
        
        response.json({
            code : Const.responsecodeSucceed,
            time : Utils.now(),
            data : data
        });
    
    }
        
}

module["exports"] = BackendBase;