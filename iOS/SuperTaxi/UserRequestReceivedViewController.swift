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

class UserRequestReceivedViewController: UIViewController,DriverUpdateDistance, ProfileDelegate, OrderCancelDelegate {
    
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
    var driverLoc:CLLocationCoordinate2D!
    
    var orderId: String!
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    var timer:NSTimer!

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
        apiManager.profileDelegate = self
        apiManager.cancelOrderDelegate = self
        distance = "** km"
        txtDistance.text = distance
        driverLoc = CLLocationCoordinate2D(latitude: driverLocation[1].double!, longitude: driverLocation[0].double!)
        calculateDistance(driverLoc,endLocation: from)
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(UserRequestReceivedViewController.getDriverLocation), userInfo: nil, repeats: true)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDriverLocation(){
        print("tražim vozača")
        self.apiManager.getProfileDetail(self.userInformation.stringForKey(UserDetails.TOKEN)!, userId: self.driver.id)
    }
    
    func calculateDistance( startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
        
        let sourceLocation = startLocation
        let destinationLocation = endLocation
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = DriverAnnotation(title: driver.name, coordinate: startLocation)
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
      
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.txtDistance.text = String(route.distance / 1000) + " km"
            self.distance = String(route.distance / 1000) + " km"
        }
        
    }

    
    func updateDriverDistance( distance: String) {
        txtDistance.text = distance
        self.distance = distance
    }

    @IBAction func showOnMap(sender: AnyObject) {
        viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserMapWithTaxiID") as? UserLongPressViewController
        viewController?.driver = driver
        viewController?.driverLocation = driverLocation
        viewController?.from = from
        viewController?.to = to
        viewController?.orderId = orderId
        viewController?.driverDistanceDelegate = self
        self.timer.invalidate()
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        apiManager.cancelOrder(userInformation.stringForKey(UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
        
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
    
    func onProfileDetailsSuccess(json: JSON){
        driverLoc = CLLocationCoordinate2D(latitude: json["data"]["user"]["currentLocation"][1].double!, longitude: json["data"]["user"]["currentLocation"][0].double!)
        print(driverLoc)
        calculateDistance(driverLoc, endLocation: from)
    
    }
    
    func onProfileDetailsError(error: NSInteger) {
        timer.invalidate()
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            self.getDriverLocation()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(UserRequestReceivedViewController.getDriverLocation), userInfo: nil, repeats: true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onCancelOrderSuccess() {
        self.timer.invalidate()
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func onCancelOrderError(error: NSInteger) {
        self.timer.invalidate()
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            self.cancel(self)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(UserRequestReceivedViewController.getDriverLocation), userInfo: nil, repeats: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
