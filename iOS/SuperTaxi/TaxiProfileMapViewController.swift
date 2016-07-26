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

class TaxiProfileMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, DriverListDelegate  {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var mapView: MKMapView!
    
    let UserInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var locationManager: CLLocationManager!
    
    var lat: Double!
    var lon: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserInformation.stringForKey(UserDetails.THUMBNAIL) != ""){
            avatar.load(Api.IMAGE_URL + UserInformation.stringForKey(UserDetails.THUMBNAIL)!)
        }
        
        apiManager = ApiManager()
        apiManager.driversListDelegate = self
        
        avatar.layer.cornerRadius = avatar.frame.size.height/2
        avatar.clipsToBounds = true
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationReuseId = "driver"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else if (annotation is DriverAnnotation){
            anView!.annotation = annotation
        }
        
        if annotation is DriverAnnotation {
            anView!.image = UIImage(named: "map_car")
            anView!.backgroundColor = UIColor.clearColor()
        } else {
            anView?.image = UIImage(named: "location_pin")
        }
        
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
            let driverAnnotation = DriverAnnotation(title: driver["driver"]["name"].string!, coordinate: CLLocationCoordinate2D(latitude: driver["currentLocation"][1].double!, longitude: driver["currentLocation"][0].double!), info: "Taxi")
            mapView.addAnnotation(driverAnnotation)
            
        }
    }
    
    func onDriversListError(error: NSInteger) {
        
    }
    
    func createRoute(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        
//        // 2.
//        let sourceLocation = CLLocationCoordinate2D(latitude: 45.815956, longitude: 15.956540)
//        let destinationLocation = CLLocationCoordinate2D(latitude: 45.801506, longitude: 16.013786)
        
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
