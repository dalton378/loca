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
    
    private var propertyData: ListData?
    private var transData: ListData?
    private var cityData: ListData?
    private var districtData: ListData?
    
    var itemView: ListViewCustom?
    
    let store = AlamofireStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()

    }
    
    @IBAction func showTransList(_ sender: Any) {
        guard let data = transData else {return}
        displayListView(view: transTypeView, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.transTypeText.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func shoPropertyList(_ sender: Any) {
        guard let data = propertyData else {return}
        displayListView(view: propertyTypeView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.propertyTypeText.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showCityList(_ sender: Any) {
        guard let data = cityData else {return}
        displayListView(view: cityView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.cityText.text = text
            self.itemView?.removeFromSuperview()
            self.getDistrictByProvince(id: String(id))
        })
    }
    
    
    @IBAction func districtList(_ sender: Any) {
        guard let data = districtData else {return}
        displayListView(view: districtView, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.districtText.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showWardList(_ sender: Any) {
        
    }
    
    @IBAction func showSquareUnitList(_ sender: Any) {
        displayListView(view: squareUnitView, listHeight: 100, text: ["m2"], id: [1], selectionHandler: {(text,id) in
            self.squareUnitText.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showCostUnitList(_ sender: Any) {
        displayListView(view: costunitView, listHeight: 100, text: ["tỷ", "triệu"], id: [1,2], selectionHandler: {(text,id) in
            self.costUnitText.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    private func prepareUI(){
        getPropertyType()
        getCities()
        transData = ListData.init(text: ["Bán", "Cho thuê"], id: [1,2])
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
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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

    @IBAction func confirm(_ sender: UIButton) {
        
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
