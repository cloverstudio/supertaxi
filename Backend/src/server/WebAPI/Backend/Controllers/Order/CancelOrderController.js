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
     * @apiDescription This API receives JSON request. Cancels open order
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} type (Required) User type should be "user" or "driver"
     * @apiParam {String} [reason] Descriptive reason for canceling a order
    
     * @apiError UnknownError 6000000
     * @apiError ParamErrorWrongType 6000011

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
                    updateParams.cancel = { userTs: Utils.now() };
                else
                    updateParams.cancel = { driverTs: Utils.now() };

                if (request.body.reason)
                        updateParams.cancel.reason = request.body.reason;

                orderModel.update({
                    acceptTs: { $exists: false },
                    arriveTs: { $exists: false },
                    finishTs: { $exists: false },
                    cancel: { $exists: false }
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

CancelOrderController.prototype.validation = function(fields) {

    if (fields.type != Const.userTypeNormal && fields.type != Const.userTypeDriver) {
        return { handledError: Const.responsecodeParamErrorWrongType };
    }

    return null;
}

module["exports"] = new CancelOrderController();
