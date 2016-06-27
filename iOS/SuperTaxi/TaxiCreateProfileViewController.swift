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
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        btnSave.enabled = true
        btnSave.alpha = 1.0
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        btnSave.enabled = true
        btnSave.alpha = 1.0
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
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            appDelegate?.string = txtTaxiDriverName.text
            
            if ((txtTaxiDriverName.text?.isEmpty) == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Name", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if ((txtCartype.text?.isEmpty) == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Car Type", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if ((txtCarRegnumber.text?.isEmpty) == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Car Reg Number", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if ((txtStartfee.text?.isEmpty) == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Start Fee", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if ((txtFeekm.text?.isEmpty) == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Fee/km", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if (imgTaxiDriverPhoto.image == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please upload your avatar photo", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                btnSave.enabled = false
                btnSave.alpha = 0.4
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
