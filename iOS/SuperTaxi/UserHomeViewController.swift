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

class UserHomeViewController: UIViewController, UIApplicationDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    
    @IBOutlet weak var lblCars: UILabel!
    @IBOutlet weak var lblKilometre: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnOneSeat: UIButton!
    @IBOutlet weak var btnTwoSeat: UIButton!
    @IBOutlet weak var btnThreeSeat: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewSeat: UIView!
    @IBOutlet weak var viewOneSeat: UIView!
    @IBOutlet weak var viewTwoSeat: UIView!
    @IBOutlet weak var viewThreeSeat: UIView!
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var flag: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Draw route between two points/locations
        // 1.
        mapView.delegate = self
        
        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: 45.8106045, longitude: 15.9887504)
        let destinationLocation = CLLocationCoordinate2D(latitude: 45.8137528, longitude: 15.9592461)
        
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
        
        // SlideMenu Viewcontroller
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // left and right bar buttonitem event
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        //set image for button
        button.setImage(UIImage(named: "image1.png"), forState: UIControlState.Normal)
        //set frame
        button.frame = CGRectMake(60, 0, 30, 30)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.blackColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 248/255.0, green: 244/255.0, blue: 236/255.0, alpha: 1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MapView related Methods
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 57/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        
        return renderer
    }
    
    // MARK: - UIAction Methods
    @IBAction func onNextClick(sender: AnyObject) {
        
        if !flag {
            viewRequest.hidden = false
            viewSeat.hidden = true
            viewBottom.hidden = true
        } else {
        
            viewSeat.hidden = false
            btnNext.setImage(UIImage(named: "btn_next_blur.png"), forState: .Normal)
            btnNext.enabled = false
        
            mapView.alpha = 0.3
            mapView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        }

    }
    
    // MARK: - SeatView UIButton Action Methods
    @IBAction func onSeatOneClick(sender: AnyObject) {
        
        imgOne.image = UIImage(named: "check.png")
        imgTwo.image = UIImage(named: "")
        imgThree.image = UIImage(named: "")
        
        viewOneSeat.alpha = 1.0
        viewTwoSeat.alpha = 0.4
        viewThreeSeat.alpha = 0.4
        
        btnTwoSeat.enabled = false
        btnThreeSeat.enabled = false
        
        btnNext.enabled = true
        btnNext.setImage(UIImage(named: "btn_next.png"), forState: .Normal)
        
        flag = false
    }
    
    @IBAction func onSeatTwoClick(sender: AnyObject) {
        
        imgOne.image = UIImage(named: "")
        imgTwo.image = UIImage(named: "check.png")
        imgThree.image = UIImage(named: "")
        
        viewOneSeat.alpha = 0.4
        viewTwoSeat.alpha = 1.0
        viewThreeSeat.alpha = 0.4
        
        btnOneSeat.enabled = false
        btnThreeSeat.enabled = false
        
        btnNext.enabled = true
        btnNext.setImage(UIImage(named: "btn_next.png"), forState: .Normal)
    }
    
    @IBAction func onSeatThreeClick(sender: AnyObject) {
        
        imgOne.image = UIImage(named: "")
        imgTwo.image = UIImage(named: "")
        imgThree.image = UIImage(named: "check.png")
        
        viewOneSeat.alpha = 0.4
        viewTwoSeat.alpha = 0.4
        viewThreeSeat.alpha = 1.0
        
        btnOneSeat.enabled = false
        btnTwoSeat.enabled = false
        
        btnNext.enabled = true
        btnNext.setImage(UIImage(named: "btn_next.png"), forState: .Normal)
    }
    
}