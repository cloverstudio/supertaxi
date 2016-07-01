var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');
var formidable = require('formidable');
var fs = require('fs');
var easyImg = require('easyimage');
var path = require('path');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Config = require( pathTop + "lib/init");
var DatabaseManager = require( pathTop + 'lib/DatabaseManager');
var Utils = require( pathTop + 'lib/utils');

var BackendBase = require('../BackendBase');

var UpdateProfileController = function(){
}

_.extend(UpdateProfileController.prototype,BackendBase.prototype);

UpdateProfileController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/profile/update just test
     * @apiName UpdateProfile
     * @apiGroup WebAPI
     * @apiDescription Update user's proflie, both for taxt driver and user
     * @apiSuccessExample Success-Response:

{ code: 1, time: 1467125660699}

     **/

    router.post('',function(request,response){

        self.successResponse(response,Const.responsecodeSucceed,"test");

    });

    return router;

}

module["exports"] = new UpdateProfileController();
