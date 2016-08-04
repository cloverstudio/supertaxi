var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var BackendBase = require('../BackendBase');

var UpdateCoordinatesProfileController = function(){
}

_.extend(UpdateCoordinatesProfileController.prototype,BackendBase.prototype);

UpdateCoordinatesProfileController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/profile/updateCoordinates Update Profile Coordinates
     * @apiName Update Profile Coordinates
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Update user's profile coordinates, both for taxt driver and user
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {Decimal} lat (Required) Current latitude
     * @apiParam {Decimal} lon (Required) Current longitude
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorLatitude 6000024
     * @apiError ParamErrorLongitude 6000025

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075
        }

     **/

    router.post('', tokenChecker, (request, response) => {

        var user = request.user;

        async.waterfall([

            (done) => {

                done(self.validation(request.body), {});

            },
            (result, done) => {
                
                // update current user coordinates
                user.update({
                    currentLocation: [ request.body.lon, request.body.lat ]
                }, {}, (err, userResult) => {

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

UpdateCoordinatesProfileController.prototype.validation = function(fields) {

    if (!Utils.isNumeric(fields.lat)) {
        return { handledError: Const.responsecodeParamErrorLatitude };
    }
    
    if (!Utils.isNumeric(fields.lon)) {
        return { handledError: Const.responsecodeParamErrorLongitude };
    }

    return null;
}

module["exports"] = new UpdateCoordinatesProfileController();
