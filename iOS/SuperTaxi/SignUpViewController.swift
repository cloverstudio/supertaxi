//
//  SignUpViewController.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 14/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

public class SignUpViewController: UIViewController, SignUpApiDelegate {

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    var apiManager: ApiManager!
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    
    public override func viewDidLoad() {
        
        apiManager = ApiManager()
        apiManager.signUpDelegate = self
        
    }
    
    public override func didReceiveMemoryWarning() {
        
    }

    @IBAction func OnSignUp(sender: AnyObject) {
        
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
        
        apiManager.getTimeForSecret(2)
        
    }
    
    func onSignUpTimeSuccess(secret: String) {
        print(secret)
        let parameters : NSDictionary = ["email" : txtEmail.text!,
                                         "password" : Tools().sha1(txtPassword.text! + Api.SALT),
                                         "secret": secret]
        
        apiManager.signUp(parameters)
    }
    
    func onSignUpSuccess(data: UserLoginModel) {
        
        self.performSegueWithIdentifier("ChooseProfileSegue", sender: nil)
        userInformation.setValue(data.data.token_new, forKey: UserDetails.TOKEN)
        userInformation.setValue(data.data.user.email, forKey: UserDetails.EMAIL)
        userInformation.setValue(data.data.user._id, forKey: UserDetails._ID)
    }
    
    func onSignUpError(errorCode: NSInteger){
        
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(errorCode), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
