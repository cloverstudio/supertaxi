var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var UserModel = require(pathTop + 'Models/User');

var BackendBase = require('../BackendBase');

var GetNearestDriverProfileController = function(){
}

_.extend(GetNearestDriverProfileController.prototype,BackendBase.prototype);

GetNearestDriverProfileController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/profile/getNearestDriver Get Nearest Driver
     * @apiName Get Nearest Driver
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Get nearest driver to current user
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {Decimal} lat (Required) Current user latitude
     * @apiParam {Decimal} lon (Required) Current user longitude
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorLatitude 6000024
     * @apiError ParamErrorLongitude 6000025

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075,
            data: { 
                driver: {
                    __v: 0,
                    _id: 5788dc42d92859ee355119d6,
                    created: 1468587074518,
                    currentLocation: [ 10, -19.999907 ],
                    email: 'testwjwrO@test.com',
                    password: '*****',
                    telNum: '+385981234567',
                    token: '*****',
                    token_generated: 1468587074837,
                    avatar: { 
                        fileid: 'rpOMhKHbp1vxkAZM4iToBE5YFX321tB0',
                        thumbfileid: 'UMttVkf3XzxLLaSJVH9QH77zbELnjvNx' 
                    },
                    driver: { 
                        name: 'test',
                        car_type: 'Caravan',
                        car_registration: 'ZG2344HR',
                        fee_start: 30,
                        fee_km: 5,
                        status: 1
                    },
                    averageRate: 4.34
                }
            }
        }

     **/

    router.post('', tokenChecker, (request, response) => {

        var userModel = UserModel.get();
        var user = request.user;

        async.waterfall([

            (done) => {

                done(self.validation(request.body), {});

            },
            (result, done) => {
                
                userModel.findOne({
                    currentLocation: { 
                        $near: {
                            $geometry: { 
                                type: 'Point', 
                                coordinates: [ request.body.lon, request.body.lat ]
                            }
                        }
                    },
                    driver: { $exists: true },
                    $or: [
                        { "driver.status": { $exists: false } },
                        { "driver.status": Const.driverStatus.available }
                    ]
                }, (err, findResult) => {

                    result.driver = findResult;
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

                self.successResponse(response, Const.responsecodeSucceed, result);

            }

        });

    });

    return router;

}

GetNearestDriverProfileController.prototype.validation = function(fields) {

    if (!Utils.isNumeric(fields.lat)) {
        return { handledError: Const.responsecodeParamErrorLatitude };
    }
    
    if (!Utils.isNumeric(fields.lon)) {
        return { handledError: Const.responsecodeParamErrorLongitude };
    }

    return null;
}

module["exports"] = new GetNearestDriverProfileController();
