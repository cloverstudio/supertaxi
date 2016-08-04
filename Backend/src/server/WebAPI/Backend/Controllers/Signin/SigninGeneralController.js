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

var SigninGeneralController = function(){
}

_.extend(SigninGeneralController.prototype,BackendBase.prototype);

SigninGeneralController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/signin SignIn
     * @apiName General Signin
     * @apiGroup WebAPI
     * @apiDescription Signin to backend and generate new token for the user.
     *   
     * @apiParam {String} email (Required)  Email Address 
     * @apiParam {String} password (Required)  Password 
     * @apiParam {String} secret (Required)  Secret
     * 
     * @apiError UnknownError 6000000
     * @apiError ParamErrorNoEmail 6000001
     * @apiError ParamErrorNoPassword 6000002
     * @apiError ParamErrorNoSecret 6000003
     * @apiError SignInError 6000008
     * 
     * @apiSuccessExample Success-Response User:
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
                    _id: '5772884116cc68e662fc072f',
                    user: { 
                        name: 'test',
                        age: 0,
                        note: null
                    }
                }
            }
        }
    
    * @apiSuccessExample Success-Response Driver:
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
                    _id: '5772884116cc68e662fc072f',
                    driver: {
                        name: 'test',
                        car_type: 'Caravan',
                        car_registration: 'ZG2344HR',
                        fee_start: 30,
                        fee_km: 5
                    }
                }
            }
        }
    
    * @apiSuccessExample Success-Response Undefined:
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
{ code: 6000008, time: 1467124038393 }

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
                var userModel = UserModel.get();

                var passwordHashed = sha1(reqPassword + Config.hashSalt);

                userModel.findOne({
                    email: reqEmail,
                    password : passwordHashed
                },function(err,findResult){

                    if(!findResult){

                        done({
                            handledError:Const.responsecodeSignInError
                        });

                    }else{

                        result.user = findResult.toObject();
                        done(err,result);

                    }

                });

            },
            (result,done) => {

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

module["exports"] = new SigninGeneralController();
