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


class UserHomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CallOrderDelegate, OrderStatusDelegate, NearestDriverDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let UserInformation = UserDefaults.standard
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
    
    var driverId = ""
    var driverPhoneNumber: String!
    
    var matchingItems:[MKMapItem] = []
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFrom.layer.borderWidth = 1
        viewFrom.layer.cornerRadius = 2
        viewFrom.layer.borderColor = Colors.greyBorder(1).cgColor
        viewFrom.layer.shadowColor = Colors.greyBorder(1).cgColor
        viewFrom.layer.shadowOffset = CGSize(width: 0, height: 5);
        viewFrom.layer.shadowOpacity = 1;
        viewFrom.layer.shadowRadius = 1.0;
        
        viewTo.layer.cornerRadius = 2
        viewTo.layer.borderWidth = 1
        viewTo.layer.borderColor = Colors.greyBorder(1).cgColor
        
        oneSeatView.layer.cornerRadius = 2
        oneSeatView.layer.borderWidth = 1
        oneSeatView.layer.borderColor = Colors.greyBorder(1).cgColor
        
        twoSeatsView.layer.cornerRadius = 2
        twoSeatsView.layer.borderWidth = 1
        twoSeatsView.layer.borderColor = Colors.greyBorder(1).cgColor
        
        fourSeatsView.layer.cornerRadius = 2
        fourSeatsView.layer.borderWidth = 1
        fourSeatsView.layer.borderColor = Colors.greyBorder(1).cgColor

        navView.layer.borderColor = Colors.darkBlue(1).cgColor
        navView.layer.borderWidth = 1
        
        tableBackView.backgroundColor = Colors.greyBorder(0.1)
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 2
        tableView.layer.borderColor = Colors.greyBorder(1).cgColor
        tableView.layer.shadowColor = Colors.greyBorder(1).cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 5);
        tableView.layer.shadowOpacity = 1;
        tableView.layer.shadowRadius = 1.0;
        
        seatImage.layer.cornerRadius = seatImage.frame.width / 2
        
        // Set blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = 0.8
        seatNumberView.insertSubview(blurEffectView, at: 0)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffect1 = UIVisualEffectView(effect: blur)
        blurEffect1.frame = view.bounds
        blurEffect1.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffect1.alpha = 0.9
        viewRequest.insertSubview(blurEffect1, at: 0)
        
        
        
        avatarView.layer.cornerRadius = avatarView.frame.size.height/2
        avatarView.clipsToBounds = true
        
        apiManager = ApiManager()
        apiManager.callOrderDelegate = self
        apiManager.orderStatusDelegate = self
        apiManager.nearestDriverDelegate = self
        
        fromTextView.addTarget(self, action: #selector(UserHomeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        toTextView.addTarget(self, action: #selector(UserHomeViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        mapView.showsUserLocation = true;
        
        if let coor = mapView.userLocation.location?.coordinate{
            centerMap(coor)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserInformation.string(forKey: UserDetails.THUMBNAIL) != nil){
            avatarView.load(Api.IMAGE_URL + UserInformation.string(forKey: UserDetails.THUMBNAIL)!, placeholder: UIImage(named: "user"))
        }
        getOrderStatus = false
        orderId = ""

        rotateView(groupImage)
        self.removeFromBtn.isHidden = false
    }
    
    @IBAction func onLocationSet(_ sender: AnyObject) {
        
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
    
    @IBAction func onRequestTaxi(_ sender: AnyObject) {
        if(fromTextView.text == ""){
            let alert = UIAlertController(title: "Info", message: "Please enter your pickup address.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (toTextView.text == ""){
            
            let alert = UIAlertController(title: "Info", message: "Please enter your destination address.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            seatNumberView.isHidden = false
            removeFromBtn.isHidden = true
        }
        
    }
    
    @IBAction func onDeleteFromLabel(_ sender: AnyObject) {
        fromTextView.text = ""
        isPickUpLocationSet = false
        pickUpLocationLabel.text = "SET PICKUP LOCATION"
        
    }
    
    @IBAction func oneSeatButton(_ sender: AnyObject) {
        
        seatImage.image = UIImage(named: "avatar_one_seat")
        seatImage.contentMode = UIViewContentMode.center;
        
        apiManager.orderTaxi(UserInformation.string(forKey: UserDetails.TOKEN)!, latFrom: self.latFrom, lonFrom: self.lonFrom, addressFrom: self.addressFrom, latTo: self.latTo, lonTo: self.lonTo, addressTo: self.addressTo, crewNum: 1)
        
        seatNumberView.isHidden = true
        viewRequest.isHidden = false
        
    }
    
    @IBAction func twoSeatsButton(_ sender: AnyObject) {
        
        seatImage.image = UIImage(named: "avatar_two_seat")
        seatImage.contentMode = UIViewContentMode.center;
        
        apiManager.orderTaxi(UserInformation.string(forKey: UserDetails.TOKEN)!, latFrom: latFrom, lonFrom: lonFrom, addressFrom: addressFrom, latTo: latTo, lonTo: lonTo, addressTo: addressTo, crewNum: 2)
        
        seatNumberView.isHidden = true
        viewRequest.isHidden = false
    }

    @IBAction func fourSeatsButton(_ sender: AnyObject) {
        
        seatImage.image = UIImage(named: "avatar_three_seat")
        seatImage.contentMode = UIViewContentMode.center;
        
        apiManager.orderTaxi(UserInformation.string(forKey: UserDetails.TOKEN)!, latFrom: latFrom, lonFrom: lonFrom, addressFrom: addressFrom, latTo: latTo, lonTo: lonTo, addressTo: addressTo, crewNum: 4)
        
        seatNumberView.isHidden = true
        viewRequest.isHidden = false
    }
    
    @IBAction func cancelRequestButton(_ sender: AnyObject) {
        viewRequest.isHidden = true
        apiManager.cancelOrder(UserInformation.string(forKey: UserDetails.TOKEN)!, id: orderId, type: 1, reason: "Neznam jos")
    }
    
    @IBAction func showMyLocation(_ sender: AnyObject) {
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    @IBAction func onMenuShow(_ sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func bntRemoveSeatView(_ sender: AnyObject) {
        seatNumberView.isHidden = true
        removeFromBtn.isHidden = false
    }
    
    
    func getOrderResult(){
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            self.apiManager.getOrderStatus(self.UserInformation.string(forKey: UserDetails.TOKEN)!, orderId: self.orderId)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!isLocSet){
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            centerMap(locValue)
            isLocSet = true
        }
        
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        let geoCoder = CLGeocoder()
        
        lat = center.latitude
        lon = center.longitude
        
        if (!isPickUpLocationSet) {
            apiManager.getNearestDriver(UserInformation.string(forKey: UserDetails.TOKEN)!, lat: lat, lon: lon)
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
        
        pickUpLocationView.isHidden = false
        viewTo.isHidden = false
        viewFrom.isHidden = false
        
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        pickUpLocationView.isHidden = true
        viewTo.isHidden = true
        viewFrom.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func onCallOrdered(_ id: String) {
        orderId = id
        
        getOrderResult()
    }
    
    func onCallOrderError(_ error: NSInteger) {
        print("error")
    }
    
    func createRoute(_ startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
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
            
            for route in response.routes {
//                let route = response.routes[0]
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            }
            
            
        }
        
    }
    
    func onOrderStatusSuccess(_ json: JSON) {
        
        let driver: DriverInfoModel = DriverInfoModel(
            name: json["data"]["driver"]["driver"]["name"].string!,
            car_type: json["data"]["driver"]["driver"]["car_type"].string!,
            car_registration: json["data"]["driver"]["driver"]["car_registration"].string!,
            fee_start: json["data"]["driver"]["driver"]["fee_start"].int!,
            fee_km: json["data"]["driver"]["driver"]["fee_km"].int!)
        
        var driverFileId = ""
        
        if json["data"]["driver"]["avatar"]["fileid"].string != nil {
            driverFileId = json["data"]["driver"]["avatar"]["fileid"].string!
        }
        
        let location = json["data"]["driver"]["currentLocation"].array!
        
        driverId = json["data"]["driver"]["_id"].string!
        driverPhoneNumber = json["data"]["driver"]["telNum"].string!
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaxiDriverDetailsID") as? UserRequestReceivedViewController
        viewController!.driver = driver
        viewController!.driverFileId = driverFileId
        viewController!.driverLocation = location
        viewController?.from = CLLocationCoordinate2D(latitude: latFrom, longitude: lonFrom)
        viewController?.to = CLLocationCoordinate2D(latitude: latTo, longitude: lonTo)
        viewController?.orderId = orderId
        viewController?.driverId = driverId
        viewController?.driverPhoneNumber = driverPhoneNumber
        self.navigationController?.pushViewController(viewController!, animated: true)
        
        viewRequest.isHidden = true
        
    }
    
    func onOrderStatusNoDrivers() {
        if !getOrderStatus {
            getOrderResult()
        }
    }
    
    func onOrderStatusError(_ error: NSInteger) {
        
    }
    
    func onOrderStatusCanceled(_ json: JSON) {
        
        if getOrderStatus {
            if(json["data"]["cancelType"].number == 2){
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.viewRequest.isHidden = true
                }
                
                let alert = UIAlertController(title: "Info", message: "Driver canceled!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.viewRequest.isHidden = true
            }
        }
    }
    
    func onOrderSrarusStartedDrive(_ json: JSON){
        getOrderStatus = true
    }
    
    func onOrderStatusDriveEnded(_ json: JSON){
        
    }
    
    func onNearestDriverSuccess(_ latitude: Double, longitude: Double) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    
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
            
            for route in response.routes {
                self.minutesLabel.text = String(NSInteger(route.expectedTravelTime / 60))
            }
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if(textField.text != ""){
            
            tableBackView.isHidden = false
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = textField.text
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else {
                    print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                    return
                }
                
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
        } else {
            tableBackView.isHidden = true
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.matchingItems[(indexPath as NSIndexPath).row].placemark.title
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!isPickUpLocationSet){
            addressFrom = self.matchingItems[(indexPath as NSIndexPath).row].placemark.title!
            fromTextView.text = self.matchingItems[(indexPath as NSIndexPath).row].placemark.title!
            latFrom = self.matchingItems[(indexPath as NSIndexPath).row].placemark.coordinate.latitude
            lonFrom = self.matchingItems[(indexPath as NSIndexPath).row].placemark.coordinate.longitude
            isPickUpLocationSet = true
            pickUpLocationLabel.text = "SET DESTINATION LOCATION"
            matchingItems.removeAll()
            tableBackView.isHidden = true
        } else {
            addressTo = self.matchingItems[(indexPath as NSIndexPath).row].placemark.title!
            toTextView.text = self.matchingItems[(indexPath as NSIndexPath).row].placemark.title!
            latTo = self.matchingItems[(indexPath as NSIndexPath).row].placemark.coordinate.latitude
            lonTo = self.matchingItems[(indexPath as NSIndexPath).row].placemark.coordinate.longitude
            matchingItems.removeAll()
            tableBackView.isHidden = true
            createRoute(CLLocationCoordinate2D(latitude: latFrom, longitude: lonFrom), endLocation: CLLocationCoordinate2D(latitude: latTo, longitude: lonTo))
        }
    }
    
    fileprivate func rotateView(_ targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { finished in
            self.rotateView(targetView, duration: duration)
        }
    }
}














