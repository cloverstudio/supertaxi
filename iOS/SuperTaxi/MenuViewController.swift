//
//  MenuViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var slideOutAnimationEnabled: Bool!
    var settingsVC: SettingsViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        self.slideOutAnimationEnabled = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.slideOutAnimationEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if(segue.identifier == "settings_segue")
        {
            SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(settingsVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
        }
    }

}
