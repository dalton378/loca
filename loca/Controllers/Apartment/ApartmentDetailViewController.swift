//
//  ApartmentDetailViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class ApartmentDetailViewController: UIViewController {

    var apartmentId: String?
    var apartmentDetail: ApartmentDetail?
    let store = AlamofireStore()
    var data = [ApartmentData]()
    let customIndicator = CustomIndicator()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customIndicator.addIndicator(view: self, alpha: 1)
        customIndicator.startIndicator(timeout: 5)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getApartmentDetail(id: apartmentId!)
        
    }

    private func getApartmentDetail(id: String) {
        store.getApartmentDetail(id: id, completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentDetail.self, from: newData) else {return}
                self.apartmentDetail = autParams
                self.prepareData()
                let totalHeight = self.addADCustomView(containerView: self.stackView, numofViews: self.data.count, viewHeigh: 60)
                
                for a in self.containerView.constraints {
                    if a.identifier == "containerHeight" {
                        a.constant = CGFloat(totalHeight)
                    }
                }
                self.descriptionTextView.text = self.apartmentDetail?.description
                self.view.layoutIfNeeded()
            case .failure:
                return
            }
            self.customIndicator.stopIndicator()
        })
    }
    
    
    func addADCustomView(containerView: UIView, numofViews: Int, viewHeigh: Int) -> Int{

           let width = containerView.frame.size.width
           
           for i in 0...numofViews - 1 {
               let cus = APCustomView.init(frame: CGRect(x: 0, y: viewHeigh * i , width: Int(width), height: viewHeigh))
               
            cus.setData(photo: data[i].icon, text:data[i].description)
            cus.addAnimation(animationDirection: .left, delay: i)
            containerView.addSubview(cus)
           }
           
           return ((viewHeigh * numofViews) + 450)
       }
    
    private func prepareData(){
        guard let apartment = apartmentDetail else {return}
        
        data.append(ApartmentData(icon: UIImage(named: "location_icon")!, description: "Địa chỉ: \(apartment.address)"))
        data.append(ApartmentData(icon: UIImage(named: "transaction_icon")!, description: "Loại hình giao dịch: \(apartment.post_type.name)"))
        data.append(ApartmentData(icon: UIImage(named: "house_icon")!, description: "Loại hình bất động sản: \(apartment.property_type.name)"))
        data.append(ApartmentData(icon: UIImage(named: "date_icon")!, description: "Ngày bắt đầu: \(apartment.start_date)"))
        data.append(ApartmentData(icon: UIImage(named: "date_icon")!, description: "Ngày kết thúc:\(apartment.end_date)"))
        data.append(ApartmentData(icon: UIImage(named: "size_icon")!, description: "Diện tích: \(apartment.area) \(apartment.area_unit.name)"))
        if apartment.floor_number != nil {
            data.append(ApartmentData(icon: UIImage(named: "layer_icon")!, description: "Số tầng: \(apartment.floor_number!)"))
        }
        if apartment.bedroom_number != nil {
            data.append(ApartmentData(icon: UIImage(named: "bedroom_icon")!, description: "Số phòng ngủ: \(apartment.bedroom_number!)"))
        }
        if apartment.bathroom_number != nil {
            data.append(ApartmentData(icon: UIImage(named: "bathroom_icon")!, description: "Số phòng tắm: \(apartment.bathroom_number!)"))
        }
        
        data.append(ApartmentData(icon: UIImage(named: "dollar_icon")!, description: "Giá: \(apartment.price) \(apartment.currency.name)"))
        data.append(ApartmentData(icon: UIImage(named: "contact_icon")!, description: "Người liên hệ: \(apartment.apartment_contacts.first!.name) "))
        data.append(ApartmentData(icon: UIImage(named: "phone_icon")!, description: "Số điện thoại: \(apartment.apartment_contacts.first!.phone) "))
        data.append(ApartmentData(icon: UIImage(named: "email_icon")!, description: "Email: \(apartment.apartment_contacts.first!.email) "))
        
        
    }

     struct ApartmentData {
        var icon: UIImage
        var description : String

    }
}
