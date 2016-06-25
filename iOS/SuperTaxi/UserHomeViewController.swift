//
//  UserHomeViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/23/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UserHomeViewController: UIViewController, UIApplicationDelegate, SlideNavigationControllerDelegate {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    
    @IBOutlet weak var lblCars: UILabel!
    @IBOutlet weak var lblKilometre: UILabel!
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnOneSeat: UIButton!
    @IBOutlet weak var btnTwoSeat: UIButton!
    @IBOutlet weak var btnThreeSeat: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewSeat: UIView!
    @IBOutlet weak var viewOneSeat: UIView!
    @IBOutlet weak var viewTwoSeat: UIView!
    @IBOutlet weak var viewThreeSeat: UIView!
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    var flag: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Circle Image
        imgPhoto.layer.masksToBounds = false
        imgPhoto.layer.cornerRadius = imgPhoto.frame.width/2
        imgPhoto.clipsToBounds = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        imgPhoto.image = appDelegate.imgSave
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIAction Methods
    @IBAction func onMenuClick(sender: AnyObject) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    
    @IBAction func onNextClick(sender: AnyObject) {
        
        if !flag {
            viewRequest.hidden = false
            viewSeat.hidden = true
            viewBottom.hidden = true
        } else {
        
            viewSeat.hidden = false
            btnNext.setImage(UIImage(named: "btn_next_blur.png"), forState: .Normal)
            btnNext.enabled = false
        
            mapView.alpha = 0.3
            mapView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        }

    }
    
    // MARK: - SlideNavigationController Methods
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    // MARK: - SeatView UIButton Action Methods
    @IBAction func onSeatOneClick(sender: AnyObject) {
        
        imgOne.image = UIImage(named: "check.png")
        imgTwo.image = UIImage(named: "")
        imgThree.image = UIImage(named: "")
        
        viewOneSeat.alpha = 1.0
        viewTwoSeat.alpha = 0.4
        viewThreeSeat.alpha = 0.4
        
        btnTwoSeat.enabled = false
        btnThreeSeat.enabled = false
        
        btnNext.enabled = true
        btnNext.setImage(UIImage(named: "btn_next.png"), forState: .Normal)
        
        flag = false
    }
    
    @IBAction func onSeatTwoClick(sender: AnyObject) {
        
        imgOne.image = UIImage(named: "")
        imgTwo.image = UIImage(named: "check.png")
        imgThree.image = UIImage(named: "")
        
        viewOneSeat.alpha = 0.4
        viewTwoSeat.alpha = 1.0
        viewThreeSeat.alpha = 0.4
        
        btnOneSeat.enabled = false
        btnThreeSeat.enabled = false
        
        btnNext.enabled = true
        btnNext.setImage(UIImage(named: "btn_next.png"), forState: .Normal)
    }
    
    @IBAction func onSeatThreeClick(sender: AnyObject) {
        
        imgOne.image = UIImage(named: "")
        imgTwo.image = UIImage(named: "")
        imgThree.image = UIImage(named: "check.png")
        
        viewOneSeat.alpha = 0.4
        viewTwoSeat.alpha = 0.4
        viewThreeSeat.alpha = 1.0
        
        btnOneSeat.enabled = false
        btnTwoSeat.enabled = false
        
        btnNext.enabled = true
        btnNext.setImage(UIImage(named: "btn_next.png"), forState: .Normal)
    }
    
}