var async = require('async');

var UserModel = require('../Models/User');

var UpdateStatus = (userId, status, callBack) => {
    
    var userModel = UserModel.get();

    async.waterfall([

        (done) => {

            // update driver status
            userModel.update({ _id: userId }, { $set: { "driver.status": status } }, (err, updateResult) => {

                done(err);

            });

        }
    ],
    (err) => {
        callBack(err);
    });

};

module["exports"] = UpdateStatus;