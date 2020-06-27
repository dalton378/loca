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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        circleRing.layer.cornerRadius = 100
        tableView.dataSource = self
        tableView.delegate = self
        cIndicator.addIndicator(view: self, alpha: 1)
        cIndicator.startIndicator(timeout: 5)
        getPost()
    }
    
    private func getPost(){
        store.getPost(completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try! JSONDecoder().decode(ApartmentPostList?.self, from: newData) else {return}
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
        
        
        let newString = data[indexPath.row].images.first!.img.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let data1 = newString.data(using: .utf8)
        let newData = data1!
        let autParams = try? JSONDecoder().decode(ApartmentPhotoDetail.self, from: newData)
        
        let urlString = "\(AppConfig.shared.ApiBaseUrl)/\( autParams!.thumbnail)"
        let urlPhoto = URL(string: urlString)
        
        let photo = self.downloadImage(from: urlPhoto!)
        
        cell.setUI(photo: photo, address: data[indexPath.row].address, price: "\(data[indexPath.row].area) \(data[indexPath.row].area_unit.name) - \(data[indexPath.row].price) \(data[indexPath.row].currency.name)", date: data[indexPath.row].start_date, status: .pending)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let id = self.data[indexPath.row].track_id
            self.store.deletePost(id: String(id), completionHandler: { result in
                switch result{
                case .success:
                    Messages.displaySuccessMessage(message: "Xoá thành công!")
                    self.tableView.reloadData()
                case.failure:
                    Messages.displayErrorMessage(message: "Xoá không thành công. Vui lòng thử lại sau!")
                }
            })
        }

        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            print("Edit")
        }

        share.backgroundColor = UIColor.blue

        return [delete, share]
    }
    
    
    func downloadImage(from url: URL) -> UIImage  {
        guard let data = try? Data(contentsOf: url) else {return UIImage()}
        guard let photo = UIImage(data: data) else {return UIImage()}
        return photo
    }
}
