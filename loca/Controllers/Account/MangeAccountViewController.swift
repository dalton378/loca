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
    var updateData: AccountUpdate?
    var updateCaseNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEmptyBackButton()
        
        nameLabel.text = AppConfig.shared.profileName
        prepareData()
        settingTable.delegate = self
        settingTable.dataSource = self
    }

    private func prepareData(){
        settingData.append(SettingData.init(icon: UIImage(named: "contact_icon")!, description: "Tên: \(AppConfig.shared.profileName!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "phone_icon")!, description: "Số điện thoại: \(AppConfig.shared.profilePhone!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "email_icon")!, description: "Email: \(AppConfig.shared.profileEmail!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "password_icon")!, description: "Cập nhật Password"))
        settingData.append(SettingData.init(icon: UIImage(named: "letter_icon")!, description: "Liên hệ với LocaLoca"))
        settingData.append(SettingData.init(icon: UIImage(named: "letter_icon")!, description: "Đăng tin"))
        settingData.append(SettingData.init(icon: UIImage(named: "management_icon")!, description: "Quản lý tin"))
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
            updateCaseNum = 0
            performSegue(withIdentifier: "accountSetting_updateName", sender: self)
        case 1:
            updateCaseNum = 1
            performSegue(withIdentifier: "accountSetting_updateName", sender: self)
        case 2:
            updateCaseNum = 2
            performSegue(withIdentifier: "accountSetting_updateName", sender: self)
        case 3:
            performSegue(withIdentifier: "accountSetting_updatePass", sender: self)
        case 4:
            performSegue(withIdentifier: "manageaccount_contact", sender: self)
        case 5:
            performSegue(withIdentifier: "mangeaccount_createpost", sender: self)
        case 6:
            performSegue(withIdentifier: "manageaccount_postmanage", sender: self)
        default:
            print("2")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountSetting_updateName" {
            let viewController = segue.destination as! UpdateAccountNameViewController
            viewController.delegate = self
            
            switch updateCaseNum {
            case 0:
                updateData = AccountUpdate(type: .name)
            case 1:
                updateData = AccountUpdate(type: .phone)
            case 2:
                updateData = AccountUpdate(type: .email)
            default:
                break
            }
            viewController.data = updateData
        }
    }
    
    
    struct SettingData {
        var icon: UIImage
        var description: String
    }
    
}

extension MangeAccountViewController: UpdateAccountData {
    func update(data: String, type: UpdateCase) {
        switch type {
        case .name:
            settingData[0].description = "Tên: \(data)"
            nameLabel.text = data
            AppConfig.shared.profileName = data
        case .phone:
            settingData[1].description = "Số điện thoại: \(data)"
            AppConfig.shared.profilePhone = data
        case .email:
            settingData[2].description = "Email: \(data)"
            AppConfig.shared.profileEmail = data
        default:
            break
        }
        
        settingTable.reloadData()
    }
}
