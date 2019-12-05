//
//  DetailsViewController.swift
//  ejemplo2
//
//  Created by gdaalumno on 9/18/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleEvent: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var newTitle = String()
    var date = Date()
    var latitude = Double()
    var longitude = Double()
    
    override func viewWillAppear(_ animated: Bool) {
        titleEvent.text = newTitle
        updateMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(DetailsViewController.longpress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(lpgr)
        
        let tr = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.tap(gestureRecognizer:)))
        tr.numberOfTapsRequired = 3
        mapView.addGestureRecognizer(tr)
    }
    
    func updateMap() {
        var mapRegion = MKCoordinateRegion()
        
        let mapRegionSpan = 0.02
        mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan
        
        mapView.setRegion(mapRegion, animated: true)
        addAnnotationMap()
    }
    
    func addAnnotationMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = newTitle
        annotation.subtitle = formatDate(date)
        
        mapView.addAnnotation(annotation)
    }
    func formatDate(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let result = format.string(from: date)
        return result
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = newTitle
            annotation.subtitle = formatDate(date)
            
            mapView.addAnnotation(annotation)
            print("longpress activated")
        }
    }
    
    @objc func tap(gestureRecognizer: UIGestureRecognizer) {
        print("3 taps")
        mapView.removeAnnotations(mapView.annotations)
    }
}
