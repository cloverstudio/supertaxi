//
//  TaxiProfileMapViewController.swift
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

class TaxiProfileMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, DriverListDelegate, GetOpenOrdersDelegate  {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var mapView: MKMapView!
    
    let UserInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var locationManager: CLLocationManager!
    
    var lat: Double!
    var lon: Double!
    
    var getOrder: Bool = false
    
    var n = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserInformation.stringForKey(UserDetails.THUMBNAIL) != nil){
            avatar.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        avatar.layer.cornerRadius = avatar.frame.size.height/2
        avatar.clipsToBounds = true
        
        apiManager = ApiManager()
        apiManager.driversListDelegate = self
        apiManager.openOrderDelegate = self
        
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
    
    override func viewDidAppear(animated: Bool) {
        getOpenOrders()
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        centerMap(locValue)
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        apiManager.getDriverList(UserInformation.stringForKey(UserDetails.TOKEN)!, lat: lat, lon: lon)
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        
        lat = center.latitude
        lon = center.longitude
        
        apiManager.updateCoordinates(UserInformation.stringForKey(UserDetails.TOKEN)!, lat: lat, lon: lon)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "driver"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }

        anView!.image = UIImage(named: "black_car_icon")
        
        return anView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        
        return renderer
    }
    
    func onDriversListSucess(json: JSON) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        for driver in json.array! {
            let driverAnnotation = DriverAnnotation(title: driver["driver"]["name"].string!, coordinate: CLLocationCoordinate2D(latitude: driver["currentLocation"][1].double!, longitude: driver["currentLocation"][0].double!))
            mapView.addAnnotation(driverAnnotation)
            
        }
    
    }
    
    func onDriversListError(error: NSInteger) {
        
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
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
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
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            
            
        }
    
    }
    
    func getOpenOrders(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if (self.lat != nil && self.lon != nil){
                self.apiManager.getOpenOrder(self.UserInformation.stringForKey(UserDetails.TOKEN)!, lat: self.lat, lon: self.lon)
            }
            
        })
    }
    
    func onOpenOrderNoOrders() {
            getOpenOrders()
    }
    
    func onOpenOrderSuccess(json: JSON) {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxiRequestMapView") as? TaxiRequestFromUserViewController
        viewController!.json = json
        viewController!.lat = mapView.userLocation.coordinate.latitude
        viewController!.lon = mapView.userLocation.coordinate.longitude
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
    func onOpenOrderError(error: NSInteger) {
        
    }

}
