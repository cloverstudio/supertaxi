//
//  LoginViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController, GIDSignInUIDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIAction Methods
    @IBAction func onSigninClick(sender: UIButton) {
        if txtEmail.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Email Address", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if txtPassword.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let signinurl : String = SERVER_BASE_URL + USER_SIGNIN_URL
        let parameters : NSDictionary = ["email" : txtEmail.text!,
                                         "password" : txtPassword.text!]
//        ServerCommunication.sharedManager().basicURL(signinurl, dict: parameters as [NSObject : AnyObject], imagedata: nil, success:  <#T##((AnyObject!) -> Void)!##((AnyObject!) -> Void)!##(AnyObject!) -> Void#>, failure: <#T##((NSError!) -> Void)!##((NSError!) -> Void)!##(NSError!) -> Void#>)
//        NSString *owner_loginurl = [NSString stringWithFormat:@"%@%@", SERVER_BASE_URL, USER_LOGIN_URL];
//        NSDictionary *parameters = @{@"email": emailTextfield.text,
//            @"password": passwordTextField.text};
//
//        [[ServerCommunication sharedManager] basicURL:owner_loginurl dict:parameters imagedata:nil success:^(id _responseObject) {
//            NSError *error = nil;
//            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:_responseObject
//            options:kNilOptions
//            error:&error];
//            NSLog(@"%@", json);
//            if([[json objectForKey:@"error"] integerValue] == 0)
//            {
//            // Get credential informations
//            NSString *client_id;
//            NSString *first_name;
//            NSString *last_name;
//            NSString *phone_number;
//            NSString *username;
//            
//            client_id = [[json objectForKey:@"client"] objectForKey:@"id"];
//            first_name = [[json objectForKey:@"client"] objectForKey:@"first_name"];
//            last_name = [[json objectForKey:@"client"] objectForKey:@"last_name"];
//            phone_number = [[json objectForKey:@"client"] objectForKey:@"phone"];
//            
//            // Get full name = first name + last name
//            username = [NSString stringWithFormat:@"%@ %@", first_name, last_name];
//            
//            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//            delegate.nameLoggedin = username;
//            delegate.mobileNumLoggedin = phone_number;
//            
//            // Go to Home Screen
//            HomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
//            [self.navigationController pushViewController:homeVC animated:YES];
//            }else{
//            [self alertViewShowWithMessage:@"Invalid Credentials"];
//            }
//            } failure:^(NSError *_error) {
//            [self alertViewShowWithMessage:@"Network Error"];
//            }];
    }
    
    @IBAction func onForgotPasswordClick(sender: AnyObject) {
    }
    
    // MARK: - Social Login Methods
    // MARK: FB login
    @IBAction func btnFBLoginPressed(sender: AnyObject) {
        
//        SVProgressHUD.showWithStatus(NSLocalizedString("Login...", comment: ""))
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: { (result, error) -> Void in
            if (error == nil){
//                SVProgressHUD.dismiss();
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email")){
                    self.getFBUserData()
                    self.performSegueWithIdentifier("select_segue_identifier", sender: self)
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                }
            })
        }
    }
    
    // MARK: Twitter Login
    @IBAction func btnTwitterLoginPressed(sender: AnyObject) {
        
        Twitter.sharedInstance().startWithConsumerKey("49ed1a7380e5df875c8892fe84398629465e5d8c", consumerSecret: "NHymzsK5dRKNTyBoAHht7AzxXN2fgsQgIEZWkqODLogJ7KWibl")
        
        Twitter.sharedInstance().logInWithCompletion {
            (session, error) -> Void in
            if (session != nil) {
                
                self.performSegueWithIdentifier("select_segue_identifier", sender: self)
                
                print("signed in as \(session!.userName)");
                print("signed in as \(session!.userID)");
                print("signed in as \(session!.authToken)");
                print("signed in as \(session!.authTokenSecret)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    
//    let client = TWTRAPIClient.clientWithCurrentUser()
//    let request = client.URLRequestWithMethod("GET",
//                                              URL: "https://api.twitter.com/1.1/account/verify_credentials.json",
//                                              parameters: ["include_email": "true", "skip_status": "true"],
//                                              error: nil)
//    
//    client.sendTwitterRequest(req) { response, data, connectionError in }
    
    // MARK: Google+ Login
    @IBAction func btnGoogleLoginPressed(sender: AnyObject) {
//        func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                    withError error: NSError!) {
//            if (error == nil) {
//                
//                self.performSegueWithIdentifier("select_segue_identifier", sender: self)
//                
//                print("signed in as \(user.userID)");
//                print("signed in as \(user.authentication.idToken)");
//                print("signed in as \(user.profile.name)");
//                print("signed in as \(user.profile.givenName)");
//                print("signed in as \(user.profile.familyName)");
//                print("signed in as \(user.profile.email)");
//            } else {
//                print("\(error.localizedDescription)")
//            }
//        }
    }
    
//    func signIn(signIn: GIDSignIn!,
//                presentViewController viewController: UIViewController!) {
//        self.presentViewController(viewController, animated: true, completion: nil)
//    }
//
//    func signIn(signIn: GIDSignIn!,
//                dismissViewController viewController: UIViewController!) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
}
