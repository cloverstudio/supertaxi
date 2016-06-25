//
//  TaxiProfileMapViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class TaxiProfileMapViewController: UIViewController, UIApplicationDelegate {

    @IBOutlet weak var lblTaxiDriverName: UILabel!
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgPhoto.layer.masksToBounds = false
        imgPhoto.layer.cornerRadius = imgPhoto.frame.width/2
        imgPhoto.clipsToBounds = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        imgPhoto.image = appDelegate?.imgSave
        lblTaxiDriverName.text = appDelegate?.string
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
