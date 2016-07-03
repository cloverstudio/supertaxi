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
var tokenChecker = require( pathTop + 'lib/authAPI');

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

    router.post('',tokenChecker,(request,response) => {

        var form = new formidable.IncomingForm();

        async.waterfall([(done) => {

                var result = {};

                form.parse(request, (err, fields, files) =>  {

                    result.fields = fields;
                    result.files = files;
                    
                    done(null,result)

                });

            },
            (result,done) => {

                if(_.isEmpty(result.fields.name)){
                    done({
                        handledError:Const.responsecodeParamErrorNoName
                    });
                    return;
                }

                if(_.isEmpty(result.fields.type)){
                    done({
                        handledError:Const.responsecodeParamErrorWrongType
                    });
                    return;
                }


                done(null,result);

            },
            (result,done) => {

                var user = request.user;

                var updateParams = {};

                if(result.fields.type == Const.userTypeNormal){
                    updateParams.user = {
                        name: result.fields.name
                    };
                }

                else if(result.fields.type == Const.userTypeDriver){
                    updateParams.driver = {
                        name: result.fields.name
                    };
                } else {
                    done({
                        handledError:Const.responsecodeParamErrorWrongType
                    });
                    return;
                }

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
                                src: Config.uploadPath + "/" + result.file.newFileName, 
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
                    
                    done(null,result);
                    
                }

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
