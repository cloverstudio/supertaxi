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

var StartTripOrderController = function(){
}

_.extend(StartTripOrderController.prototype,BackendBase.prototype);

StartTripOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/start Update Driver's Start Time
     * @apiName Update Driver's Start Time
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Update driver's start time
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} orderId (Required) Order id
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorInvalidId 6000026
     * @apiError ParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled 6000029

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075
        }

     **/

    router.post('', tokenChecker, (request, response) => {

        var orderModel = OrderModel.get();

        async.waterfall([

            (done) => {

                done(self.validation(request.body), {});

            },
            (result, done) => {

                // update order
                var updateParams = {
                    startTripTs: Utils.now()
                };

                orderModel.update({
                    _id: request.body.orderId,
                    startTripTs: { $exists: false },
                    cancelOrderOrTrip: { $exists: false }
                }, {
                    $set: updateParams
                }, (err, updateResult) => {

                    var error = null;

                    if (err)

                        error = err;

                    else {
                        // if order not found
                        if (updateResult.n == 0)
                            error = { handledError: Const.responsecodeParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled };

                    }

                    done(error, result);

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

StartTripOrderController.prototype.validation = function(fields) {

    if (!Utils.isObjectId(fields.orderId)) {
        return { handledError: Const.responsecodeParamErrorInvalidId };
    }

    return null;
}

module["exports"] = new StartTripOrderController();
