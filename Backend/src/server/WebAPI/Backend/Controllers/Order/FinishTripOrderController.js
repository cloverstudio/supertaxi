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

var FinishTripOrderController = function(){
}

_.extend(FinishTripOrderController.prototype,BackendBase.prototype);

FinishTripOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/finish Update Driver's Finish Time
     * @apiName Update Driver's Finish Time
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Update driver's finish time
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} orderId (Required) Order id
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorInvalidId 6000026
     * @apiError ParamErrorDriverAlreadyFinishedDrive 6000030

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
                    finishTripTs: Utils.now()
                };

                orderModel.update({
                    _id: request.body.orderId,
                    finishTripTs: { $exists: false }
                }, {
                    $set: updateParams
                }, (err, updateResult) => {

                    var error = null;

                    if (err)

                        error = err;

                    else {
                        // if order not found
                        if (updateResult.n == 0)
                            error = { handledError: Const.responsecodeParamErrorDriverAlreadyFinishedDrive };

                    }

                    done(error, result);

                });

            },
            (result, done) => {

                // update driver status
                UpdateDriverStatusLogic(user._id.toString(), Const.driverStatus.available, (err) => {
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

FinishTripOrderController.prototype.validation = function(fields) {

    if (!Utils.isObjectId(fields.orderId)) {
        return { handledError: Const.responsecodeParamErrorInvalidId };
    }

    return null;
}

module["exports"] = new FinishTripOrderController();
