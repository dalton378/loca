//
//  EnterPhoneViewController.swift
//  loca
//
//  Created by Dalton on 7/13/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class EnterPhoneViewController: UIViewController {

    @IBOutlet weak var phoneTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var submitButton: TransitionButton!
    let validation = TextValidation()
    var result: ResultTextValidation?
    let store = AlamofireStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FloatingTextField.configureFloatingText(textfield: phoneTextfield, placeHolder: "Số Điện Thoại", title: "Số Điện Thoại")
        phoneTextfield.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        phoneTextfield.keyboardType = .phonePad
        
        submitButton.layer.cornerRadius = 5
    }
    
    @IBAction func submit(_ sender: TransitionButton) {
        guard let text = phoneTextfield.text else {return}
        store.updateAccountPhone(phone: text, completionHandler: {result in
            switch result {
            case.success:
                Messages.displaySuccessMessage(message: "Cập nhật số điện thoại không thành công")
                self.performSegue(withIdentifier: "phoneNumber_verifyPhone", sender: self)
            case.failure:
                Messages.displayErrorMessage(message: "Cập nhật số điện thoại không thành công. Vui lòng thử lại sau!")
            }
        })
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func validateInput(_ textfield: SkyFloatingLabelTextField){
        guard let text = textfield.text else {return}
        submitButton.isEnabled = false
        if textfield == phoneTextfield {
            result = validation.validateByRule(rules: [.empty, .phone], text: text)
        }
        guard let _ = result?.isFailed else{
            textfield.errorMessage = ""
            submitButton.isEnabled = true
            return
        }
        textfield.errorMessage = result?.message
    }
}
