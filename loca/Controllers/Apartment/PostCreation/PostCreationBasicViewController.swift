//
//  PostCreationBasicViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/8/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class PostCreationBasicViewController: UIViewController {
    
    
    @IBOutlet weak var transTypeView: UIView!
    @IBOutlet weak var propertyTypeView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var districtView: UIView!
    @IBOutlet weak var wardView: UIView!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var numberAddressTextField: UITextField!
    @IBOutlet weak var squareUnitView: UIView!
    @IBOutlet weak var squareTextfield: UITextField!
    @IBOutlet weak var costunitView: UIView!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var transTypeText: UILabel!
    @IBOutlet weak var propertyTypeText: UILabel!
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var districtText: UILabel!
    @IBOutlet weak var wardText: UILabel!
    @IBOutlet weak var squareUnitText: UILabel!
    @IBOutlet weak var costUnitText: UILabel!
    @IBOutlet weak var confirmButto: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let customIndicator = CustomIndicator()
    
    private var propertyData: ListData?
    private var transData: ListData?
    private var cityData: ListData?
    private var districtData: ListData?
    private var wardData: ListData?
    private var currenciesData: ListData?
    private var areaUnitData: ListData?
    
    var delegate: PostCreationBasicProtocol?
    
    let store = AlamofireStore()
    var propertyString = ""; var tranString = ""; var cityString = ""; var districtString = ""; var wardString = ""; var squareUnitString = ""; var priceUnitString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()

    }
    
    @IBAction func showTransList(_ sender: Any) {
        guard let data = transData else {return}
        ListView.displayListView(view: transTypeView, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.transTypeText.text = text
            self.tranString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func shoPropertyList(_ sender: Any) {
        guard let data = propertyData else {return}
        ListView.displayListView(view: propertyTypeView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.propertyTypeText.text = text
            self.propertyString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showCityList(_ sender: Any) {
        guard let data = cityData else {return}
        ListView.displayListView(view: cityView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.cityText.text = text
            self.cityString = String(id)
            ListView.removeListView()
            self.getDistrictByProvince(id: String(id))
        })
    }
    
    
    @IBAction func districtList(_ sender: Any) {
        guard let data = districtData else {return}
        ListView.displayListView(view: districtView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.districtText.text = text
            self.districtString = String(id)
            self.getWardByDistrict(id: String(id))
            ListView.removeListView()
        })
    }
    
    @IBAction func showWardList(_ sender: Any) {
        guard let data = wardData else {return}
        ListView.displayListView(view: wardView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.wardText.text = text
            self.wardString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showSquareUnitList(_ sender: Any) {
        guard let data = areaUnitData else {return}
        ListView.displayListView(view: squareUnitView, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.squareUnitText.text = text
            self.squareUnitString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showCostUnitList(_ sender: Any) {
        guard let data = currenciesData else {return}
        
        ListView.displayListView(view: costunitView, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.costUnitText.text = text
            self.priceUnitString = String(id)
            ListView.removeListView()
        })
    }
    
    private func prepareUI(){
        customIndicator.addIndicator(view: self, alpha: 1)
        customIndicator.startIndicator(timeout: 5)
        getPropertyType()
        getCities()
        getCurrencies()
        getAreaUnit()
        getTransactionType()
        registerForKeyboardNotifications()
    }
    
    
    private func getPropertyType(){
           store.getPropertyType(completionHandler: {resut in
               switch resut{
               case .success(let data):
                   let parsedData = data.data(using: .utf8)
                   guard let newData = parsedData, let autParams = try! JSONDecoder().decode([PropertyType]?.self, from: newData) else {return}
                   var items = [String]()
                   var ids = [Int]()
                   for i in autParams {
                       items.append(i.name)
                       ids.append(i.id)
                   }
                   
                   self.propertyData = ListData(text: items, id: ids)
               case .failure:
                   return
               }
           })
       }
       
       private func getCities(){
           store.getProvinces(completionHandler: {resut in
               switch resut{
               case .success(let data):
                   let parsedData = data.data(using: .utf8)
                   guard let newData = parsedData, let autParams = try! JSONDecoder().decode(ProvinceList?.self, from: newData) else {return}
                   var cityItems = [String]()
                   var cityIds = [Int]()
                   for i in autParams.data {
                       cityItems.append(i.name)
                       cityIds.append(i.id)
                   }
                   
                   self.cityData = ListData.init(text: cityItems, id: cityIds)
               case .failure:
                   return
               }
           })
       }
       
       private func getDistrictByProvince(id: String) {
           store.getDistrictByProvince(id: id, completionHandler: {result in
               switch result {
               case .success(let data):
                   let parsedData = data.data(using: .utf8)
                   guard let newData = parsedData, let autParams = try! JSONDecoder().decode(DistrictList?.self, from: newData) else {return}
                   
                   var items = [String]()
                   var ids = [Int]()
                   for i in autParams.data {
                       items.append(i.name)
                       ids.append(i.id)
                   }
                   
                   self.districtData = ListData.init(text: items, id: ids)
               case .failure:
                   return
               }
           })
       }
    
    private func getWardByDistrict(id: String) {
        store.getWardByDisctrict(id: id, completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try! JSONDecoder().decode(DistrictList?.self, from: newData) else {return}
                
                var items = [String]()
                var ids = [Int]()
                for i in autParams.data {
                    items.append(i.name)
                    ids.append(i.id)
                }
                
                self.wardData = ListData.init(text: items, id: ids)
            case .failure:
                return
            }
        })
    }
    
    private func getCurrencies(){
        store.getCurrencies(completionHandler: {(result) in
            switch result{
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try! JSONDecoder().decode([CommonAPIReturn]?.self, from: newData) else {return}
                
                var items = [String]()
                var ids = [Int]()
                for i in autParams {
                    items.append(i.name)
                    ids.append(i.id)
                }
                self.currenciesData = ListData.init(text: items, id: ids)
            case .failure:
                return
            }
            
        })
    }
    
    private func getAreaUnit(){
        store.getAreaUnit(completionHandler: {(result) in
            switch result{
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try! JSONDecoder().decode([CommonAPIReturn]?.self, from: newData) else {return}
                
                var items = [String]()
                var ids = [Int]()
                for i in autParams {
                    items.append(i.name)
                    ids.append(i.id)
                }
                self.areaUnitData = ListData.init(text: items, id: ids)
            case .failure:
                return
            }
            
        })
    }
    
    private func getTransactionType(){
           store.getTransactionType(completionHandler: {(result) in
            self.customIndicator.stopIndicator()
               switch result{
               case .success(let data):
                   let parsedData = data.data(using: .utf8)
                   guard let newData = parsedData, let autParams = try! JSONDecoder().decode([CommonAPIReturn]?.self, from: newData) else {return}
                   
                   var items = [String]()
                   var ids = [Int]()
                   for i in autParams {
                       items.append(i.name)
                       ids.append(i.id)
                   }
                   self.transData = ListData.init(text: items, id: ids)
               case .failure:
                   return
               }
               
           })
       }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        delegate?.getBasicInfo(transType: tranString, proType: propertyString, city: cityString, district: districtString, ward: wardString, street: streetTextField.text!, unitNum: numberAddressTextField.text!, square: squareTextfield.text!, squareUnit: squareUnitString, price: costTextField.text!, priceUnit: priceUnitString, startDate: startDateTextField.text!, endDate: endDateTextField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
}
private struct ListData {
    var text: [String]
    var id: [Int]
}


extension PostCreationBasicViewController {
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}


protocol PostCreationBasicProtocol {
    func getBasicInfo(transType: String, proType: String, city: String, district: String, ward: String, street: String, unitNum: String, square: String, squareUnit: String, price: String, priceUnit: String, startDate: String, endDate: String)
}
