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
            imgPhoto.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        imgPhoto.layer.cornerRadius = imgPhoto.frame.size.height/2
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
    
}
