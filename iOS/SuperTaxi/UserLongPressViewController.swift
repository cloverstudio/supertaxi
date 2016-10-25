//
//  UserLongPressViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import ImageLoader
import MapKit
import CoreLocation
import SWRevealViewController
import SwiftyJSON

class UserLongPressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, OrderStatusDelegate, ProfileDelegate, RateViewDelegate {
    
    @IBOutlet var ratingView: UIView!
    @IBOutlet var navView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var txtDistance: UILabel!
    @IBOutlet var cancelTripBottom: UIButton!
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var txtDriverName: UILabel!
    @IBOutlet var avatarImage3: UIImageView!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var carRegistration: UILabel!
    @IBOutlet weak var startFee: UILabel!
    @IBOutlet weak var telNum: UILabel!
    @IBOutlet weak var driverRating: UIView!
    @IBOutlet weak var driverRatingFirstStar: UIImageView!
    @IBOutlet weak var driverRatingSecondStar: UIImageView!
    @IBOutlet weak var driverRatingThirdStar: UIImageView!
    @IBOutlet weak var driverRatingFourthStar: UIImageView!
    @IBOutlet weak var driverRatingFifthStar: UIImageView!
    @IBOutlet weak var txtAboveTheDistance1: UILabel!
    @IBOutlet weak var txtAboveTheDistance2: UILabel!
    
    var locationManager: CLLocationManager!
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var driver: DriverInfoModel!
    var driverLocation: [JSON]!
    var driverLoc: CLLocationCoordinate2D!
    
    var from: CLLocationCoordinate2D!
    var to: CLLocationCoordinate2D!
    var helperLocation: CLLocationCoordinate2D!
    var distance:String!
    var driverDistanceDelegate:DriverUpdateDistance!

    
    var orderId: String!
    
    var tripStarted = false
    var tripEnded = false
    var timer:NSTimer!
    var angle: Float! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ja sam nastao")
        apiManager = ApiManager()
        apiManager.orderStatusDelegate = self
        apiManager.profileDelegate = self
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenterCoordinate(coor, animated: true)
        }
        
        mapView.showsUserLocation = true;

        ratingView.layer.cornerRadius = 5
        navView.layer.borderColor = Colors.darkBlue(1).CGColor
        navView.layer.borderWidth = 1
        
        if (userInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
            avatarImage.load(Api.IMAGE_URL + userInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height/2
        avatarImage.clipsToBounds = true
        
        
        avatarImage3.load(Api.IMAGE_URL + driver.fileId)
        
        avatarImage3.layer.cornerRadius = avatarImage3.frame.size.height/2
        avatarImage3.clipsToBounds = true
        
        txtDriverName.text = driver.name
        carType.text = driver.car_type
        carRegistration.text = driver.car_registration
        telNum.text = driver.telNum
        startFee.text = String(driver.fee_start)
        
    
        driverLoc = CLLocationCoordinate2D(latitude: driverLocation[1].double!, longitude: driverLocation[0].double!)
        createRoute(driverLoc, endLocation: from)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(UserLongPressViewController.getDriverLocation), userInfo: nil, repeats: true)
        
    }
    
    func getDriverLocation(){
        self.apiManager.getProfileDetail(self.userInformation.stringForKey(UserDetails.TOKEN)!, userId: self.driver.id)
    }
    
    override func viewDidAppear(animated: Bool) {
        getOrderStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseDialog(sender: AnyObject) {
        ratingView.hidden = true
    }
    
    @IBAction func onCancelTrip(sender: AnyObject) {
        apiManager.cancelOrder(userInformation.stringForKey(UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
    }
    
    @IBAction func onCancelTripBottom(sender: AnyObject) {
        apiManager.cancelOrder(userInformation.stringForKey(UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
    }
    
    @IBAction func onMenuOpen(sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKPointAnnotation {
            return nil
            
        } else if annotation is DriverAnnotation {
            let reuseId = "driver"
            
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                anView!.canShowCallout = false
                anView!.image = UIImage(named: "black_car_icon")
            }
         
            var rotationTransform: CGAffineTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformMakeRotation(CGFloat(angle));
            anView!.transform = rotationTransform;
            
            return anView
            
        } else if annotation is UserAnnotation {
            
            let reuseId = "user"
            
            var userView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if userView == nil {
                userView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                userView!.canShowCallout = true
                
                let pinImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, 35, 35))
                pinImage.load(Api.IMAGE_URL + userInformation.stringForKey(UserDetails.THUMBNAIL)!)
                pinImage.layer.cornerRadius = pinImage.layer.frame.size.width / 2
                pinImage.layer.borderWidth = 2
                pinImage.layer.borderColor = Colors.greenTransparent(1).CGColor
                pinImage.layer.masksToBounds = true
                
                UIGraphicsBeginImageContext(pinImage.bounds.size);
                pinImage.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let screenShot = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                userView!.image = screenShot
            }
            
            return userView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation
        if annotation is DriverAnnotation {
            setAverageRating(driver.averageRate)
            ratingView.hidden=false
        }
    }
    
    func createRoute(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
        if helperLocation != nil {
            let delatLongitude = Float(helperLocation.longitude - startLocation.longitude)
            let deltaLatitude = Float(helperLocation.latitude - startLocation.latitude)
            self.angle = atan2f(delatLongitude, deltaLatitude)
            
        }
        
        helperLocation = startLocation
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
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
        
        if tripStarted {
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = ""
            
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        } else {
            
            let destinationAnnotation = UserAnnotation(title: "Me", coordinate: endLocation)
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
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
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            self.txtDistance.text = String(route.distance / 1000) + " km"
            self.distance = String(route.distance / 1000) + " km"
            self.driverDistanceDelegate.updateDriverDistance(String(route.distance / 1000) + " km")
        }
        
    }
    
    func getOrderStatus(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.apiManager.getOrderStatus(self.userInformation.stringForKey(UserDetails.TOKEN)!, orderId: self.orderId)
        })
    }
    
    func onOrderStatusSuccess(json: JSON) {
        getOrderStatus()
    }
    
    func onOrderStatusNoDrivers() {
        getOrderStatus()
    }
    
    func onOrderStatusError(error: NSInteger) {
        getOrderStatus()
    }
    
    func onOrderStatusCanceled(json: JSON) {
        
        if(json["data"]["cancelType"].number == 2){
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.timer.invalidate()
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
            
            let alert = UIAlertController(title: "Info", message: "Driver canceled!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.timer.invalidate()
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func onOrderSrarusStartedDrive(json: JSON){
        if !tripStarted {
            txtAboveTheDistance1.text = "DISTANCE TO"
            txtAboveTheDistance2.text = "DESTINATION:"
            createRoute(driverLoc, endLocation: to)
            cancelTripBottom.enabled = false
        }
        
        tripStarted = true
        
        getOrderStatus()
    }
    
    func onOrderStatusDriveEnded(json: JSON){
        if !tripEnded {
            if driver.fileId == nil {
                driver.fileId = ""
            }
            let customView = RateView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), name: driver.name, start: from, end: to, type: 1, image: driver.fileId, id: driver.id, driver: driver)
            
            customView.rateViewDelegate = self
            self.view.addSubview(customView)
        }
        
        tripEnded = true
        
    }
    
    func setAverageRating(averageRating: Float) {
        let yellowStar = UIImage(named: "small_star_active")
        let grayStar = UIImage(named: "gray_star")
        driverRatingFirstStar.image = grayStar
        driverRatingSecondStar.image = grayStar
        driverRatingThirdStar.image = grayStar
        driverRatingFourthStar.image = grayStar
        driverRatingFifthStar.image = grayStar
        if averageRating >= 0.5 {
            driverRatingFirstStar.image = yellowStar
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
    
    func onDriveRated() {
        helperLocation = nil
        self.timer.invalidate()
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
        self.navigationController?.pushViewController(viewController!, animated: true)

    }
    
    func onDriveRatedError(){
        helperLocation = nil
        self.timer.invalidate()
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func onProfileDetailsSuccess(json: JSON){
        driverLoc = CLLocationCoordinate2D(latitude: json["data"]["user"]["currentLocation"][1].double!, longitude: json["data"]["user"]["currentLocation"][0].double!)
        if tripStarted {
            createRoute(driverLoc, endLocation: to)
        } else {
            createRoute(driverLoc, endLocation: from)
        }
    }
}
