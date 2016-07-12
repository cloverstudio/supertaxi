//
//  TaxiRequestFromUserViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit

class TaxiRequestFromUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIAction Methods
    @IBAction func onIgnoreClick(sender: AnyObject) {
    }
    
    @IBAction func onAcceptClick(sender: AnyObject) {
    }

}
