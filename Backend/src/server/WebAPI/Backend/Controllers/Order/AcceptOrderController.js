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

var AcceptOrderController = function(){
}

_.extend(AcceptOrderController.prototype,BackendBase.prototype);

AcceptOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/accept Accept Order
     * @apiName Accept Order
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Driver accepts open order
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} orderId (Required) Open order id
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorInvalidId 6000026
     * @apiError ParamErrorOrderAlreadyAcceptedOrCanceled 6000027
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

                // update order
                var updateParams = {
                    driverId: user._id.toString(),                
                    acceptOrderTs: Utils.now()
                };

                orderModel.update({
                    _id: request.body.orderId,
                    acceptOrderTs: { $exists: false },
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
                            error = { handledError: Const.responsecodeParamErrorOrderAlreadyAcceptedOrCanceled };

                    }

                    done(error, result);

                });

            },
            (result, done) => {

                // update driver status
                UpdateDriverStatusLogic(user._id.toString(), Const.driverStatus.busy, (err) => {
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

    if (!Utils.isObjectId(fields.orderId)) {
        return { handledError: Const.responsecodeParamErrorInvalidId };
    }

    return null;
}

module["exports"] = new AcceptOrderController();
