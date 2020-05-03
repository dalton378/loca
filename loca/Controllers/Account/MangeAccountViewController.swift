//
//  MangeAccountViewController.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class MangeAccountViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingTable: UITableView!
    
    var settingData = [SettingData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEmptyBackButton()
        self.setTransparentNavigationBar()


        nameLabel.text = AppConfig.shared.profileName
        
        settingTable.delegate = self
        settingTable.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        settingData.append(SettingData.init(icon: UIImage(named: "contact_icon")!, description: "Tên: \(AppConfig.shared.profileName!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "phone_icon")!, description: "Số điện thoại: \(AppConfig.shared.profilePhone!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "email_icon")!, description: "Email: \(AppConfig.shared.profileEmail!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "password_icon")!, description: "Cập nhật Password"))
        settingData.append(SettingData.init(icon: UIImage(named: "letter_icon")!, description: "Liên hệ với LocaLoca"))
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting_cell", for: indexPath) as! AccountSettingsTableViewCell
        cell.setData(icon: settingData[indexPath.row].icon, description: settingData[indexPath.row].description)
        cell.addAnimation(animationDirection: .left, delay: (indexPath.row * 4) )
        return cell
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("1")
        default:
            print("2")
        }
    }
    
    
    struct SettingData {
        var icon: UIImage
        var description: String
    }
    
}
