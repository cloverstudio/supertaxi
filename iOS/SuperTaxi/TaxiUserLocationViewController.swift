//
//  TaxiUserLocationViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SWRevealViewController
import SwiftyJSON
import ImageLoader

class TaxiUserLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, OrderStatusDelegate, RateViewDelegate {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var btnStartTrip: UIButton!
    @IBOutlet var btnEndTrip: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var txtDistance: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var txtUserAge: UILabel!
    @IBOutlet var addressFrom: UILabel!
    @IBOutlet var addressTo: UILabel!
    @IBOutlet var txtUserNote: UILabel!
    @IBOutlet var txtUserName: UILabel!
    @IBOutlet weak var txtAboveTheDistance1: UILabel!
    @IBOutlet weak var txtAboveTheDistance2: UILabel!
    
    
    var locationManager: CLLocationManager!
    let UserInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var from: CLLocationCoordinate2D!
    var to: CLLocationCoordinate2D!
    var driverLocation: CLLocationCoordinate2D!
    var helperLocation: CLLocationCoordinate2D!
    
    var tripStarted = false
    
    var userFileId: String!
    var userName: String!
    var userAge: NSInteger!
    var userNote: String!
    var userAddressFrom: String!
    var userAddressTo: String!
    var orderId: String!
    var userId: String!
    
    var orderStatus = false
    
    var angle: Float! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        mapView.showsUserLocation = true;
        
        apiManager = ApiManager()
        apiManager.orderStatusDelegate = self

        viewAlert.layer.cornerRadius = 5
        
        if (UserInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
            avatar.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        avatar.layer.cornerRadius = avatar.frame.size.height/2
        avatar.clipsToBounds = true
        
        createRoute(driverLocation, endLocation: from)
        
//        _ = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(TaxiUserLocationViewController.updateMyLocation), userInfo: nil, repeats: true)
        
        txtUserName.text = userName
        txtUserAge.text = String(userAge)
        txtUserNote.text = userNote
        
        addressFrom.text = userAddressFrom
        addressTo.text = userAddressTo
        
     //   userAvatar.load(Api.IMAGE_URL + userFileId)
       // userAvatar.layer.cornerRadius = userAvatar.frame.size.height/2
      //  userAvatar.clipsToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        getOrderStatus()
    }
    
    func updateMyLocation(){
        if !tripStarted {
            createRoute(driverLocation, endLocation: from)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func onStartTripClick(sender: AnyObject) {
        
        tripStarted = true
        txtAboveTheDistance1.text="DISTANCE TO"
        txtAboveTheDistance2.text="DESTINATION:"
        createRoute(driverLocation, endLocation: to)
        
        btnStartTrip.hidden = true
        btnEndTrip.hidden = false
        
        apiManager.updateArriveTime(UserInformation.stringForKey(UserDetails.TOKEN)!, orderId: orderId)
        apiManager.updateStartTime(UserInformation.stringForKey(UserDetails.TOKEN)!, orderId: orderId)
    }
    
    @IBAction func onEndTrip(sender: AnyObject) {
        if  userFileId == nil {
            userFileId=""
        }
        let customView = RateView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), name: userName, start: from, end: to, type: 2, image: userFileId, id: userId)
        
        customView.rateViewDelegate = self
        self.view.addSubview(customView)
        apiManager.updateFinishTime(UserInformation.stringForKey(UserDetails.TOKEN)!, orderId: orderId)
        
    }
    
    @IBAction func onCancelTrip(sender: AnyObject) {
        apiManager.cancelOrder(UserInformation.stringForKey(UserDetails.TOKEN)!, id: orderId, type: 2, reason: "Neznam")
    }
    
    @IBAction func openSidebar(sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        apiManager.updateCoordinates(UserInformation.stringForKey(UserDetails.TOKEN)!, lat: (manager.location?.coordinate.latitude)!, lon: (manager.location?.coordinate.longitude)!)
        
        if !tripStarted {
            driverLocation = manager.location?.coordinate
        }
    }
    
    @IBAction func onClose(sender: AnyObject) {
        viewAlert.hidden = true
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        
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
               // pinImage.load(Api.IMAGE_URL + userFileId)
                pinImage.layer.cornerRadius = pinImage.layer.frame.size.width / 2
                pinImage.layer.borderWidth = 2
                pinImage.layer.borderColor = Colors.greenTransparent(1).CGColor
                pinImage.layer.masksToBounds = true
                
                UIGraphicsBeginImageContext(pinImage.bounds.size);
               // pinImage.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let screenShot = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                userView!.image = screenShot
            }
            
            return userView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation is UserAnnotation {
            viewAlert.hidden = false
        }
    }
    
    func createRoute(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
        if helperLocation != nil {
            let delatLongitude = Float(helperLocation.longitude - startLocation.longitude)
            let deltaLatitude = Float(helperLocation.latitude - startLocation.latitude)
            self.angle = atan2f(delatLongitude, deltaLatitude)
            
        }
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        let sourceLocation = startLocation
        let destinationLocation = endLocation
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = DriverAnnotation(title: "Me", coordinate: startLocation)
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        if tripStarted {
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = userAddressTo
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        } else {
        
            let destinationAnnotation = UserAnnotation(title: userName, coordinate: endLocation)
            
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
    
    func getOrderStatus(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.apiManager.getOrderStatus(self.UserInformation.stringForKey(UserDetails.TOKEN)!, orderId: self.orderId)
        })
    }
    
    func onOrderStatusSuccess(json: JSON) {
        if (tripStarted) {
            getOrderStatus()
        }
    }
    
    func onOrderStatusNoDrivers() {
        if (tripStarted) {
            getOrderStatus()
        }
    }
    
    func onOrderStatusError(error: NSInteger) {
        if (tripStarted) {
            getOrderStatus()
        }
    }
    
    func onOrderStatusCanceled(json: JSON) {
        if(orderStatus){
            if(json["data"]["cancelType"].number == 1){
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiProfileMapVC") as? TaxiProfileMapViewController
                    self.navigationController?.pushViewController(viewController!, animated: true)
                }
                
                let alert = UIAlertController(title: "Info", message: "User canceled!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiProfileMapVC") as? TaxiProfileMapViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
        }
        
        orderStatus = true
    }
    
    func onOrderSrarusStartedDrive(json: JSON){
    
    }
    
    func onOrderStatusDriveEnded(json: JSON){
        
    }
    
    func onDriveRated() {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiProfileMapVC") as? TaxiProfileMapViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
    func onDriveRatedError(){
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiProfileMapVC") as? TaxiProfileMapViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
