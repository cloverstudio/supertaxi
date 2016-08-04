var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');
var formidable = require('formidable');
var fs = require('fs-extra');
var easyimg = require('easyimage');
var path = require('path');
var phone = require('phone');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Config = require( pathTop + "lib/init");
var DatabaseManager = require( pathTop + 'lib/DatabaseManager');
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var BackendBase = require('../BackendBase');

var UpdateProfileController = function(){
}

_.extend(UpdateProfileController.prototype,BackendBase.prototype);

UpdateProfileController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/profile/update Update Profile
     * @apiName UpdateProfile
     * @apiGroup WebAPI
     * @apiDescription This API receives multipart url-form-encoded request not JSON. Update user's profile, both for taxt driver and user
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} name (Required) Name of user/driver 
     * @apiParam {Number=1,2} type (Required) User type should be 1: user or 2: driver
     * @apiParam {String} telNum (Required) Telephone number of user/driver (+385981234567, +385 99 1234 655, ...)
     * @apiParam {Number} age Age of user 
     * @apiParam {String} note note
     * @apiParam {String} car_type CarType
     * @apiParam {String} car_registration Car registration number
     * @apiParam {Number} fee_start Start fee
     * @apiParam {Number} fee_km Fee per km
     * @apiParam {File} file picture file (png,jpeg,gif)
     * 
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorNoName 6000010
     * @apiError ParamErrorWrongType 6000011
     * @apiError ParamErrorFeeStart 6000013
     * @apiError ParamErrorFeeKm 6000014
     * @apiError ParamErrorWrongImageType 6000012
     * @apiError ParamErrorAge 6000015
     * @apiError ParamErrorWrongTelNum 6000016

     * 
     * @apiSuccessExample Success-Response User:
        { 
            code: 1,
            time: 1468314014075,
            data: { 
                user: { 
                    __v: 0,
                    _id: 57875c9c1c1a343769872e7e,
                    created: 1468488860290,
                    email: 'testsFr2B@test.com',
                    password: '*****',
                    telNum: '+385981234567',
                    token: '*****',
                    token_generated: 1468488860456,
                    avatar: { 
                        fileid: 'nJSoPuuRMGwHOjP3n0qwldOB13uLNyPF',
                        thumbfileid: 'qjZn3t0WiD079YuKbRIGMjpjojBD6w2x' 
                    },
                    user: { 
                        age: 0, 
                        name: 'test' 
                    }
                }
            }
        }
    
    * @apiSuccessExample Success-Response Driver:
        { 
            code: 1,
            time: 1468314014075,
            data: { 
                user: { 
                    __v: 0,
                    _id: 57875c9c1c1a343769872e7e,
                    created: 1468488860290,
                    email: 'testsFr2B@test.com',
                    password: '*****',
                    telNum: '+385981234567',
                    token: '*****',
                    token_generated: 1468488860456,
                    avatar: { 
                        fileid: 'nJSoPuuRMGwHOjP3n0qwldOB13uLNyPF',
                        thumbfileid: 'qjZn3t0WiD079YuKbRIGMjpjojBD6w2x' 
                    },
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

     **/

    router.post('',tokenChecker,(request,response) => {

        var form = new formidable.IncomingForm();

        async.waterfall([(done) => {

                var result = {};

                form.parse(request, (err, fields, files) =>  {

                    result.fields = fields;

                    if(files)
                        result.file = files.file;
                    
                    done(null,result)

                });

            },
            (result,done) => {


                // validation
                if(_.isEmpty(result.fields.name)){
                    done({
                        handledError:Const.responsecodeParamErrorNoName
                    });
                    return;
                }

                if(result.fields.type != Const.userTypeNormal && result.fields.type != Const.userTypeDriver) {
                    done({
                        handledError:Const.responsecodeParamErrorWrongType
                    });
                    return;
                }

                if(result.fields.type == Const.userTypeDriver){

                    if(_.isEmpty(result.fields.fee_start)){
                        done({
                            handledError:Const.responsecodeParamErrorFeeStart
                        });
                        return;
                    }

                    if(_.isEmpty(result.fields.fee_km)){
                        done({
                            handledError:Const.responsecodeParamErrorFeeKm
                        });
                        return;
                    }
                    
                }
                
                if(result.fields.fee_start){

                    if(!Utils.isNumeric(result.fields.fee_start)){
                        done({
                            handledError:Const.responsecodeParamErrorFeeStart
                        });
                        return;
                    }

                }

                if(result.fields.fee_km){

                    if(!Utils.isNumeric(result.fields.fee_km)){
                        done({
                            handledError:Const.responsecodeParamErrorFeeKm
                        });
                        return;
                    }

                }

                if(result.fields.age){

                    if(!Utils.isNumeric(result.fields.age)){
                        done({
                            handledError:Const.responsecodeParamErrorAge
                        });
                        return;
                    }

                }

                if(result.file){

                    // generate thumbnail      
                    if(result.file.type.indexOf("jpeg") == -1 &&
                        result.file.type.indexOf("gif") == -1 &&
                        result.file.type.indexOf("png") ==  -1){
                            done({
                                handledError:Const.responsecodeParamErrorWrongImageType
                            });
                            return;
                        }

                }

                var telNum = phone(result.fields.telNum)[0];

                if (_.isEmpty(telNum)) {
                    done({
                        handledError: Const.responsecodeParamErrorWrongTelNum
                    });
                    return;
                }

                result.fields.telNum = telNum;
                done(null,result);

            },
            (result,done) => {

                var user = request.user;

                if(result.fields.type == Const.userTypeNormal){

                    if(!result.fields.age)
                        result.fields.age = 0;

                    user.user = {
                        name: result.fields.name,
                        age:result.fields.age,
                        note:result.fields.note
                    };
                }

                else if(result.fields.type == Const.userTypeDriver){

                    user.driver = {
                        name: result.fields.name,
                        car_type:result.fields.car_type,
                        car_registration:result.fields.car_registration,
                        fee_start:result.fields.fee_start,
                        fee_km:result.fields.fee_km
                    };

                }

                user.telNum = result.fields.telNum;

                user.save((err, saveResult) => {

                    result.user = user.toObject();
                    done(err, result);

                });

            },
            (result,done) => {
                
                if(!result.file){
                    done(null,result);
                    return;
                }
            
                var file = result.file;

                // generate thumbnail      
                if(file.type.indexOf("jpeg") > -1 ||
                    file.type.indexOf("gif") > -1 ||
                    file.type.indexOf("png") > -1){
                        
                        var thumbFileName = Utils.getRandomString(32); 
                        result.file.thumbName = thumbFileName;

                        var destPathTmp = Config.uploadPath + "/" + thumbFileName;

                        easyimg.thumbnail({
                                src: file.path, 
                                dst:destPathTmp + ".png",
                                width:Const.thumbSize, height:Const.thumbSize
                            }).then(
                            
                            function(image) {
                                
                                fs.rename(destPathTmp + ".png", 
                                    destPathTmp, function(err) {
                                    
                                    result.file.thumbSize = image.size;
                                    done(err,result);
                                    
                                });

                            },
                            function (err) {
                            
                                // ignore thubmnail error
                                console.log(err);
                                done(null,result);
                            }
                            
                        );
                    
                } else {
                    
                    done({
                        handledError:Const.responsecodeParamErrorWrongImageType
                    });
                    
                }

            },
            (result,done) => {
                
                if(!result.file){
                    done(null,result);
                    return;
                }
            
                var file = result.file;

                // save file
                if(file.type.indexOf("jpeg") > -1 ||
                    file.type.indexOf("gif") > -1 ||
                    file.type.indexOf("png") > -1){
                        
                    // save to upload dir
                    var tempPath = result.file.path;
                    var fileName = result.file.name;
                    var destPath = Config.uploadPath + "/";
                    
                    var newFileName = Utils.getRandomString(32);                
                    result.file.newFileName = newFileName;
                    
                    fs.copy(tempPath, destPath + newFileName, function(err) {

                        easyimg.convert({src: destPath + newFileName, dst: destPath + newFileName + ".png", quality:100}).then(function (file) {

                            fs.rename( destPath + newFileName + ".png", 
                                destPath + newFileName, function(err) {
                                
                                done(err,result);
                                
                            });
                                                            
                        });
                    
                    });
                    
                } else {
                    
                    done({
                        handledError:Const.responsecodeParamErrorWrongImageType
                    });
                    
                }

            },
            (result,done) => {

                if(!result.file){
                    done(null,result);
                    return;
                }

                // save thumbnail and avatar fileid

                var user = request.user;

                user.avatar = {
                    fileid: result.file.newFileName,
                    thumbfileid: result.file.thumbName
                };

                user.save((err, saveResult) => {

                    result.user = user.toObject();
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

                self.successResponse(response, Const.responsecodeSucceed, { user: result.user });

            }

        });

    });

    return router;

}

module["exports"] = new UpdateProfileController();
