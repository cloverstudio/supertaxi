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
    
    let UserInformation = UserDefaults.standard
    var apiManager: ApiManager!
    
    var locationManager: CLLocationManager!
    
    var lat: Double!
    var lon: Double!
    
    var getOrder: Bool = false
    
    var n = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserInformation.string(forKey: UserDetails.THUMBNAIL) != nil){
            avatar.load(URL(string: Api.IMAGE_URL + UserInformation.string(forKey: UserDetails.THUMBNAIL)!))
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
            mapView.setCenter(coor, animated: true)
        }
        
        mapView.showsUserLocation = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getOpenOrders()
    }
    
    @IBAction func menuButton(_ sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        centerMap(locValue)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        apiManager.getDriverList(UserInformation.string(forKey: UserDetails.TOKEN)!, lat: lat, lon: lon)
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        
        lat = center.latitude
        lon = center.longitude
        
        apiManager.updateCoordinates(UserInformation.string(forKey: UserDetails.TOKEN)!, lat: lat, lon: lon)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "driver"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        
        return renderer
    }
    
    func onDriversListSucess(_ json: JSON) {
        mapView.removeAnnotations(mapView.annotations)
        
        for driver in json.array! {
            if let title = driver["driver"]["name"].string
                , let latitude =  driver["currentLocation"][1].double
                , let longitude = driver["currentLocation"][0].double {
            
                let driverAnnotation = DriverAnnotation(title: title, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                mapView.addAnnotation(driverAnnotation)
            }
        }
    
    }
    
    func onDriversListError(_ error: NSInteger) {
        
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
            
            
        }
    
    }
    
    func getOpenOrders(){
        DispatchQueue.global(qos: .default).async(execute: {
            if (self.lat != nil && self.lon != nil){
                self.apiManager.getOpenOrder(self.UserInformation.string(forKey: UserDetails.TOKEN)!, lat: self.lat, lon: self.lon)
            }
            
        })
    }
    
    func onOpenOrderNoOrders() {
            getOpenOrders()
    }
    
    func onOpenOrderSuccess(_ json: JSON) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaxiRequestMapView") as? TaxiRequestFromUserViewController
        viewController!.json = json
        viewController!.lat = mapView.userLocation.coordinate.latitude
        viewController!.lon = mapView.userLocation.coordinate.longitude
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
    func onOpenOrderError(_ error: NSInteger) {
        
    }

}
