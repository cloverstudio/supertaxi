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
     * @apiParam {Decimal} latFrom (Required) User start latitude
     * @apiParam {Decimal} lonFrom (Required) User start longitude
     * @apiParam {String} addressFrom (Required) User start address
     * @apiParam {Decimal} latTo (Required) User destination latitude
     * @apiParam {Decimal} lonTo (Required) User destination longitude
     * @apiParam {String} addressTo (Required) User destination address
     * @apiParam {Number} crewNum (Required) Number of passengers
    
     * @apiError UnknownError 6000000
     * @apiError TokenInvalid 6000009
     * @apiError ParamErrorLatitudeFrom 6000017
     * @apiError ParamErrorLongitudeFrom 6000018
     * @apiError ParamErrorNoAddressFrom 6000019
     * @apiError ParamErrorLatitudeTo 6000020
     * @apiError ParamErrorLongitudeTo 6000021
     * @apiError ParamErrorNoAddressTo 6000022
     * @apiError ParamErrorCrewNumber 6000023

     * 
     * @apiSuccessExample Success-Response:
        { 
            code: 1,
            time: 1468314014075,
            data: { 
                order: { 
                    userId: '5784a21a773cfd5e2d58e770',
                    createOrderTs: 1468310044176,
                    crewNum: 4,
                    _id: 5784a21c773cfd5e2d58e771,
                    __v: 0,
                    to: { 
                        location: [ 34.4344333, -44.5665333 ],
                        address: 'Bučarova 13 Zagreb' 
                    },
                    from: { 
                        location: [ 35.4344333, -44.7453333 ],
                        address: 'Siget 11 Zagreb' 
                    }
                }
            }
        }

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
                        location: [ result.fields.lonFrom, result.fields.latFrom ],
                        address: result.fields.addressFrom
                    },
                    to: {
                        location: [ result.fields.lonTo, result.fields.latTo ],
                        address: result.fields.addressTo
                    },
                    createOrderTs: Utils.now(),
                    crewNum: result.fields.crewNum
                };                           
                
                // save new order           
                var order = new orderModel(insertParams);
                order.save((err, saveResult) => {
                    
                    result.order = saveResult.toObject();
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

                self.successResponse(response, Const.responsecodeSucceed, { order: result.order });

            }

        });

    });

    return router;

}


CallOrderController.prototype.validation = function(fields) {

    // coordinates from
    if (!Utils.isNumeric(fields.latFrom)) {
        return { handledError: Const.responsecodeParamErrorLatitudeFrom };
    }

    if (!Utils.isNumeric(fields.lonFrom)) {
        return { handledError: Const.responsecodeParamErrorLongitudeFrom };
    }
    
    if (_.isEmpty(fields.addressFrom)) {
        return { handledError: Const.responsecodeParamErrorNoAddressFrom };
    }

    // coordinates to
    if (!Utils.isNumeric(fields.latTo)) {
        return { handledError: Const.responsecodeParamErrorLatitudeTo };
    }
    
    if (!Utils.isNumeric(fields.lonTo)) {
        return { handledError: Const.responsecodeParamErrorLongitudeTo };
    }
    
    if (_.isEmpty(fields.addressTo)) {
        return { handledError: Const.responsecodeParamErrorNoAddressTo };
    }

     // passenger number
    if (!Utils.isNumeric(fields.crewNum)) {
        return { handledError: Const.responsecodeParamErrorCrewNumber };
    }

    return null;
}

module["exports"] = new CallOrderController();
