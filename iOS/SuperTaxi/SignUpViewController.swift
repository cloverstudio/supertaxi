//
//  SignUpViewController.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 14/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

open class SignUpViewController: UIViewController, SignUpApiDelegate {

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    var apiManager: ApiManager!
    
    let userInformation = UserDefaults.standard
    let progressHUD = ProgressHUD(text: "")
    
    open override func viewDidLoad() {
        
        apiManager = ApiManager()
        apiManager.signUpDelegate = self
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
        
    }
    
    open override func didReceiveMemoryWarning() {
        
    }

    @IBAction func OnSignUp(_ sender: AnyObject) {
        
        if txtEmail.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Email Address", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if txtPassword.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            apiManager.getTimeForSecret(2)
            progressHUD.show()
        }
    }
    
    func onSignUpTimeSuccess(_ secret: String) {
        print(secret)
        let parameters : NSDictionary = ["email" : txtEmail.text!,
                                         "password" : Tools().sha1(txtPassword.text! + Api.SALT),
                                         "secret": secret]
        
        apiManager.signUp(parameters)
    }
    
    func onSignUpSuccess(_ data: UserLoginModel) {
        
        self.performSegue(withIdentifier: "ChooseProfileSegue", sender: nil)
        userInformation.setValue(data.data.token_new, forKey: UserDetails.TOKEN)
        userInformation.setValue(data.data.user.email, forKey: UserDetails.EMAIL)
        userInformation.setValue(data.data.user._id, forKey: UserDetails._ID)
    }
    
    func onSignUpError(_ errorCode: NSInteger){
        
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(errorCode), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        progressHUD.hide()
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}
