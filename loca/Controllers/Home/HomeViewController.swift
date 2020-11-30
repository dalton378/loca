//
//  HomeViewController.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var rentView: UIView!
    @IBOutlet weak var mapTypeButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!
    
    let store = AlamofireStore()
    var apartmentId = "", isNavigateToPhone = 0, fullAddress = "", selectedLocation = [Double]()
    var locationManager: CLLocationManager?
    let searchRequest = MKLocalSearch.Request()
    var addressDetail: AddressDetailSearch?
    var selectedAnnotations = [MKAnnotation]()
    var cancellable: AnyCancellable?
    
    var city = "", district = "", min_price = "", min_currency = "", max_price = "", max_currency = "", transaction = "", propertyType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDataFromServer()
    }
    
    private func setupUI(){
        setEmptyBackButton()
        addMarker()
        locationManager = CLLocationManager()
        let status = CLLocationManager.authorizationStatus()
        locationManager?.delegate = self
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
        
        mapView.showsCompass = false
        searchView.layer.cornerRadius = 30
        searchTextField.delegate = self
        accountImage.layer.cornerRadius = accountImage.frame.width/2
        
        [filterView,sellView,rentView].forEach({view in
            view.layer.cornerRadius = view.frame.height/2
        })
        mapTypeButton.layer.cornerRadius = mapTypeButton.frame.height/2
        myLocationButton.layer.cornerRadius = myLocationButton.frame.height/2
        
        self.cancellable = AppConfig.shared.publisherSignIn.sink(receiveValue: {isSignedIn in
            switch isSignedIn{
            case true:
                self.accountImage.image = sharedFunctions.imageWith(name: String(AppConfig.shared.profileName?.prefix(1) ?? "A"))
            case false:
                self.accountImage.image = UIImage(named: "user_icon")
            }
        })
        _ = AppConfig.shared.isSignedIn
        self.mapView.mapType = .satellite
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){
        self.mapView.removeAnnotations(self.selectedAnnotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        selectedAnnotations.append(annotation)
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        locationManager?.startUpdatingLocation()
    }
    
    private func getDataFromServer() {
        getApartmentList()
        guard  let _ = AppConfig.shared.accessToken else {
            return
        }
        getUserData()
    }
    
    private func getUserData(){
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
                AppConfig.shared.isSignedIn = true
            case .failure:
                return
            }
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        ListView.removeListView()
    }
    
    
    @IBAction func changeMapTypeTap(_ sender: UIButton) {
        switch mapTypeButton.isSelected {
        case true:
            mapTypeButton.setImage(UIImage(systemName: "map"), for: .normal)
            self.mapView.mapType = .satellite
        default:
            mapTypeButton.setImage(UIImage(systemName: "gyroscope"), for: .normal)
            self.mapView.mapType = .mutedStandard
        }
        mapTypeButton.isSelected = !mapTypeButton.isSelected
    }
    
    @IBAction func sellViewTap(_ sender: Any) {
        sellView.backgroundColor = UIColor.darkGray
        rentView.backgroundColor = UIColor.white
        store.searchApartment(token: AppConfig.shared.accessToken ?? "", post_type_id: "1", min_price: "", min_currency: "", max_price: "", max_currency: "", property_type_id: "", province_id: "", district_id: "", completionHandler: {result in
                                switch result {
                                case .success(let dataString):
                                    let parsedData = dataString.data(using: .utf8)
                                    guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentList.self, from: newData) else {return}
                                    AppConfig.shared.apartmentList = autParams
                                    self.addApartmentAnnotation(mapView: self.mapView, apartmentList: autParams)
                                case .failure:
                                    return
                                }})
    }
    
    @IBAction func rentViewTap(_ sender: Any) {
        sellView.backgroundColor = UIColor.white
        rentView.backgroundColor = UIColor.darkGray
        store.searchApartment(token: AppConfig.shared.accessToken ?? "", post_type_id: "2", min_price: "", min_currency: "", max_price: "", max_currency: "", property_type_id: "", province_id: "", district_id: "", completionHandler: {result in
                                switch result {
                                case .success(let dataString):
                                    let parsedData = dataString.data(using: .utf8)
                                    guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentList.self, from: newData) else {return}
                                    AppConfig.shared.apartmentList = autParams
                                    self.addApartmentAnnotation(mapView: self.mapView, apartmentList: autParams)
                                case .failure:
                                    return
                                }})
    }
    
    
    @IBAction func myLocationTap(_ sender: UIButton) {
        self.locationManager?.startUpdatingLocation()
    }
    
    @IBAction func filterTap(_ sender: Any) {
        sellView.backgroundColor = UIColor.white
        rentView.backgroundColor = UIColor.white
        self.performSegue(withIdentifier: "home_apartmentFilter", sender: self)
    }
    
    
    @IBAction func accountTap(_ sender: Any) {
        guard let isSignedIn = AppConfig.shared.isSignedIn else {return}
        switch isSignedIn {
        case true:
            self.performSegue(withIdentifier: "home_manage", sender: self)
        default:
            Messages.displaySignInMessage(completionHandler: self.getDataFromServer, navigateSignUpAction: {self.performSegue(withIdentifier: "signup_home", sender: self)}, navigateForgotPassAction: {self.performSegue(withIdentifier: "home_forgotPass", sender: self)}, navigateGGsignInAction: {self.performSegue(withIdentifier: "google_signin", sender: self)}, fbSignInAction: self.FBcompletionAction)
        }
    }
    
    func addMarker(){
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        let defaultCoordinate = CLLocationCoordinate2D(latitude: Double(AppConstants.defaultLatitude)!, longitude: Double(AppConstants.defaultLongtitude)!)
        let annotation = MakerAnnotation(coordinate: defaultCoordinate, title: "", subTitle: "", icon: UIImage())
        
        mapView.setRegion(annotation.region, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func addApartmentAnnotation(mapView: MKMapView, apartmentList: ApartmentList){
        mapView.removeAnnotations(mapView.annotations)
        for apartment in apartmentList.data {
            var icon: UIImage?
            apartment.post_type_id == 1 ? (icon = UIImage(named: "loca_pin_icon")) : (icon = UIImage(named: "loca_blue_pin_icon"))
            let anotation = MakerAnnotation(coordinate: CLLocationCoordinate2D(latitude: (apartment.lat as NSString).doubleValue,  longitude: (apartment.lng as NSString).doubleValue), title: "", subTitle: "\(apartment.search_text)|\(apartment.id)", icon: icon ?? UIImage())
            mapView.addAnnotation(anotation)
            
        }
    }
    
    class MakerAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title : String?
        var subtitle: String?
        var region : MKCoordinateRegion {
            let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            return MKCoordinateRegion(center: coordinate, span: span)
        }
        var icon: UIImage
        init(coordinate : CLLocationCoordinate2D, title : String, subTitle : String, icon: UIImage) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subTitle
            self.icon = icon
            super.init()
        }
    }
    
    func FBcompletionAction(){
        sharedFunctions.getUserInfo(completionHandler: {
            guard let _ = AppConfig.shared.profilePhone else {
                if self.isNavigateToPhone == 0 {
                    self.performSegue(withIdentifier: "home_phonenumber", sender: self)
                    self.isNavigateToPhone = 1
                }
                return
            }
        })
    }
    
    func displayPostCreation(address: String){
        Messages.displayYesNoMessage(title: "Đăng Tin", message: address, buttonText: "+ Bán/Cho Thuê", buttonAction: {
            guard let isVerified = AppConfig.shared.profilePhoneVerified, let isSignIn = AppConfig.shared.isSignedIn else { return}
            if isSignIn == false {
                Messages.displayErrorMessage(message: "Vui lòng đăng nhập trước khi đăng tin!")
            }
            else if isVerified == 0 {
                Messages.displayErrorMessage(message: "Tài khoản chưa xác thực. Vui lòng xác thực!")
            } else {
                self.store.searchAddressDetail(address: address, completionHandler: {result in
                    switch result {
                    case .success(let dataString):
                        let parsedData = dataString.data(using: .utf8)
                        guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AddressDetailSearch.self, from: newData) else {return}
                        self.addressDetail = autParams
                        self.performSegue(withIdentifier: "home_apartmentcreation", sender: self)
                    case .failure:
                        Messages.displayErrorMessage(message: "Lỗi. Vui lòng thử lại sau!")
                        return
                    }
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home_apartmentDetail" {
            let view = segue.destination as! ApartmentDetailViewController
            view.apartmentId = apartmentId
        }else if segue.identifier == "home_apartmentFilter" {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
            view.window!.layer.add(transition, forKey: kCATransition)
            let view = segue.destination as! FilterViewController
            view.delegate = self
        }
        else if segue.identifier == "google_signin" {
            let view = segue.destination as! GoogleSigninViewController
            view.getData = self.getDataFromServer
        }
        else if segue.identifier == "home_apartmentcreation" {
            let view = segue.destination as! CreateApartmentPostViewController
            var passedData = ApartmentPostCreation()
            passedData.lat = self.addressDetail?.lat ?? 0
            passedData.lng = self.addressDetail?.lng ?? 0
            passedData.street = self.addressDetail?.street ?? ""
            passedData.apartment_number = self.addressDetail?.apartment_number ?? 0
            passedData.ward_id = self.addressDetail?.ward.id ?? 0
            passedData.district_id = self.addressDetail?.district.id ?? 0
            passedData.province_id = self.addressDetail?.province.id ?? 0
            view.data = passedData
            view.operation = .create
        }
    }
    
    private func searchByDragDrop(coordinate: CLLocationCoordinate2D){
        self.addressDetail = nil
        self.view.endEditing(true)

       //  Add annotation:
        let annotation = MKPointAnnotation()
       
        store.searchAddressByLocation(long: coordinate.longitude, lat: coordinate.latitude, completionHandler: { [self]result in
            switch result{
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AddressDetailSearch.self, from: newData) else {
                    Messages.displayErrorMessage(message: "Lỗi. Vui lòng thử lại sau!")
                    return
                }
                self.addressDetail = autParams
                annotation.coordinate = coordinate
                selectedAnnotations.append(annotation)
                self.mapView.addAnnotation(annotation)
                selectAnnotation(annotation: annotation)
            case .failure:
                Messages.displayErrorMessage(message: "Lỗi. Vui lòng thử lại sau!")
            }
        })
    }
    
    private func selectAnnotation(annotation: MKAnnotation){
        ListView.removeListView()
        guard let selectedAnnotation = annotation as? MakerAnnotation else {
            guard let detail = self.addressDetail  else { return }
            displayPostCreation(address: detail.address)
            return}
        guard let text = selectedAnnotation.subtitle else {return}
        let fulltextArr = text.split(separator: "|")
        apartmentId = String(fulltextArr[1])
        Messages.displayApartmentPreviewMessage(title: "Thông Tin", message: String(fulltextArr[0]), buttonAction: {
                                                    self.performSegue(withIdentifier: "home_apartmentDetail", sender: self)})
    }
}

extension HomeViewController: FilterSelectionProtocol {
    
    private func generateFromCostID(cost: String, min_price: inout String, min_currency: inout String, max_price: inout String, max_currency: inout String){
        
        switch cost {
        case "1":
            min_price = "0"; min_currency = "trieu"; max_price = "500"; max_currency = "trieu"
        case "2":
            min_price = "500"; min_currency = "trieu"; max_price = "1"; max_currency = "ty"
        case "3":
            min_price = "1"; min_currency = "ty"; max_price = "2"; max_currency = "ty"
        case "4":
            min_price = "2"; min_currency = "ty"; max_price = "5"; max_currency = "ty"
        case "5":
            min_price = "5"; min_currency = "ty"; max_price = "10"; max_currency = "ty"
        case "6":
            min_price = "10"; min_currency = "ty"
        case "7":
            min_price = "0"; min_currency = "trieu"; max_price = "5"; max_currency = "trieu"
        case "8":
            min_price = "5"; min_currency = "trieu"; max_price = "10"; max_currency = "trieu"
        case "9":
            min_price = "10"; min_currency = "trieu"; max_price = "15"; max_currency = "trieu"
        case "10":
            min_price = "15"; min_currency = "trieu"; max_price = "20"; max_currency = "trieu"
        case "11":
            min_price = "20"; min_currency = "trieu"; max_price = "30"; max_currency = "trieu"
        case "12":
            min_price = "30"; min_currency = "trieu"
        default:
            return
        }
    }
    
    func getFilterSelection(selections: [FilterSelection]) {
        city = ""; district = ""; min_price = ""; min_currency = ""; max_price = ""; max_currency = ""; transaction = ""; propertyType = ""
        for section in selections {
            switch section.type {
            case .city:
                city = section.value
            case .district:
                district = section.value
            case .transType:
                transaction = section.value
            case .propertyType:
                propertyType = section.value
            case .cost :
                generateFromCostID(cost: section.value, min_price: &min_price, min_currency: &min_currency, max_price: &max_price, max_currency: &max_currency)
            }
        }
        let token = AppConfig.shared.accessToken ?? ""
        store.searchApartment(token: token, post_type_id: transaction, min_price: min_price, min_currency: min_currency, max_price: max_price, max_currency: max_currency, property_type_id: propertyType, province_id: city, district_id: district, completionHandler: { result in
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
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text  else {return true}
        if text.count > 3 {
            self.searchIndicator.startAnimating()
            searchAddress(address: text)
        }
        return true
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        self.selectedLocation.append(lat)
        self.selectedLocation.append(lon)
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            let addressString = "\(pm.subThoroughfare ?? "") \(pm.thoroughfare ?? ""), \(pm.subLocality ?? ""), \(pm.subAdministrativeArea ?? ""), \(pm.locality ?? ""), \(pm.country ?? "")"
                                            print(addressString)
                                            self.fullAddress = addressString
                                        }
                                    })
        
    }
    
    private func searchAddress(address: String){
        store.searchAddress(address: address, completionHandler: {result in
            self.searchIndicator.stopAnimating()
            switch result {
            case .success(let dataString):
                let parsedData = dataString.data(using: .utf8)
                guard let newData = parsedData, let autParams = try! JSONDecoder().decode(SearchAddressList?.self, from: newData) else {return}
                
                var listItem = [String]()
                var ids = [Int]()
                guard let datas = autParams.data else {return}
                for item in datas {
                    listItem.append(item.search_text)
                    ids.append(item.id ?? 0)
                }
                
                ListView.displayListView(view: self.searchView, listHeight: 150, text: listItem, id: ids, selectionHandler: {(a,b) in
                    ListView.removeListView()
                    self.view.endEditing(true)
                    self.store.searchAddressDetail(address: a, completionHandler: {result in
                        switch result {
                        case .success(let dataString):
                            let parsedData = dataString.data(using: .utf8)
                            guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AddressDetailSearch.self, from: newData) else {return}
                            self.addressDetail = autParams
                            guard let lat = autParams.lat, let long = autParams.lng else {
                                Messages.displayErrorMessage(message: "Lỗi. Vui lòng thử lại sau!")
                                return
                            }
                            self.dropPinZoomIn(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D.init(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: long)!)))
                        case .failure:
                            Messages.displayErrorMessage(message: "Lỗi. Vui lòng thử lại sau!")
                            return
                        }
                    })
                    
                })
            case .failure:
                Messages.displayErrorMessage(message: "Lỗi. Vui lòng thử lại sau!")
                return
            }
        })
    }
}

//MARK: Mapview delegates
extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .ending, .canceling:
            guard let annotation = view.annotation else {return}
            mapView.removeAnnotations(self.selectedAnnotations)
            searchByDragDrop(coordinate: annotation.coordinate)
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let selectedAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            selectedAnnotation.markerTintColor = .clear
            selectedAnnotation.glyphTintColor = .clear
            if let custom = annotation as? MakerAnnotation {
                selectedAnnotation.image = custom.icon
            } else {
                selectedAnnotation.image = UIImage(named: "loca_pin") ?? UIImage()
            }
            
            selectedAnnotation.canShowCallout = true
            selectedAnnotation.isDraggable = true
            selectedAnnotation.animatesWhenAdded = true
            
            return selectedAnnotation
        }
        else {return nil}
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {return}
        selectAnnotation(annotation: annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            self.getAddressFromLatLon(pdblLatitude: String(location.coordinate.latitude), withLongitude: String(location.coordinate.longitude))
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
        locationManager?.stopUpdatingLocation()
    }
}
