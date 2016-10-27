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
import SwiftyJSON


class UserHomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CallOrderDelegate, OrderStatusDelegate, NearestDriverDelegate, UITableViewDelegate, UITableViewDataSource, OrderCancelDelegate {
    
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
    @IBOutlet var seatImage: UIImageView!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var removeFromBtn: UIButton!
    @IBOutlet var groupImage: UIImageView!

    @IBOutlet var setLocationButton: UIButton!
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var tableBackView: UIView!
    @IBOutlet var tableView: UITableView!

    var flag: Bool = true
    var isLocSet = false
    
    let UserInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var locationManager: CLLocationManager!
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    var address = ""
    var addressFrom = ""
    var latFrom: Double = 0.0
    var lonFrom: Double = 0.0
    
    var addressTo = ""
    var latTo: Double = 0.0
    var lonTo: Double = 0.0
    
    var isPickUpLocationSet = false
    
    var orderId = ""
    var getOrderStatus = false
    var getOrderErrorCounter = 0
  
    
    var matchingItems:[MKMapItem] = []
    
    let cellReuseIdentifier = "cell"
    
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
        
        oneSeatView.layer.cornerRadius = 2
        oneSeatView.layer.borderWidth = 1
        oneSeatView.layer.borderColor = Colors.greyBorder(1).CGColor
        
        twoSeatsView.layer.cornerRadius = 2
        twoSeatsView.layer.borderWidth = 1
        twoSeatsView.layer.borderColor = Colors.greyBorder(1).CGColor
        
        fourSeatsView.layer.cornerRadius = 2
        fourSeatsView.layer.borderWidth = 1
        fourSeatsView.layer.borderColor = Colors.greyBorder(1).CGColor

        navView.layer.borderColor = Colors.darkBlue(1).CGColor
        navView.layer.borderWidth = 1
        
        tableBackView.backgroundColor = Colors.greyBorder(0.1)
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 2
        tableView.layer.borderColor = Colors.greyBorder(1).CGColor
        tableView.layer.shadowColor = Colors.greyBorder(1).CGColor
        tableView.layer.shadowOffset = CGSizeMake(0, 5);
        tableView.layer.shadowOpacity = 1;
        tableView.layer.shadowRadius = 1.0;
        
        seatImage.layer.cornerRadius = seatImage.frame.width / 2
        
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
        
        
        
        avatarView.layer.cornerRadius = avatarView.frame.size.height/2
        avatarView.clipsToBounds = true
        
        apiManager = ApiManager()
        apiManager.callOrderDelegate = self
        apiManager.orderStatusDelegate = self
        apiManager.nearestDriverDelegate = self
        apiManager.cancelOrderDelegate = self
        
        fromTextView.addTarget(self, action: #selector(UserHomeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        toTextView.addTarget(self, action: #selector(UserHomeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
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
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        mapView.showsUserLocation = true;
        
        if let coor = mapView.userLocation.location?.coordinate{
            centerMap(coor)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (UserInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
            avatarView.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!, placeholder: UIImage(named: "user"))
        }
        getOrderStatus = false
        orderId = ""

        rotateView(groupImage)
        self.removeFromBtn.hidden = false
    }
    
    @IBAction func onLocationSet(sender: AnyObject) {
        
        if (!isPickUpLocationSet) {
            
            latFrom = lat
            lonFrom = lon
            
            self.addressFrom = self.address
            
            fromTextView.text = addressFrom
            isPickUpLocationSet = true
            pickUpLocationLabel.text = "SET DESTINATION LOCATION"
            
        } else {
            
            self.addressTo = self.address
            
            latTo = lat
            lonTo = lon
            
            toTextView.text = addressTo
            createRoute(CLLocationCoordinate2D(latitude: latFrom, longitude: lonFrom), endLocation: CLLocationCoordinate2D(latitude: latTo, longitude: lonTo))
        }
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
            removeFromBtn.hidden = true
        }
        
    }
    
    @IBAction func onDeleteFromLabel(sender: AnyObject) {
        fromTextView.text = ""
        isPickUpLocationSet = false
        pickUpLocationLabel.text = "SET PICKUP LOCATION"
        
    }
    
    @IBAction func oneSeatButton(sender: AnyObject) {
        
        seatImage.image = UIImage(named: "avatar_one_seat")
        seatImage.contentMode = UIViewContentMode.Center;
        
        apiManager.orderTaxi(UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: self.latFrom, lonFrom: self.lonFrom, addressFrom: self.addressFrom, latTo: self.latTo, lonTo: self.lonTo, addressTo: self.addressTo, crewNum: 1)
        
        seatNumberView.hidden = true
        viewRequest.hidden = false
        
    }
    
    @IBAction func twoSeatsButton(sender: AnyObject) {
        
        seatImage.image = UIImage(named: "avatar_two_seat")
        seatImage.contentMode = UIViewContentMode.Center;
        
        apiManager.orderTaxi(UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: latFrom, lonFrom: lonFrom, addressFrom: addressFrom, latTo: latTo, lonTo: lonTo, addressTo: addressTo, crewNum: 2)
        
        seatNumberView.hidden = true
        viewRequest.hidden = false
    }

    @IBAction func fourSeatsButton(sender: AnyObject) {
        
        seatImage.image = UIImage(named: "avatar_three_seat")
        seatImage.contentMode = UIViewContentMode.Center;
        
        apiManager.orderTaxi(UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: latFrom, lonFrom: lonFrom, addressFrom: addressFrom, latTo: latTo, lonTo: lonTo, addressTo: addressTo, crewNum: 4)
        
        seatNumberView.hidden = true
        viewRequest.hidden = false
    }
    
    
    @IBAction func cancelRequestButton(sender: AnyObject) {
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
    
    @IBAction func bntRemoveSeatView(sender: AnyObject) {
        seatNumberView.hidden = true
        removeFromBtn.hidden = false
    }
    
    
    func getOrderResult(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.apiManager.getOrderStatus(self.UserInformation.stringForKey(UserDetails.TOKEN)!, orderId: self.orderId)
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!isLocSet){
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            centerMap(locValue)
            isLocSet = true
        }
        
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
        
        lat = center.latitude
        lon = center.longitude
        
        if (!isPickUpLocationSet) {
            
            apiManager.getNearestDriver(UserInformation.stringForKey(UserDetails.TOKEN)!, lat: lat, lon: lon)
        }
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
 
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
        
        getOrderResult()
    }
    
    
    func onCallOrderError(error: NSInteger, crewNumber: NSInteger) {
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            self.apiManager.orderTaxi(self.UserInformation.stringForKey(UserDetails.TOKEN)!, latFrom: self.latFrom, lonFrom: self.lonFrom, addressFrom: self.addressFrom, latTo: self.latTo, lonTo: self.lonTo, addressTo: self.addressTo, crewNum: crewNumber)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) in
            
            self.viewRequest.hidden=true
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
        
        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
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
            
            for route in response.routes {
//                let route = response.routes[0]
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            }
            
            
        }
        
    }
    
    func onOrderStatusSuccess(json: JSON) {
        
        print(json)
        
        let driver: DriverInfoModel = DriverInfoModel(
            id: json["data"]["driver"]["_id"].string!,
            name: json["data"]["driver"]["driver"]["name"].string!,
            car_type: json["data"]["driver"]["driver"]["car_type"].string!,
            car_registration: json["data"]["driver"]["driver"]["car_registration"].string!,
            fee_start: json["data"]["driver"]["driver"]["fee_start"].int!,
            fee_km: json["data"]["driver"]["driver"]["fee_km"].int!)
        
        if json["data"]["driver"]["averageRate"].float != nil {
            driver.averageRate = json["data"]["driver"]["averageRate"].float!
        } else {
            driver.averageRate = 0.0
        }
        
        
        if json["data"]["driver"]["telNum"].string != nil {
            driver.telNum = json["data"]["driver"]["telNum"].string!
        } else {
            driver.telNum = ""
        }
        
        
        if json["data"]["driver"]["avatar"]["fileid"].string != nil {
            driver.fileId = json["data"]["driver"]["avatar"]["fileid"].string!
        } else {
            driver.fileId=""
        }
        
        let location = json["data"]["driver"]["currentLocation"].array!
        
        
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiDriverDetailsID") as? UserRequestReceivedViewController
        viewController!.driver = driver
        viewController!.driverFileId = driver.fileId
        viewController!.driverLocation = location
        viewController?.from = CLLocationCoordinate2D(latitude: latFrom, longitude: lonFrom)
        viewController?.to = CLLocationCoordinate2D(latitude: latTo, longitude: lonTo)
        viewController?.orderId = orderId
        self.navigationController?.pushViewController(viewController!, animated: true)
        
        viewRequest.hidden = true
        
    }
    
    func onOrderStatusNoDrivers() {
        if !getOrderStatus {
            getOrderResult()
        }
    }
    
    
    func onOrderStatusError(error: NSInteger) {
        
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            if !self.getOrderStatus {
                self.getOrderResult()
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
       }
    

    
    func onOrderStatusCanceled(json: JSON) {
        
        if getOrderStatus {
            if(json["data"]["cancelType"].number == 2){
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.viewRequest.hidden = true
                }
                
                let alert = UIAlertController(title: "Info", message: "Driver canceled!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.viewRequest.hidden = true
            }
        }
    }
    
    func onOrderSrarusStartedDrive(json: JSON){
        getOrderStatus = true
    }
    
    func onOrderStatusDriveEnded(json: JSON){
        
    }
    
    func onNearestDriverSuccess(latitude: Double, longitude: Double) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    
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
            
            for route in response.routes {
                self.minutesLabel.text = String(NSInteger(route.expectedTravelTime / 60))
            }
        }
    }
    
    
    func onNearestDriveError(error: NSInteger) {
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            self.apiManager.getNearestDriver(self.UserInformation.stringForKey(UserDetails.TOKEN)!, lat: self.lat, lon: self.lon)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldDidChange(textField: UITextField) {
        if(textField.text != ""){
            
            tableBackView.hidden = false
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = textField.text
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { response, error in
                guard let response = response else {
                    print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                    return
                }
                
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
        } else {
            tableBackView.hidden = true
        }
    }
    
    func onCancelOrderSuccess() {
        viewRequest.hidden = true
    }
    
    func onCancelOrderError(error: NSInteger) {
        let alert = UIAlertController(title: "Error", message: Tools().getErrorFromCode(error), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
            self.viewRequest.hidden = false
            self.cancelRequestButton(self)
                   }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.matchingItems[indexPath.row].placemark.title
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!isPickUpLocationSet){
            addressFrom = self.matchingItems[indexPath.row].placemark.title!
            fromTextView.text = self.matchingItems[indexPath.row].placemark.title!
            latFrom = self.matchingItems[indexPath.row].placemark.coordinate.latitude
            lonFrom = self.matchingItems[indexPath.row].placemark.coordinate.longitude
            isPickUpLocationSet = true
            pickUpLocationLabel.text = "SET DESTINATION LOCATION"
            matchingItems.removeAll()
            tableBackView.hidden = true
        } else {
            addressTo = self.matchingItems[indexPath.row].placemark.title!
            toTextView.text = self.matchingItems[indexPath.row].placemark.title!
            latTo = self.matchingItems[indexPath.row].placemark.coordinate.latitude
            lonTo = self.matchingItems[indexPath.row].placemark.coordinate.longitude
            matchingItems.removeAll()
            tableBackView.hidden = true
            createRoute(CLLocationCoordinate2D(latitude: latFrom, longitude: lonFrom), endLocation: CLLocationCoordinate2D(latitude: latTo, longitude: lonTo))
        }
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: {
            targetView.transform = CGAffineTransformRotate(targetView.transform, CGFloat(M_PI))
        }) { finished in
            self.rotateView(targetView, duration: duration)
        }
    }
}














