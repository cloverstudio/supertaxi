//
//  UserRequestReceivedViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit


protocol DriverUpdateDistance {
    func updateDriverDistance( distance:String);
}

class UserRequestReceivedViewController: UIViewController,DriverUpdateDistance {
    
    @IBOutlet var contactView: UIView!
    @IBOutlet var txtName: UILabel!
    @IBOutlet var txtDistance: UILabel!
    @IBOutlet var txtCarType: UILabel!
    @IBOutlet var txtCarRegistraion: UILabel!
    @IBOutlet var txtFeeStart: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet weak var driverRatingFirstStar: UIImageView!
    @IBOutlet weak var driverRatingSecondStar: UIImageView!
    @IBOutlet weak var driverRatingThirdStar: UIImageView!
    @IBOutlet weak var driverRatingFourthStar: UIImageView!
    @IBOutlet weak var driverRatingFifthStar: UIImageView!
    
    var driver: DriverInfoModel!
    var driverFileId: String!
    var driverLocation: [JSON]!
    var from: CLLocationCoordinate2D!
    var to: CLLocationCoordinate2D!
    var distance: String!
    var driverPhoneNumber: String!
    var driverId: String!
    var viewController:UserLongPressViewController!
    
    var orderId: String!
    
    let UserInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        contactView.layer.borderWidth = 1
        contactView.layer.borderColor = Colors.darkBlue(1).CGColor
        
        if driverFileId != nil {
            avatar.load(Api.IMAGE_URL + driverFileId, placeholder: UIImage(named: "taxi_driver"))
        }
        
        avatar.layer.cornerRadius = avatar.frame.size.height/2
        avatar.clipsToBounds = true
        
        if driver != nil {
            txtName.text = driver.name
            txtCarType.text = driver.car_type
            txtCarRegistraion.text = driver.car_registration
            txtFeeStart.text = String(driver.fee_start)
            setAverageRating(driver.averageRate)
        }
        
        apiManager = ApiManager()
        
        distance = "3.34 km"
        txtDistance.text = distance
         viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserMapWithTaxiID") as? UserLongPressViewController
        viewController?.driver = driver
        print("boooook")
        viewController?.driverLocation = driverLocation
        viewController?.from = from
        viewController?.to = to
        viewController?.orderId = orderId
        viewController?.driverDistanceDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDriverDistance( distance: String) {
        txtDistance.text = distance
        self.distance = distance
    }

    @IBAction func showOnMap(sender: AnyObject) {
    
    
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        apiManager.cancelOrder(UserInformation.stringForKey(UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func btnCallDriver(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://" + driverPhoneNumber)!)
    }
    
    func setAverageRating(averageRating: Float) {
        let yellowStar = UIImage(named: "small_star_active")
        let grayStar = UIImage(named: "gray_star")
       // driverRatingFirstStar.image = grayStar
        driverRatingSecondStar.image = grayStar
        driverRatingThirdStar.image = grayStar
        driverRatingFourthStar.image = grayStar
        driverRatingFifthStar.image = grayStar
        if averageRating >= 0.5 {
           // driverRatingFirstStar.image = yellowStar
        }
        
        if averageRating >= 1.5 {
            driverRatingSecondStar.image = yellowStar
        }
        
        if averageRating >= 2.5 {
            driverRatingThirdStar.image = yellowStar
        }
        
        if averageRating >= 3.5 {
            driverRatingFourthStar.image = yellowStar
        }
        
        if averageRating >= 4.5 {
            driverRatingFifthStar.image = yellowStar
        }
        
    }
    
    
    
}
