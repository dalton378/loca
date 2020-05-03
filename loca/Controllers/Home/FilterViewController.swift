//
//  FilterViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/3/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import iOSDropDown

class FilterViewController: UIViewController {
    
    
    @IBOutlet weak var propertyType: DropDown!
    @IBOutlet weak var cost: DropDown!
    @IBOutlet weak var proType: DropDown!
    @IBOutlet weak var city: DropDown!
    @IBOutlet weak var district: DropDown!
    
    @IBOutlet weak var confirmButton: UIButton!
    let store = AlamofireStore()
    var delegate: FilterSelectionProtocol!
    var filterSelections = [FilterSelection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDropDownDataFromServer()
        prepareUI()
    }
    
    private func getDropDownDataFromServer(){
        getCities()
        getPropertyType()
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
                self.proType.prepareDropDown(optionArray: items, idArray: ids, completionHandler: {(text,id) in
                    self.filterSelections.append(FilterSelection(value: String(id), type: .propertyType))
                })
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
                self.city.prepareDropDown(optionArray: cityItems, idArray: cityIds, completionHandler: {(text,id) in
                    self.filterSelections.append(FilterSelection(value: String(id), type: .city))
                    self.getDistrictByProvince(id: String(id))
                })
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
                self.district.prepareDropDown(optionArray: items, idArray: ids, completionHandler: {(text,id) in
                    self.filterSelections.append(FilterSelection(value: String(id), type: .district))
                })
                
            case .failure:
                return
            }
        })
    }
    
    private func prepareUI() {
        setTransparentNavigationBar()
        confirmButton.layer.cornerRadius = 10
        
        propertyType.prepareDropDown(optionArray: ["Bán", "Cho thuê"], idArray: [1,2], completionHandler: {(text, id) in
            self.filterSelections.append(FilterSelection(value: String(id), type: .transType))
            switch id {
            case 1 :
                self.cost.prepareDropDown(optionArray: ["0 - 500 triệu", "500 triệu - 1 tỷ", "1 tỳ - 2 tỷ", "2 tỷ - 5 tỷ", "5 tỷ - 10 tỷ", ">10 tỷ"], idArray: [1,2,3,4,5,6], completionHandler: { (text, id) in
                    self.filterSelections.append(FilterSelection(value: String(id), type: .cost))
                })
            case 2:
                self.cost.prepareDropDown(optionArray: ["0 - 5 triệu", "5 triệu - 10 triệu", "10 triệu - 15 triệu", "15 triệu - 20 triệu", "20 triệu - 30 triệu", ">30 triệu"], idArray: [1,2,3,4,5,6], completionHandler: { (text, id) in
                    self.filterSelections.append(FilterSelection(value: String(id), type: .cost))
                })
            default:
                break
            }
        })
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate.getFilterSelection(selections: self.filterSelections)
    }
    
   
}

protocol FilterSelectionProtocol {
    func getFilterSelection(selections: [FilterSelection])
}

enum FilterType {
    case transType
    case cost
    case propertyType
    case district
    case city
}
struct FilterSelection {
    var value: String
    var type: FilterType
    
}
