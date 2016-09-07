//
//  RateView.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 30/08/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import UIKit
import MapKit

protocol RateViewDelegate {
    func onDriveRated()
    func onDriveRatedError()
}

class RateView: UIView, MKMapViewDelegate, RateDelegate {
    
    var view:UIView!
    
    @IBOutlet var mainBackView: UIView!
    @IBOutlet var name: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var oneStar: UIButton!
    @IBOutlet var twoStars: UIButton!
    @IBOutlet var threeStars: UIButton!
    @IBOutlet var fourStars: UIButton!
    @IBOutlet var fiveStars: UIButton!
    
    var nameText: String!
    var start: CLLocationCoordinate2D!
    var end: CLLocationCoordinate2D!
    var imageFile: String!
    var type: NSInteger!
    var id: String!
    
    let userInformation = NSUserDefaults.standardUserDefaults()
    var apiManager: ApiManager!
    
    var rateViewDelegate: RateViewDelegate!
    
    init(frame: CGRect, name: String, start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, type: NSInteger, image: String, id: String) {
        super.init(frame: frame)
        
        self.nameText = name
        self.start = start
        self.end = end
        self.imageFile = image
        self.type = type
        self.id = id
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func loadViewFromNib() {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RateView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.backgroundColor = Colors.greyBorder(0.7)
        self.addSubview(view)
        
        mapView.delegate = self
        apiManager = ApiManager()
        apiManager.rateDelegate = self
        apiManager.rateDelegate = self

        mainBackView.layer.cornerRadius = 10
        mainBackView.clipsToBounds = true
        name.text = nameText
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Weekday], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let day = components.weekday
        
        let dayOfWeek: String = dayOfTheWeek(day)!
        
        time.text = dayOfWeek  + ", " + String(hour) + ":" + String(minutes)
        
        if (imageFile != nil){
            if type == 1 {
                image.load(Api.IMAGE_URL + imageFile, placeholder: UIImage(named: "user"))
            } else {
                image.load(Api.IMAGE_URL + imageFile, placeholder: UIImage(named: "taxi_driver"))
            }
            
        }
        
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        
        createRoute(start, endLocation: end)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        
        return renderer
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
            
            self.mapView.zoomEnabled = false
            self.mapView.rotateEnabled = false
            self.mapView.scrollEnabled = false
            self.mapView.pitchEnabled = false
        }
        
    }
    
    func dayOfTheWeek(day: NSInteger) -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Satudrday,"
        ]
        
        return weekdays[day -  1]
    }
    
    
    @IBAction func oneStarBtn(sender: AnyObject) {
        oneStar.setImage(UIImage(named: "star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: id, type: type, rate: 1)
    }
    
    @IBAction func twoStarBtn(sender: AnyObject) {
        oneStar.setImage(UIImage(named: "star_active"), forState: .Normal)
        twoStars.setImage(UIImage(named: "small_star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: id, type: type, rate: 2)
    }
    
    @IBAction func threeStarBtn(sender: AnyObject) {
        oneStar.setImage(UIImage(named: "star_active"), forState: .Normal)
        twoStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        threeStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: id, type: type, rate: 3)
    }
    
    @IBAction func fourStarBtn(sender: AnyObject) {
        oneStar.setImage(UIImage(named: "star_active"), forState: .Normal)
        twoStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        threeStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        fourStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: id, type: type, rate: 4)
    }
    
    @IBAction func fiveStarBtn(sender: AnyObject) {
        oneStar.setImage(UIImage(named: "star_active"), forState: .Normal)
        twoStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        threeStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        fourStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        fiveStars.setImage(UIImage(named: "star_active"), forState: .Normal)
        
        apiManager.rateProfile(userInformation.stringForKey(UserDetails.TOKEN)!, id: id, type: type, rate: 5)
    }
    
    func onRateSuccess() {
        rateViewDelegate.onDriveRated()
    }
    
    func onRateError() {
        rateViewDelegate.onDriveRatedError()
    }
    
}
