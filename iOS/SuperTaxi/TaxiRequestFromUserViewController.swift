//
//  TaxiRequestFromUserViewController.swift
//  SuperTaxi
//
//  Created by Administrator on 6/24/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import ObjectMapper

class TaxiRequestFromUserViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, AcceptOrderDelegate, OrderStatusDelegate {
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var txtName: UILabel!
    @IBOutlet var txtStreet: UILabel!
    @IBOutlet var txtCity: UILabel!
    
    var locationManager: CLLocationManager!
    let UserInformation = UserDefaults.standard
    var apiManager: ApiManager!
    
    var json: JSON!
    
    var from: CLLocationCoordinate2D!
    var to: CLLocationCoordinate2D!
    
    var lat: Double!
    var lon: Double!
    
    var orderId: String!
    var userId: String!
    
    var userFileId: String!
    var userName: String!
    var userAge: NSInteger!
    var userNote: String!
    var userAddressFrom: String!
    var userAddressTo: String!
    
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
            mapView.setCenter(coor, animated: true)
        }
        
        mapView.showsUserLocation = true;
        
        apiManager = ApiManager()
        apiManager.acceptOrderDelegate = self
        apiManager.orderStatusDelegate = self
        
        orderId = json["data"]["order"]["_id"].string
        userId = json["data"]["order"]["user"]["_id"].string
        
        getOrderStatus()
        
        txtStreet.text = "From: " + json["data"]["order"]["from"]["address"].string!
        txtCity.text = "To: " + json["data"]["order"]["to"]["address"].string!
        
        if (json["data"]["order"]["user"] != JSON.null) {
            
            userName = json["data"]["order"]["user"]["user"]["name"].string!
            userAge = json["data"]["order"]["user"]["user"]["age"].int!
            userNote = json["data"]["order"]["user"]["user"]["note"].string!
            txtName.text = userName
            
            if (json["data"]["order"]["user"]["avatar"].exists()){
                userFileId = json["data"]["order"]["user"]["avatar"]["fileid"].string!
                avatar.load(URL(string: Api.IMAGE_URL + userFileId), placeholderImage: UIImage(named: "user"))
            }
        }
        
        avatar.layer.cornerRadius = avatar.frame.size.height/2
        avatar.clipsToBounds = true
        
        userAddressFrom = json["data"]["order"]["from"]["address"].string!
        userAddressTo = json["data"]["order"]["to"]["address"].string!
        
        from = CLLocationCoordinate2D(latitude: json["data"]["order"]["from"]["location"][1].double!, longitude: json["data"]["order"]["from"]["location"][0].double!)
        to = CLLocationCoordinate2D(latitude: json["data"]["order"]["to"]["location"][1].double!, longitude: json["data"]["order"]["to"]["location"][0].double!)
        
        createRoute(from, endLocation: to)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIAction Methods
    @IBAction func onIgnoreClick(_ sender: AnyObject) {
        apiManager.cancelOrder(UserInformation.string(forKey: UserDetails.TOKEN)!, id: self.orderId, type: 2, reason: "Neznam jos")
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAcceptClick(_ sender: AnyObject) {
        apiManager.acceptOrder(UserInformation.string(forKey: UserDetails.TOKEN)!, orderId: self.orderId)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        
        return renderer
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
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
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
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    func onAcceptORderSuccess() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaxiUserLocationID") as? TaxiUserLocationViewController
        viewController!.from = from
        viewController!.to = to
        viewController!.driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        viewController!.userName = userName
        viewController!.userAge = userAge
        viewController!.userNote = userNote
        viewController!.userFileId = userFileId
        viewController!.userAddressFrom = userAddressFrom
        viewController!.userAddressTo = userAddressTo
        viewController!.orderId = orderId
        viewController!.userId = userId
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func onAcceptOrderError(_ error: NSInteger) {
        print("error")
    }
    
    func getOrderStatus(){
        
        DispatchQueue.global(qos: .default).async(execute: {
            self.apiManager.getOrderStatus(self.UserInformation.string(forKey: UserDetails.TOKEN)!, orderId: self.orderId)
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
        
        if(json["data"]["cancelType"].number == 1){
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaxiProfileMapVC") as? TaxiProfileMapViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
            
            let alert = UIAlertController(title: "Info", message: "User canceled!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaxiProfileMapVC") as? TaxiProfileMapViewController
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
    }
    
    func onOrderSrarusStartedDrive(_ json: JSON){
        
    }
    
    func onOrderStatusDriveEnded(_ json: JSON){
        
    }

}
