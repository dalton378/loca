//
//  HomeViewController.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let store = AlamofireStore()
    var apartmentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEmptyBackButton()
        addMarker()
        guard  let token = AppConfig.shared.accessToken else {
            return
        }
        print(token)
        getDataFromServer()
    }
    
    @IBAction func accountClick(_ sender: UIButton) {
        
        guard let isSignedIn = AppConfig.shared.isSignedIn else {return}
        switch isSignedIn {
        case true:
            performSegue(withIdentifier: "home_manage", sender: self)
        default:
            Messages.displaySignInMessage(completionHandler: getDataFromServer, navigateSignUpAction: {self.performSegue(withIdentifier: "signup_home", sender: self)}, navigateForgotPassAction: {self.performSegue(withIdentifier: "home_forgotPass", sender: self)})
        }
        
    }
    
    private func getDataFromServer() {
        getUser()
        getApartmentList()
    }
    
    private func getApartmentList() {
        store.getApartments(completionHandler: { result in
            switch result {
            case .success(let dataString):
                let parsedData = dataString.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentList.self, from: newData) else {return}
                AppConfig.shared.apartmentList = autParams
                self.addApartmentAnnotation(mapView: self.mapView, apartmentList: autParams)
            case .failure:
                return
            }
        })
    }
    
    private func getUser(){
        
        store.getUser(completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ProfileModel.self, from: newData) else {return}
                AppConfig.shared.profileName = autParams.name
                AppConfig.shared.profileId = autParams.id
                AppConfig.shared.profileEmail = autParams.email
                AppConfig.shared.profilePhone = autParams.phone
                AppConfig.shared.profileEmailVerified = autParams.is_email_verified
                AppConfig.shared.profilePhoneVerified = autParams.is_phone_verified
                
            case .failure:
                return
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func addMarker(){
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
        
        let defaultCoordinate = CLLocationCoordinate2D(latitude: Double(AppConstants.defaultLatitude)!, longitude: Double(AppConstants.defaultLongtitude)!)
        let annotation = MakerAnnotation(coordinate: defaultCoordinate, title: "", subTitle: "")
        
        
        mapView.setRegion(annotation.region, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func addApartmentAnnotation(mapView: MKMapView, apartmentList: ApartmentList){
        for apartment in apartmentList.data {
            let anotation = MakerAnnotation(coordinate: CLLocationCoordinate2D(latitude: (apartment.lat as NSString).doubleValue,  longitude: (apartment.lng as NSString).doubleValue), title: "", subTitle: "\(apartment.search_text)|\(apartment.id)")
            mapView.addAnnotation(anotation)
           
        }
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let selectedAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            selectedAnnotation.animatesWhenAdded = true
            selectedAnnotation.titleVisibility = .adaptive
            selectedAnnotation.subtitleVisibility = .adaptive
            
            let rightButton = UIButton(type: .contactAdd)
            rightButton.tag = annotation.hash
            //selectedAnnotation.animatesDrop = true
            selectedAnnotation.canShowCallout = false
            selectedAnnotation.rightCalloutAccessoryView = rightButton
            
            return selectedAnnotation
        }
        else {return nil}
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let selectedAnnotation = view.annotation as! MakerAnnotation
        guard let text = selectedAnnotation.subtitle else {return}
        let fulltextArr = text.split(separator: "|")
        apartmentId = String(fulltextArr[1])

        Messages.displayApartmentPreviewMessage(title: "Thông Tin", message: String(fulltextArr[0]), buttonAction: {
            self.performSegue(withIdentifier: "home_apartmentDetail", sender: self)})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home_apartmentDetail" {
            let view = segue.destination as! ApartmentDetailViewController
            view.apartmentId = apartmentId
        }else if segue.identifier == "home_apartmentFilter" {
            let view = segue.destination as! FilterViewController
            view.delegate = self
        }
    }
}


extension HomeViewController: FilterSelectionProtocol {
    func getFilterSelection(selections: [FilterSelection]) {
        print(selections)
    }
    
}
