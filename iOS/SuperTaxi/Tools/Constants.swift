//
//  Constants.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 13/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import UIKit

struct Api {
    static let SERVER_BASE_URL = "http://107.170.147.230/api/v1/"
    static let IMAGE_URL = "http://107.170.147.230/uploads/"
    static let SALT = "8zgqvU6LaziThJI1uz3PevYd"
    static let USER_SIGNIN_URL = "signin"
    static let USER_SIGNUP_URL = "signup"
    static let USER_UPDATE_PROFILE_URL = "profile/update"
    static let PROFILE_DETAIL = "profile/detail"
    static let FORGOT_PASSWORD = "sendForgetPasswordEmail"
    static let CHANGE_PASSWORD = "changePassword"
    static let CANCEL_THE_RIDE = "cancelRequest"
    static let TEST = "test"
    
    static let ORDER_CALL = "order/call"
    static let CANCEL_ORDER = "order/cancel"
    static let GET_OPEN_ORDER = "order/getOpenOrder"
    static let ACCEPT_ORDER = "order/accept"
    static let ORDER_STATUS = "order/status"
    static let NEAREST_DRIVER = "profile/getNearestDriver"
    
    static let ARRIVE_TIME = "order/arrive"
    static let FINISH_TIME = "order/finish"
    static let START_TIME = "order/start"
    
    static let UPDATE_COORDINATES = "profile/updateCoordinates"
    
    static let RATE_PROFILE = "profile/rate"
    
    static let DRIVERS = "profile/getDriverList"
    
}

// User information
struct UserDetails {
    
    static let IS_LOGGED_IN = "isLoggedIn"
    static let IS_PROFILE_SET = "isProfileSet"
    static let REMEMBER_ME = "rememberMe"
    
    static let TOKEN = "token"
    static let EMAIL = "email"
    static let _ID = "_id"
    
    static let NAME = "name"
    static let TYPE = "type"
    static let TEL_NUM = "telNum"
    static let AGE = "age"
    static let NOTE = "note"
    static let CAR_TYPE = "carType"
    static let CAR_REGISTRATION = "carRegistration"
    static let FEE_START = "feeStart"
    static let FEE_KM = "feeKm"
    static let THUMBNAIL = "thumbnail"
    static let AVATAR = "avatar"
    
}

struct Colors {
    
    static func darkBlue(alpha:CGFloat) -> UIColor {
        return UIColor.init(red: 26/255, green: 53/255, blue: 58/255, alpha: alpha)
    }
    
    static func greyBorder(alpha:CGFloat) -> UIColor {
        return UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: alpha)
    }
    
    static func progressFill(alpha:CGFloat) -> UIColor {
        return UIColor.init(red: 14.0/255, green: 155.0/255, blue: 123.0/255, alpha: alpha)
    }
    
    static func darkTransparent(alpha:CGFloat) -> UIColor {
        return UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: alpha)
    }
    
    static func greenTransparent(alpha:CGFloat) -> UIColor {
        return UIColor.init(red: 53/255, green: 222/255, blue: 59/255, alpha: alpha)
    }
    
}





