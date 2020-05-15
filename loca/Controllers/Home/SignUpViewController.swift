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
    @IBOutlet weak var confirmButton: TransitionButtonExtent!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var result: ResultTextValidation?
    var store = AlamofireStore()
    var delegate: SignUpProtocol?
    
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
        
        registerForKeyboardNotifications()
    }
    
    
    @IBAction func register(_ sender: TransitionButtonExtent) {
        if nameTextField.text!.isEmpty || phoneTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPassTextField.text!.isEmpty {
            Messages.displayErrorMessage(message: "Vui lòng điền đầy đủ thông tin")
        } else {
            guard let error = result, let _ = error.isFailed else {
                confirmButton.startAnimation()
                store.register(name: nameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, pass: passwordTextField.text!, passConfirm: confirmPassTextField.text!, completionHandler: { (result,data) in
                    switch result{
                    case .success(let data):
                        let parsedData = data.data(using: .utf8)
                        guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else {
                            print(data)
                            self.confirmButton.stopAnimation()
                            return}
                        self.confirmButton.stopAnimation(animationStyle: .normal, color: .green, revertAfterDelay: 1, completion: {
                            AppConfig.shared.accessToken = autParams.access_token
                            AppConfig.shared.isSignedIn = true
                            Messages.displaySuccessMessage(message: "Đăng ký thành công.")
                            self.navigationController?.popViewController(animated: true)
                            self.delegate?.completionHandler()
                        })
                        
                    case .failure:
                        self.confirmButton.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {
                            
                            guard let newData = data, let autParams = try? JSONDecoder().decode(AccountGeneralError.self, from: newData) else {return}
                            
                            Messages.displayErrorMessage(message: "\(String(describing: autParams.errors.email)) \(String(describing: autParams.errors.phone))")
                        })
                    }
                })
                
                return
            }
            confirmButton.startAnimation()
            Messages.displayErrorMessage(message: error.message)
        }
    }
    
    private func setUserData(){
        
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

protocol SignUpProtocol {
    func completionHandler()
}


extension SignUpViewController {
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
