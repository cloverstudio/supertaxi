    var Const = {};

    Const.responsecodeSucceed = 1;
    Const.responsecodeUnknownError = 6000000;
    Const.responsecodeParamErrorNoEmail = 6000001;
    Const.responsecodeParamErrorNoPassword = 6000002;
    Const.responsecodeParamErrorNoSecret = 6000003;
    Const.responsecodeParamErrorWrongEmail = 6000004;
    Const.responsecodeParamErrorWrongPassword = 6000005;
    Const.responsecodeParamErrorEmailExists = 6000006;
    Const.responsecodeParamErrorWrongSecret = 6000007;
    Const.responsecodeSignInError = 6000008;
    Const.responsecodeTokenInvalid = 6000009;
    Const.responsecodeParamErrorNoName = 6000010;
    Const.responsecodeParamErrorWrongType = 6000011;
    Const.responsecodeParamErrorWrongImageType = 6000012;
    Const.responsecodeParamErrorFeeStart = 6000013;
    Const.responsecodeParamErrorFeeKm = 6000014;
    Const.responsecodeParamErrorAge = 6000015;
    Const.responsecodeParamErrorWrongTelNum = 6000016;
    Const.responsecodeParamErrorLatitudeFrom = 6000017;
    Const.responsecodeParamErrorLongitudeFrom = 6000018;
    Const.responsecodeParamErrorNoAddressFrom = 6000019;
    Const.responsecodeParamErrorLatitudeTo = 6000020;
    Const.responsecodeParamErrorLongitudeTo = 6000021;
    Const.responsecodeParamErrorNoAddressTo = 6000022;
    Const.responsecodeParamErrorCrewNumber = 6000023;
    Const.responsecodeParamErrorLatitude = 6000024;
    Const.responsecodeParamErrorLongitude = 6000025;
    Const.responsecodeParamErrorInvalidId = 6000026;
    Const.responsecodeParamErrorOrderAlreadyAcceptedOrCanceled = 6000027;
    Const.responsecodeParamErrorDriverAlreadyArrivedOrOrderIsCanceled = 6000028;
    Const.responsecodeParamErrorDriverAlreadyStartedDriveOrOrderIsCanceled = 6000029;
    Const.responsecodeParamErrorDriverAlreadyFinishedDrive = 6000030;
    Const.responsecodeParamErrorRateNumber = 6000031;
    Const.responsecodeParamErrorUserNotFound = 6000032;
    Const.responsecodeParamErrorDriverNotFound = 6000033;
    Const.responsecodeParamErrorOrderNotFound = 6000034;

    Const.httpCodeSucceed = 200;
    Const.httpCodeForbidden = 403;
    Const.httpCodeFileNotFound = 404;
    Const.httpCodeServerError = 500;

    Const.sessionkey = "supertaxisession";
    Const.sessionsalt = "8zgqvU6LaziThJI1uz3PevYd";

    Const.REUsername = /^[0-9A-Za-z._+-]{6,}$/;
    Const.REPassword = /^[0-9A-Za-z._+-]{6,}$/;
    Const.RENumbers = /^[0-9]*$/;

    Const.userTypeNormal = 1; // user
    Const.userTypeDriver = 2; // driver

    Const.userRate = {
        min: 1,
        max: 5
    };

    Const.tokenValidInteval = 60*60*24*1000;

    Const.thumbSize = 256;

    Const.orderStatus = {
        accepted: 1,
        canceled: 2,
        pending: 3,
        arrivedToStartLocation: 4,
        startedDrive: 5,
        finishedDrive: 6
    };

    Const.driverStatus = {
        available: 1,
        busy: 2
    };

    module["exports"] = Const;