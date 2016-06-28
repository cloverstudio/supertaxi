var _ = require('lodash');
var async = require('async');

var Const = require("../lib/consts");
var Config = require("../lib/init");
var Utils = require("../lib/utils");

var DatabaseManager = require("../lib/DatabaseManager");

var UserModel = require('../Models/User');

var UpdateToken = (userId,callBack) => {
    
    var userModel = UserModel.get();

    async.waterfall([
        (done) => {

            var result = {};

            userModel.findOne({_id:userId},(err,findResult) => {

                if(!findResult){
                    done("no user");
                }else{
                    result.user = findResult;
                    done(err,result)
                }

            });

        },
        (result,done) => {

            // generate token here
            var token = Utils.getRandomString(16);
            
            result.user.update({
                token: token,
                token_generated: Utils.now()
            },(err,updateResult) => {
                result.token = token;
                done(null,result)
            })

        }
    ],
    (err,result) => {
        callBack(err,result);
    });

};

module["exports"] = UpdateToken;