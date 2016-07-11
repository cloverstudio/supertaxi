var express = require('express');
var router = express.Router();
var async = require('async');
var sha1 = require('sha1');
var _ = require('lodash');
var validator = require('validator');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Config = require( pathTop + "lib/init");
var Utils = require( pathTop + 'lib/utils');

var DatabaseManager = require( pathTop + 'lib/DatabaseManager');
var UserModel = require(pathTop + 'Models/User');

var UpdateTokenLogic = require(pathTop + 'Logics/UpdateToken');

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
     * @apiParam {String} email (Required) Email Address 
     * @apiParam {String} password (Required) Password 
     * @apiParam {String} secret (Required) Secret
     * 
     * @apiError UnknownError 6000000
     * @apiError ParamErrorNoEmail 6000001
     * @apiError ParamErrorNoPassword 6000002
     * @apiError ParamErrorNoSecret 6000003
     * @apiError ParamErrorWrongEmail 6000004
     * @apiError ParamErrorWrongPassword 6000005
     * @apiError ParamErrorEmailExists 6000006
     * @apiError ParamErrorWrongSecret 6000007
     * 
     * @apiSuccessExample Success-Response:
{
	code: 1,
	time: 1467123777463,
	data: {
		token_new: 'UpQM5SM2hKyCzKoP',
		user: {
			__v: 0,
			email: 'testT61gb@test.com',
			password: '*****',
			created: 1467123777437,
			_id: '5772884116cc68e662fc072f'
		}
	}
}

    * @apiErrorExample {json} Error-Response:
    {
        code: 6000006, 
        time: 1467124038393 
    }

 */


    router.post('', (request,response) => {

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

        if(_.isEmpty(request.body.secret)){
            self.successResponse(response,Const.responsecodeParamErrorNoSecret);
            return;
        }

        // check secret first
        var tenSec = Math.floor(Utils.now() / 1000 / 10);
        var salt = Config.hashSalt;
        
        var candidate1 = salt + (tenSec);
        var candidate2 = salt + (tenSec - 1);
        var candidate3 = salt + (tenSec - 2);
        
        if(sha1(candidate1) == reqSecret || 
            sha1(candidate2) == reqSecret || 
            sha1(candidate3) == reqSecret){
            
            
        } else {
            
            if(reqSecret != Config.signinBackDoorSecret){
                self.successResponse(response,Const.responsecodeParamErrorWrongSecret);
                return;
            }
            
        }


        async.waterfall([

            (done) => {

                var result = {};

                // check format
                if(!validator.isEmail(reqEmail)){

                    done({
                        handledError:Const.responsecodeParamErrorWrongEmail
                    });

                }

                // check password
                else if(!Const.REPassword.test(reqPassword)){

                    done({
                        handledError:Const.responsecodeParamErrorWrongPassword
                    });

                } else 
                    done(null,result);

            },
            (result,done) => {

                // check duplication

                var result = {};
                var userModel = UserModel.get();

                userModel.findOne({
                    email: reqEmail
                },function(err,findResult){

                    if(findResult){

                        done({
                            handledError:Const.responsecodeParamErrorEmailExists
                        });

                    }else{
                        done(err,result);
                    }

                });
            },
            (result,done) => {

                var userModel = UserModel.get();

                var passwordHashed = sha1(reqPassword + Config.hashSalt);

                var user = new userModel({
                    email: reqEmail,
                    password: passwordHashed,
                    created: Utils.now()
                });
                
                user.save(function(err,saveResult){
                    
                    result.user = saveResult.toObject();
                    done(err,result);
                    
                });

            },
            (result,done) => {

                // create token

                UpdateTokenLogic(result.user._id,(err,tokenResult) => {

                    result.token = tokenResult.token;
                    done(err,result);

                });

                
            }

        ],
        (err,result) => {

            if(err){

                if(err.handledError){

                    self.successResponse(response,err.handledError);

                }else {

                    console.log(err);

                    self.successResponse(response,Const.responsecodeUnknownError);

                }

            } else {

                self.successResponse(response,Const.responsecodeSucceed,{
                    token_new: result.token,
                    user : result.user
                });

            }

        });

    });

    return router;

}

module["exports"] = new SignupGeneralController();
