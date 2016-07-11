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

    Const.httpCodeSucceed = 200;
    Const.httpCodeForbidden = 403;
    Const.httpCodeFileNotFound = 404;
    Const.httpCodeServerError = 500;

    Const.sessionkey = "supertaxisession";
    Const.sessionsalt = "8zgqvU6LaziThJI1uz3PevYd";

    Const.REUsername = /^[0-9A-Za-z._+-]{6,}$/;
    Const.REPassword = /^[0-9A-Za-z._+-]{6,}$/;
    Const.RENumbers = /^[0-9]*$/;

    Const.userTypeNormal = 'user';
    Const.userTypeDriver = 'driver';

    Const.tokenValidInteval = 60*60*24*1000;

    Const.thumbSize = 256;

    module["exports"] = Const;