//
//  UserRequestReceivedViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class UserRequestReceivedViewController: UIViewController {
    
    @IBOutlet var contactView: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.hidden = true
        
        contactView.layer.borderWidth = 1
        contactView.layer.borderColor = Colors.darkBlue(1).CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
