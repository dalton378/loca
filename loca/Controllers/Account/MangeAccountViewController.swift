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
    @IBOutlet weak var accountStatus: UIImageView!
    
    var settingData = [SettingData]()
    var updateData: AccountUpdate?
    var updateCaseNum = 0
    let store = AlamofireStore()
    let cIndicator = CustomIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEmptyBackButton()
        cIndicator.addIndicator(view: self, alpha: 1)
        cIndicator.startIndicator(timeout: 5)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Đăng xuất", style: .plain, target: self, action: #selector(signOut))
        
        nameLabel.text = AppConfig.shared.profileName
        prepareData()
        settingTable.delegate = self
        settingTable.dataSource = self
    }

    private func prepareData(){
        settingData.append(SettingData.init(icon: UIImage(named: "contact_icon")!, description: "Tên: \(AppConfig.shared.profileName!)"))
        settingData.append(SettingData.init(icon: UIImage(named: "phone_icon")!, description: "Số điện thoại: \(AppConfig.shared.profilePhone ?? "")"))
        settingData.append(SettingData.init(icon: UIImage(named: "email_icon")!, description: "Email: \(AppConfig.shared.profileEmail ?? "")"))
        settingData.append(SettingData.init(icon: UIImage(named: "password_icon")!, description: "Cập nhật Password"))
        settingData.append(SettingData.init(icon: UIImage(named: "letter_icon")!, description: "Đăng tin"))
        settingData.append(SettingData.init(icon: UIImage(named: "management_icon")!, description: "Quản lý tin"))
        
        guard let _ = AppConfig.shared.accessToken else {return}
        getUserData()
    }
    
    @IBAction func showAccountStatus(_ sender: UITapGestureRecognizer) {
        if AppConfig.shared.profilePhoneVerified == 0 {
            Messages.displayYesNoMessage(title: "Tài khoản chưa xác thực!", message: "", buttonText: "Xác thực tài khoản", buttonAction: {
                self.store.requestToken(completionHandler: {result in
                    switch result{
                    case .success:
                        self.performSegue(withIdentifier: "account_phoneverify", sender: nil)
                    case .failure:
                        Messages.displayErrorMessage(message: "Không thể xác thực tài khoản. Vui lòng thử lại sau!")
                    }
                })
            })
        }
    }
    
    @objc func signOut(){
        sharedFunctions.signOut {
            self.navigationController?.popToRootViewController(animated: true)
            Messages.displaySuccessMessage(message: "Đăng xuất thành công!")
        }
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
            performSegue(withIdentifier: "mangeaccount_createpost", sender: self)
        case 5:
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
        } else if segue.identifier == "mangeaccount_createpost" {
            let viewController = segue.destination as! CreateApartmentPostViewController
            viewController.operation = .create
        }
    }
    
    private func getUserData(){
        store.getUser(completionHandler: {result in
            self.cIndicator.stopIndicator()
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ProfileModel.self, from: newData) else {return}
                AppConfig.shared.profileName = autParams.name
                AppConfig.shared.profileId = autParams.id
                AppConfig.shared.profileEmail = autParams.email
                AppConfig.shared.profilePhone = autParams.phone
                AppConfig.shared.profileEmailVerified = autParams.is_email_verified
                AppConfig.shared.profilePhoneVerified = autParams.is_phone_verified
                if AppConfig.shared.profilePhoneVerified == 1 {
                    self.accountStatus.image = UIImage(named: "green_check_icon")
                }
            case .failure:
                return
            }
        })
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
