//
//  ApiManager.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 13/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

protocol LoginApiDelegate {
    func onLoginTimeSuccess(secret: String)
    func onLoginSuccess(data: UserLoginModel)
    func onLoginError(errocCode: NSInteger)
}

protocol SignUpApiDelegate {
    func onSignUpTimeSuccess(secret: String)
    func onSignUpSuccess(data: UserLoginModel)
    func onSignUpError(errorCode: NSInteger)
}

protocol SetUserDetailsDelegate {
    func onSetUserDetailsSuccess(json: JSON)
    func onSetUserDetailsError(error: NSInteger)
    func showPRogress(totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
}

protocol CallOrderDelegate {
    func onCallOrdered(id: String)
    func onCallOrderError(error: NSInteger, crewNumber: NSInteger)
}

protocol DriverListDelegate {

    func onDriversListSucess(json: JSON)
    func onDriversListError(error: NSInteger)
}

protocol GetOpenOrdersDelegate {
    
    func onOpenOrderSuccess(json: JSON)
    func onOpenOrderNoOrders()
    func onOpenOrderError(error: NSInteger)
}

protocol AcceptOrderDelegate {
    func onAcceptORderSuccess()
    func onAcceptOrderError(error: NSInteger)
}

protocol OrderStatusDelegate {
    
    func onOrderStatusSuccess(json: JSON)
    func onOrderStatusCanceled(json: JSON)
    func onOrderStatusNoDrivers()
    func onOrderStatusError(error: NSInteger)
    func onOrderSrarusStartedDrive(json: JSON)
    func onOrderStatusDriveEnded(json: JSON)
}

protocol OrderCancelDelegate {
    func onCancelOrderSuccess()
    func onCancelOrderError(error: NSInteger)
}

protocol RateDelegate {
    func onRateSuccess()
    func onRateError()
}

protocol ProfileDelegate {
    func onProfileDetailsSuccess(json: JSON)
    func onProfileDetailsError(error: NSInteger)
}

protocol NearestDriverDelegate {
    func onNearestDriverSuccess(latitude: Double, longitude: Double)
    func onNearestDriveError(error: NSInteger)
    
}

protocol UpdateTimeDelegate {
    func onStartTimeUpdateSuccess()
    func onStartTimeUpdateError(error: NSInteger)
    func onArriveTimeUpdateSuccess()
    func onArriveTimeUpdateError(error: NSInteger)
    func onFinishTimeUpdateSuccess()
    func onFinishTimeUpdateError(error: NSInteger)
}

protocol UpdateCoordinatesDelegate {
    func onUpdateCoordinatesSuccess()
    func onUpdateCoordinatesError(error: NSInteger)
}


public class ApiManager {
    
    var loginDelegate: LoginApiDelegate!
    var signUpDelegate: SignUpApiDelegate!
    var setUserDetailsDelegate: SetUserDetailsDelegate!
    var callOrderDelegate: CallOrderDelegate!
    var driversListDelegate: DriverListDelegate!
    var openOrderDelegate: GetOpenOrdersDelegate!
    var acceptOrderDelegate: AcceptOrderDelegate!
    var orderStatusDelegate: OrderStatusDelegate!
    var rateDelegate: RateDelegate!
    var profileDelegate: ProfileDelegate!
    var nearestDriverDelegate: NearestDriverDelegate!
    var updateCoordinatesDelegate: UpdateCoordinatesDelegate!
    var updateTimeDelegate: UpdateTimeDelegate!
    var cancelOrderDelegate:OrderCancelDelegate!

    func getTimeForSecret(type: NSInteger) {
        
        let url : String = Api.SERVER_BASE_URL + Api.TEST
        
        Alamofire.request(.GET, url).responseObject {
            (response: Response<BaseModel, NSError>) in
            switch response.result {
            case .Success(let value):
              let baseModel = value
              var time = baseModel.time
              time = time! / 10000
              let timePlusSalt = Api.SALT + (time?.description)!
              let shaSecret = Tools().sha1(timePlusSalt)
            
              if(type == 1){
                  self.loginDelegate.onLoginTimeSuccess(shaSecret)
              } else{
                  self.signUpDelegate.onSignUpTimeSuccess(shaSecret)
              }
            case .Failure(let error):
              if(type == 1){
                    self.loginDelegate.onLoginError(error.code)
              } else{
                    self.signUpDelegate.onSignUpError(error.code)
                }
        }
            
    }
    
    }
    
    func signin(parameters : NSDictionary){
        
        let signinurl : String = Api.SERVER_BASE_URL + Api.USER_SIGNIN_URL
    
        Alamofire.request(.POST, signinurl, parameters: parameters as? [String : AnyObject])
            .responseObject {
                (response: Response<UserLoginModel, NSError>) in
                
                switch response.result {
                case .Success(let value):
                      self.loginDelegate.onLoginSuccess(value)
                case .Failure(let error):
                      self.loginDelegate.onLoginError(error.code)
                  
            }
        }
    }
    
    func signUp(parameters : NSDictionary){
        let signupurl : String = Api.SERVER_BASE_URL + Api.USER_SIGNUP_URL
        
        Alamofire.request(.POST, signupurl, parameters: parameters as? [String : AnyObject])
            .responseObject {
                (response: Response<UserLoginModel, NSError>) in
                
                switch response.result {
                case .Success(let value):
                    self.signUpDelegate.onSignUpSuccess(value)
                case .Failure(let error):
                    self.signUpDelegate.onSignUpError(error.code)
                }
        }
    }
    
    func setUserDetails(token: String, name: String, type: String, telNum: String, age: String, note: String,car_type: String,
                        car_registration: String, fee_start: String, fee_km: String, fileData: NSData, fileName: String, mime: String){
        
        let url = Api.SERVER_BASE_URL + Api.USER_UPDATE_PROFILE_URL
        
        let headers = ["access-token": token]
        
        var mimeType: String = "image/jpeg"
        
        if (mime == "JPG" || mime == "jpg"){
            mimeType = "image/jpeg"
        } else if (mime == "PNG" || mime == "png"){
            mimeType = "image/png"
        } else if (mime == "GIF" || mime == "gif"){
            mimeType = "image/gif"
        }
    
        Alamofire.upload(.POST, url, headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: fileData, name: "file", fileName: fileName, mimeType: "image/" + mimeType)
                multipartFormData.appendBodyPart(data:name.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"name")
                multipartFormData.appendBodyPart(data:type.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"type")
                multipartFormData.appendBodyPart(data:telNum.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"telNum")
                multipartFormData.appendBodyPart(data:age.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"age")
                multipartFormData.appendBodyPart(data:note.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"note")
                multipartFormData.appendBodyPart(data:car_type.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"car_type")
                multipartFormData.appendBodyPart(data:car_registration.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"car_registration")
                multipartFormData.appendBodyPart(data:fee_start.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"fee_start")
                multipartFormData.appendBodyPart(data:fee_km.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"fee_km")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
          
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            self.setUserDetailsDelegate.showPRogress(totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
                            
                        })
                    }
                    
                    
                    upload.responseJSON { response in
                        let json = JSON(response.result.value!)
                        
                        if(json["data"]["user"].exists()){
                            self.setUserDetailsDelegate.onSetUserDetailsSuccess(json)
                        } else {
                            self.setUserDetailsDelegate.onSetUserDetailsError(json["code"].int!)
                        }
                        
                    }
                case .Failure(_):
                    self.setUserDetailsDelegate.onSetUserDetailsError(1000)
                }
            }
        )
    }
    
    
    func orderTaxi(token: String, latFrom: Double, lonFrom: Double, addressFrom: String, latTo: Double, lonTo: Double, addressTo: String, crewNum: NSInteger){
        let url : String = Api.SERVER_BASE_URL + Api.ORDER_CALL
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "latFrom": latFrom,
            "lonFrom": lonFrom,
            "addressFrom": addressFrom,
            "latTo": latTo,
            "lonTo": lonTo,
            "addressTo": addressTo,
            "crewNum": crewNum]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseObject {
                (response: Response<OrderResponseModel, NSError>) in
                
                switch response.result {
                case .Success(let value) :
                    let order: OrderResponseModel = value
                    if (order.data["order"]["_id"] != nil) {
                        self.callOrderDelegate.onCallOrdered(order.data["order"]["_id"].string!)
                    } else {
                        self.callOrderDelegate.onCallOrderError(value.code, crewNumber: crewNum)
                    }
                case .Failure(let error) :
                    self.callOrderDelegate.onCallOrderError(error.code, crewNumber: crewNum)
                    
                }
        }
    }
    
    func cancelOrder(token: String, id: String, type: NSInteger, reason: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.CANCEL_ORDER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": id,
            "type": type,
            "reason": reason]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                            
                switch response.result {
                case .Success(_):
                    self.cancelOrderDelegate.onCancelOrderSuccess()
                case .Failure(let error):
                    self.cancelOrderDelegate.onCancelOrderError(error.code)
                }
        }
        
    }
    
    func getDriverList(token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.DRIVERS
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                
                switch response.result {
                case .Success(let value):
                    let json = JSON(value)
                    self.driversListDelegate.onDriversListSucess(json["data"]["drivers"])
                case .Failure(let error):
                    self.driversListDelegate.onDriversListError(error.code)
                }
        }
    
    }

    func getOpenOrder(token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.GET_OPEN_ORDER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                switch response.result{
                case .Success(let value):
                    let json = JSON(value)
                    if (json["data"]["order"].exists()){
                        self.openOrderDelegate.onOpenOrderSuccess(json)
                    } else {
                        self.openOrderDelegate.onOpenOrderNoOrders()
                    }
                case .Failure(let error) :
                    self.openOrderDelegate.onOpenOrderError(error.code)
                
                }
        }
        
    }
    
    func acceptOrder(token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.ACCEPT_ORDER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(_):
                    self.acceptOrderDelegate.onAcceptORderSuccess()
                case .Failure(let error):
                    self.acceptOrderDelegate.onAcceptOrderError(error.code)
                }
                
        }
        
    }
    
    func getOrderStatus(token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.ORDER_STATUS
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                
                switch response.result{
                    
                case .Success(let value):
                    let json = JSON(value)
                    
                    if (json["data"]["orderStatus"].number == 1){
                        self.orderStatusDelegate.onOrderStatusSuccess(json)
                    } else if(json["data"]["orderStatus"].number == 2){
                        self.orderStatusDelegate.onOrderStatusCanceled(json)
                    } else if(json["data"]["orderStatus"].number == 5) {
                        self.orderStatusDelegate.onOrderSrarusStartedDrive(json)
                    } else if(json["data"]["orderStatus"].number == 6) {
                        self.orderStatusDelegate.onOrderStatusDriveEnded(json)
                    } else {
                        self.orderStatusDelegate.onOrderStatusNoDrivers()
                    }
                case .Failure(let error) :
                    self.orderStatusDelegate.onOrderStatusError(error.code)
                    
                    
                }
        }
        
    }
    
    func updateCoordinates(token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.UPDATE_COORDINATES
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                
                switch response.result  {
                case .Success(_):
                    self.updateCoordinatesDelegate.onUpdateCoordinatesSuccess()
                case .Failure(let error):
                    self.updateCoordinatesDelegate.onUpdateCoordinatesError(error.code)
                }
        }
        
    }
    
    func updateArriveTime(token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.ARRIVE_TIME
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    self.updateTimeDelegate.onArriveTimeUpdateSuccess()
                case .Failure(let error):
                    self.updateTimeDelegate.onArriveTimeUpdateError(error.code)
                }
        }
        
    }
    
    func updateFinishTime(token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.FINISH_TIME
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
               
                switch response.result {
                case .Success(_):
                    self.updateTimeDelegate.onFinishTimeUpdateSuccess()
                case . Failure(let error):
                    self.updateTimeDelegate.onStartTimeUpdateError(error.code)
                }
        }
        
    }
    
    func updateStartTime(token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.START_TIME
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                
                switch response.result {
                case .Success(_):
                    self.updateTimeDelegate.onStartTimeUpdateSuccess()
                case .Failure(let error):
                    self.updateTimeDelegate.onStartTimeUpdateError(error.code)
                }
        }
        
    }
    
    func rateProfile(token: String, id: String, type: NSInteger, rate: NSInteger){
        
        let url : String = Api.SERVER_BASE_URL + Api.RATE_PROFILE
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
        "id": id,
        "type": type,
        "rate": rate]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
        .responseJSON { response in
            
            switch response.result {
                
            case .Success(let value):
                
                let json = JSON(value)
                
                if(json["code"].number == 1){
                    self.rateDelegate.onRateSuccess()
                } else {
                    self.rateDelegate.onRateError()
                }
                
            case .Failure(_):
                self.rateDelegate.onRateError()
            
            }
        }
        
    }
    
    func getProfileDetail(token: String, userId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.PROFILE_DETAIL
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "userId": userId]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                
                switch response.result{
                case .Success(let value):
                    let json = JSON(value)
                    self.profileDelegate.onProfileDetailsSuccess(json)
                case .Failure(let error):
                    self.profileDelegate.onProfileDetailsError(error.code)
                    
                }
        }
        
    }
    
        
    func getNearestDriver(token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.NEAREST_DRIVER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                switch response.result{
                    
                case .Success(let value):
                    let json = JSON(value)
                    self.nearestDriverDelegate.onNearestDriverSuccess(json["data"]["driver"]["currentLocation"][1].double!, longitude: json["data"]["driver"]["currentLocation"][0].double!)
                    
                case .Failure(let error):
                    self.nearestDriverDelegate.onNearestDriveError(error.code)
                    
                }
        
    }

}
}












































