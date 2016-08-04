var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var BackendBase = require('../BackendBase');

var RateModel = require(pathTop + 'Models/Rate');
var UserModel = require(pathTop + 'Models/User');

var RateProfileController = function(){
}

_.extend(RateProfileController.prototype,BackendBase.prototype);

RateProfileController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/profile/rate Rate Profile
     * @apiName Rate Profile
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Rate user or driver profile
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} id (Required) Profile id to rate
     * @apiParam {Number=1,2} type (Required) Profile type should be 1: user or 2: driver. Profile type to rate
     * @apiParam {Number=1,2,3,4,5} rate (Required) Rate number
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorWrongType 6000011
     * @apiError ParamErrorInvalidId 6000026
     * @apiError ParamErrorRateNumber 6000031
     * @apiError ParamErrorUserNotFound 6000032
     * @apiError ParamErrorDriverNotFound 6000033

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075
        }

     **/

    router.post('', tokenChecker, (request, response) => {

        var rateModel = RateModel.get();

        async.waterfall([

            (done) => {

                self.validation(request.body, (err, user) => {

                    done(err, { user: user });

                });

            },
            (result, done) => {

                var insertParams = {                    
                    userId: request.body.id.toString(),
                    rate: request.body.rate
                };                           
            
                // save new rate
                var rate = new rateModel(insertParams);
                rate.save((err, saveResult) => {

                    done(err, result);

                });  
        
            },
            (result, done) => {

                // get rate sum of user
                rateModel.aggregate([
                    {
                        $match: { userId: request.body.id.toString() }
                    },
                    {
                        $group: {
                            _id: null,
                            sumRate: { $sum: '$rate' },
                            count: { $sum: 1 }
                        }
                    }
                ], (err, findResult) => {

                    result.rate = findResult[0];
                    done(err, result);

                });
        
            },
            (result, done) => {
                
                // save user average rate
                result.user.averageRate = result.rate.sumRate / result.rate.count;
                result.user.save((err, saveResult) => {

                    done(err, result);

                });

            }
        ],
        (err, result) => {

            if (err) {

                if (err.handledError) {

                    self.successResponse(response, err.handledError);

                } else {

                    console.log(err);

                    self.successResponse(response, Const.responsecodeUnknownError);

                }

            } else {

                self.successResponse(response, Const.responsecodeSucceed, {});

            }

        });

    });

    return router;

}


RateProfileController.prototype.validation = function(fields, callback) {

    var userModel = UserModel.get();
    var errorObject = null;

    async.waterfall([

        (done) => {

            if (!Utils.isObjectId(fields.id))
                errorObject = { handledError: Const.responsecodeParamErrorInvalidId };

            else if (fields.type != Const.userTypeNormal && fields.type != Const.userTypeDriver)
                errorObject = { handledError: Const.responsecodeParamErrorWrongType };

            else if (!Utils.isNumeric(fields.rate) || fields.rate < Const.userRate.min || fields.rate > Const.userRate.max)
                errorObject = { handledError: Const.responsecodeParamErrorRateNumber };
            
            done(errorObject, {});

        },
        (result, done) => {

            var query = {
                _id: fields.id
            };

            if (fields.type == Const.userTypeNormal)
                query.user = { $exists: true };
            else
                query.driver = { $exists: true };

            userModel.findOne(query, (err, findResult) => {

                result.user = findResult;
                done(err, result);
           
            });
    
        },
        (result, done) => {

            if (!result.user) {

                if (fields.type == Const.userTypeNormal)
                    errorObject = { handledError: Const.responsecodeParamErrorUserNotFound };
                else
                    errorObject = { handledError: Const.responsecodeParamErrorDriverNotFound };

            }

            done(errorObject, result);
    
        }
    ],
    (err, result) => {

        callback(err, result.user);

    });

}

module["exports"] = new RateProfileController();
