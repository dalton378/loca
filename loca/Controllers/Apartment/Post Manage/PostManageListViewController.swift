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
        cIndicator.addIndicator(view: self, alpha: 1)
        cIndicator.startIndicator(timeout: 5)
        getPost()
   }
    
    private func getPost(){
        store.getPost(completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentPostList.self, from: newData) else {return}
                for item in autParams.data {
                    self.data.append(item)
                }
                self.cIndicator.stopIndicator()
                self.postNumberLabel.text = String(autParams.data.count)
                self.tableView.reloadData()
            case .failure:
                return
            }
        })
    }
    
}


extension PostManageListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].address
        return cell
    }
    
    
}
