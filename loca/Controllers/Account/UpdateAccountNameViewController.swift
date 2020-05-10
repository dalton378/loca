//
//  UpdateAccountNameViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/9/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class UpdateAccountNameViewController: UIViewController {
    
    @IBOutlet weak var newNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: UpdateAccountData?
    var store = AlamofireStore()
    var data: AccountUpdate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI(){
        var dataString = ""
        switch data!.type {
        case .name:
            dataString = AppConfig.shared.profileName!
        case .phone:
            dataString = AppConfig.shared.profilePhone!
        case .email:
            dataString = AppConfig.shared.profileEmail!
        default:
            break
        }
        newNameTextField.text = dataString
        FloatingTextField.configureFloatingText(textfield: newNameTextField, placeHolder: data!.title, title: data!.title)
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        guard let name = newNameTextField.text, var newData = data else {return}
        newData.newValue = name
        updateByType(dataUpdated: newData)
    }
    
    private func updateByType(dataUpdated: AccountUpdate){
        switch data?.type {
        case .name:
            store.updateAccountName(name: dataUpdated.newValue, completionHandler: {(result) in
                switch result {
                case .success:
                    self.updatedSuccess(data: dataUpdated)
                case .failure:
                    Messages.displayErrorMessage(message: dataUpdated.errorMessage)
                }
            })
        case .phone:
            store.updateAccountPhone(phone: dataUpdated.newValue, completionHandler:{(result) in
                switch result {
                case .success:
                    self.updatedSuccess(data: dataUpdated)
                case .failure:
                    Messages.displayErrorMessage(message: dataUpdated.errorMessage)
                }
            })
        case .email:
            store.updateAccountEmail(email: dataUpdated.newValue, completionHandler: {(result) in
                switch result {
                case .success:
                    self.updatedSuccess(data: dataUpdated)
                case .failure:
                    Messages.displayErrorMessage(message: dataUpdated.errorMessage)
                }
            })
        default:
            break
        }
    }
    
    private func updatedSuccess(data: AccountUpdate){
        Messages.displaySuccessMessage(message: data.successMessage)
        self.delegate?.update(data: data.newValue, type: data.type)
        self.navigationController?.popViewController(animated: true)
    }
}

