//
//  CreatingUserProfileViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class CreatingUserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIApplicationDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var imgUpload: UIImageView!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
        self.imgUserPhoto.layer.cornerRadius = self.imgUserPhoto.frame.size.width/2
        imgUserPhoto.clipsToBounds = true
        
        btnSave.enabled = false
        btnSave.alpha = 0.4
        txtName.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtAge.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        txtNote.addTarget(self, action: #selector(CreatingUserProfileViewController.textFieldDidChange(_:)), forControlEvents: .EditingDidEnd)
        
        txtName.delegate = self
        txtAge.delegate = self
        txtNote.delegate = self
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let age:Int? = Int(txtAge.text!)
        
        if(segue.identifier == "userhome_segue")
        {
            if txtName.text == "" {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Name", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if txtAge.text == ""  {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Age", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if age > 150  {
                let alert = UIAlertController(title: "Alert", message: "Age can't be bigger than 150", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            if txtNote.text == "" {
                let alert = UIAlertController(title: "Alert", message: "Please enter your Note", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                btnSave.enabled = false
                btnSave.alpha = 0.4
            }
            
            if (imgUserPhoto.image == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please upload your avatar photo", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UIAction Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgUserPhoto.image = choosenImage
        dismissViewControllerAnimated(true, completion: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate?.imgSave = imgUserPhoto.image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
