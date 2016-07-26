//
//  CreatingUserProfileViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreatingUserProfileViewController: UIViewController, UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate, UIApplicationDelegate, UITextFieldDelegate,
                        SetUserDetailsDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var imgUpload: UIImageView!
    let picker = UIImagePickerController()
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var imageData: NSData!
    var mime: String!
    
    var goNext = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        imgUserPhoto.clipsToBounds = true
        
        btnSave.enabled = false
        btnSave.alpha = 0.4
        txtName.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtAge.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtNote.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        
        txtName.delegate = self
        txtAge.delegate = self
        txtNote.delegate = self
        
        apiManager = ApiManager()
        apiManager.setUserDetailsDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField Delegate
    func textFieldDidChange(textField: UITextField ) {
        if (!(txtName.text?.isEmpty)! && !(txtAge.text?.isEmpty)! && !(txtNote.text?.isEmpty)!) {
            btnSave.enabled = true
            btnSave.alpha = 1.0
        }
    }
    
    // MARK: - UIAction Methods
    @IBAction func onCancelClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onUploadAvatarClick(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        imgUpload.hidden = true
    }
    
    @IBAction func onSave(sender: AnyObject) {
        
        let age:Int? = Int(txtAge.text!)
        
        if txtName.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if txtAge.text == ""  {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Age", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if age > 150  {
            let alert = UIAlertController(title: "Alert", message: "Age can't be bigger than 150", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            goNext = true
        }
        
        if txtNote.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Note", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if (imgUserPhoto.image == nil) {
            let alert = UIAlertController(title: "Alert", message: "Please upload your avatar photo", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            goNext = false
        } else {
            goNext = true
        }
    
        if (goNext) {
            apiManager.setUserDetails(userInformation.objectForKey(UserDetails.TOKEN) as! String, name: txtName.text!, type: "1", telNum: txtPhoneNumber.text!, age: txtAge.text!, note: txtNote.text!, car_type: "Taxi", car_registration: "KR-1234-ZG", fee_start: "10", fee_km: "10", fileData: imageData, fileName: "file", mime: mime)
        }
        
        
    }
    
    // MARK: - UIAction Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgUserPhoto.image = choosenImage
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        mime = imageURL.pathExtension
        imageData = UIImagePNGRepresentation(choosenImage)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onSetUserDetailsSuccess(json: JSON) {
        self.performSegueWithIdentifier("SetUSerDetailsSegue", sender: nil)
        print(json)
        
        userInformation.setValue(json["data"]["user"]["avatar"]["thumbfileid"].string, forKey: UserDetails.THUMBNAIL)
        userInformation.setValue(json["data"]["user"]["avatar"]["fileid"].string, forKey: UserDetails.AVATAR)
    }
    
    func onSetUserDetailsError(error: NSInteger) {
        print(error)
    }
    
    func showPRogress(totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 30, 40.0, 40.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating()
    }
    
}
