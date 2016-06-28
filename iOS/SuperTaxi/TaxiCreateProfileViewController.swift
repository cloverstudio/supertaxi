//
//  TaxiCreateProfileViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class TaxiCreateProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIApplicationDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtTaxiDriverName: UITextField!
    @IBOutlet weak var txtCartype: UITextField!
    @IBOutlet weak var txtCarRegnumber: UITextField!
    @IBOutlet weak var txtStartfee: UITextField!
    @IBOutlet weak var txtFeekm: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imgTaxiDriverPhoto: UIImageView!
    @IBOutlet weak var imgDriver: UIImageView!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        imgTaxiDriverPhoto.layer.masksToBounds = false
        imgTaxiDriverPhoto.layer.cornerRadius = imgTaxiDriverPhoto.frame.size.height / 2
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

    @IBAction func onSaveClick(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if(segue.identifier == "taxiprofile_segue")
        {
            if (imgTaxiDriverPhoto.image == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please upload your avatar photo", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - UIAction Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgTaxiDriverPhoto.image = choosenImage
        dismissViewControllerAnimated(true, completion: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate?.imgSave = imgTaxiDriverPhoto.image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
