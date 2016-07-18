var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var BackendBase = require('../BackendBase');

var UserModel = require(pathTop + 'Models/User');

var GetUserDetailProfileController = function(){
}

_.extend(GetUserDetailProfileController.prototype,BackendBase.prototype);

GetUserDetailProfileController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/profile/detail Get Profile Detail
     * @apiName Get Profile Detail
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Returns user's data
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} [userId] User or driver id. If not specified, then return user's data from access-token.
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorInvalidId 6000026

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075,
            data: { 
                user: { 
                    __v: 0,
                    _id: 57875c9c1c1a343769872e7e,
                    created: 1468488860290,
                    currentLocation: [ 10.000151, -19.999907 ],
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
                    },
                    user: { 
                        age: 0, 
                        name: 'test' 
                    }
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

                if (request.body.userId) {
                    
                    userModel.findOne({ _id: request.body.userId }, (err, findResult) => {

                        result.user = findResult;
                        done(err, result);

                    });

                } else {

                    result.user = user;
                    done(null, result);

                }

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

                self.successResponse(response, Const.responsecodeSucceed, { user: result.user });

            }

        });

    });

    return router;

}

GetUserDetailProfileController.prototype.validation = function(fields) {

    if (fields.userId && !Utils.isObjectId(fields.userId)) {
        return { handledError: Const.responsecodeParamErrorInvalidId };
    }

    return null;
}

module["exports"] = new GetUserDetailProfileController();
