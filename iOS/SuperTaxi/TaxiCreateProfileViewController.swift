//
//  TaxiCreateProfileViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import SwiftyJSON

class TaxiCreateProfileViewController: UIViewController, UINavigationControllerDelegate,
                UIImagePickerControllerDelegate, UIApplicationDelegate, UITextFieldDelegate, SetUserDetailsDelegate {

    @IBOutlet weak var txtTaxiDriverName: UITextField!
    @IBOutlet weak var txtCartype: UITextField!
    @IBOutlet weak var txtCarRegnumber: UITextField!
    @IBOutlet weak var txtStartfee: UITextField!
    @IBOutlet weak var txtFeekm: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet weak var imgTaxiDriverPhoto: UIImageView!
    @IBOutlet weak var imgDriver: UIImageView!
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
        imgTaxiDriverPhoto.layer.masksToBounds = false
        imgTaxiDriverPhoto.clipsToBounds = true
        
        btnSave.enabled = false
        btnSave.alpha = 0.4
        txtTaxiDriverName.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtCartype.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtCarRegnumber.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtStartfee.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtFeekm.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        
        txtTaxiDriverName.delegate = self
        txtCartype.delegate = self
        txtCarRegnumber.delegate = self
        txtStartfee.delegate = self
        txtFeekm.delegate = self
        
        apiManager = ApiManager()
        apiManager.setUserDetailsDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField Delegate
    func textFieldDidChange(textField: UITextField ) {
        if (!(txtTaxiDriverName.text?.isEmpty)! && !(txtCartype.text?.isEmpty)! && !(txtCarRegnumber.text?.isEmpty)! && !(txtStartfee.text?.isEmpty)! && !(txtFeekm.text?.isEmpty)!)  {
            btnSave.enabled = true
            btnSave.alpha = 1.0
        }
    }
    
    // MARK: - UIAction Methods
    @IBAction func onCancelClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onUploadPhotoClick(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        imgDriver.hidden = true
        
    }

    @IBAction func onSaveDetails(sender: AnyObject) {
        
        if txtTaxiDriverName.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if txtCartype.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your car type.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if txtCarRegnumber.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your car register number.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if txtStartfee.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your start fee.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if txtFeekm.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your km fee.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            btnSave.enabled = false
            btnSave.alpha = 0.4
            goNext = false
        } else {
            goNext = true
        }
        
        if (goNext) {
            apiManager.setUserDetails(userInformation.objectForKey(UserDetails.TOKEN) as! String, name: txtTaxiDriverName.text!, type: "2", telNum: txtPhoneNumber.text!, age: "", note: "", car_type: txtCartype.text!, car_registration: txtCarRegnumber.text!, fee_start: txtStartfee.text!, fee_km: txtFeekm.text!, fileData: imageData, fileName: "file", mime: mime)
        }
    }
    
    // MARK: - UIAction Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgTaxiDriverPhoto.image = choosenImage
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        mime = imageURL.pathExtension
        imageData = UIImagePNGRepresentation(choosenImage)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onSetUserDetailsSuccess(json: JSON) {
        print("*****")
        print(json)
        self.performSegueWithIdentifier("SetDriverDetailsSegue", sender: nil)
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
