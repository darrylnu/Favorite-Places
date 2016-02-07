//
//  ViewController.swift
//  Memorable Places
//
//  Created by Darryl Nunn on 2/7/16.
//  Copyright © 2016 Darryl Nunn. All rights reserved.
//

import UIKit
import MapKit

var pressedLat: CLLocationDegrees?
var pressedLon: CLLocationDegrees?

var activePoint = false

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    
    var locationManger = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        var uilgpr = UILongPressGestureRecognizer(target: self, action: "pressed:")
        
        uilgpr.minimumPressDuration = 2
        map.addGestureRecognizer(uilgpr)
        
        print("map loaded")
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var userLocation:CLLocation = locations[0]
        
        if pressedLon != nil && pressedLat != nil && activePoint {
            var latitude: CLLocationDegrees = pressedLat!
            var longitude: CLLocationDegrees = pressedLon!
            var latDelta: CLLocationDegrees = 0.5
            var lonDelta: CLLocationDegrees = 0.5
            var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            var region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: false)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = location
            map.addAnnotation(annotation)
            
            
        } else if !activePoint {
        var latitude: CLLocationDegrees = userLocation.coordinate.latitude
        var longitude: CLLocationDegrees = userLocation.coordinate.longitude
            var latDelta: CLLocationDegrees = 0.5
            var lonDelta: CLLocationDegrees = 0.5
            var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            var region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: false)
        }
      
    }
    
    func pressed(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            var touchPoint = gestureRecognizer.locationInView(map)
            var newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: map)
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            map.addAnnotation(annotation)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
                if error != nil {
                    print(error)
                }
                var title = ""
                
                if let placemarks: CLPlacemark = CLPlacemark(placemark: placemark![0]) {
                    
                    if placemarks.subThoroughfare != nil && placemarks.thoroughfare != nil {
                    
                    title = "\(placemarks.subThoroughfare!) \(placemarks.thoroughfare!)"
                    }
                }
                if title == "" {
                    title = "added \(NSDate())"
                }
                var annotation = MKPointAnnotation()
                annotation.title = title
                annotation.coordinate = newCoordinate
                self.map.addAnnotation(annotation)
                
                places.append(["name": title, "lat": "\(newCoordinate.latitude)", "lon": "\(newCoordinate.longitude)"])
                
            })
            
        }
    
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

