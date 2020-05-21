//
//  CreateApartmentPostViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/5/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class CreateApartmentPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableData = [TableData]()
    var data = ApartmentPostCreation()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        tableData.append(TableData(icon: UIImage(named: "info_icon")!, description: "Thông tin cở bản", status: UIImage()))
        tableData.append(TableData(icon: UIImage(named: "map_icon")!, description: "Vị trí", status: UIImage()))
        tableData.append(TableData(icon: UIImage(named: "details_icon")!, description: "Thông tin mô tả", status: UIImage()))
        tableData.append(TableData(icon: UIImage(named: "graph_icon")!, description: "Thông tin khác", status: UIImage()))
        tableData.append(TableData(icon: UIImage(named: "photo_icon")!, description: "Hình ảnh", status: UIImage()))
        tableData.append(TableData(icon: UIImage(named: "contact_icon")!, description: "Liên hệ", status: UIImage()))
        setEmptyBackButton()
        
        confirmButton.layer.cornerRadius = 10
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createPost_cell", for: indexPath) as! CreatePostTableViewCell
        cell.setData(icon: tableData[indexPath.row].icon, description: tableData[indexPath.row].description, statusIcon: tableData[indexPath.row].status)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "createPost_basicInfo", sender: self)
        case 1:
            performSegue(withIdentifier: "createPost_map", sender: self)
        case 2:
            performSegue(withIdentifier: "postcreation_description", sender: self)
        case 3:
            performSegue(withIdentifier: "postcreation_addInfo", sender: self)
        case 4:
            performSegue(withIdentifier: "postcreation_camera", sender: self)
        case 5:
            performSegue(withIdentifier: "createPost_contact", sender: self)
        default:
            break
        }
        
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        print(data)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPost_map" {
            let view = segue.destination as! PostCreationMapViewController
            view.delegate = self
        } else if segue.identifier == "postcreation_description" {
            let view = segue.destination as! PostCreationDesViewController
            view.delegate = self
        } else if segue.identifier == "postcreation_addInfo" {
            let view = segue.destination as! PostCreationAddInfoViewController
            view.delegate = self
        } else if segue.identifier == "postcreation_camera" {
            let view = segue.destination as! PostCreationCameraViewController
            view.delegate = self
        } else if segue.identifier == "createPost_contact" {
            let view = segue.destination as! PosCreationContactViewController
            view.delegate = self
        } else if segue.identifier == "createPost_basicInfo" {
            let view = segue.destination as! PostCreationBasicViewController
            view.delegate = self
        }
    }
    
    struct TableData{
        var icon: UIImage
        var description: String
        var status: UIImage
    }
}

extension CreateApartmentPostViewController: ApartmentPostLocationProtocol{
    func getLocation(long: String, lat: String) {
        data.lng = long
        data.lat = lat
        tableData[1].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
    
}

extension CreateApartmentPostViewController: PostCreationDescritionProtocol{
    func getDescription(description: String) {
        data.content = description
        tableData[2].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationAddInfoProtocol {
    func getInfo(direction: String, floor: String, bedroom: String, bathroom: String, pool: String, elevator: String, garden: String, roof: String) {
        
        data.direction = direction; data.floor_number = floor; data.bedroom_number = bedroom; data.bathroom_number = bathroom; data.pool = pool; data.garden = garden; data.rooftop = roof
        
        tableData[3].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
    
    func getInfo() {
        
    }
}

extension CreateApartmentPostViewController: PostCreationCameraProtocol {
    func getPhotos(phots: [UIImage]) {
        tableData[4].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationContactProtocol {
    func getContact(name: String, phone: String, email: String) {
        data.contacts.append(ApartmentContact.init(name: name, phone: phone, email: email))
        tableData[5].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationBasicProtocol {
    func getBasicInfo(transType: String, proType: String, city: String, district: String, ward: String, street: String, unitNum: String, square: String, squareUnit: String, price: String, priceUnit: String, startDate: String, endDate: String) {
        
        data.post_type_id = transType; data.property_type_id = proType; data.province_id = city; data.district_id = district; data.ward_id = ward; data.street = street; data.address = unitNum; data.area = square; data.area_unit_id = squareUnit; data.price = price; data.prices_unit_id = priceUnit; data.start_date = startDate; data.end_date = endDate
    }
}

