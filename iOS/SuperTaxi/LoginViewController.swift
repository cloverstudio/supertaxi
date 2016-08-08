//
//  LoginViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Google

@available(iOS 9.0, *)
class LoginViewController: UIViewController, LoginApiDelegate, SignUpApiDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet var switchRememberMe: UISwitch!
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    var dict : NSDictionary!
    
    var apiManager: ApiManager!
    
    var loginType = 1
    var fbEmail: String!
    var fbId: String!
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiManager = ApiManager()
        apiManager.loginDelegate = self
        apiManager.signUpDelegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onSigninClick(sender: UIButton) {
        if txtEmail.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Email Address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if txtPassword.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        apiManager.getTimeForSecret(1)
    
    
    }
    
    func onLoginTimeSuccess(secret: String) {
        
        var parameters : NSDictionary!
        
        if (loginType == 1) {
            parameters = ["email" : txtEmail.text!,
                                             "password" : Tools().sha1(txtPassword.text! + Api.SALT),
                                             "secret": secret]
//            parameters = ["email" : "driver@clover.com",
//                          "password" : Tools().sha1("driver" + Api.SALT),
//                          "secret": secret]
            
        } else if(loginType == 2){
            parameters = ["email" : self.fbEmail,
                          "password" : Tools().sha1(self.fbId + Api.SALT),
                          "secret": secret]
        }
        
        apiManager.signin(parameters)

    }
    
    func onLoginSuccess(data: UserLoginModel) {
        
        if data.data.user.user != nil {
            self.performSegueWithIdentifier("SignInSeague", sender: nil)
            userInformation.setValue(data.data.user.user.name, forKey: UserDetails.NAME)
            userInformation.setValue(data.data.user.user.age, forKey: UserDetails.AGE)
            userInformation.setValue(data.data.user.user.note, forKey: UserDetails.NOTE)
            userInformation.setValue(data.data.user.avatar["thumbfileid"].string!, forKey: UserDetails.THUMBNAIL)

        } else {
            self.performSegueWithIdentifier("DriverSigInSegue", sender: nil)
            userInformation.setValue(data.data.user.driver.name, forKey: UserDetails.NAME)
            userInformation.setValue(data.data.user.avatar["thumbfileid"].string!, forKey: UserDetails.THUMBNAIL)
    
        }
        
        userInformation.setValue(data.data.token_new, forKey: UserDetails.TOKEN)
        userInformation.setValue(data.data.user.email, forKey: UserDetails.EMAIL)
        userInformation.setValue(data.data.user._id, forKey: UserDetails._ID)
        
        if (switchRememberMe.on) {
            userInformation.setBool(true, forKey: UserDetails.REMEMBER_ME)
        }
    }
    
    func onLoginError(errocCode: NSInteger){
        
        if (loginType == 1) {
            
            let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(errocCode), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            apiManager.getTimeForSecret(2)
        }
    }
    
    // Background Sign Up
    
    func onSignUpTimeSuccess(secret: String) {
        print(secret)
        let parameters : NSDictionary = ["email" : fbEmail,
                                         "password" : Tools().sha1(fbId + Api.SALT),
                                         "secret": secret]
        
        apiManager.signUp(parameters)
        
        self.loginType = 1
    }
    
    func onSignUpSuccess(data: UserLoginModel) {
        
        self.performSegueWithIdentifier("SocialSignUpSegue", sender: nil)
        userInformation.setValue(data.data.token_new, forKey: UserDetails.TOKEN)
        userInformation.setValue(data.data.user.email, forKey: UserDetails.EMAIL)
        userInformation.setValue(data.data.user._id, forKey: UserDetails._ID)
        
        self.loginType = 1
        
        if (switchRememberMe.on) {
            userInformation.setBool(true, forKey: UserDetails.REMEMBER_ME)
        }
    }
    
    func onSignUpError(errorCode: NSInteger){
        
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(errorCode), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        self.loginType = 1
    }
    
    @IBAction func onForgotPasswordClick(sender: AnyObject) {
        
    }
    
    // MARK: Facebook Login
    @IBAction func btnFBLoginPressed(sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    self.loginType = 2
                    
                    self.dict = result as! NSDictionary
                    
                    self.apiManager.getTimeForSecret(1)
                    
                    for (key, value) in self.dict {
                        if(key as! String == "email"){
                            self.fbEmail = value as! String
                            self.txtEmail.text = self.fbEmail
                        }
                        
                        if(key as! String == "id"){
                            self.fbId = value as! String
                            self.txtPassword.text = self.fbId
                        }
                    }
                    
//                    var first_name = self.dict["first_name"]
//                    var last_name = self.dict["last_name"]
                    
        
                    
                }
            })
        }
    }
    
    // MARK: Twitter Login
    @IBAction func btnTwitterLoginPressed(sender: AnyObject) {
        
       
    }

    // MARK: Google+ Login
    @IBAction func btnGoogleLoginPressed(sender: AnyObject) {
       
        
    }

}
