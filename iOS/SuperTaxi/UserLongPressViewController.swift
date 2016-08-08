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

class UserLongPressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, OrderStatusDelegate, RateDelegate, ProfileDelegate {
    
    @IBOutlet var ratingView: UIView!
    @IBOutlet var navView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var ratingView2: UIView!
    @IBOutlet var routeImage: UIImageView!
    @IBOutlet var txtDistance: UILabel!
    @IBOutlet var cancelTripBottom: UIButton!
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var txtDriverName: UILabel!
    @IBOutlet var avatarImage2: UIImageView!
    @IBOutlet var avatarImage3: UIImageView!
    
    @IBOutlet var twoStars: UIButton!
    @IBOutlet var threeStars: UIButton!
    @IBOutlet var fourStars: UIButton!
    @IBOutlet var fiveStars: UIButton!
    
    var locationManager: CLLocationManager!
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var driver: DriverInfoModel!
    var driverFileId: String!
    var driverLocation: [JSON]!
    var driverLoc: CLLocationCoordinate2D!
    var driverId: String!
    
    var from: CLLocationCoordinate2D!
    var to: CLLocationCoordinate2D!
    
    var orderId: String!
    
    var tripStarted = false
    var tripEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager = ApiManager()
        apiManager.orderStatusDelegate = self
        apiManager.rateDelegate = self
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
        ratingView2.layer.backgroundColor = Colors.darkTransparent(0.5).CGColor
        navView.layer.borderColor = Colors.darkBlue(1).CGColor
        navView.layer.borderWidth = 1
        
        if (userInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
            avatarImage.load(Api.IMAGE_URL + userInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height/2
        avatarImage.clipsToBounds = true
        
        avatarImage2.load(Api.IMAGE_URL + driverFileId)
        avatarImage2.layer.cornerRadius = avatarImage2.frame.size.height/2
        avatarImage2.clipsToBounds = true
        
        avatarImage3.load(Api.IMAGE_URL + driverFileId)
        avatarImage3.layer.cornerRadius = avatarImage3.frame.size.height/2
        avatarImage3.clipsToBounds = true
        
        txtDriverName.text = driver.name
//        txtCarReg.text = driver.car_registration
//        txtCarType.text = driver.car_type
        
    
        driverLoc = CLLocationCoordinate2D(latitude: driverLocation[1].double!, longitude: driverLocation[0].double!)
        createRoute(driverLoc, endLocation: from)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(UserLongPressViewController.getDriverLocation), userInfo: nil, repeats: true)
        
    }
    
    func getDriverLocation(){
        self.apiManager.getProfileDetail(self.userInformation.stringForKey(UserDetails.TOKEN)!, userId: self.driverId)
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
    
    
    @IBAction func oneStarRate(sender: AnyObject) {
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: driverId, type: 2, rate: 1)
    }
    
    @IBAction func twoStarRate(sender: AnyObject) {
        twoStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: driverId, type: 2, rate: 2)
    }
    
    @IBAction func threeStarRate(sender: AnyObject) {
        twoStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        threeStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: driverId, type: 2, rate: 3)
    }
    
    @IBAction func fourStarRate(sender: AnyObject) {
        twoStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        threeStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        fourStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: driverId, type: 2, rate: 4)
    }
    
    @IBAction func fiveStarRate(sender: AnyObject) {
        twoStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        threeStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        fourStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        fiveStars.setBackgroundImage(UIImage(named: "small_star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: driverId, type: 2, rate: 5)
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
                anView!.canShowCallout = true
                anView!.image = UIImage(named: "black_car_icon")
            }
            
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
                pinImage.layer.borderColor = Colors.greyBorder(1).CGColor
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
    
    func createRoute(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
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
            
        }
        
    }
    
    func createMapSnapshot (){
        
        let options = MKMapSnapshotOptions()
        options.region = mapView.region
        options.size = mapView.frame.size
        options.scale = UIScreen.mainScreen().scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler { snapshot, error in
            guard let snapshot = snapshot else {
                print("Snapshot error: \(error)")
                return
            }
            
            for annotation in self.mapView.annotations {
                snapshot.pointForCoordinate(annotation.coordinate)
            }
            
            self.routeImage.image = snapshot.image
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
                
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
            
            let alert = UIAlertController(title: "Info", message: "Driver canceled!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func onOrderSrarusStartedDrive(json: JSON){
        if !tripStarted {
            createRoute(driverLoc, endLocation: to)
            cancelTripBottom.enabled = false
        }
        
        tripStarted = true
        
        getOrderStatus()
    }
    
    func onOrderStatusDriveEnded(json: JSON){
        if !tripEnded {
            ratingView2.hidden = false
        }
        
        tripEnded = true
        createMapSnapshot()
        
    }
    
    func onRateSuccess() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserHomeVC") as? UserHomeViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func onRateError() {
        
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
