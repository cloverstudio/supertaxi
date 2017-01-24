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
    
    let UserInformation = UserDefaults.standard
    
    required init?(coder aDecoder: NSCoder) {
        self.slideOutAnimationEnabled = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.slideOutAnimationEnabled = true
        
        if (UserInformation.string(forKey: UserDetails.THUMBNAIL) != nil){
            imgPhoto.load(Api.IMAGE_URL + UserInformation.string(forKey: UserDetails.THUMBNAIL)!, placeholder: UIImage(named: "user"))
        }
        
        imgPhoto.layer.cornerRadius = imgPhoto.frame.size.width / 2
        imgPhoto.clipsToBounds = true
        
        txtFirstName.text = UserInformation.string(forKey: UserDetails.NAME)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func onHome(_ sender: AnyObject) {
        self.revealViewController().revealToggle(animated: true)
        
    }
    
    @IBAction func btnOpenProfile(_ sender: AnyObject) {
        if (UserInformation.string(forKey: UserDetails.TYPE)! == "2") {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaxiCreateProfileVC") as? TaxiCreateProfileViewController
            viewController?.isEditingProfile = true
            self.revealViewController()?.present(viewController!, animated: true, completion: nil)
        } else {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatingUserProfileVC") as? CreatingUserProfileViewController
            viewController?.isEditingProfile = true
            self.revealViewController()?.present(viewController!, animated: true, completion: nil)
        }
        
        self.revealViewController().revealToggle(animated: true)

    }
    
    @IBAction func btnSettings(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as? SettingsViewController
        self.revealViewController()?.present(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func btnReportAProblem(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ReportID") as? ReportProblemViewController
        self.revealViewController()?.present(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func btnAbout(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutID") as? AboutViewController
        self.revealViewController()?.present(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func btnHistory(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryID") as? HistoryViewController
        self.revealViewController()?.present(viewController!, animated: true, completion: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
}
