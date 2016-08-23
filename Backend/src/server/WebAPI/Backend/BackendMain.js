var express = require('express');
var router = express.Router();
var fs = require('fs')

var bodyParser = require("body-parser");
var _ = require('lodash');

var init = require('../../lib/init.js');

var BackendMain ={

    init: function(app){

        var self = this;
        
        router.use("/test", require("./Controllers/Test/TestController").init(app));
        router.use("/signup", require("./Controllers/Signup/SignupGeneralController").init(app));
        router.use("/signin", require("./Controllers/Signin/SigninGeneralController").init(app));

        router.use("/profile/update", require("./Controllers/Profile/UpdateProfileController").init(app));
        router.use("/profile/updateCoordinates", require("./Controllers/Profile/UpdateCoordinatesProfileController").init(app));
        router.use("/profile/getDriverList", require("./Controllers/Profile/GetDriverListProfileController").init(app));
        router.use("/profile/detail", require("./Controllers/Profile/GetUserDetailProfileController").init(app));
        router.use("/profile/rate", require("./Controllers/Profile/RateProfileController").init(app));
        router.use("/profile/getNearestDriver", require("./Controllers/Profile/GetNearestDriverProfileController").init(app));

        router.use("/order/call", require("./Controllers/Order/CallOrderController").init(app));
        router.use("/order/getOpenOrder", require("./Controllers/Order/GetOpenOrderController").init(app));
        router.use("/order/cancel", require("./Controllers/Order/CancelOrderController").init(app));
        router.use("/order/accept", require("./Controllers/Order/AcceptOrderController").init(app));
        router.use("/order/arrive", require("./Controllers/Order/ArriveOrderController").init(app));
        router.use("/order/start", require("./Controllers/Order/StartTripOrderController").init(app));
        router.use("/order/finish", require("./Controllers/Order/FinishTripOrderController").init(app));
        router.use("/order/status", require("./Controllers/Order/CheckStatusOrderController").init(app));

        return router;

    }

}

module["exports"] = BackendMain;
