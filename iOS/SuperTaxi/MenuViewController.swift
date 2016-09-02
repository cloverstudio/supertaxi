//
//  MenuViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var imgPhoto: UIImageView!
    @IBOutlet var txtFirstName: UILabel!
    
    var slideOutAnimationEnabled: Bool!
    var settingsVC: SettingsViewController!
    
    let UserInformation = NSUserDefaults.standardUserDefaults()
    
    required init?(coder aDecoder: NSCoder) {
        self.slideOutAnimationEnabled = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.slideOutAnimationEnabled = true
        
        if (UserInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
            imgPhoto.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!, placeholder: UIImage(named: "user"))
        }
        
        imgPhoto.layer.cornerRadius = imgPhoto.frame.size.width / 2
        imgPhoto.clipsToBounds = true
        
        txtFirstName.text = UserInformation.stringForKey(UserDetails.NAME)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func onHome(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
        
    }
    
    @IBAction func btnOpenProfile(sender: AnyObject) {
        if (UserInformation.stringForKey(UserDetails.TYPE)! == "2") {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiCreateProfileVC") as? TaxiCreateProfileViewController
            viewController?.isEditingProfile = true
            self.revealViewController()?.presentViewController(viewController!, animated: true, completion: nil)
        } else {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreatingUserProfileVC") as? CreatingUserProfileViewController
            viewController?.isEditingProfile = true
            self.revealViewController()?.presentViewController(viewController!, animated: true, completion: nil)
        }
        
        self.revealViewController().revealToggleAnimated(true)

    }
    
    @IBAction func btnSettings(sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("Settings") as? SettingsViewController
        self.revealViewController()?.presentViewController(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggleAnimated(true)
    }
    
    @IBAction func btnReportAProblem(sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ReportID") as? ReportProblemViewController
        self.revealViewController()?.presentViewController(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggleAnimated(true)
    }
    
    @IBAction func btnAbout(sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutID") as? AboutViewController
        self.revealViewController()?.presentViewController(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggleAnimated(true)
    }
    
    @IBAction func btnHistory(sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryID") as? HistoryViewController
        self.revealViewController()?.presentViewController(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggleAnimated(true)
    }
    
}
