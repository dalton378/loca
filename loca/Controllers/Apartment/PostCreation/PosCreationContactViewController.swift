//
//  PosCreationContactViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/7/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PosCreationContactViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: PostCreationContactProtocol?
    var data: ApartmentContact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setEmptyBackButton()
        confirmButton.layer.cornerRadius = 10
    }
    
    private func setupUI(){
        FloatingTextField.configureFloatingText(textfield: nameTextField, placeHolder: "Họ Tên", title: "Họ Tên")
        nameTextField.text = AppConfig.shared.profileName
        
        FloatingTextField.configureFloatingText(textfield: phoneTextField, placeHolder: "Số điện thoại", title: "Số điện thoại")
        phoneTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        phoneTextField.text = AppConfig.shared.profilePhone
        FloatingTextField.configureFloatingText(textfield: emailTextField, placeHolder: "Email", title: "Email")
        emailTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        emailTextField.text = AppConfig.shared.profileEmail
        guard let contact = data, let name = contact.name else { return }
        if !name.isEmpty {
            nameTextField.text = contact.name
            phoneTextField.text = contact.phone
            emailTextField.text = contact.email
        }
    }
    
    @objc func validateInput(_ textfield: SkyFloatingLabelTextField) {
        
        let validation = TextValidation()
        if let text = textfield.text {
            var result: ResultTextValidation?
            if textfield == emailTextField {
                result = validation.validateByRule(rules: [.empty, .emailPattern], text: text)
                
            } else if textfield == phoneTextField {
                result = validation.validateByRule(rules: [.empty, .phone], text: text)
            }
            guard let _ = result?.isFailed else{
                textfield.errorMessage = ""
                confirmButton.isEnabled = true
                return }
            
            textfield.errorMessage = result?.message
            confirmButton.isEnabled = false
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if emailTextField.text!.isEmpty || phoneTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            Messages.displayErrorMessage(message: "Vui lòng nhập đầy đủ thông tin")
        } else {
            self.navigationController?.popViewController(animated: true)
            delegate?.getContact(name: nameTextField.text!, phone: phoneTextField.text!, email: emailTextField.text!)
        }
    }
}

protocol PostCreationContactProtocol {
    func getContact(name: String, phone: String, email: String)
}
