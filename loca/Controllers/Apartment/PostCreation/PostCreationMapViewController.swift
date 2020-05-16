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
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextFiled: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    var long = ""
    var lat = ""
    let searchRequest = MKLocalSearch.Request()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func searchAddress(_ sender: UIButton) {
        let address = searchTextFiled.text!
        searchAdressByText(text: address)
    }
    
    private func searchAdressByText(text: String){
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = mapView.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            var listItem = [String]()
            var ids = [Int]()
            var i = 0
            for item in response.mapItems {
                print(item.phoneNumber ?? "No phone number.")
                listItem.append(item.name!)
                
                ids.append(i)
                i+=1
            }
            
            ListView.displayListView(view: self.searchView, listHeight: 150, text: listItem, id: ids, selectionHandler: {(a,b) in
                ListView.removeListView()
                self.dropPinZoomIn(placemark: response.mapItems[b].placemark)
                
            })
        }
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        //selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    private func prepareUI(){
        TransitionButtonCustom.configureTransitionButton(button: confirmButton, tittle: "Hoàn Tất", tapHandler: nil)
        setEmptyBackButton()
        mapView.delegate = self
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        addMarker()
        searchTextFiled.layer.cornerRadius = 10
        searchTextFiled.delegate = self
       
       
    }
    
    @IBAction func back(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
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


extension PostCreationMapViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text  else {return true}
        if text.count > 3 {
            searchAdressByText(text: text)
        }
        return true
    }
}
