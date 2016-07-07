var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');
var formidable = require('formidable');
var fs = require('fs-extra');
var easyimg = require('easyimage');
var path = require('path');
var validator = require('validator');
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
     * @apiParam {String} type (Required) User type should be "user" or "driver"
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
     * @apiError ParamErrorNoName 6000010
     * @apiError ParamErrorWrongType 6000011
     * @apiError ParamErrorFeeStart 6000013
     * @apiError ParamErrorFeeKm 6000014
     * @apiError ParamErrorWrongImageType 6000012
     * @apiError ParamErrorAge 6000015
     * @apiError ParamErrorWrongTelNum 6000016

     * 
     * @apiSuccessExample Success-Response:

{ code: 1, time: 1467125660699}

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

                    if(!validator.isNumeric(result.fields.fee_start)){
                        done({
                            handledError:Const.responsecodeParamErrorFeeStart
                        });
                        return;
                    }

                }

                if(result.fields.fee_km){

                    if(!validator.isNumeric(result.fields.fee_km)){
                        done({
                            handledError:Const.responsecodeParamErrorFeeKm
                        });
                        return;
                    }

                }

                if(result.fields.age){

                    if(!validator.isNumeric(result.fields.age)){
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

                var updateParams = {};

                if(result.fields.type == Const.userTypeNormal){

                    if(!result.fields.age)
                        result.fields.age = 0;

                    updateParams.user = {
                        name: result.fields.name,
                        age:result.fields.age,
                        note:result.fields.note,
                    };
                }

                else if(result.fields.type == Const.userTypeDriver){

                    updateParams.driver = {
                        name: result.fields.name,
                        car_type:result.fields.name,
                        car_registration:result.fields.car_registration,
                        fee_start:result.fields.fee_start,
                        fee_km:result.fields.fee_km,
                    };

                }

                updateParams.telNum = result.fields.telNum;

                user.update(
                    updateParams
                ,{},(err,userResult) => {

                    done(err,result);

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

                user.update({
                    avatar:{
                        fileid: result.file.newFileName,
                        thumbfileid: result.file.thumbName
                    }
                }
                ,{},(err,userResult) => {

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

                    self.successResponse(response,err.responsecodeUnknownError);

                }

            } else {

                self.successResponse(response,Const.responsecodeSucceed,{});

            }

        });

    });

    return router;

}

module["exports"] = new UpdateProfileController();
