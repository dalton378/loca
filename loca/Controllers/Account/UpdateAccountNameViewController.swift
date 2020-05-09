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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = AppConfig.shared.profileName
        newNameTextField.text = name
        confirmButton.layer.cornerRadius = 10
        FloatingTextField.configureFloatingText(textfield: newNameTextField, placeHolder: "Tên hiển thị", title: "Tên hiển thị")
    }
    

    @IBAction func confirm(_ sender: UIButton) {
        guard let name = newNameTextField.text else {return}
        store.updateAccountName(name: name, completionHandler: {(result) in
            switch result {
            case .success:
                Messages.displaySuccessMessage(message: "Cập nhật tên thành công")
                self.delegate?.update(data: name)
                self.navigationController?.popViewController(animated: true)
            case .failure:
                Messages.displayErrorMessage(message: "Cập nhật không thàh công. Vui lòng thử lại sau!")
            }
        })
    }
}

