//
//  CreatingUserProfileViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import SwiftyJSON
import AssetsLibrary
import ImageLoader

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
    
    var imageData: NSData! = nil
    var mime: String!
    
    var goNext = false
    var isNameOk = false
    var isAgeOk = false
    var isNoteOK = false
    var isPhoneNumOK = false
    
    var isEditingProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        imgUserPhoto.clipsToBounds = true
        
        if !isEditingProfile{
            btnSave.enabled = false
            btnSave.alpha = 0.4
        }
        
        txtName.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtAge.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtNote.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        
        txtName.delegate = self
        txtAge.delegate = self
        txtNote.delegate = self
        
        apiManager = ApiManager()
        apiManager.setUserDetailsDelegate = self
        
        let status:ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        
        if status != ALAuthorizationStatus.Authorized{
            print("User has not given authorization for the camera roll")
        }
        
        if isEditingProfile {
            txtName.text = userInformation.stringForKey(UserDetails.NAME)
            txtAge.text = userInformation.stringForKey(UserDetails.AGE)
            txtNote.text = userInformation.stringForKey(UserDetails.NOTE)
            txtPhoneNumber.text = userInformation.stringForKey(UserDetails.TEL_NUM)
            
            if (userInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
                imgUserPhoto.load(Api.IMAGE_URL + userInformation.stringForKey(UserDetails.THUMBNAIL)!)
            }
            
            imageData = NSData()
            mime = ""
        }
        
        
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
        if isEditingProfile {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
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
        } else {
            isNameOk = true
        }
        
        if txtAge.text == ""  {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Age", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
        } else {
            isAgeOk = true
        }
        
        if age > 100  {
            let alert = UIAlertController(title: "Alert", message: "Age can't be bigger than 150", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            isAgeOk = false
        } else {
            isAgeOk = true
        }
        
        if txtNote.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Note", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
        } else {
            isNoteOK = true
        }
        
        if (imgUserPhoto.image == nil) {
            let alert = UIAlertController(title: "Alert", message: "Please upload your avatar photo", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            goNext = true
        }
        
        if txtPhoneNumber.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your phone number!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
        } else {
            isPhoneNumOK = true
        }
    
        if (goNext) {
            apiManager.setUserDetails(userInformation.objectForKey(UserDetails.TOKEN) as! String, name: txtName.text!, type: "1", telNum: txtPhoneNumber.text!, age: txtAge.text!, note: txtNote.text!, car_type: "", car_registration: "", fee_start: "", fee_km: "", fileData: imageData, fileName: "file", mime: mime)
            
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
            
            alert.view.tintColor = UIColor.blackColor()
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            presentViewController(alert, animated: true, completion: nil)
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
        
        if isEditingProfile{
            self.dismissViewControllerAnimated(true, completion: nil)
            btnSave.enabled = true
            btnSave.alpha = 1
        } else {
            userInformation.setValue(json["data"]["user"]["telNum"].string, forKey: UserDetails.TEL_NUM)
            userInformation.setValue(json["data"]["user"]["user"]["name"].string, forKey: UserDetails.NAME)
            userInformation.setValue(json["data"]["user"]["user"]["age"].number, forKey: UserDetails.AGE)
            userInformation.setValue(json["data"]["user"]["user"]["note"].string, forKey: UserDetails.NOTE)
            userInformation.setValue(json["data"]["user"]["avatar"]["thumbfileid"].string, forKey: UserDetails.THUMBNAIL)
            userInformation.setValue(json["data"]["user"]["avatar"]["fileid"].string, forKey: UserDetails.AVATAR)
            userInformation.setValue("1", forKey: UserDetails.TYPE)
            self.performSegueWithIdentifier("SetUSerDetailsSegue", sender: nil)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func onSetUserDetailsError(error: NSInteger) {
        dismissViewControllerAnimated(true, completion: nil)
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showPRogress(totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        
    }
}
