//
//  FilterViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/3/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import TransitionButton

class FilterViewController: UIViewController {
    
    
    @IBOutlet weak var propertyType: UIView!
    @IBOutlet weak var cost: UIView!
    @IBOutlet weak var proType: UIView!
    @IBOutlet weak var city: UIView!
    @IBOutlet weak var district: UIView!
    @IBOutlet weak var confirmButton: TransitionButton!
    @IBOutlet weak var propertySelected: UILabel!
    @IBOutlet weak var costSelected: UILabel!
    @IBOutlet weak var proSelected: UILabel!
    @IBOutlet weak var citySelected: UILabel!
    @IBOutlet weak var districtSelected: UILabel!
    
    let store = AlamofireStore()
    var delegate: FilterSelectionProtocol!
    var filterSelections = [FilterSelection]()
    var itemView: ListViewCustom?
    
    private var propertyData: ListData?
    private var costData: ListData?
    private var proData: ListData?
    private var cityData: ListData?
    private var districtData: ListData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDropDownDataFromServer()
        prepareUI()
    }
    
    private func getDropDownDataFromServer(){
        getCities()
        getPropertyType()
    }
    
    @IBAction func dismissPopup(_ sender: UITapGestureRecognizer) {
        itemView?.removeFromSuperview()
    }
    
    @IBAction func showList(_ sender: UITapGestureRecognizer) {
        guard let data = propertyData else {return}
        displayListView(view: propertyType, listHeight: 100, text: data.text , id: data.id, selectionHandler: {(text,id) in
            self.propertySelected.text = text
            self.itemView?.removeFromSuperview()
            switch id {
            case 1:
                self.costData = ListData.init(text: ["0 - 500 triệu", "500 triệu - 1 tỷ", "1 tỳ - 2 tỷ", "2 tỷ - 5 tỷ", "5 tỷ - 10 tỷ", ">10 tỷ"], id: [1,2,3,4,5,6])
            case 2:
                self.costData = ListData.init(text: ["0 - 5 triệu", "5 triệu - 10 triệu", "10 triệu - 15 triệu", "15 triệu - 20 triệu", "20 triệu - 30 triệu", ">30 triệu"], id: [1,2,3,4,5,6])
            default:
                break
            }
        })
    }
    
    @IBAction func showCostList(_ sender: UITapGestureRecognizer) {
        guard let data = costData else {return}
        displayListView(view: cost, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.costSelected.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showProList(_ sender: Any) {
        guard let data = proData else {return}
        displayListView(view: proType, listHeight: 250, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.proSelected.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showDistrcitList(_ sender: Any) {
        guard let data = districtData else {return}
        displayListView(view: district, listHeight: 250, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.districtSelected.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showCityList(_ sender: Any) {
        guard let data = cityData else {return}
        displayListView(view: city, listHeight: 250, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.getDistrictByProvince(id: String(id))
            self.citySelected.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    private func displayListView(view: UIView, listHeight: Int, text: [String], id: [Int], selectionHandler: @escaping ((String, Int) -> Void) ){
        itemView?.removeFromSuperview()
        var y = view.frame.maxY
        
        if y + CGFloat(listHeight) > (view.superview?.frame.height)! {
            y = view.frame.minY - CGFloat(listHeight + 10)
        }
        itemView = ListViewCustom(frame: CGRect(x: view.frame.minX, y: y + 5, width: view.frame.width, height: CGFloat(listHeight)))
        itemView!.setData(data: text, ids: id, selectionHandler: selectionHandler)
        itemView?.addClearInAnimation()
        self.view.addSubview(itemView!)
        
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
                
                self.proData = ListData(text: items, id: ids)
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
    
    private func prepareUI() {
        setTransparentNavigationBar()
        TransitionButtonCustom.configureTransitionButton(button: confirmButton, tittle: "Lọc", tapHandler: nil)
        
        
        proType.layer.cornerRadius = 10
        proType.layer.borderWidth = 1
        proType.layer.borderColor = UIColor.init(named: "UBlack")?.cgColor
        
        propertyType.layer.cornerRadius = 10
        propertyType.layer.borderWidth = 1
        propertyType.layer.borderColor = UIColor.init(named: "UBlack")?.cgColor
        
        city.layer.cornerRadius = 10
        city.layer.borderWidth = 1
        city.layer.borderColor = UIColor.init(named: "UBlack")?.cgColor
        
        district.layer.cornerRadius = 10
        district.layer.borderWidth = 1
        district.layer.borderColor = UIColor.init(named: "UBlack")?.cgColor
        
        cost.layer.cornerRadius = 10
        cost.layer.borderWidth = 1
        cost.layer.borderColor = UIColor.init(named: "UBlack")?.cgColor
        
        propertyData = ListData.init(text: ["Bán", "Cho thuê"], id: [1,2])
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        confirmButton.startAnimation()
        self.confirmButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 3, completion: {})
        self.navigationController?.popViewController(animated: true)
        self.delegate.getFilterSelection(selections: self.filterSelections)
        
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

private struct ListData {
    var text: [String]
    var id: [Int]
}

