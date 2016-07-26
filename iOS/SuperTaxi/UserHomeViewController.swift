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
import SWRevealViewController

class UserHomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CallOrderDelegate {
    
    @IBOutlet var viewFrom: UIView!
    @IBOutlet var viewTo: UIView!
    @IBOutlet var pickUpLocationView: UIView!
    @IBOutlet var taxiOptionsView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet var fromTextView: UITextField!
    @IBOutlet var toTextView: UITextField!
    @IBOutlet var pickUpLocationLabel: UILabel!
    @IBOutlet var seatNumberView: UIView!
    @IBOutlet var oneSeatView: UIView!
    @IBOutlet var twoSeatsView: UIView!
    @IBOutlet var fourSeatsView: UIView!
    @IBOutlet var navView: UIView!

    @IBOutlet var setLocationButton: UIButton!
    @IBOutlet var avatarView: UIImageView!

    
    var flag: Bool = true
    
    let UserInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var locationManager: CLLocationManager!
    var address = ""
    var addressFrom = ""
    var latFrom: Double = 0.0
    var lonFrom: Double = 0.0
    
    var addressTo = ""
    var latTo: Double = 0.0
    var lonTo: Double = 0.0
    
    var isPickUpLocationSet = false
    
    var orderId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFrom.layer.borderWidth = 1
        viewFrom.layer.cornerRadius = 2
        viewFrom.layer.borderColor = Colors.greyBorder(1).CGColor
        viewFrom.layer.shadowColor = Colors.greyBorder(1).CGColor
        viewFrom.layer.shadowOffset = CGSizeMake(0, 5);
        viewFrom.layer.shadowOpacity = 1;
        viewFrom.layer.shadowRadius = 1.0;
        
        viewTo.layer.cornerRadius = 2
        viewTo.layer.borderWidth = 1
        viewTo.layer.borderColor = Colors.greyBorder(1).CGColor
        
        pickUpLocationView.layer.cornerRadius = pickUpLocationView.frame.height / 2
        pickUpLocationView.clipsToBounds = true
        
        navView.layer.borderColor = Colors.darkBlue(1).CGColor
        navView.layer.borderWidth = 1
        
        
        // Set blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 0.8
        seatNumberView.insertSubview(blurEffectView, atIndex: 0)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffect1 = UIVisualEffectView(effect: blur)
        blurEffect1.frame = view.bounds
        blurEffect1.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        blurEffect1.alpha = 0.9
        viewRequest.insertSubview(blurEffect1, atIndex: 0)
        
        if (UserInformation.stringForKey(UserDetails.THUMBNAIL) != ""){
            avatarView.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        avatarView.layer.cornerRadius = avatarView.frame.size.height/2
        avatarView.clipsToBounds = true
        
        apiManager = ApiManager()
        apiManager.callOrderDelegate = self
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func onLocationSet(sender: AnyObject) {
        if (!isPickUpLocationSet) {
            fromTextView.text = address
            isPickUpLocationSet = true
            pickUpLocationLabel.text = "SET DESTINATION LOCATION"
        } else {
            toTextView.text = address
            createRoute(CLLocationCoordinate2D(latitude: latFrom, longitude: lonFrom), endLocation: CLLocationCoordinate2D(latitude: latTo, longitude: lonTo))
        }
        
    }

    @IBAction func onShowMore(sender: AnyObject) {
        self.taxiOptionsView.hidden = false
    }
    
    @IBAction func onRequestTaxi(sender: AnyObject) {
        if(fromTextView.text == ""){
            let alert = UIAlertController(title: "Info", message: "Please enter your pickup address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else if (toTextView.text == ""){
            
            let alert = UIAlertController(title: "Info", message: "Please enter your destination address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            seatNumberView.hidden = false
        }
        
    }
    
    @IBAction func onDeleteFromLabel(sender: AnyObject) {
        fromTextView.text = ""
        isPickUpLocationSet = false
        pickUpLocationLabel.text = "SET PICKUP LOCATION"
    }
    
    @IBAction func oneSeatButton(sender: AnyObject) {
        
        apiManager.orderTaxi(UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: self.latFrom, lonFrom: self.lonFrom, addressFrom: self.addressFrom, latTo: self.latTo, lonTo: self.lonTo, addressTo: self.addressTo, crewNum: 1)
        
        seatNumberView.hidden = true
        viewRequest.hidden = false
    }
    
    @IBAction func twoSeatsButton(sender: AnyObject) {
        apiManager.orderTaxi(UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: latFrom, lonFrom: lonFrom, addressFrom: addressFrom, latTo: latTo, lonTo: lonTo, addressTo: addressTo, crewNum: 2)
        
        seatNumberView.hidden = true
        viewRequest.hidden = false
    }
    
    @IBAction func fourSeatsButton(sender: AnyObject) {
        apiManager.orderTaxi(UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: latFrom, lonFrom: lonFrom, addressFrom: addressFrom, latTo: latTo, lonTo: lonTo, addressTo: addressTo, crewNum: 4)
        
        seatNumberView.hidden = true
        viewRequest.hidden = false
    }
    
    @IBAction func cancelRequestButton(sender: AnyObject) {
        viewRequest.hidden = true
        apiManager.cancelOrder(UserInformation.stringForKey(UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
    }
    
    @IBAction func showMyLocation(sender: AnyObject) {
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenterCoordinate(coor, animated: true)
        }
    }
    
    
    @IBAction func onMenuShow(sender: AnyObject) {

        self.revealViewController().revealToggle(sender)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        centerMap(locValue)
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        let geoCoder = CLGeocoder()
        
        if (isPickUpLocationSet) {
            latTo = center.latitude
            lonTo = center.longitude
        } else {
            latFrom = center.latitude
            lonFrom = center.longitude
        }
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
//            var postCode = ""
            var street = ""
            var city = ""
            var country = ""
            
            // Location name
            if let streetName = placeMark.addressDictionary!["Name"] as? NSString {
                street = streetName as String
            }
            
            // City
            if let cityName = placeMark.addressDictionary!["City"] as? NSString {
                city = cityName as String
            }
            
            // Country
            if let countryName = placeMark.addressDictionary!["Country"] as? NSString {
                country = countryName as String
            }
            
            self.address = street + ", " + city + ", " + country
            
            if (self.isPickUpLocationSet) {
                self.addressTo = self.address
            } else {
                self.addressFrom = self.address
            }
            
        })
        
        pickUpLocationView.hidden = false
        viewTo.hidden = false
        viewFrom.hidden = false
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        pickUpLocationView.hidden = true
        viewTo.hidden = true
        viewFrom.hidden = true
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func onCallOrdered(id: String) {
        orderId = id
    }
    
    func onCallOrderError(error: NSInteger) {
        print("error")
    }
    
    func createRoute(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        // 2.
        let sourceLocation = startLocation
        let destinationLocation = endLocation
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
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
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }

    
}