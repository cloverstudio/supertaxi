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
    func onLoginTimeSuccess(_ secret: String)
    func onLoginSuccess(_ data: UserLoginModel)
    func onLoginError(_ errocCode: NSInteger)
}

protocol SignUpApiDelegate {
    func onSignUpTimeSuccess(_ secret: String)
    func onSignUpSuccess(_ data: UserLoginModel)
    func onSignUpError(_ errorCode: NSInteger)
}

protocol SetUserDetailsDelegate {
    func onSetUserDetailsSuccess(_ json: JSON)
    func onSetUserDetailsError(_ error: NSInteger)
    func showPRogress(_ totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
}

protocol CallOrderDelegate {
    func onCallOrdered(_ id: String)
    func onCallOrderError(_ error: NSInteger)
}

protocol DriverListDelegate {

    func onDriversListSucess(_ json: JSON)
    func onDriversListError(_ error: NSInteger)
}

protocol GetOpenOrdersDelegate {
    
    func onOpenOrderSuccess(_ json: JSON)
    func onOpenOrderNoOrders()
    func onOpenOrderError(_ error: NSInteger)
}

protocol AcceptOrderDelegate {
    func onAcceptORderSuccess()
    func onAcceptOrderError(_ error: NSInteger)
}

protocol OrderStatusDelegate {
    
    func onOrderStatusSuccess(_ json: JSON)
    func onOrderStatusCanceled(_ json: JSON)
    func onOrderStatusNoDrivers()
    func onOrderStatusError(_ error: NSInteger)
    func onOrderSrarusStartedDrive(_ json: JSON)
    func onOrderStatusDriveEnded(_ json: JSON)
}

protocol RateDelegate {
    func onRateSuccess()
    func onRateError()
}

protocol ProfileDelegate {
    func onProfileDetailsSuccess(_ json: JSON)
}

protocol NearestDriverDelegate {
    func onNearestDriverSuccess(_ latitude: Double, longitude: Double)
}

open class ApiManager {
    
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

    func getTimeForSecret(_ type: NSInteger) {
        
        let url : String = Api.SERVER_BASE_URL + Api.TEST
        
        Alamofire.request(url).responseObject { (response: DataResponse<BaseModel>) in
            
            let baseModel = response.result.value
            var time = baseModel?.time
            time = time! / 10000
            let timePlusSalt = Api.SALT + (time?.description)!
            let shaSecret = Tools().sha1(timePlusSalt)
            
            if(type == 1){
                self.loginDelegate.onLoginTimeSuccess(shaSecret)
            } else{
                self.signUpDelegate.onSignUpTimeSuccess(shaSecret)
            }
        }
        
    }
    
    func signin(_ parameters : NSDictionary){
        
        let signinurl : String = Api.SERVER_BASE_URL + Api.USER_SIGNIN_URL
    
        Alamofire.request(signinurl, method: .post, parameters: parameters as? [String : AnyObject])
            .responseObject {
                (response: DataResponse<UserLoginModel>) in
                
                let userLogin: UserLoginModel = response.result.value!
                
                if(userLogin.data != nil){
                    self.loginDelegate.onLoginSuccess(response.result.value!)
                } else {
                    self.loginDelegate.onLoginError((response.result.value?.code)!)
                }
        }
    }
    
    func signUp(_ parameters : NSDictionary){
        let signupurl : String = Api.SERVER_BASE_URL + Api.USER_SIGNUP_URL
        
        Alamofire.request(signupurl, method: .post, parameters: parameters as? [String : AnyObject])
            .responseObject {
                (response: DataResponse<UserLoginModel>) in
                
                let userLogin: UserLoginModel = response.result.value!
                
                if(userLogin.data != nil){
                    self.signUpDelegate.onSignUpSuccess(response.result.value!)
                } else {
                    self.signUpDelegate.onSignUpError((response.result.value?.code)!)
                }
                
        }
    }
    
    func setUserDetails(_ token: String, name: String, type: String, telNum: String, age: String, note: String,car_type: String,
                        car_registration: String, fee_start: String, fee_km: String, fileData: Data, fileName: String, mime: String){
        
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
    
        
       
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileData, withName: "file", fileName: fileName, mimeType: "image/" + mimeType)
                multipartFormData.append(name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"name")
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"type")
                multipartFormData.append(telNum.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"telNum")
                multipartFormData.append(age.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"age")
                multipartFormData.append(note.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"note")
                multipartFormData.append(car_type.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"car_type")
                multipartFormData.append(car_registration.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"car_registration")
                multipartFormData.append(fee_start.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"fee_start")
                multipartFormData.append(fee_km.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"fee_km")        },
            to: url, headers: headers, 
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress { progress in
                        DispatchQueue.main.async(execute: {

                            self.setUserDetailsDelegate.showPRogress(progress.completedUnitCount, totalBytesExpectedToWrite: progress.totalUnitCount)
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
                    
                    
                case .failure( _):
                    self.setUserDetailsDelegate.onSetUserDetailsError(1000)
                }
            }
        )
    }
    
    
    func orderTaxi(_ token: String, latFrom: Double, lonFrom: Double, addressFrom: String, latTo: Double, lonTo: Double, addressTo: String, crewNum: NSInteger){
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
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseObject {
                (response: DataResponse<OrderResponseModel>) in
                let order: OrderResponseModel = response.result.value!
            
                if (order.data["order"]["_id"] != JSON.null) {
                    self.callOrderDelegate.onCallOrdered(order.data["order"]["_id"].string!)
                } else {
                    self.callOrderDelegate.onCallOrderError((response.result.value?.code)!)
                }

            }
        }
    
    func cancelOrder(_ token: String, id: String, type: NSInteger, reason: String){
        
    /* TODO: cancel order
         
        let url : String = Api.SERVER_BASE_URL + Api.CANCEL_ORDER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": id,
            "type": type,
            "reason": reason]
        
        
        Alamofire.request(.POST, url, headers: headers, parameters: parameters as? [String : AnyObject])
            .responseJSON { response in
                            
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
        }
        */
    }
    
    func getDriverList(_ token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.DRIVERS
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                    self.driversListDelegate.onDriversListSucess(json["data"]["drivers"])
                } else {
                    self.driversListDelegate.onDriversListError(((response.result.value as AnyObject).code)!)
                }
        }
    }

    func getOpenOrder(_ token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.GET_OPEN_ORDER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                
                    if (json["data"]["order"].exists()){
                        self.openOrderDelegate.onOpenOrderSuccess(json)
                    } else {
                        self.openOrderDelegate.onOpenOrderNoOrders()
                    }
                } else {
                    self.openOrderDelegate.onOpenOrderError(((response.result.value as AnyObject).code)!)
                }
        }
        
    }
    
    func acceptOrder(_ token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.ACCEPT_ORDER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    self.acceptOrderDelegate.onAcceptORderSuccess()
                } else {
                    self.acceptOrderDelegate.onAcceptOrderError(((response.result.value as AnyObject).code)!)
                }
        }
        
    }
    
    func getOrderStatus(_ token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.ORDER_STATUS
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                
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
                } else {
                    self.orderStatusDelegate.onOrderStatusError(((response.result.value as AnyObject).code)!)
                }
        }
        
    }
    
    func updateCoordinates(_ token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.UPDATE_COORDINATES
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    print("Coordinates updated!")
                }
        }
        
    }
    
    func updateArriveTime(_ token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.ARRIVE_TIME
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON ARRIVE TIME: \(JSON)")
                }
        }
        
    }
    
    func updateFinishTime(_ token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.FINISH_TIME
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON FINISH TIME: \(JSON)")
                }
        }
        
    }
    
    func updateStartTime(_ token: String, orderId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.START_TIME
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "orderId": orderId]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON START TIME: \(JSON)")
                }
        }
        
    }
    
    func rateProfile(_ token: String, id: String, type: NSInteger, rate: NSInteger){
        
        let url : String = Api.SERVER_BASE_URL + Api.RATE_PROFILE
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
        "id": id,
        "type": type,
        "rate": rate]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
        .responseJSON { response in
            
            if response.result.value != nil {
                
                let json = JSON(response.result.value!)
                
                if(json["code"].number == 1){
                    self.rateDelegate.onRateSuccess()
                } else {
                    self.rateDelegate.onRateError()
                }
            }
        }
        
    }
    
    func getProfileDetail(_ token: String, userId: String){
        
        let url : String = Api.SERVER_BASE_URL + Api.PROFILE_DETAIL
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "userId": userId]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject],  headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                    self.profileDelegate.onProfileDetailsSuccess(json)
                }
        }
        
    }
    
    func getNearestDriver(_ token: String, lat: Double, lon: Double){
        
        let url : String = Api.SERVER_BASE_URL + Api.NEAREST_DRIVER
        
        let headers = ["access-token": token]
        
        let parameters: NSDictionary = [
            "lat": lat,
            "lon": lon]
        
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], headers: headers)
            .responseJSON { response in
                
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                    self.nearestDriverDelegate.onNearestDriverSuccess(json["data"]["driver"]["currentLocation"][1].double!, longitude: json["data"]["driver"]["currentLocation"][0].double!)
                }
        }
        
    }

}















































