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

var UpdateDriverStatusLogic = require(pathTop + 'Logics/UpdateDriverStatus');

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
        var user = request.user;

        async.waterfall([

            (done) => {

                done(self.validation(request.body), {});

            },
            (result, done) => {

                orderModel.findOne({ _id: request.body.orderId }, (err, findResult) => {

                    if (err) {
                        done(err, result);
                        return;
                    }

                    if (!findResult) {
                        done({ handledError: Const.responsecodeParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled }, result);
                        return;
                    }

                    result.order = findResult;
                    done(null, result);

                });

            },
            (result, done) => {

                var updateParams = {};

                // user canceled
                if (request.body.type == Const.userTypeNormal) {

                    updateParams.$set = { 
                        cancelOrderOrTrip: { 
                            userTs: Utils.now() 
                        } 
                    };

                } else {
                    // if order is not accepted, then just ignore order by driver, not canceled it
                    if (!result.order.acceptOrderTs) 
                        updateParams.$push = { driversIgnoreOrder: user._id.toString() };
                    else
                        updateParams.$set = { 
                            cancelOrderOrTrip: { 
                                driverTs: Utils.now() 
                            } 
                        };
                        
                }

                if (updateParams.$set && request.body.reason)
                    updateParams.$set.cancelOrderOrTrip.reason = request.body.reason;

                orderModel.update({
                    _id: request.body.orderId,
                    startTripTs: { $exists: false },
                    cancelOrderOrTrip: { $exists: false }
                }, updateParams, (err, updateResult) => {
                    
                    if (err) {
                        done(err, result);
                        return;
                    }

                    // if order not found
                    if (updateResult.n == 0) {
                        done({ handledError: Const.responsecodeParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled }, result);
                        return;
                    }

                    done(null, result);

                });

            },
            (result, done) => {

                // if driver canceled order, then update driver status
                if (request.body.type == Const.userTypeDriver) {

                    // update driver status
                    UpdateDriverStatusLogic(user._id.toString(), Const.driverStatus.available, (err) => {
                        done(err, result);
                    });

                } else {
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
