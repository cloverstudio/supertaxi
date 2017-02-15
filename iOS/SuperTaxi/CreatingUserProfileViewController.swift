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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    
    let userInformation = UserDefaults.standard
    var apiManager: ApiManager!
    
    var imageData: Data! = nil
    var mime: String!
    
    var goNext = false
    var isNameOk = false
    var isAgeOk = false
    var isNoteOK = false
    var isPhoneNumOK = false
    
    var isEditingProfile = false
    
    let progressHUD = ProgressHUD(text: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        imgUserPhoto.clipsToBounds = true
        
        if !isEditingProfile{
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        }
        
        txtName.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        txtAge.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        txtNote.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), for: .editingDidEnd)
        
        txtName.delegate = self
        txtAge.delegate = self
        txtNote.delegate = self
        
        apiManager = ApiManager()
        apiManager.setUserDetailsDelegate = self
        
        let status:ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        
        if status != ALAuthorizationStatus.authorized{
            print("User has not given authorization for the camera roll")
        }
        
        if isEditingProfile {
            txtName.text = userInformation.string(forKey: UserDetails.NAME)
            txtAge.text = userInformation.string(forKey: UserDetails.AGE)
            txtNote.text = userInformation.string(forKey: UserDetails.NOTE)
            txtPhoneNumber.text = userInformation.string(forKey: UserDetails.TEL_NUM)
            
            if (userInformation.string(forKey: UserDetails.THUMBNAIL) != nil){
                imgUserPhoto.load(URL(string: Api.IMAGE_URL + userInformation.string(forKey: UserDetails.THUMBNAIL)!))
            }
            
            imageData = Data()
            mime = ""
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
        if (!(txtName.text?.isEmpty)! && !(txtAge.text?.isEmpty)! && !(txtNote.text?.isEmpty)!) {
            btnSave.isEnabled = true
            btnSave.alpha = 1.0
        }
    }
    
    // MARK: - UIAction Methods
    @IBAction func onCancelClick(_ sender: AnyObject) {
        if isEditingProfile {
            self.dismiss(animated: true, completion: nil)
        } else {
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func onUploadAvatarClick(_ sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        imgUpload.isHidden = true
    }
    
    @IBAction func onSave(_ sender: AnyObject) {
        
        let age:Int? = Int(txtAge.text!)
        
        if txtName.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isNameOk = true
        }
        
        if txtAge.text == ""  {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Age", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isAgeOk = true
        }
        
        if age > 100  {
            let alert = UIAlertController(title: "Alert", message: "Age can't be bigger than 150", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            isAgeOk = false
        } else {
            isAgeOk = true
        }
        
        if txtNote.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your Note", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isNoteOK = true
        }
        
        if (imgUserPhoto.image == nil) {
            let alert = UIAlertController(title: "Alert", message: "Please upload your avatar photo", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            goNext = true
        }
        
        if txtPhoneNumber.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter your phone number!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            btnSave.isEnabled = false
            btnSave.alpha = 0.4
        } else {
            isPhoneNumOK = true
        }
    
        if (goNext) {
            apiManager.setUserDetails(userInformation.object(forKey: UserDetails.TOKEN) as! String, name: txtName.text!, type: "1", telNum: txtPhoneNumber.text!, age: txtAge.text!, note: txtNote.text!, car_type: "", car_registration: "", fee_start: "", fee_km: "", fileData: imageData, fileName: "file", mime: mime)
            
            progressHUD.show()
        }
        
        
    }
    
    // MARK: - UIAction Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgUserPhoto.image = choosenImage
        
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
            userInformation.setValue(json["data"]["user"]["user"]["name"].string, forKey: UserDetails.NAME)
            userInformation.setValue(json["data"]["user"]["user"]["age"].number, forKey: UserDetails.AGE)
            userInformation.setValue(json["data"]["user"]["user"]["note"].string, forKey: UserDetails.NOTE)
            userInformation.setValue(json["data"]["user"]["avatar"]["thumbfileid"].string, forKey: UserDetails.THUMBNAIL)
            userInformation.setValue(json["data"]["user"]["avatar"]["fileid"].string, forKey: UserDetails.AVATAR)
            userInformation.setValue("1", forKey: UserDetails.TYPE)
            self.performSegue(withIdentifier: "SetUSerDetailsSegue", sender: nil)
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
