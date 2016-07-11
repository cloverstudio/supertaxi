var express = require('express');
var router = express.Router();
var _ = require('lodash');
var async = require('async');

var validator = require('validator');

var pathTop = "../../../../";

var Const = require( pathTop + "lib/consts");
var Utils = require( pathTop + 'lib/utils');
var tokenChecker = require( pathTop + 'lib/authAPI');

var BackendBase = require('../BackendBase');

var OrderModel = require(pathTop + 'Models/Order');

var CallOrderController = function(){
}

_.extend(CallOrderController.prototype,BackendBase.prototype);

CallOrderController.prototype.init = function(app){
        
    var self = this;

   /**
     * @api {post} /api/v1/order/call Call Taxi
     * @apiName Call Taxi
     * @apiGroup WebAPI
     * @apiDescription This API receives JSON request. Sent request to taxi driver
     * 
     * @apiHeader {String} access-token Users unique access-token.
     * 
     * @apiParam {Decimal} latFrom (Required) From latitude
     * @apiParam {Decimal} lonFrom (Required) From longitude
     * @apiParam {String} addressFrom (Required) From address
     * @apiParam {Decimal} latTo (Required) To latitude
     * @apiParam {Decimal} lonTo (Required) To longitude
     * @apiParam {String} addressTo (Required) To address
     * @apiParam {Number} crewNum (Required) Number of passengers
    
     * @apiError UnknownError 6000000
     * @apiError ParamErrorLatitudeFrom 6000017
     * @apiError ParamErrorLongitudeFrom 6000018
     * @apiError ParamErrorNoAddressFrom 6000019
     * @apiError ParamErrorLatitudeTo 6000020
     * @apiError ParamErrorLongitudeTo 6000021
     * @apiError ParamErrorNoAddressTo 6000022
     * @apiError ParamErrorCrewNumber 6000023

     * 
     * @apiSuccessExample Success-Response:

    { code: 1, time: 1467125660699 }

     **/

    router.post('', tokenChecker, (request, response) => {

        var orderModel = OrderModel.get();
        var user = request.user;

        async.waterfall([

            (done) => {
                    
                done(null, { fields: request.body });

            },
            (result, done) => {

                done(self.validation(result.fields), result);

            },
            (result, done) => {

                var insertParams = {                    
                    userId: user._id.toString(),
                    from: {
                        lat: result.fields.latFrom,
                        lon: result.fields.lonFrom,
                        address: result.fields.addressFrom
                    },
                    to: {
                        lat: result.fields.latTo,
                        lon: result.fields.lonTo,
                        address: result.fields.addressTo
                    },
                    orderTs: Utils.now(),
                    crewNum: result.fields.crewNum
                };                           
                
                // save new order           
                var order = new orderModel(insertParams);
                order.save((err, saveResult) => {

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


CallOrderController.prototype.validation = function(fields) {

    // coordinates from
    if (!_.isNumber(fields.latFrom)) {
        return { handledError: Const.responsecodeParamErrorLatitudeFrom };
    }
    
    if (!_.isNumber(fields.lonFrom)) {
        return { handledError: Const.responsecodeParamErrorLongitudeFrom };
    }
    
    if (_.isEmpty(fields.addressFrom)) {
        return { handledError: Const.responsecodeParamErrorNoAddressFrom };
    }

    // coordinates to
    if (!_.isNumber(fields.latTo)) {
        return { handledError: Const.responsecodeParamErrorLatitudeTo };
    }
    
    if (!_.isNumber(fields.lonTo)) {
        return { handledError: Const.responsecodeParamErrorLongitudeTo };
    }
    
    if (_.isEmpty(fields.addressTo)) {
        return { handledError: Const.responsecodeParamErrorNoAddressTo };
    }

     // passenger number
    if (!_.isNumber(fields.crewNum)) {
        return { handledError: Const.responsecodeParamErrorCrewNumber };
    }

    return null;
}

module["exports"] = new CallOrderController();
