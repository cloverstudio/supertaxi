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

var TestController = function(){
}

_.extend(TestController.prototype,BackendBase.prototype);

TestController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {get} /api/v1/test just test
     * @apiName Test
     * @apiGroup WebAPI
     * @apiDescription Returns text "test"
     * @apiSuccessExample Success-Response:

{ code: 1, time: 1467125660699, data: 'test' }

     **/

    router.get('',function(request,response){

        self.successResponse(response,Const.responsecodeSucceed,"test");

    });

   /**
     * @api {get} /api/v1/test/error error
     * @apiName General Error Response
     * @apiGroup WebAPI
     * @apiDescription Returns error
     **/

    router.get('/error',function(request,response){

        self.successResponse(response,Const.responsecodeUnknownError);

    });

    return router;

}

module["exports"] = new TestController();
