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
    
    var locationManager: CLLocationManager!
    
    let userInformation = UserDefaults.standard
    var apiManager: ApiManager!
    
    var driver: DriverInfoModel!
    var driverFileId: String!
    var driverLocation: [JSON]!
    var driverLoc: CLLocationCoordinate2D!
    var driverId: String!
    
    var from: CLLocationCoordinate2D!
    var to: CLLocationCoordinate2D!
    var helperLocation: CLLocationCoordinate2D!
    
    var orderId: String!
    
    var tripStarted = false
    var tripEnded = false
    
    var angle: Float! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            mapView.setCenter(coor, animated: true)
        }
        
        mapView.showsUserLocation = true;

        ratingView.layer.cornerRadius = 5
        navView.layer.borderColor = Colors.darkBlue(1).cgColor
        navView.layer.borderWidth = 1
        
        if (userInformation.string(forKey: UserDetails.THUMBNAIL) != nil){
            avatarImage.load(URL(string: Api.IMAGE_URL + userInformation.string(forKey: UserDetails.THUMBNAIL)!))
        }
        
        avatarImage.layer.cornerRadius = avatarImage.frame.size.height/2
        avatarImage.clipsToBounds = true
        
        avatarImage3.load(URL(string: Api.IMAGE_URL + driverFileId))
        avatarImage3.layer.cornerRadius = avatarImage3.frame.size.height/2
        avatarImage3.clipsToBounds = true
        
        txtDriverName.text = driver.name
//        txtCarReg.text = driver.car_registration
//        txtCarType.text = driver.car_type
        
    
        driverLoc = CLLocationCoordinate2D(latitude: driverLocation[1].double!, longitude: driverLocation[0].double!)
        createRoute(driverLoc, endLocation: from)
        
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(UserLongPressViewController.getDriverLocation), userInfo: nil, repeats: true)
        
    }
    
    func getDriverLocation(){
        self.apiManager.getProfileDetail(self.userInformation.string(forKey: UserDetails.TOKEN)!, userId: self.driverId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getOrderStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseDialog(_ sender: AnyObject) {
        ratingView.isHidden = true
    }
    
    @IBAction func onCancelTrip(_ sender: AnyObject) {
        apiManager.cancelOrder(userInformation.string(forKey: UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
    }
    
    @IBAction func onCancelTripBottom(_ sender: AnyObject) {
        apiManager.cancelOrder(userInformation.string(forKey: UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
    }
    
    @IBAction func onMenuOpen(_ sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKPointAnnotation {
            return nil
            
        } else if annotation is DriverAnnotation {
            let reuseId = "driver"
            
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                anView!.canShowCallout = true
                anView!.image = UIImage(named: "black_car_icon")
            }
         
            var rotationTransform: CGAffineTransform = CGAffineTransform.identity;
            rotationTransform = CGAffineTransform(rotationAngle: CGFloat(angle));
            anView!.transform = rotationTransform;
            
            return anView
            
        } else if annotation is UserAnnotation {
            
            let reuseId = "user"
            
            var userView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if userView == nil {
                userView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                userView!.canShowCallout = true
                
                let pinImage: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                pinImage.load(URL(string: Api.IMAGE_URL + userInformation.string(forKey: UserDetails.THUMBNAIL)!))
                pinImage.layer.cornerRadius = pinImage.layer.frame.size.width / 2
                pinImage.layer.borderWidth = 2
                pinImage.layer.borderColor = Colors.greenTransparent(1).cgColor
                pinImage.layer.masksToBounds = true
                
                UIGraphicsBeginImageContext(pinImage.bounds.size);
                pinImage.layer.render(in: UIGraphicsGetCurrentContext()!)
                let screenShot = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                userView!.image = screenShot
            }
            
            return userView
        }
        
        return nil
    }
    
    func createRoute(_ startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
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
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            self.txtDistance.text = String(route.distance / 1000) + " km"
            
        }
        
    }
    
    func getOrderStatus(){
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.apiManager.getOrderStatus(self.userInformation.string(forKey: UserDetails.TOKEN)!, orderId: self.orderId)
        })
    }
    
    func onOrderStatusSuccess(_ json: JSON) {
        getOrderStatus()
    }
    
    func onOrderStatusNoDrivers() {
        getOrderStatus()
    }
    
    func onOrderStatusError(_ error: NSInteger) {
        getOrderStatus()
    }
    
    func onOrderStatusCanceled(_ json: JSON) {
        
        if(json["data"]["cancelType"].number == 2){
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as? UserHomeViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
            
            let alert = UIAlertController(title: "Info", message: "Driver canceled!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as? UserHomeViewController
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func onOrderSrarusStartedDrive(_ json: JSON){
        if !tripStarted {
            createRoute(driverLoc, endLocation: to)
            cancelTripBottom.isEnabled = false
        }
        
        tripStarted = true
        
        getOrderStatus()
    }
    
    func onOrderStatusDriveEnded(_ json: JSON){
        if !tripEnded {
            let customView = RateView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), name: driver.name, start: from, end: to, type: 1, image: driverFileId, id: driverId)
            customView.rateViewDelegate = self
            self.view.addSubview(customView)
        }
        
        tripEnded = true
        
    }
    
    func onDriveRated() {
        helperLocation = nil
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as? UserHomeViewController
        self.navigationController?.pushViewController(viewController!, animated: true)

    }
    
    func onDriveRatedError(){
        helperLocation = nil
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserHomeVC") as? UserHomeViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func onProfileDetailsSuccess(_ json: JSON){
        driverLoc = CLLocationCoordinate2D(latitude: json["data"]["user"]["currentLocation"][1].double!, longitude: json["data"]["user"]["currentLocation"][0].double!)
        if tripStarted {
            createRoute(driverLoc, endLocation: to)
        } else {
            createRoute(driverLoc, endLocation: from)
        }
    }
}
