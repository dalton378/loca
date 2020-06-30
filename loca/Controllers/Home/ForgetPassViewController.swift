//
//  ForgetPassViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/12/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class ForgetPassViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmButton: TransitionButton!
    
    var store = AlamofireStore()
    var cIndicator = CustomIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        FloatingTextField.configureFloatingText(textfield: emailTextField, placeHolder: "Email", title: "Email")
        emailTextField.addTarget(self, action: #selector(textValidation(_:)), for: .editingChanged)
        confirmButton.layer.cornerRadius = 10
        cIndicator.addIndicator(view: self, alpha: 0.7)
    }
    
    @objc func textValidation(_ textfield: SkyFloatingLabelTextField) {
        guard let text = textfield.text else {return}
        let validation = TextValidation()
        confirmButton.isEnabled = false
        let result = validation.validateByRule(rules: [.empty, .emailPattern], text: text)
        
        guard let _ = result.isFailed else{
            textfield.errorMessage = ""
            confirmButton.isEnabled = true
            return }
        
        textfield.errorMessage = result.message
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let text = emailTextField.text else {return}
        if text.isEmpty {
            Messages.displayErrorMessage(message: "Vui lòng điền đầy đủ thông tin.")
        } else {
            cIndicator.startIndicator(timeout: 10)
            store.forgetPassword(email: text, completionHandler: { (result,data)  in
                self.cIndicator.stopIndicator()
                switch result {
                case .success:
                    Messages.displaySuccessMessage(message: "Vui lòng kiểm tra email và làm theo hướng dẫn.")
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure:
                    Messages.displayErrorMessage(message: "Vui lòng thử lại sau!")
                }
            })
        }
    }
    
}
