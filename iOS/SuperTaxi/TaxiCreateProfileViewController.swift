//
//  TaxiCreateProfileViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import SwiftyJSON
import AssetsLibrary
import ImageLoader

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
    
    let userInformation = UserDefaults.standard
    var apiManager: ApiManager!
    
    var imageData: Data!
    var mime: String!
    
    var isNameOk = false
    var isCarTypeOk = false
    var isCarRegOk = false
    var isStartFeeOk = false
    var isFeeKnOk = false
    var isPhoneNumberOk = false
    
    var isEditingProfile = false

    let progressHUD = ProgressHUD(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        imgTaxiDriverPhoto.layer.masksToBounds = false
        imgTaxiDriverPhoto.clipsToBounds = true
        
        btnSave.isEnabled = false
        btnSave.alpha = 0.4
        txtTaxiDriverName.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        txtCartype.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        txtCarRegnumber.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        txtStartfee.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        txtFeekm.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        
        txtTaxiDriverName.delegate = self
        txtCartype.delegate = self
        txtCarRegnumber.delegate = self
        txtStartfee.delegate = self
        txtFeekm.delegate = self
        
        apiManager = ApiManager()
        apiManager.setUserDetailsDelegate = self
        
        let status:ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        
        if status != ALAuthorizationStatus.authorized{
            print("User has not given authorization for the camera roll")
        }
        
        if (isEditingProfile){
            txtTaxiDriverName.text = userInformation.string(forKey: UserDetails.NAME)
            txtCartype.text = userInformation.string(forKey: UserDetails.CAR_TYPE)
            txtCarRegnumber.text = userInformation.string(forKey: UserDetails.CAR_REGISTRATION)
            txtFeekm.text = userInformation.string(forKey: UserDetails.FEE_KM)
            txtStartfee.text = userInformation.string(forKey: UserDetails.FEE_START)
            txtPhoneNumber.text = userInformation.string(forKey: UserDetails.TEL_NUM)
            
            if (userInformation.string(forKey: UserDetails.THUMBNAIL) != nil){
                imgTaxiDriverPhoto.load(Api.IMAGE_URL + userInformation.string(forKey: UserDetails.THUMBNAIL)!)
            }
        }
        
        self.view.addSubview(progressHUD)
        progressHUD.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField Delegate
    func textFieldDidChange(_ textField: UITextField ) {
        if (!(txtTaxiDriverName.text?.isEmpty)! && !(txtCartype.text?.isEmpty)! && !(txtCarRegnumber.text?.isEmpty)! && !(txtStartfee.text?.isEmpty)! && !(txtFeekm.text?.isEmpty)!)  {
            btnSave.isEnabled = true
            btnSave.alpha = 1.0
        }
    }
    
    // MARK: - UIAction Methods
    @IBAction func onCancelClick(_ sender: AnyObject) {
        if isEditingProfile {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @IBAction func onUploadPhotoClick(_ sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        imgDriver.isHidden = true
        
    }

    @IBAction func onSaveDetails(_ sender: AnyObject) {
        
        if txtTaxiDriverName.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isNameOk = true
        }
        
        if txtCartype.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your car type.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isCarTypeOk = true
        }
        
        if txtCarRegnumber.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your car register number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isCarRegOk = true
        }
        
        if txtStartfee.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your start fee.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isStartFeeOk = true
        }
        
        if txtFeekm.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your km fee.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isFeeKnOk = true
        }
        
        if txtPhoneNumber.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your phone number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isPhoneNumberOk = true
        }
        
        if imageData == nil {
            let alert = UIAlertController(title: "Alert", message: "Please choose image.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if (isNameOk && isCarTypeOk && isCarRegOk && isStartFeeOk && isFeeKnOk && isPhoneNumberOk && imageData != nil) {
            apiManager.setUserDetails(userInformation.object(forKey: UserDetails.TOKEN) as! String, name: txtTaxiDriverName.text!, type: "2", telNum: txtPhoneNumber.text!, age: "", note: "", car_type: txtCartype.text!, car_registration: txtCarRegnumber.text!, fee_start: txtStartfee.text!, fee_km: txtFeekm.text!, fileData: imageData, fileName: "file", mime: mime)
            
            progressHUD.show()
        }
    }
    
    // MARK: - UIAction Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgTaxiDriverPhoto.image = choosenImage
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! URL
        
        mime = imageURL.pathExtension
        imageData = UIImagePNGRepresentation(choosenImage)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func onSetUserDetailsSuccess(_ json: JSON) {
        if isEditingProfile{
            self.dismiss(animated: true, completion: nil)
            btnSave.isEnabled = true
            btnSave.alpha = 1
        } else {
            userInformation.setValue(json["data"]["user"]["telNum"].string, forKey: UserDetails.TEL_NUM)
            userInformation.setValue(json["data"]["user"]["driver"]["fee_km"].number, forKey: UserDetails.FEE_KM)
            userInformation.setValue(json["data"]["user"]["driver"]["car_registration"].string, forKey: UserDetails.CAR_REGISTRATION)
            userInformation.setValue(json["data"]["user"]["driver"]["car_type"].string, forKey: UserDetails.CAR_TYPE)
            userInformation.setValue(json["data"]["user"]["driver"]["name"].string, forKey: UserDetails.NAME)
            userInformation.setValue(json["data"]["user"]["driver"]["fee_start"].number, forKey: UserDetails.FEE_START)
            userInformation.setValue(json["data"]["user"]["avatar"]["fileid"].string, forKey: UserDetails.AVATAR)
            userInformation.setValue(json["data"]["user"]["avatar"]["thumbfileid"].string, forKey: UserDetails.THUMBNAIL)
            userInformation.setValue("2", forKey: UserDetails.TYPE)
            self.performSegue(withIdentifier: "SetDriverDetailsSegue", sender: nil)
        }
        
        
    }
    
    func onSetUserDetailsError(_ error: NSInteger) {
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        progressHUD.hide()
    }
    
    func showPRogress(_ totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){

    }

}
