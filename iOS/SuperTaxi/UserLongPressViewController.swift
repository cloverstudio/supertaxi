//
//  UserLongPressViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import ImageLoader

class UserLongPressViewController: UIViewController {
    
    @IBOutlet var ratingView: UIView!
    @IBOutlet var navView: UIView!
    
    @IBOutlet var avatarImage: UIImageView!
    
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ratingView.layer.cornerRadius = 5
        navView.layer.borderColor = Colors.darkBlue(1).CGColor
        navView.layer.borderWidth = 1
        
        apiManager = ApiManager()
        
        if (userInformation.stringForKey(UserDetails.THUMBNAIL) != ""){
            avatarImage.load(Api.IMAGE_URL + userInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height/2
        avatarImage.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseDialog(sender: AnyObject) {
        ratingView.hidden = true
    }
    
    @IBAction func onCancelTrip(sender: AnyObject) {
        
    }
}
