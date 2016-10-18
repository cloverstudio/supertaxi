//
//  AboutViewController.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 29/08/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}