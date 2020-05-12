//
//  SignUpViewController.swift
//  loca
//
//  Created by Dalton on 5/4/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import TransitionButton
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var confirmButton: TransitionButton!
    
    var result: ResultTextValidation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        
        FloatingTextField.configureFloatingText(textfield: nameTextField, placeHolder: "Tên", title: "Tên")
        FloatingTextField.configureFloatingText(textfield: phoneTextField, placeHolder: "Số điện thoại", title: "Số điện thoại")
        FloatingTextField.configureFloatingText(textfield: emailTextField, placeHolder: "Email", title: "Email")
        FloatingTextField.configureFloatingText(textfield: passwordTextField, placeHolder: "Mật khẩu", title: "Mật khẩu")
        FloatingTextField.configureFloatingText(textfield: confirmPassTextField, placeHolder: "Nhập lại mật khẩu", title: "Nhập lại mật khẩu")
        
        nameTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        confirmPassTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        
        TransitionButtonCustom.configureTransitionButton(button: confirmButton, tittle: "Đăng Ký", tapHandler: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPassTextField.text!.isEmpty {
            Messages.displayErrorMessage(message: "Vui lòng điền đầy đủ thông tin")
        } else {
            guard let error = result, let _ = error.isFailed else {
                confirmButton.startAnimation()
                confirmButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {})
                return
            }
            Messages.displayErrorMessage(message: error.message)
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func validateInput(_ textfield: SkyFloatingLabelTextField){
        guard let text = textfield.text else {return}
        let validation = TextValidation()
        confirmButton.isEnabled = false
        if textfield == nameTextField {
            result = validation.validateByRule(rules: [.empty], text: text)
        } else if textfield == phoneTextField {
            result = validation.validateByRule(rules: [.empty, .phone], text: text)
        } else if textfield == emailTextField {
            result = validation.validateByRule(rules: [.empty, .emailPattern], text: text)
        } else if textfield == confirmPassTextField {
            guard let pass = passwordTextField.text else {
                result = ResultTextValidation.init(isFailed: .isConfirmPassFailed)
                return}
            result = validation.validateByRule(rules: [.empty,.confirmPass], text: text, confirmText: pass)
        }
        guard let _ = result?.isFailed else{
            textfield.errorMessage = ""
            confirmButton.isEnabled = true
            return }
        
        textfield.errorMessage = result?.message
    }
}
