//
//  UpdateAccountPassViewController.swift
//  loca
//
//  Created by Dalton on 5/10/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class UpdateAccountPassViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var confirmButton: TransitionButtonExtent!
    let store = AlamofireStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI(){
        FloatingTextField.configureFloatingText(textfield: passwordTextField, placeHolder: "Nhập Password cũ", title: "Password cũ")
        FloatingTextField.configureFloatingText(textfield: newPassTextField, placeHolder: "Nhập Password mới", title: "Password mới")
        FloatingTextField.configureFloatingText(textfield: confirmPassTextField, placeHolder: "Nhập lại password", title: "Nhập lại password")
        confirmPassTextField.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        confirmButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        confirmButton.startAnimation()
        if confirmPassTextField.text!.isEmpty || passwordTextField.text!.isEmpty || newPassTextField.text!.isEmpty {
            Messages.displayErrorMessage(message: "Vui lòng nhập đầy đủ thông tin")
            confirmButton.stopAnimation()
            return
        }
        
        if confirmPassTextField.text! != newPassTextField.text! {
            Messages.displayErrorMessage(message: "Mật khẩu mới không trùng khớp")
            confirmButton.stopAnimation()
            return
        }
        
        store.changeAccountPass(pass: passwordTextField.text!, newPass: newPassTextField.text!, confirmPass: confirmPassTextField.text!, completionHandler: { (result,data) in
            
            
            switch result {
            case .success:
                self.confirmButton.stopAnimation(animationStyle: .normal, color: UIColor.green, revertAfterDelay: 1, completion: {
                    Messages.displaySuccessMessage(message: "Cập nhật mật khẩu thành công")
                })
            case .failure:
                guard let newData = data, let autParams = try? JSONDecoder().decode(UpdateAccountError.self, from: newData) else {
                    self.confirmButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {
                        Messages.displayErrorMessage( message: "Cập nhật không thành công. Vui lòng thử lại sau")})
                    return
                }
                
                self.confirmButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {
                    Messages.displayErrorMessage(message: autParams.error)})
            }
        })
    }
    
    
    @objc func validateInput(_ textfield: SkyFloatingLabelTextField) {
        let validation = TextValidation()
        if let text = textfield.text {
            let  result = validation.validateByRule(rules: [.empty, .confirmPass], text: text, confirmText: self.newPassTextField.text! )
            textfield.errorMessage = result.message
        }
    }
}
