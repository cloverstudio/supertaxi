//
//  TaxiProfileMapViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class TaxiProfileMapViewController: UIViewController, UIApplicationDelegate {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SlideMenu Viewcontroller
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // left and right bar buttonitem event
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        //set image for button
        button.setImage(UIImage(named: "ex_image.png"), forState: UIControlState.Normal)
        //set frame
        button.frame = CGRectMake(60, 0, 30, 30)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.blackColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 248/255.0, green: 244/255.0, blue: 236/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
