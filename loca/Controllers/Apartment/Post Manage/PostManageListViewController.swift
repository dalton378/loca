//
//  PostManageListViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/22/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class PostManageListViewController: UIViewController {
    
    @IBOutlet weak var circleRing: UIView!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let store = AlamofireStore()
    let cIndicator = CustomIndicator()
    var data = [ApartmentPostDetail]()
    var selectedIndex = 0
    var defaultPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaultPage = 1
        getPost()
    }
    
    private func setupUI(){
        self.setEmptyBackButton()
        circleRing.layer.cornerRadius = 100
        tableView.dataSource = self
        tableView.delegate = self
        cIndicator.addIndicator(view: self, alpha: 1)
        cIndicator.startIndicator(timeout: 5)
    }
    
    private func getPost(){
        store.getPost(page: String(defaultPage), completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try! JSONDecoder().decode(ApartmentPostList?.self, from: newData) else {return}
                self.data.removeAll()
                for item in autParams.data {
                    self.data.append(item)
                }
                self.cIndicator.stopIndicator()
                self.postNumberLabel.text = String(autParams.data.count)
                self.tableView.reloadData()
            case .failure:
                Messages.displayErrorMessage(message: "Không có dữ liệu. Vui lòng thử lại sau!")
                self.navigationController?.popViewController(animated: true)
                return
            }
        })
    }
}


extension PostManageListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manage_post", for: indexPath) as! ManagePostTableViewCell
        guard let image = data[indexPath.row].images.first else {
            cell.setUI(photo: URL(string: ""), address: data[indexPath.row].address, price: "\(data[indexPath.row].area) \(data[indexPath.row].area_unit.name) - \(data[indexPath.row].price) \(data[indexPath.row].currency.name)", date: data[indexPath.row].start_date, status: .pending)
            return cell
        }
        
        let newString = image.img.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let data1 = newString.data(using: .utf8)
        let newData = data1!
        let autParams = try? JSONDecoder().decode(ApartmentPhotoDetail.self, from: newData)
        
        let urlString = "\(AppConfig.shared.ApiBaseUrl)/\( autParams!.thumbnail)"
        let urlPhoto = URL(string: urlString)
        
        
        cell.setUI(photo: urlPhoto!, address: data[indexPath.row].address, price: "\(data[indexPath.row].area) \(data[indexPath.row].area_unit.name) - \(data[indexPath.row].price) \(data[indexPath.row].currency.name)", date: data[indexPath.row].start_date, status: .pending)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Xoá") { (action, indexPath) in
            let id = self.data[indexPath.row].track_id
            self.store.deletePost(id: String(id), completionHandler: { result in
                switch result{
                case .success:
                    Messages.displaySuccessMessage(message: "Xoá thành công!")
                    self.navigationController?.popViewController(animated: true)
                case.failure:
                    Messages.displayErrorMessage(message: "Xoá không thành công. Vui lòng thử lại sau!")
                }
            })
        }

        let share = UITableViewRowAction(style: .normal, title: "Sửa") { (action, indexPath) in
            self.selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "managepost_editpost", sender: self)
        }

        share.backgroundColor = UIColor.blue

        return [delete, share]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if data.count - 1 == indexPath.row {
            self.defaultPage += 1
            store.getPost(page: String(defaultPage), completionHandler: {result in
                switch result {
                case .success(let data):
                    let parsedData = data.data(using: .utf8)
                    guard let newData = parsedData, let autParams = try! JSONDecoder().decode(ApartmentPostList?.self, from: newData) else {return}

                    if !autParams.data.isEmpty {
                        for item in autParams.data {
                            self.data.append(item)
                        }
                        self.cIndicator.stopIndicator()
                        self.postNumberLabel.text = String(self.data.count)
                        self.tableView.reloadData()
                        self.defaultPage += 1
                    } else {
                        self.defaultPage -= 1
                    }
                case .failure:
                    Messages.displayErrorMessage(message: "Không có dữ liệu. Vui lòng thử lại sau!")
                    self.navigationController?.popViewController(animated: true)
                    return
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "managepost_editpost" {
            let view = segue.destination as! CreateApartmentPostViewController
            var passedData = ApartmentPostCreation()
            passedData.address = self.data[selectedIndex].address
            passedData.apartment_code = self.data[selectedIndex].apartment_code ?? ""
            //passedData.apartment_number = self.data[selectedIndex].apartment_number ?? 0 
            passedData.apartment_id = String(self.data[selectedIndex].id ?? 0)
            //passedData.apartment_number = String(self.data[selectedIndex]. ?? 0)
            passedData.area = self.data[selectedIndex].area
            passedData.area_unit_id = self.data[selectedIndex].area_unit.id
            passedData.bathroom_number = self.data[selectedIndex].bathroom_number ?? 0
            passedData.bedroom_number = self.data[selectedIndex].bedroom_number ?? 0
            passedData.contacts = self.data[selectedIndex].contacts ?? []
            //passedData.content = self.data[selectedIndex].description
            passedData.currency_id = self.data[selectedIndex].currency.id
            passedData.description = self.data[selectedIndex].description
            passedData.direction = self.data[selectedIndex].direction
            passedData.district_id = self.data[selectedIndex].district.id
            passedData.end_date = self.data[selectedIndex].end_date
            passedData.floor_number = self.data[selectedIndex].floor_number ?? 0
            passedData.garden = self.data[selectedIndex].garden ?? "1"
            passedData.id = String(self.data[selectedIndex].id ?? 0)
            //passedData.images = self.data[selectedIndex].images
            passedData.lat = self.data[selectedIndex].lat
            passedData.lng = self.data[selectedIndex].lng
            passedData.pool = self.data[selectedIndex].pool ?? "1"
            passedData.post_type_id = self.data[selectedIndex].post_type.id
            passedData.price = self.data[selectedIndex].price
            //passedData.prices_unit_id = self.data[selectedIndex].c
            passedData.property_type_id = self.data[selectedIndex].property_type.id
            passedData.province_id = self.data[selectedIndex].province.id
            passedData.region = self.data[selectedIndex].region
            passedData.rooftop = self.data[selectedIndex].rooftop ?? "1"
            passedData.start_date = self.data[selectedIndex].start_date
            passedData.street = self.data[selectedIndex].street
            passedData.total_area = self.data[selectedIndex].area
            passedData.track_id = self.data[selectedIndex].track_id
            passedData.user_id = String(self.data[selectedIndex].user_id)
            passedData.ward_id = self.data[selectedIndex].ward.id
            view.data = passedData
            view.postedPhotoLink = self.data[selectedIndex].images
            view.operation = .update
        }
    }
    
    func downloadImage(from url: URL) -> UIImage  {
        guard let data = try? Data(contentsOf: url) else {return UIImage()}
        guard let photo = UIImage(data: data) else {return UIImage()}
        return photo
    }
}
