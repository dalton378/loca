//
//  PostCreationMapViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/5/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import TransitionButton

class PostCreationMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmButton: TransitionButton!
    
    var gestureRecognizer = UITapGestureRecognizer()
    var delegate : ApartmentPostLocationProtocol?
    
    var long = ""
    var lat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI(){
        TransitionButtonCustom.configureTransitionButton(button: confirmButton, tittle: "Hoàn Tất", tapHandler: nil)
        setEmptyBackButton()
        mapView.delegate = self
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        addMarker()
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        confirmButton.setTitle("", for: .normal)
        confirmButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
            self.confirmButton.spinnerColor = UIColor.clear
            self.delegate?.getLocation(long: self.long, lat: self.lat)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func addMarker(){
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let defaultCoordinate = CLLocationCoordinate2D(latitude: Double(AppConstants.defaultLatitude)!, longitude: Double(AppConstants.defaultLongtitude)!)
        let annotation = MakerAnnotation(coordinate: defaultCoordinate, title: "", subTitle: "")
        
        
        mapView.setRegion(annotation.region, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        removeAllAnnotations()
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        long = String(coordinate.longitude)
        lat = String(coordinate.latitude)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func removeAllAnnotations(){
        mapView.removeAnnotations(mapView.annotations)
    }
    
    final class MakerAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title : String?
        var subtitle: String?
        var region : MKCoordinateRegion {
            let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            return MKCoordinateRegion(center: coordinate, span: span)
        }
        
        init(coordinate : CLLocationCoordinate2D, title : String, subTitle : String) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subTitle
            super.init()
        }
    }
}

protocol ApartmentPostLocationProtocol {
    func getLocation(long: String, lat: String)
}
