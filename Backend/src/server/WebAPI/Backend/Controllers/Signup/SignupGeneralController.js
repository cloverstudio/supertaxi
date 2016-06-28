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

var SignupGeneralController = function(){
}

_.extend(SignupGeneralController.prototype,BackendBase.prototype);

SignupGeneralController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/signup Signup
     * @apiName General Signup
     * @apiGroup WebAPI
     * @apiDescription Reigster new user to database and returns new token.
     *   
     * @apiParam {String} email Email Address 
     * @apiParam {String} password Password 
     * @apiParam {String} secret Secret
     * 
     * @apiSuccessExample Success-Response:
{
	code: 1,
	time: 1454417582385,
	data: {
		newToken: 'DOqsolWe6zt3EFn0',
		user: {
			_id: '56b0a6ae6753ea416ad58ea9',
			name: 'user1',
			userid: 'userid1ixfQJ',
			password: '*****',
			created: 1454417582354,
			__v: 0,
			token: '*****',
			tokenGeneratedAt: 1454417582384
		},
		organization: {
			_id: '56b0a6ae6753ea416ad58ea8',
			organizationId: 'clover',
			name: 'user1',
			created: 1454417582336,
			status: 1,
			__v: 0
		}
	}
}

    */

    router.post('',function(request,response){

        var reqEmail = request.body.email;
        var reqPassword = request.body.password;
        var reqSecret = request.body.secret;

        if(_.isEmpty(request.body.email)){
            self.successResponse(response,Const.responsecodeParamErrorNoEmail);
            return;
        }

        if(_.isEmpty(request.body.password)){
            self.successResponse(response,Const.responsecodeParamErrorNoPassword);
            return;
        }

        async.waterfall([

            function(done){

                var result = {};



                done(null,result);
            },

            function(result,done){

                

                done(null,result);
            }

        ],
        function(err,result){

            self.successResponse(response,Const.responsecodeSucceed,"test");

        });

    });

    return router;

}

module["exports"] = new SignupGeneralController();
