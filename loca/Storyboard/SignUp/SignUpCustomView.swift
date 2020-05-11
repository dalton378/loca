//
//  SignUpCustomView.swift
//  loca
//
//  Created by Toan Nguyen on 4/30/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SwiftMessages
import TransitionButton
import SkyFloatingLabelTextField

class SignUpCustomView: MessageView {
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var confirmButton: TransitionButton!
    
    var pass = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SignUp", owner: self, options: nil)
        contentView.fixInView(self)
        setupUI()
    }
    
    func setupUI(){
        contentView.layer.cornerRadius = 20
        
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
        confirmButton.startAnimation()
        confirmButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {})
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func validateInput(_ textfield: SkyFloatingLabelTextField){
        guard let text = textfield.text else {return}
        let validation = TextValidation()
        var result: ResultTextValidation?
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
            return }
        
        textfield.errorMessage = result?.message
    }
    
}
