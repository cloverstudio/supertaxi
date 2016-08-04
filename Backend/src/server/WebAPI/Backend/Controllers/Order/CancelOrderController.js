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

var CancelOrderController = function(){
}

_.extend(CancelOrderController.prototype,BackendBase.prototype);

CancelOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/cancel Cancel Order
     * @apiName Cancel Order
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Cancels order
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} orderId (Required) Accepted order id
     * @apiParam {Number=1,2} type (Required) User type should be 1: user or 2: driver
     * @apiParam {String} [reason] Descriptive reason for canceling a order
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorWrongType 6000011
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

                var updateParams = {};

                if (request.body.type == Const.userTypeNormal)
                    updateParams.cancelOrderOrTrip = { userTs: Utils.now() };
                else
                    updateParams.cancelOrderOrTrip = { driverTs: Utils.now() };

                if (request.body.reason)
                    updateParams.cancelOrderOrTrip.reason = request.body.reason;

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

CancelOrderController.prototype.validation = function(fields) {

    if (!Utils.isObjectId(fields.orderId)) {
        return { handledError: Const.responsecodeParamErrorInvalidId };
    }

    if (fields.type != Const.userTypeNormal && fields.type != Const.userTypeDriver) {
        return { handledError: Const.responsecodeParamErrorWrongType };
    }

    return null;
}

module["exports"] = new CancelOrderController();
