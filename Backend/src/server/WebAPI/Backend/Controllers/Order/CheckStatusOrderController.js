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
var UserModel = require(pathTop + 'Models/User');

var CheckStatusOrderController = function(){
}

_.extend(CheckStatusOrderController.prototype,BackendBase.prototype);

CheckStatusOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/status Check Order Status
     * @apiName Check Order Status
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. User check order status (accepted, canceled, pending)
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {String} orderId (Required) Order id
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorInvalidId 6000026
     * @apiError ParamErrorOrderNotFound 6000034
    
     * 
     * @apiSuccess {Number=1,2,3,4,5,6} orderStatus 1 = accepted, 2 = canceled, 3 = pending, 4 = arrivedToStartLocation, 5 = startedDrive, 6 = finishedDrive

     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075,
            data: {
                orderStatus: 1,
                driver: {
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
                    }
                }
            }
        }

     **/

    router.post('', tokenChecker, (request, response) => {

        var orderModel = OrderModel.get();
        var userModel = UserModel.get();

        async.waterfall([

            (done) => {

                done(self.validation(request.body), {});

            },
            (result, done) => {

                orderModel.findOne({
                    _id: request.body.orderId
                }, (err, findResult) => {

                    // check if order is found
                    if (!findResult) {
                        done({ handledError: Const.responsecodeParamErrorOrderNotFound });
                        return;
                    }

                    var order = findResult.toObject();

                    var orderStatus = 0;

                    if (order.cancelOrderOrTrip)
                        orderStatus = Const.orderStatus.canceled;

                    else if (order.acceptOrderTs)
                        orderStatus = Const.orderStatus.accepted;

                    else if (order.arriveToStartLocationTs)
                        orderStatus = Const.orderStatus.arrivedToStartLocation;

                    else if (order.startTripTs)
                        orderStatus = Const.orderStatus.startedDrive;

                    else if (order.finishTripTs)
                        orderStatus = Const.orderStatus.finishedDrive;

                    else
                        orderStatus = Const.orderStatus.pending;

                    result.driverId = order.driverId;
                    result.orderStatus = orderStatus;
                    
                    done(err, result);

                });

            },
            (result, done) => {

                userModel.findOne({
                    _id: result.driverId
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

                self.successResponse(response, Const.responsecodeSucceed, {
                    orderStatus: result.orderStatus,
                    driver: result.driver
                });

            }

        });

    });

    return router;

}

CheckStatusOrderController.prototype.validation = function(fields) {

    if (!Utils.isObjectId(fields.orderId)) {
        return { handledError: Const.responsecodeParamErrorInvalidId };
    }

    return null;
}

module["exports"] = new CheckStatusOrderController();
