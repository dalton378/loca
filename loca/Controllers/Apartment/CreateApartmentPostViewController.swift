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
    let store = AlamofireStore()
    var photos = [UIImage]()
    var postedPhotos = [Int]()
    var postedPhotoLink = [ApartmentPhotos]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    let cIndicator = CustomIndicator()
    var operation: OperationType!
    
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
        
        cIndicator.addIndicator(view: self, alpha: 0.6)
        
        if AppConfig.shared.profilePhoneVerified == 0 {
            self.navigationController?.popViewController(animated: true)
            Messages.displayYesNoMessage(title: "Tài khoản chưa xác thực", message: "Ấn vào avatar để xác thực tài khoản", buttonText: "OK", buttonAction: {})
        }
        
        if !postedPhotoLink.isEmpty && operation == .update {
            for i in postedPhotoLink {
                photos.append(sharedFunctions.downloadLocaApartmentImage(image: i))
            }
        }
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
        
        guard let operationType = operation else { return}
        print(data)
        postedPhotos.removeAll()
        switch operationType {
        case .create:
            createPostRequest()
        case .update:
            updatePostRequest()
        }
    }
    
    private func updatePostRequest(){
        if photos.isEmpty {
            self.updatePost()
        } else {
            cIndicator.startIndicator(timeout: 7)
            var second = 0.0
            for i in 0...self.photos.count - 1 {
                second += 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
                    sleep(1)
                    self.store.postImageFormData(image: self.photos[i], completionHandler: {respose in
                        
                        print(String(decoding: respose.data!, as: UTF8.self))
                        guard let newData = respose.data, let autParams = try? JSONDecoder().decode(ApartmentPhotoReturn.self, from: newData) else {
                            Messages.displayErrorMessage(message: "Upload file không thành công!")
                            return
                        }
                        self.postedPhotos.append(autParams.id)
                        
                        if self.postedPhotos.count == self.photos.count {
                            self.cIndicator.stopIndicator()
                            self.data.images = self.postedPhotos
                            self.updatePost()
                        }
                        print(autParams.id)
                        print(autParams.path.original)
                    })
                })
            }
        }
    }
    
    private func updatePost(){
        store.updatePost(data: self.data, completionHandler: {result in
            print(result)
            switch result{
            case .success:
                Messages.displaySuccessMessage(message: "Cập nhật tin thành công")
            case .failure:
                Messages.displayErrorMessage(message: "Cập nhật tin không thành công")
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    private func createPostRequest(){
        if data.district_id == 0 || data.lat == 0 {
            Messages.displayErrorMessage(message: "Vui lòng điền đầy đủ thông tin trước khi đăng tin!")
        }
        else {
            if photos.isEmpty {
                self.createPost()
            } else {
                cIndicator.startIndicator(timeout: 7)
                var second = 0.0
                for i in 0...self.photos.count - 1 {
                    second += 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
                        sleep(1)
                        self.store.postImageFormData(image: self.photos[i], completionHandler: {respose in
                            
                            print(String(decoding: respose.data!, as: UTF8.self))
                            guard let newData = respose.data, let autParams = try? JSONDecoder().decode(ApartmentPhotoReturn.self, from: newData) else {
                                Messages.displayErrorMessage(message: "Upload file không thành công!")
                                return
                            }
                            self.postedPhotos.append(autParams.id)
                            
                            if self.postedPhotos.count == self.photos.count {
                                self.cIndicator.stopIndicator()
                                self.data.images = self.postedPhotos
                                self.createPost()
                            }
                            print(autParams.id)
                            print(autParams.path.original)
                        })
                    })
                }
            }
        }
    }
    
    private func createPost(){
        cIndicator.startIndicator(timeout: 10)
        store.createPost(data: data, completionHandler: { (result, data) in
            self.cIndicator.stopIndicator()
            switch result {
            case .success:
                Messages.displaySuccessMessage(message: "Đăng tin thành công")
                self.navigationController?.popViewController(animated: true)
            case .failure:
                Messages.displayErrorMessage(message: "Không thành công. Vui lòng thử lại sau!")
                return
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createPost_map" {
            let view = segue.destination as! PostCreationMapViewController
            view.delegate = self
            view.dataLocation = data
        } else if segue.identifier == "postcreation_description" {
            let view = segue.destination as! PostCreationDesViewController
            view.delegate = self
            view.data = data.description
        } else if segue.identifier == "postcreation_addInfo" {
            let view = segue.destination as! PostCreationAddInfoViewController
            view.delegate = self
            view.data = data
        } else if segue.identifier == "postcreation_camera" {
            let view = segue.destination as! PostCreationCameraViewController
            view.delegate = self
            view.photoCollection = self.photos
        } else if segue.identifier == "createPost_contact" {
            let view = segue.destination as! PosCreationContactViewController
            view.delegate = self
            view.data = data.contacts.first
        } else if segue.identifier == "createPost_basicInfo" {
            let view = segue.destination as! PostCreationBasicViewController
            view.delegate = self
            view.dataBasic = data
        }
    }
    
    struct TableData{
        var icon: UIImage
        var description: String
        var status: UIImage
    }
    enum OperationType {
        case create
        case update
    }
}

extension CreateApartmentPostViewController: ApartmentPostLocationProtocol{
    func getLocation(long: Double, lat: Double) {
        data.lng = long
        data.lat = lat
        tableData[1].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
    
}

extension CreateApartmentPostViewController: PostCreationDescritionProtocol{
    func getDescription(description: String) {
        data.description = description
        tableData[2].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationAddInfoProtocol {
    func getInfo(direction: String, floor: String, bedroom: String, bathroom: String, pool: String, elevator: String, garden: String, roof: String) {
        
        data.direction = direction; data.floor_number = Int(floor) ?? 0; data.bedroom_number = Int(bedroom) ?? 0; data.bathroom_number = Int(bathroom) ?? 0; data.pool = pool; data.garden = garden; data.rooftop = roof
        
        tableData[3].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationCameraProtocol {
    func getPhotos(images: [UIImage]) {
        self.photos.removeAll()
        if images.count == 0 {
            self.data.images = []
        } else {
             self.photos = images
        }
        tableData[4].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationContactProtocol {
    func getContact(name: String, phone: String, email: String) {
        //data.contacts.append(ApartmentContact.init(name: name, phone: phone, email: email))
        data.contacts[0] = ApartmentContact.init(name: name, phone: phone, email: email)
        tableData[5].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

extension CreateApartmentPostViewController: PostCreationBasicProtocol {
    func getBasicInfo(transType: String, proType: String, city: String, district: String, ward: String, street: String, fullAddress: String, unitNum: String, square: String, squareUnit: String, price: String, priceUnit: String, startDate: String, endDate: String) {
        data.post_type_id = Int(transType)!; data.property_type_id = proType; data.province_id = Int(city)!; data.district_id = Int(district)!; data.ward_id = Int(ward)!; data.street = street; data.address = fullAddress; data.area = square; data.area_unit_id = Int(squareUnit)!; data.price = price; data.currency_id = Int(priceUnit)!; data.start_date = startDate; data.end_date = endDate; data.apartment_number = Int(unitNum) ?? 0
        
        tableData[0].status = UIImage(named: "green_check_icon")!
        tableView.reloadData()
    }
}

