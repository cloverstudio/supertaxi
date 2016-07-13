var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var BackendBase = require('../BackendBase');

var OrderModel = require(pathTop + 'Models/Order');

var AcceptOrderController = function(){
}

_.extend(AcceptOrderController.prototype,BackendBase.prototype);

AcceptOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/accept Accept Order
     * @apiName Accept Order
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Driver accepts order
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {Decimal} lat (Required) Current driver latitude
     * @apiParam {Decimal} lon (Required) Current driver longitude
    
     * @apiError UnknownError 6000000
     * @apiError ParamErrorLatitudeDriver 6000024
     * @apiError ParamErrorLongitudeDriver 6000025

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075
        }

     **/

    router.post('', tokenChecker, (request, response) => {

        var orderModel = OrderModel.get();
        var user = request.user;

        async.waterfall([

            (done) => {

                done(self.validation(request.body), {});

            },
            (result, done) => {

                var updateParams = {
                    driver: {
                        id: user._id.toString(),
                        lat: request.body.lat,
                        lon: request.body.lon
                    },
                    acceptOrderTs: Utils.now()
                };

                orderModel.update({
                    acceptOrderTs: { $exists: false },
                    cancelOrderOrTrip: { $exists: false }
                }, { 
                    $set: updateParams
                }, (err, updateResult) => {
                    
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

AcceptOrderController.prototype.validation = function(fields) {

    if (!_.isNumber(fields.lat)) {
        return { handledError: Const.responsecodeParamErrorLatitudeDriver };
    }
    
    if (!_.isNumber(fields.lon)) {
        return { handledError: Const.responsecodeParamErrorLongitudeDriver };
    }

    return null;
}

module["exports"] = new AcceptOrderController();
