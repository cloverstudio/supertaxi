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
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion
import Google

class LoginViewController: UIViewController, LoginApiDelegate, SignUpApiDelegate, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet var switchRememberMe: UISwitch!
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    var dict : NSDictionary!
    
    var apiManager: ApiManager!
    
    var loginType = 1
    var fbEmail: String!
    var fbId: String!
    
    let userInformation = UserDefaults.standard
    
    let progressHUD = ProgressHUD(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        apiManager = ApiManager()
        apiManager.loginDelegate = self
        apiManager.signUpDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onSigninClick(_ sender: UIButton) {
        if txtEmail.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Email Address", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if txtPassword.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            apiManager.getTimeForSecret(1)
            progressHUD.show()
        }
    }
    
    func onLoginTimeSuccess(_ secret: String) {
        
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
    
    func onLoginSuccess(_ data: UserLoginModel) {
        
        if data.data.user.user != nil {
            self.performSegue(withIdentifier: "SignInSeague", sender: nil)
            userInformation.setValue(data.data.user.user.name, forKey: UserDetails.NAME)
            userInformation.setValue(data.data.user.user.age, forKey: UserDetails.AGE)
            userInformation.setValue(data.data.user.user.note, forKey: UserDetails.NOTE)
            userInformation.setValue(data.data.user.avatar["thumbfileid"].string!, forKey: UserDetails.THUMBNAIL)
            userInformation.setValue(data.data.user.avatar["fileid"].string!, forKey: UserDetails.THUMBNAIL)
            userInformation.setValue("1", forKey: UserDetails.TYPE)

        } else {
            if data.data.user.driver != nil {
                userInformation.setValue(data.data.user.driver.name, forKey: UserDetails.NAME)
                userInformation.setValue(data.data.user.driver.car_registration, forKey: UserDetails.CAR_REGISTRATION)
                userInformation.setValue(data.data.user.driver.car_type, forKey: UserDetails.CAR_TYPE)
                userInformation.setValue(data.data.user.driver.fee_km, forKey: UserDetails.FEE_KM)
                userInformation.setValue(data.data.user.driver.fee_start, forKey: UserDetails.FEE_START)
            }
            
            if data.data.user.avatar != nil {
                userInformation.setValue(data.data.user.avatar["thumbfileid"].string!, forKey: UserDetails.THUMBNAIL)
                userInformation.setValue(data.data.user.avatar["fileid"].string!, forKey: UserDetails.AVATAR)
            }
            
            userInformation.setValue("2", forKey: UserDetails.TYPE)
            self.performSegue(withIdentifier: "DriverSigInSegue", sender: nil)
        }
        
        userInformation.setValue(data.data.user.telNum, forKey: UserDetails.TEL_NUM)
        userInformation.setValue(data.data.token_new, forKey: UserDetails.TOKEN)
        userInformation.setValue(data.data.user.email, forKey: UserDetails.EMAIL)
        userInformation.setValue(data.data.user._id, forKey: UserDetails._ID)
        
        if (switchRememberMe.isOn) {
            userInformation.set(true, forKey: UserDetails.REMEMBER_ME)
        }
        
        userInformation.set(true, forKey: UserDetails.IS_LOGGED_IN)
    }
    
    func onLoginError(_ errocCode: NSInteger){
        
        if (loginType == 1) {
            
            let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(errocCode), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            apiManager.getTimeForSecret(2)
        }
        
        progressHUD.hide()
    }
    
    // Background Sign Up
    
    func onSignUpTimeSuccess(_ secret: String) {
        let parameters : NSDictionary = ["email" : fbEmail,
                                         "password" : Tools().sha1(fbId + Api.SALT),
                                         "secret": secret]
        
        apiManager.signUp(parameters)
        
        self.loginType = 1
    }
    
    func onSignUpSuccess(_ data: UserLoginModel) {
        
        self.performSegue(withIdentifier: "SocialSignUpSegue", sender: nil)
        userInformation.setValue(data.data.token_new, forKey: UserDetails.TOKEN)
        userInformation.setValue(data.data.user.email, forKey: UserDetails.EMAIL)
        userInformation.setValue(data.data.user._id, forKey: UserDetails._ID)
        
        self.loginType = 1
        
        if (switchRememberMe.isOn) {
            userInformation.set(true, forKey: UserDetails.REMEMBER_ME)
        }
    }
    
    func onSignUpError(_ errorCode: NSInteger){
        
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(errorCode), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.loginType = 1
        
        progressHUD.hide()
    }
    
    @IBAction func onForgotPasswordClick(_ sender: AnyObject) {
    }
    
    // MARK: Facebook Login
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
        progressHUD.show()
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            let fbloginresult : FBSDKLoginManagerLoginResult = result!
            
            if fbloginresult.isCancelled {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                if error == nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
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
    @IBAction func btnTwitterLoginPressed(_ sender: AnyObject) {
        
    }

    // MARK: Google+ Login
    
    @IBAction func gSignIn(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
        self.loginType = 2
        progressHUD.show()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
                present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                withError error: Error!) {
        if (error == nil) {
            
            let userId = user.userID
            let email = user.profile.email
        
            fbEmail = email
            txtEmail.text = email
                
            fbId = userId
            txtPassword.text = userId
                
            self.apiManager.getTimeForSecret(1)
            
        } else {
            print("\(error.localizedDescription)")
        }
        
        progressHUD.hide()
    }
    
    private func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
        progressHUD.hide()
    }
}
